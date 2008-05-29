//Prevayler(TM) - The Free-Software Prevalence Layer.
//Copyright (C) 2001-2003 Klaus Wuestefeld
//This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

/** A deterministic Clock that always returns the same time until it is forced to advance. 
 * This class is useful as a Clock mock in order to run automated tests involving date/time related rules.
 * A new BrokenClock's time() starts off at new Date(0);
* @author Default
* @version 0.1
*/

package com.troyworks.prevayler.implementation.clock {
	import com.troyworks.prevayler.Clock;

	public class BrokenClock implements Clock {
		private var _time:Date;
		protected var _millis:Number;
		
		public function BrokenClock(time:Date = null) {
			if(time == null){
				_time = new Date();
			}else{
				_time =time;
				_millis = time.getTime();
			}
		}
		/* synchronized */
		public function time():Date{
			return _time;
		}
		/* synchronized */
		public function advanceTo(newTime:Date):void{
			var newMillis:Number = newTime.getTime();
			if (newMillis == _millis) return;
				_millis = newMillis;
				_time = newTime;
			}
	}
	
}
