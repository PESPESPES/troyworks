/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.core.time {
	import com.troyworks.core.time.IClock;	
	
	public class BaseClock implements IClock {
		protected var _time:Date;
		protected var _millis:int;
		
		public function BaseClock() {
		}
		
		/* synchronized */
		public function time():Date{
			return _time;
		}
		public function getTime():int{
			return _millis;
		}
		/* synchronized */
		public function advanceTo(newTime:Date):void{
			var newMillis:int = int(newTime.getTime());
			if (newMillis == _millis){
				return;
			}else{
				_millis = newMillis;
				_time = newTime;
			}
		}
	}	
}
