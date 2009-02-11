package com.troyworks.framework { 
	
	/**
	 * @author Troy Gardner
	 */
	import flash.events.MouseEvent;	
	import flash.display.DisplayObjectContainer;	

	import com.troyworks.framework.controller.CollectionManager;	

	import flash.display.*;

	public class SelectionManager extends CollectionManager {
		public static var SINGLE_SELECT_MODE : Number = 0;
		public static var MULTIPLE_SELECT_MODE : Number = 1;
		public var selectionMode : Number = SINGLE_SELECT_MODE;
		public var onChildRelease : Number;
		public var topClip : Sprite;
//		public var topClipDepth : Number = 1000;

		public function SelectionManager(name : String, scope : DisplayObjectContainer) {
			super(name);
			scope.addEventListener(MouseEvent.CLICK, onClick);
		}

		public function onClick(evt : MouseEvent) : void {

			push(evt.target);
		}

		public function setTopClip(_mc : Sprite) : void {
			if(topClip != null) {
				//topClip.swapDepths(_mc);
				_mc.parent.addChild(_mc);
				topClip = _mc;
			}else {
				_mc.parent.addChild(_mc);
				//_mc.swapDepths(topClipDepth);
				topClip = _mc;
			}
		}

		override public function push(obj : Object) : Number {
			var res : Number;
			var i:Number;
			if(selectionMode == SINGLE_SELECT_MODE) {
				for( i = 0;i < c.length; i++) {
					c[i].isSelected = false;
				}
				obj.selectedOrder = 1;
				res = super.push(obj);
			}else if(selectionMode == MULTIPLE_SELECT_MODE) {
				res = super.push(obj);
				for(i = 0;i < c.length; i++) {
					c[i].selectedOrder = (i + 1);
				}
			}
			return res;
		}

		public function remove(obj : Object) : void {
			super.removeFromCollectionItem(obj);
			for(var i : Number = 0;i < c.length; i++) {
				c[i].selectedOrder = (i + 1);
			}
		}

		public function get totalSelected() : Number {
			return c.length;
		}

		public function onMouseDown() : void {
			trace(" MouseDown");
		}

		public function onMouseUp() : void {
			trace(" MouseUp" + onChildRelease);
			/////////// hit test ///////////
			if(isNaN(onChildRelease)) {
				for(var i : Number = 0;i < c.length; i++) {
					c[i].isSelected = false;
				}
			}else {
				onChildRelease = NaN;
			}
		}
	}
}