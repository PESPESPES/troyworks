/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.core.tweeny {

	public class Easing {
		
		var ease:Function;
		var o1:Object;
		var o2:Object;
		var o3:Object;
//		var cnt:Number = 0;
		
		public function Easing($ease:Function, $o1:Object = null, $o2:Object = null, $o3:Object = null) {
			ease = $ease;
			o1 = $o1;
			o2 = $o2;
			o3 = $o3;
		}
				/**
		 * Easing equation function for a simple linear tweening, with no easing.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public function easeRelay1 (t:Number, b:Number, c:Number, d:Number):Number {	
			return ease(t,b,c,d,o1);
		}
		public function easeRelay2 (t:Number, b:Number, c:Number, d:Number):Number {	
		//	trace("easeR2 " + o1 + " " + o2);
			return ease(t,b,c,d,o1, o2);
		}
		public function easeRelay3 (t:Number, b:Number, c:Number, d:Number):Number {	
			return ease(t,b,c,d,o1,o2,o3);
		}
		
		//////////////// FACTORY METHODS ////////////////////////////////
		/* Easing equation function for an elastic (exponentially decaying sine wave) easing in: accelerating from zero velocity.
		 *
		 * @param a		Amplitude.
		 * @param p		Period.
		 * @return		The correct value.*/
		public static function getElastic(fn:Function, amplitude:Number = Number.NaN, period:Number = Number.NaN):Function{
			
			var eP:Easing = new Easing(fn,amplitude,period);
			return eP.easeRelay2;
		}
		/* @param s		Overshoot ammount: higher s means greater overshoot (0 produces cubic easing with no overshoot, and the default value of 1.70158 produces an overshoot of 10 percent).*/
		public static function getBack(fn:Function, overshoot:Number = Number.NaN):Function{
			var eP:Easing = new Easing(fn,overshoot);
			return eP.easeRelay1;
		}



	}
	
}
