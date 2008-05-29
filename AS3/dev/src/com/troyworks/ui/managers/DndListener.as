package com.troyworks.ui.managers { 
	/*******************************************************
	** dndListener Class
	** Written by JabbyPanda, JudahPanda
	* 
	*  Inspired from DDTrash class written by Jonathan Doklovic
	** 2003 Fuseware LTD.
	**
	** This is the listener class. A movieclip that inherits this class can 
	** receive onDragOver, onDragOut and onDrop events from any other dndUIWidget
	* 
	*******************************************************/
	import mx.events.EventDispatcher;
	import mx.utils.Delegate;
	
	//register our class
	import flash.ui.Mouse;
	import flash.display.MovieClip;
	public class DndListener extends MovieClip {
		protected var _inited:Boolean;
		
		public var addEventListener:Function;
		public var removeEventListener:Function;
		protected var dispatchEvent:Function;
		protected var isOver:Boolean;
		public var noDropIcon:MovieClip;
	
		public function DndListener() {
			if (!_inited) init();
		}
		
		// priv methods
		protected function init():void{
			EventDispatcher.initialize(this);
			_inited = true;
			public var crossdndWidgetList:DndUIWidgets = DndUIWidgets.getWidgetList ();	
			crossdndWidgetList.addItem(this);
		}
		
		// *******************
		// ** onDraggerMove **
		// *******************
		// ******************************************************
		// ** This method captures movement of something being
		// ** dragged.
		// *****************************************************
		function onDraggerMove(eventObj:Object):void {
			//trace("drag move")
			// if node is on the trash, show the on state
			if (this.hitTest(_root.mouseX, _root.mouseY)) {
				if (!isOver) {
					//trace("drag hit move")
					hideCustomCursor();
					dispatchEvent ({type:"onDragOver", target:this, drag_mc:eventObj.target});
					isOver = true;
				}
			} else {
				if(isOver) {
					showCustomCursor();
					dispatchEvent ({type:"onDragOut", target:this, drag_mc:eventObj.target});	
					isOver = false;
				}
			}
		}
		
		// *******************
		// ** onDraggerDrop **
		// *******************
		// ******************************************************
		// ** This method captures the drop event when the drag_mc is
		// ** dropped.
		// *****************************************************
		function onDraggerDrop(eventObj:Object):void  {
			
			// if dragger is dropped on the trash, run the onDrop function
			if (this.hitTest(_root.mouseX, _root.mouseY)) {
				hideCustomCursor();
				dispatchEvent ({type:"onDrop", target:this, drag_mc:eventObj.target});
			}
		}
	
		// shows the custom "noDrop possible" cursor
		public function showCustomCursor():void {
			Mouse.hide();
			noDropIcon.visible = true;		
		}
		
		
		// hides the custom "noDrop possible" cursor
		public function hideCustomCursor():void 	{
			Mouse.show();
			noDropIcon.visible = false;
		}
	}
	
}