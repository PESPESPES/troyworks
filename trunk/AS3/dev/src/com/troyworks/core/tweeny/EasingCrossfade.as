/**
* CrossFades two tweens around the split point like an A/B slider on a DJ rig.
* 
* ==============     ------------
* ==(ease1)======xXx---(ease2)---
* =============xxXXXxx-----------
* 
* @author Troy Gardner
* @version 0.1
*/

package com.troyworks.core.tweeny {

	public class EasingCrossfade {
		/* easing function 1 */
		public var ease1:Function;
		/* easing function 2 */
		public var ease2:Function;
		/* percentage of duration to use as the switch */
		public var perc:Number;
		/* percentage of duration to use as the switch */
		public var cross:Number;
		
		/* percentage of duration to use as the switch */
		 var sp:Number;
		 var ep:Number;
		
		public function EasingCrossfade(easeFn1:Function, easeFn2:Function, switchAtPercentageOfDuration:Number = .5, crossFadeWidthPercent:Number = .1) {
			ease1 = easeFn1;
			ease2 = easeFn2;
			perc = switchAtPercentageOfDuration;
			cross = crossFadeWidthPercent;
			var hc:Number  = cross/2;
			sp = perc - hc;
			ep = perc + hc;
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
		///	trace("ease " + t + " " + d);
			if(t < sp){
		//		trace("ease1");
				return ease1(t,b,c,d);
			}else if(ep < t){
		///		trace("ease2");
				return ease2(t,b,c,d);
			}else{
				//average  
				var ct:Number = t-sp/cross;
				var a:Number = ease1(t,b,c,d) * (1- ct);
				var b:Number = ease2(t,b,c,d) * ct;
				return (a+b)/2;
			}
		}	
	}
	
}
