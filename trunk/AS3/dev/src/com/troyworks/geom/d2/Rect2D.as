package com.troyworks.geom.d2 { 
	import flash.geom.Rectangle;
	
	/**
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;
	public class Rect2D extends Rectangle {
	
		public var CY : Number;
	
		public var CX : Number;
		
		public function Rect2D(x : Number, y : Number, w : Number, h : Number) {
			super(x, y, w, h);
			CX = left + width/2;
			CY = right + height/2;
		}
		public static function createRectFromClipBounds(_mc:MovieClip, context_mc:MovieClip):Rect2D{
			var b:Object = _mc.getBounds(context_mc);
			var r:Rect2D = new Rect2D(b.xMin, b.yMin, b.xMax - b.xMin, b.yMax- b.yMin);
			return r;
		}
		
	
	}
}