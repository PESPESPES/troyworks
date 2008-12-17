/**
 * ...
 * @author Default
 * @version 0.1
 */

package com.troyworks.data.filters {

	public class RGBColorRangeFilter extends RangeFilter {
		var passR : Boolean = true;
		var passG : Boolean = true;
		var passB : Boolean = true;
		var cR : uint;
		var cG : uint;
		var cB : uint;

		var lR : uint ;
		var lG : uint ;
		var lB : uint ;

		var hR : uint;
		var hG : uint;
		var hB : uint;

		
		public function RGBColorRangeFilter(minimumLuminosity : uint = 0x000000, maximumLuminosity : uint = 0xFFFFFF, minInclusive : Boolean = true, maxInclusive : Boolean = true) {
			minI = minInclusive;
			maxI = maxInclusive;	
			minColor = minimumLuminosity;
			maxColor = maximumLuminosity;
		}

		public function set maxColor(maximumLuminosity : uint) : void {
			hR = maximumLuminosity >> 16;
			hG = maximumLuminosity >> 8 & 0xFF;
			hB = maximumLuminosity & 0xFF;
		}

		public function set minColor(minimumLuminosity : uint) : void {
			lR = minimumLuminosity >> 16;
			lG = minimumLuminosity >> 8 & 0xFF;
			lB = minimumLuminosity & 0xFF;
		}

		override public function passesFilter(rgbC : *,  index : int = 0, array : Array = null) : Boolean {
			var rgb : uint = uint(rgbC);
			cR = rgb >> 16;
			cG = rgb >> 8 & 0xFF;
			cB = rgb & 0xFF;
			passR = (minI ? (lR <= cR) : (lR < cR) ) && ( maxI ? (cR <= hR) : (cR < hR));
			passG = ( minI ? (lG <= cG) : (lG < cG)) && ( maxI ? (cG <= hG) : (cG < hG));
			passB = (minI ? (lB <= cB) : (lB < cB)) && ( maxI ? (cB <= hB) : (cB < hB));
			//	trace(rgb + " =  " + passR + " " + passG + " " + passB);
			var passes : Boolean = false;
			if(passR && passG && passB) {
				passes = true;
			}else {
				passes = false;
			}
			var res : Boolean = (invert) ? !passes : passes; 
			if(res) {
				onPassedFiltered();
			}
			return res;
		}
	}
}
