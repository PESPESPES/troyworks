package com.troyworks.controls.tdraggable {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;	 

	/**
	 * @author Troy Gardner
	 */

	
	public class DraggableSource extends MovieClip {
		public var dragProxy:DragProxy;
		
		public function onPress() :void{
			trace("on dragProxyRequest");
	
		
		
		    DragProxy.getInstance().setDragSource(this);
			//onMouseUp = releaseDragProxy;
			addEventListener(MouseEvent.MOUSE_UP, releaseDragProxy);
		}
		function releaseDragProxy(evt:MouseEvent = null):void{
			DragProxy.getInstance().releaseDragSource(this);
			//delete(onMouseUp);
			removeEventListener(MouseEvent.MOUSE_UP, releaseDragProxy);
		}
	}
}