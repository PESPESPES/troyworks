/**
 * ...
 * @author Default
 * @version 0.1
 */

package com.troyworks.util {

	public class NumberUtil {
		public static function fitToRange(src : Number, min : Number, max : Number) : Number {
			var res : Number = Math.min(Math.max(min, src), max);
			trace(min + " " + res + " " + max);
			return res;
		}

		public static function snap(src : Number, range : Number, base : Number) : Number {
			var dif = (src - base) % range;
			var n = src - dif;
			if (dif > 0) {
				if (dif > range / 2) {
					n += range;
				}
			} else if (dif < -range / 2) {
				n -= range;
			}
			return n;
		}

		/**
		 * Tests if two numbers are <em>almost</em> equal.
		 */
		public function almostEqual(number1 : Number, number2 : Number, precision : int = 5) : Boolean {
			var difference : Number = number1 - number2;
			var range : Number = Math.pow(10, -precision);
			//default check:
			//0.00001 <difference> -0.00001

			return (difference < range) && (difference > -range);
		}

		/*
		 * Rounds a target number to a specific number of decimal places.
		 * @see Math#round
		 */

		public static function roundToPrecision(number : Number, precision : int = 0) : Number {

			var decimalPlaces : Number = Math.pow(10, precision);
			var res:Number= Math.round(decimalPlaces * number) / decimalPlaces;
		//	trace("round to Precision " + number + " = " + res);
			
			return res; 
		}
	}
}
