package com.troyworks.framework { 
	
	/**
	 * @author Troy Gardner
	 */
	import flash.ui.Mouse;
	import flash.display.MovieClip;
	public class SelectionManager extends CollectionManager {
		public static var SINGLE_SELECT_MODE : Number = 0;
		public static var MULTIPLE_SELECT_MODE : Number = 1;
		public var selectionMode : Number = SINGLE_SELECT_MODE;
		public var onChildRelease : Number;
		public var topClip:MovieClip;
		public var topClipDepth:Number = 1000;
		
		public function SelectionManager(name : String) {
			super(name);
			Mouse.addListener(this);
		}
		public function setTopClip(_mc:MovieClip):void{
			if(topClip != null){
				topClip.swapDepths(_mc);
				topClip = _mc;
			}else{
				_mc.swapDepths(topClipDepth);
				topClip = _mc;
			}
		}
		public function push(obj : Object) : void{
			
			if(selectionMode == SINGLE_SELECT_MODE){
				for(var i : Number = 0; i < c.length; i++){
					c[i].isSelected = false;
				}
				obj.selectedOrder = 1;
				super.push(obj);
			}else if(selectionMode == MULTIPLE_SELECT_MODE){
				super.push(obj);
				for(var i : Number = 0; i < c.length; i++){
					c[i].selectedOrder = (i+1);
				}
			}
		}
		public function remove(obj : Object) : void{
			super.remove(obj);
			for(var i : Number = 0; i < c.length; i++){
				c[i].selectedOrder = (i+1);
			}
		}
	
		public function get totalSelected():Number{
			return c.length;
		}
			
		public function onMouseDown() : void{
			trace(" MouseDown");
		}
		
		public function onMouseUp() : void{
			trace(" MouseUp" + onChildRelease);
			/////////// hit test ///////////
			if(onChildRelease == null){
				for(var i : Number = 0; i < c.length; i++){
					c[i].isSelected = false;
				}
			}else{
				onChildRelease = null;
			}
		}
	}
}