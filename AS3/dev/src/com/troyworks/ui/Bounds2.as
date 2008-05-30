package com.troyworks.ui { 
	/**
	 *  a varient on the Bounds used for MovieClip.getBounds(context)
	 *  that provides width, height and midX and midY with the data
	 *  user like
	 *  
	 *  var b:Bounds2 = new Bounds2(_mc.getBounds(this));
	 *  
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;
	public class Bounds2 extends Object {
		
		public var yMax:Number =0;
		public var yMin:Number = 0;
		public var xMax:Number = 0;
		public var xMin:Number = 0;
		public var yMid:Number = 0;
		public var xMid:Number = 0;
		public var width:Number =0;
		public var height:Number =0;
		
		public function Bounds2(b:Object = null) {
			for(var i:String in b){
				this[i] = b[i];
			}
			width  =(xMax - xMin);
			height = (yMax - yMin);
			yMid = yMin + height /2;
			xMid = xMin + width/2;
			
		}
		public static function getBounds(_mc:MovieClip, scope:MovieClip):Bounds2{
			var res:Bounds2 = new Bounds2(_mc.getBounds(scope));
			return res;
		}
		public function contains(x: Number, y : Number) : Boolean {
			if(xMin <= x && x<=xMax && yMin <= y && y <=yMax){
				return true;
			}
			return false;
		}
		/* for the given bounding rect enlarge from each side the number of pixels, increasing the size of the rect*/
		public function inflateBy(pixelPad:Number):void{
			xMax += pixelPad;
			yMax += pixelPad;
			xMin -= pixelPad;
			yMin -= pixelPad;
		}
		/* for the given bounding rect subtract from each side the number of pixels, reduce the size of the rect*/
		public function shrinkBy(pixelPad:Number):void{
			xMax -= pixelPad;
			yMax -= pixelPad;
			xMin += pixelPad;
			yMin += pixelPad;
		}
		
		public function toString():String{
			return "xMin "+ xMin + " xMax " + xMax + " yMin " + yMin + " yMax " + yMax;
		}
		public function visualize(_mc:MovieClip):void{
			_mc.graphics.lineStyle(1, 0xFF00);
			_mc.graphics.moveTo(xMin, yMin);
	
			_mc.graphics.lineTo(xMax, yMin);
			_mc.graphics.lineTo(xMax, yMax);
			_mc.graphics.lineTo(xMin, yMax);
			_mc.graphics.lineTo(xMin, yMin);
		}
	
	}
}