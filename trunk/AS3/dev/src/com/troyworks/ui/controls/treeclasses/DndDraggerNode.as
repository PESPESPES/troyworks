package com.troyworks.ui.controls.treeclasses { 
	/*******************************************************
	** dndNodeDragger Class
	** Written by JabbyPanda, JudahPanda
	* 
	*  Reused the code from DDDraggerNode class written by Jonathan Doklovic
	** 2003 Fuseware LTD.
	**
	** This is the node dragger component used by the list components.
	** This component is used to make a "ghost copy" of the
	** node while it's being dragged.
	* 
	*******************************************************/
	//register our class
	
	import mx.events.EventDispatcher;
	
	/**
	* Drag node class
	* @tiptext Drag node class
	*/
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.display.MovieClip;
	import flash.xml.XMLNode;
	public class DndDraggerNode extends MovieClip {
		// "this" refers to the dragged node movieclip that follows the movieclip
		public var isDragging:Boolean = false;
		public var hasMoved:Boolean = false;
		public var SHIFT_ICON_DRAG_XPOSITION:Number = 12;
		public var SHIFT_ICON_DRAG_YPOSITION:Number = 8;
		protected var dispatchEvent:Function;
		public var addEventListener:Function;
		public var removeEventListener:Function;
		public var owner;
		public var draggedNodeInstance;
		public var noDropIcon:MovieClip;
		public var trashCan:MovieClip;
		public var drag_mc:MovieClip;
		public var node:XMLNode;
		public var nodes:Array;
		public var strNoDropIcon:String = "dndNoDropIcon";
		protected var m_copyControlMode:String;
		public var isCtrlButtonPressed:Boolean = false;
		public var moveAfterDropMode:Boolean = true;
		public var copyIcon:MovieClip;
		public var deleted:Boolean = false;
		public var transparency = 100;
		public var xOrigin:Number;
		public var yOrigin:Number;
		public var dragOnRollOut:Boolean = false;
		public var movementBeforeDrag:Number = 4;
		public var listOwner;
		
		protected static var eventDispatcherInitialized = EventDispatcher.initialize(DndDraggerNode.prototype);
		
		public function DndDraggerNode () {
			trace("new DnDDraggerNode");
			//trace("Dragger node added to the stage")
			//set our initial property values
			isDragging = false;
			hasMoved = false;
			//hide me by default
			visible = false;
			owner = this;
			xOrigin = mouseX;
			yOrigin = mouseY;
			//listOwner is passed in the initObject in the calling class
		}
		
		/*****************************************************
		** This method sets up the dragging of the dragger
		** node.  It's fired from the row onRowPress event
		******************************************************/
		// Drag and Drop Sequence
		// 3. add listeners to list and start dragging drag mc
		// drag_mc parameter can go
		public function beginDrag (theList:Object, drag_mc:MovieClip): void {
			// listen for mouse movements and call our mouse specific 
			// functions, onMouseMove and onMouseUp
			Mouse.addListener (this);
			Keyboard.addListener (this);
			startDrag (true);
			isDragging = true;
			if (theList==undefined && listOwner!=undefined) {
				theList = listOwner;
			}
			if (theList.dndEnabled) {
				theList.dispatchEvent({type:"onRowDrag", target:theList, drag_mc:this});		
			}
		}
		
		/*****************************************************
		** This method (fired from the mouse event) is used to
		** turn on the dragger symbol in case it's being
		** dragged AND the mouse has moved.  We have this so
		** you don't see the dragger everytime you click
		** something on the list without actually dragging it.
		******************************************************/
		// Drag and Drop Sequence
		// 4. catch mouse movement and dispatch to onDraggerMove event
		public function onMouseMove () : void{
			trace("onMouseMOve");
			if (isDragging) {
				if (!visible) {
					visible = true;
					alpha = transparency;
					hasMoved = true;
					x = mouseX + SHIFT_ICON_DRAG_XPOSITION;
					y = mouseY + SHIFT_ICON_DRAG_YPOSITION;
				}
				if (hasMoved) {
					// Drag and Drop Sequence
					// 6. Dispatch onDraggerMove event with reference to this
					dispatchEvent ({type:"onDraggerMove", target:this});
					updateAfterEvent();
				}
			}
			else {
				if (!dragOnRollOut) {
					if (mouseY < yOrigin-movementBeforeDrag || mouseY > yOrigin+movementBeforeDrag || 
								mouseX < xOrigin-movementBeforeDrag || mouseX > xOrigin+movementBeforeDrag) {
							//trace("moved more than " + movementBeforeDrag + " pixels. Begin dragging")
							this.beginDrag(listOwner);
					}
				}
			}
		}
		
		/*****************************************************
		** This method (fired from the mouse event) is used to
		** stop the dragger from dragging and to broadcast the
		** onDraggerDrop event to the list.
		******************************************************/
		// Drag and Drop Sequence
		// 8. User dropped node - remove listeners - broadcast onDraggerDrop
		public function onMouseUp ():void {
			stopDrag ();
			isDragging = false;
			public var owner = this.owner;
			//only broadcast the message if this was actually moved.
			if (hasMoved) {
				dispatchEvent ({type:"onDraggerDrop", target:this});
			}
			Mouse.removeListener (this);
			Keyboard.removeListener (this);
			removeEventListener("onDraggerMove", owner);
			removeEventListener("onDraggerDrop", owner);
			owner.removeDNDEventsListener();
			//remove me from the stage
			deleted = true;
			// what a pain! you cannot remove a movieclip with a depth higher than 1048575 
			// The call to removeMovieClip() then fails silently because it can't handle the out-of-range value
			// using swap depths so we can remove it
			this.swapDepths(1048575);
			//removeMovieClip(_root.newClip_mc);
			removeMovieClip (this);
		}
	
		// shows the custom "noDrop possible" cursor
		public function showCustomCursor()	:void {
			Mouse.hide();
			noDropIcon.visible = true;		
		}
		
		
		// hides the custom "noDrop possible" cursor
		public function hideCustomCursor():void 	{
			Mouse.show();
			noDropIcon.visible = false;
		}
		
		protected function onKeyDown(e:Object):void  {
	
			if (Keyboard.isDown(Keyboard.CONTROL)) {
				copyControlMode     = "COPY";		
				isCtrlButtonPressed = true;
			}
			else {
				copyControlMode   = "MOVE";
				isCtrlButtonPressed = false;
			}
		}
		
		protected function onKeyUp():void  {	
			isCtrlButtonPressed = false;
			// reset dragging mode to the default - the node will be removed after dragging ends
			copyControlMode   = "MOVE";	
		}
		
		function set copyControlMode(newValue:String) {
		
			switch (newValue) {
				case "COPY": {
					moveAfterDropMode = false;	
					
					if (isDragging) {									
						//------------COPY node-------------
						copyIcon.visible = true;
					}					
					break;
				}
				case "MOVE": {
					moveAfterDropMode = true;
					if (isDragging) {
						//------------MOVE node-------------
						copyIcon.visible = false;
					}
					
					break;	
				}			 
			}
			m_copyControlMode = newValue;
		}
		
		function get copyControlMode() {
			return m_copyControlMode;
		}
		
		public function successfulDrop(dropTarget:Object) :void {
			
		}
	}
}