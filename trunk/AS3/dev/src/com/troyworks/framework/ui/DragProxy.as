package com.troyworks.framework.ui { 
	import flash.display.BitmapData;
	import flash.filters.DropShadowFilter;
	/**
	 * @author Troy Gardner
	 */
	import flash.ui.Mouse;
	import flash.display.MovieClip;
	public class DragProxy extends MovieClip{// DraggableClip {
		public var xOffset:Number = 0;
		public var yOffset:Number = 0;
		protected static var instance : DragProxy;
		public var proxyImage:MovieClip;
		public var currentClip:MovieClip;
		public var ghostImage:BitmapData; 
		protected var isLoaded : Boolean = false;
		
		/**
		 * @return singleton instance of DragProxy
		 */
		public static function getInstance() : DragProxy {
	
			return instance;
		}
		
		public function DragProxy() {
			trace("new ProxyImage");
			instance = this;
		}
		public function setDragSource(_mc:MovieClip):void{
			currentClip = _mc;
			trace("setDragSource " + _mc.name + " " + isLoaded);
			var bounds:Object = _mc.getBounds(_mc);
			xOffset = _mc.mouseX-bounds.xMin;
			yOffset = _mc.mouseY-bounds.yMin;
			trace("xOffset " + xOffset + " yOffset " + yOffset);
			updatePosition();
			ghostImage = new BitmapData(_mc.width, _mc.height, true);
			trace("w " + ghostImage.width + " h " + ghostImage.height);
			trace("proximage " + proxyImage);
			
			proxyImage.addChildAt(null, 2);
			proxyImage.addChildAt(ghostImage, 2);
			var ds:DropShadowFilter = new DropShadowFilter(10,45,0x000000,20);
			proxyImage.filters = [ds];
			ghostImage.draw(_mc);
		//	visible = true;
		}
		public function onLoad():void{
			trace("DragProxy.onLoad");
			proxyImage= createEmptyMovieClip("proxyImage", getNextHighestDepth());	
			
			isLoaded = true;
			alpha = 60;
		
		}
		public function onMouseMove():void{
			updatePosition();
		}
		function updatePosition():void{
		//	trace("updatePosition");
			x = parent.mouseX - xOffset;
			y = parent.mouseY- yOffset;
		}
		public function releaseDragSource(releaseMC : MovieClip) : void {
				trace("DragProxy.releaseDragSource");
				ghostImage.dispose();
			//		proxyImage.addProperty()
			//		visible = false;
		}
	
	}
}