package com.troyworks.controls.tdraggable { 
	import flash.geom.Matrix;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
		
	/**
	 * @author Troy Gardner
	 */
	import flash.ui.Mouse;
	import flash.display.MovieClip;
	public class DraggableSource extends MovieClip {
		public var dragProxy:DragProxy;
		
		public function onPress() :void{
			trace("on dragProxyRequest");
	
		
		
		    DragProxy.getInstance().setDragSource(this);
			onMouseUp = releaseDragProxy;
		}
		function releaseDragProxy():void{
			DragProxy.getInstance().releaseDragSource(this);
			delete(onMouseUp);
		}
	}
}