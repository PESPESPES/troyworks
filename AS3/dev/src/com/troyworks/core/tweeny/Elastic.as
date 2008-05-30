/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.core.tweeny {

	public class Elastic {
		
		public function Elastic() {
			
		}
				/**
		 * Easing equation function for an elastic (exponentially decaying sine wave) easing in: accelerating from zero velocity.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @param a		Amplitude.
		 * @param p		Period.
		 * @return		The correct value.
		 */
		public static function easeIn (t:Number, b:Number, c:Number, d:Number, a:Number = Number.NaN, p:Number = Number.NaN):Number {
			if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
			var s:Number;
			if (!a || a < Math.abs(c)) { a=c; s=p/4; }
			else s = p/(2*Math.PI) * Math.asin (c/a);
			return -(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
		}
	
		/**
		 * Easing equation function for an elastic (exponentially decaying sine wave) easing out: decelerating from zero velocity.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @param a		Amplitude.
		 * @param p		Period.
		 * @return		The correct value.
		 */
		public static function easeOut (t:Number, b:Number, c:Number, d:Number, a:Number = Number.NaN, p:Number = Number.NaN):Number {
			if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
			var s:Number;
			if (!a || a < Math.abs(c)) { a=c; s=p/4; }
			else s = p/(2*Math.PI) * Math.asin (c/a);
			return (a*Math.pow(2,-10*t) * Math.sin( (t*d-s)*(2*Math.PI)/p ) + c + b);
		}
	
		/**
		 * Easing equation function for an elastic (exponentially decaying sine wave) easing in/out: acceleration until halfway, then deceleration.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @param a		Amplitude.
		 * @param p		Period.
		 * @return		The correct value.
		 */
		public static function easeInOut (t:Number, b:Number, c:Number, d:Number, a:Number = Number.NaN, p:Number = Number.NaN):Number {
			if (t==0) return b;  if ((t/=d/2)==2) return b+c;  if (!p) p=d*(.3*1.5);
			var s:Number;
			if (!a || a < Math.abs(c)) { a=c; s=p/4; }
			else s = p/(2*Math.PI) * Math.asin (c/a);
			if (t < 1) return -.5*(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
			return a*Math.pow(2,-10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )*.5 + c + b;
		}
	
		/**
		 * Easing equation function for an elastic (exponentially decaying sine wave) easing out/in: deceleration until halfway, then acceleration.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @param a		Amplitude.
		 * @param p		Period.
		 * @return		The correct value.
		 */
		public static function easeOutIn (t:Number, b:Number, c:Number, d:Number, a:Number = Number.NaN, p:Number = Number.NaN):Number {
			if (t < d/2) return easeOut (t*2, b, c/2, d, a, p);
			return easeIn((t*2)-d, b+c/2, c/2, d, a, p);
		}
	
	}
	
}
