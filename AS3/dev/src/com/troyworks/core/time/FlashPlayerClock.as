/**
* A 
* @author Troy Gardner
* @version 0.1
*/

package com.troyworks.core.time {
	import com.troyworks.core.time.IClock;
	import flash.utils.getTimer;
	public class FlashPlayerClock  implements IClock{
		
		public function FlashPlayerClock() {
			
		}
		/**synchronized 
		 * 
		 * @return The local machine time (note this is not the preferred method, PlayerClock is primarily for getTimer().
		*/
		public function time():Date {
			var d:Date = new Date();
			d.time = getTimer();
			return d;
		}
		/**synchronized 
		 * @return The local player time in milliseconds
		*/
		public function getTime():int {
			return getTimer();
		}

	}
	
}
