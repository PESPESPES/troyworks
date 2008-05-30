/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.core.tweeny {

	public class Bouncy extends EasingEquation {
		
		public var bounce:Boolean = false;
		public var spring:Number = 0.1;
		public var gravity:Number = 0;
		public var friction:Number = 0.8;
		var v:Number = 0;
		var lv:Number =0;
		var p:Number = 0;
		public function Bouncy() {
			
		}
		public function reset():void{
			v = 0;
			p = 0;
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
		public function ease(t:Number, b:Number, c:Number, d:Number):Number {	
			v += ((b+c) - p) * spring;
			v *= friction;
			v += gravity;
			if(bounce && (p < 0)){
				v *= -1;
			}
			p += v;
			lv = v;
			return p;
		}			
	}
	
}
