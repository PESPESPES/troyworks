/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.core.tweeny {

	public class Linear {
		
		public static const easeOut:Function = easeIn;
		public static const easeInOut:Function = easeIn;
		public static const easeOutIn:Function = easeIn;
		/**
		 * Easing equation function for a simple linear tweening, with no easing.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeIn (t:Number, b:Number, c:Number, d:Number):Number {
		//	trace("t " + t + " b" + b + " c " + c + " d " + d);
			return c*t/d + b;
		}
		
	}
	
}
