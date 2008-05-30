/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.core.tweeny {

	public class Cubic {
		
		/**
		 * Easing equation function for a cubic (t^3) easing in: accelerating from zero velocity.
 		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeIn (t:Number, b:Number, c:Number, d:Number):Number {
			return c*(t/=d)*t*t + b;
		}
	
		/**
		 * Easing equation function for a cubic (t^3) easing out: decelerating from zero velocity.
 		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeOut (t:Number, b:Number, c:Number, d:Number):Number {
			return c*((t=t/d-1)*t*t + 1) + b;
		}
	
		/**
		 * Easing equation function for a cubic (t^3) easing in/out: acceleration until halfway, then deceleration.
 		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeInOut (t:Number, b:Number, c:Number, d:Number):Number {
			if ((t/=d/2) < 1) return c/2*t*t*t + b;
			return c/2*((t-=2)*t*t + 2) + b;
		}
	
		/**
		 * Easing equation function for a cubic (t^3) easing out/in: deceleration until halfway, then acceleration.
 		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeOutIn (t:Number, b:Number, c:Number, d:Number):Number {
			if (t < d/2) return easeOut (t*2, b, c/2, d);
			return easeIn((t*2)-d, b+c/2, c/2, d);
		}
	}
	
}
