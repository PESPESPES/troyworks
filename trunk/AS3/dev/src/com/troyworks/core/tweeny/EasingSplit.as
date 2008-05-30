/**
* used to create a sharp overlap split point(s), the 
* 
* e.g. Expo.easeIn for the first half, Elastic.easeOut for the second half, jumping immediately at the split time

* .25%
*          %
*    [fn1..[________fn2]];
* 
* .5%
*              %
*    [fn1......[_____fn2]];
* 
* .75%
*                  %
*    [fn1..........[__fn2]];
* 
* EXAMPLE: Physics Bounds with Snap At End
* var bny:Bouncy = new Bouncy();
* //bny.friction = .99;
* //bny.spring = .05;
* var epr:EasingSplit = new EasingSplit(bny.ease,None.easeInOut,1);
* @author Troy Gardner
* @version 0.1
*/

package com.troyworks.core.tweeny {

	public class EasingSplit {
		
		/* easing function 1 */
		public var ease1:Function;
		/* easing function 2 */
		public var ease2:Function;
		/* percentage of duration to use as the switch */
		public var perc:Number;
		
		public function EasingSplit(easeFn1:Function, easeFn2:Function, switchAtPercentageOfDuration:Number = .5) {
			ease1 = easeFn1;
			ease2 = easeFn2;
			perc = switchAtPercentageOfDuration;
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
			trace("ease " + t + " " + d);
			if(t < (perc * d)){
				trace("ease1");
				return ease1(t,b,c,d);
			}else{
				trace("ease2");
				return ease2(t,b,c,d);
			}
		}	
	}
	
}
