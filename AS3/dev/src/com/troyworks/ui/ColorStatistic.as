/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.ui {

	public class ColorStatistic {
		public var rgb:uint;
		public var total:int;
		public var percent:Number;
		public var distanceFromShade:Number;
		public var saturation:Number;
		public function ColorStatistic(rgb:uint, total:int, percent:Number) {
	
			this.rgb =rgb;
			this.total = total;
			this.percent = percent;
			//distanceFromShade = ColorUtil.getDistanceFromShade(rgb);
			saturation = ColorUtil.getSaturationFromRGB(rgb);
					
		}
		public function toString():String{
			return "ColorStatistic " + rgb + " " + total +  " per " + percent + " dist " + distanceFromShade ;
		}
		
		
	}
	
}
