/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.ui {
	import com.troyworks.data.filters.NumberRangeBooleanFilter;
	import com.troyworks.data.filters.RGBColorRangeFilter;

	public class ColorStatisticFilter extends RGBColorRangeFilter {
		
		public var distanceFromShadeFilter:NumberRangeBooleanFilter;
		public var colorSaturationFilter:NumberRangeBooleanFilter;
		public function ColorStatisticFilter(minimumLuminosity:uint = 0x000000, maximumLuminosity:uint = 0xFFFFFF, minInclusive:Boolean = true, maxInclusive:Boolean = true) {
			super(minimumLuminosity, maximumLuminosity, minInclusive, maxInclusive);	
		}
		
		override public function passesFilter(rgbC:*,  index:int= 0, array:Array = null):Boolean{
			var cst:ColorStatistic = (rgbC as ColorStatistic);
			var passes:Boolean =  super.passesFilter(cst.rgb);
			if(passes && (distanceFromShadeFilter != null)){
				passes = distanceFromShadeFilter.passesFilter(cst.distanceFromShade);
			}
			if(passes && (colorSaturationFilter != null)){
				passes = colorSaturationFilter.passesFilter(cst.saturation);
			}	
			
			return passes;
		}
	}
	
}
