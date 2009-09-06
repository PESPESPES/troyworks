/**
 * ...
 * @author Default
 * @version 0.1
 */

package com.troyworks.util {

		/* pick a integer from 0<=n < passed in num, useful for arrays
		 * MUST use positive
		 */
		//http://osflash.org/as3_speed_optimizations
		public static function randomPositiveInt(range : Number) : Number {
			var res : int = (Math.random() * range);
			return res;
		}

		public static function randomPositiveIntInclusive(range : Number) : int {
			var res : int = (Math.random() * range + 1);
			return res;
		}

		 * randRange(4, 11), works for positive and negative,
		 */ 
		public static function randomInRange(min : Number, max : Number) : Number {
			var randomNum : Number = Math.floor(Math.random() * (max - min + 1)) + min;
			return randomNum;
		}

			var res : Number = Math.min(Math.max(min, src), max);
			trace(min + " " + res + " " + max);
			return res;
		}
		/* takes a number and shifts it closest to the range/bin interval with base/offset
		 * by Offset-> |<---range -->|<---range -->|<---range -->|
		 * Shifts      |<<<<<<<>>>>>>|<<<<<<<>>>>>>|<<<<<<<>>>>>>|;  
		 * e.g. range 5, offset 0
		 * IN ->OUTPUT  
		 * 22 -> 20
		 * 23 -> 25  //shifts up.
		 * 68 -> 65 //shifts down
		 * 
		 * works with negative nubmers
		 * 
		 * COmpare with
		 * 	var to:Number = 5;
			var r:Number = v %to;
			var bin:Number = (v-r);
		 */
			var dif = (src - base) % range;
			var n = src - dif;
			if (dif != 0) {
				if (dif >= range / 2) {
					n += range;
				} else if (dif < -range / 2) {
					n -= range;
				}
			}
			return n;
		}

		 * Tests if two numbers are <em>almost</em> equal.
		 */
		public function almostEqual(number1 : Number, number2 : Number, precision : int = 5) : Boolean {
			var difference : Number = number1 - number2;
			var range : Number = Math.pow(10, -precision);
			//default check:
			//0.00001 <difference> -0.00001

		}

		 * Rounds a target number to a specific number of decimal places.
		 * @see Math#round
		 */


			var decimalPlaces : Number = Math.pow(10, precision);
			var res : Number = Math.round(decimalPlaces * number) / decimalPlaces;
			//	trace("round to Precision " + number + " = " + res);

		}
	}
}