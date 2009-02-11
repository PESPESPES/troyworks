package com.troyworks.geom.d2 { 
	import flash.geom.Rectangle;
	
	/**
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;
	public class Rect2D extends Rectangle {
	
		public var centerY : Number;
	
		public var centerX : Number;
		public function Rect2D(x : Number, y : Number, w : Number, h : Number) {
			super(x, y, w, h);
			centerX = left + width/2;
			centerY = right + height/2;
		}
		public function init(r:Rectangle):void{
			x = r.x;
			y = r.y;
			width = r.width;
			height = r.height;
			centerX = left + width/2;
			centerY = right + height/2;
		}
		public static function createRectFromClipBounds(_mc:MovieClip, context_mc:MovieClip):Rect2D{
			var b:Rectangle = _mc.getBounds(context_mc);
			var r:Rect2D = new Rect2D(b.x, b.y, b.width, b.height);
			return r;
		}
		public  function visualize(_mc:MovieClip):void{
			_mc.graphics.lineStyle(1, 0xFF00);
			_mc.graphics.moveTo(x, y);
	
			_mc.graphics.lineTo(right, y);
			_mc.graphics.lineTo(right, height);
			_mc.graphics.lineTo(left, bottom);
			_mc.graphics.lineTo(left, top);
		}
	
	}
}