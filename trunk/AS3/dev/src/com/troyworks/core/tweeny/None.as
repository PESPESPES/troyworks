/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.core.tweeny {

	public class None extends EasingEquation{
		
		public static const easeOut:Function = easeIn;
		public static const easeInOut:Function = easeIn;
		public static const easeOutIn:Function = easeIn;
		/**
		 * Easing equation function for no tween, useful as a snap to point
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */
		public static function easeIn (t:Number, b:Number, c:Number, d:Number):Number {
			return c+ b;
		}
	
	}
	
}
