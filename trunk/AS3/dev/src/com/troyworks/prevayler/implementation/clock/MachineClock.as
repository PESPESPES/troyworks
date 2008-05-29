/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.prevayler.implementation.clock {

	public class MachineClock {
		
		/**synchronized 
		 * @return The local machine time.
		*/
		override public function time():Date {
			update();
			return super.time();
		}
		/*synchronized*/
		private  function update():void {
			var newTime:Number = new Date().time();
			if (newTime != _millis) advanceTo(new Date(newTime));
		}
	}
	
}
