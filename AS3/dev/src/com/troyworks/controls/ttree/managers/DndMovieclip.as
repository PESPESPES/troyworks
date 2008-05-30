package com.troyworks.ui.managers { 
	/*******************************************************
	** DndMovieclip Class
	** Written by JabbyPanda, JudahPanda
	* 
	*  Inspired by code from DDDraggerNode class written by Jonathan Doklovic
	** 2003 Fuseware LTD.
	**
	** This is the node dragger component used by the list components.
	** This component is used to make a "ghost copy" of the
	** node while it's being dragged.
	* 
	*******************************************************/
	//register our class
	
	import mx.events.EventDispatcher;
	
	import flash.ui.Mouse;
	import flash.display.MovieClip;
	import flash.xml.XMLNode;
	public class DndMovieclip extends MovieClip {
		// "this" refers to the dragged node movieclip that follows the movieclip
		protected var _inited:Boolean;
		public var isDragging:Boolean = false;
		public var hasMoved:Boolean = false;
		public var SHIFT_ICON_DRAG_XPOSITION:Number = 12;
		public var SHIFT_ICON_DRAG_YPOSITION:Number = 8;
		protected var dispatchEvent:Function;
		public var addEventListener:Function;
		public var removeEventListener:Function;
		public var owner:Object;
		public var draggedNodeInstance:Object;
		public var bCrossDragEnabled:Boolean;
		public var drag_mc:MovieClip;
		public var node:XMLNode;
		public var nodes:Array;
		public var noDropIcon:MovieClip;
		public var strNoDropIcon:String = "dndNoDropIcon";
		protected var m_copyControlMode:String;
		protected var isCtrlButtonPressed:Boolean = false;
		protected var moveAfterDropMode:Boolean = true;
		protected var copyIcon:MovieClip;
		
		protected static var eventDispatcherInitialized = EventDispatcher.initialize(DndMovieclip.prototype);
		
		public function DndMovieclip () {
			if (!_inited) init();
	
		}
		
		// protected methods
		protected function init():void{
			EventDispatcher.initialize(this);
			_inited = true;
			public var crossdndWidgetList:DndUIWidgets = DndUIWidgets.getWidgetList ();	
			crossdndWidgetList.addItem(this);
			//make this a broadcaster		
			//set our initial property values
			isDragging = false;
			hasMoved = false;
			owner = this;
			//hide me by default
			visible = false;
		}
		
		/*****************************************************
		** This method sets up the dragging of the dragger
		** node.  It's fired from the row onRowPress event
		******************************************************/
		// add listeners to list and start dragging drag mc
		function beginDrag (theList:Object):void {
			// listen for mouse movements and call our mouse specific 
			// functions, onMouseMove and onMouseUp
			Mouse.addListener (this);
			//trace("_root.getNextHighestDepth()"+_root.getNextHighestDepth())
			noDropIcon = _root.attachMovie(strNoDropIcon, "noDropIcon", 1000);
			
			// convert mouse position over stage to mouse position over row
			noDropIcon.x = this.mouseX-5;
			noDropIcon.y = this.mouseY-5;
			
			noDropIcon.visible = false;
			startDrag (true);
			isDragging = true;
			
			addDNDEventsListener();
		}
		
		/*****************************************************
		** This method (fired from the mouse event) is used to
		** turn on the dragger symbol in case it's being
		** dragged AND the mouse has moved.  We have this so
		** you don't see the dragger everytime you click
		** something on the list without actually dragging it.
		******************************************************/
		// catch mouse movement and dispatch to onDraggerMove event
		function onMouseMove ():void {
			if (isDragging) {
				if (!visible) {
					visible = true;
					alpha = 100;
					hasMoved = true;
					x = mouseX + SHIFT_ICON_DRAG_XPOSITION;
					y = mouseY + SHIFT_ICON_DRAG_YPOSITION;
				}
				if (hasMoved) {
					// Dispatch onDraggerMove event with reference to this
					dispatchEvent ({type:"onDraggerMove", target:this});
					updateAfterEvent();
				}
			}
		}
		
		/*****************************************************
		** This method (fired from the mouse event) is used to
		** stop the dragger from dragging and to broadcast the
		** onDraggerDrop event to the list.
		******************************************************/
		// User dropped node - remove listeners - broadcast onDraggerDrop
		function onMouseUp () :void{
	
			stopDrag ();
			isDragging = false;
			public var owner = this.owner;
			//only broadcast the message if this was actually moved.
			if (hasMoved) {
				dispatchEvent ({type:"onDraggerDrop", target:this});
			}
	
			Mouse.removeListener (this);
			removeEventListener("onDraggerMove", owner);
			removeEventListener("onDraggerDrop", owner);
			// remove no drop icon
			noDropIcon.removeMovieClip();
	
			removeDNDEventsListener();
			// method to handle unsuccessful drop
			unSuccessfulDrop();
		}
		
		function unSuccessfulDrop():void {
			//trace("unsuccessful drop")
			//remove me from the stage
			removeMovieClip(this);
		}
		
		function successfulDrop(dropTarget:Object) :void{
			//trace("successful drop=" + dropTarget)
		}
		
		// TODO: Comment on this
		protected function addDNDEventsListener():void	{
			public var crossdndWidgetList:DndUIWidgets = DndUIWidgets.getWidgetList ();		
			
			// START :: wiring events 
			// have the ghost listen to move and drop events in case it wants to do something
			addEventListener ("onDraggerMove", this);
			addEventListener ("onDraggerDrop", this);
			
			// loop through all dnd widgets
			for (public var i = 0; i < crossdndWidgetList.length; i++)	{
				public var dndWidget = crossdndWidgetList.getItemAt(i);
				
				// each widget wants to listen to the onDraggerMove and onDraggerMove events
				// generated from this movieclip
				addEventListener ("onDraggerMove", dndWidget);
				addEventListener ("onDraggerDrop", dndWidget);
				
				// assign drag_mc instance to the every cross drag and drop widgets enabled 
				dndWidget.drag_mc  = drag_mc;
				
			}
		}
		
		// NOTE: currently not used
		protected function removeDNDEventsListener():void {
			var crossdndWidgetList:DndUIWidgets = DndUIWidgets.getWidgetList ();
			
			removeEventListener ("onDraggerMove", this);
			removeEventListener ("onDraggerDrop", this);
			
			// loop through all dnd widgets
			for (var i = 0; i < crossdndWidgetList.length; i++)	{
				public var dndWidget:Object = crossdndWidgetList.getItemAt(i);
				
				// each widget wants to listen to the onDraggerMove and onDraggerMove events
				// generated from this movieclip
				removeEventListener ("onDraggerMove", dndWidget);
				removeEventListener ("onDraggerDrop", dndWidget);
				
				// assign drag_mc instance to the every cross drag and drop widgets enabled 
				dndWidget.drag_mc  = drag_mc;
			}
			
		}
		
		// shows the custom "noDrop possible" cursor
		public function showCustomCursor():void	{
			Mouse.hide();
			noDropIcon.visible = true;		
		}
		
		
		// hides the custom "noDrop possible" cursor
		public function hideCustomCursor():void	{
			Mouse.show();
			noDropIcon.visible = false;
		}
		
		// add tree to the list of drag and drop enabled UI controls
		public function get enableCrossDrag():Boolean {
			return bCrossDragEnabled;
		}
		
		public function set enableCrossDrag(enable:Boolean):void {
	  
			var crossdndWidgetList:DndUIWidgets = DndUIWidgets.getWidgetList ();
			if (enable) {			
				crossdndWidgetList.addItem(this);
				bCrossDragEnabled = enable;
			}
			else {
				bCrossDragEnabled = false;
				crossdndWidgetList.removeItem(this);
			}	
		}
	}
}