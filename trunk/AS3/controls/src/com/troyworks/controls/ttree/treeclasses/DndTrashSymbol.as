package com.troyworks.ui.controls.treeclasses { 
	/*******************************************************
	** dndTrashSymbol Class
	** Written by JabbyPanda
	* 
	*  Reused the code from DDTrash class written by Jonathan Doklovic
	** 2003 Fuseware LTD.
	**
	** This is the trash icon movieclip class
	** This trash movieclips is used to wipe out dropped over items 
	** from a list
	* 
	*******************************************************/
	
	//register our class
	import flash.display.MovieClip;
	public class DndTrashSymbol extends MovieClip {
		
		public function DndTrashSymbol() {
			// nothing to do
		}
		
		// *******************
		// ** onDraggerMove **
		// *******************
		// ******************************************************
		// ** This method captures movement of something being
		// ** dragged.
		// *****************************************************
		function onDraggerMove(eventObj:Object):void {		
			// if node is on the trash, show the on state
			if (this.hitTest(_root.mouseX, _root.mouseY)) {
				//trace("over trash can");
				this.gotoAndStop("on");
			} else {
				this.gotoAndStop("off");
			}
		}
		
		// *******************
		// ** onDraggerDrop **
		// *******************
		// ******************************************************
		// ** This method captures the drop event when a node is
		// ** dropped.
		// *****************************************************
		function onDraggerDrop(eventObj:Object):void {
			
			public var listMC = eventObj.target._theList;
			trace ("Trash onDraggerDrop " + eventObj.target + ":" + listMC);	
			// if dragger is dropped on the trash, run the onDrop function
			if (this.hitTest(_root.mouseX, _root.mouseY)) {
				trace("next step " + listMC.dataProvider.length);
				// get the node to delete
				var i;
				for (i=0; i<listMC.dataProvider.length; i++) {			
					if (eventObj.target._index == i) {
						trace ("next step completed");
						listMC.removeItemAt(i);
						// go to off state
						this.gotoAndStop("off");	
					}
				}
			}
		}
	}
	
}