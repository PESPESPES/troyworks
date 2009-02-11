/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.dayinlife {
	import com.troyworks.logging.TraceAdapter;
	public class MainDayInLife {
		public var trace:Function = TraceAdapter.TraceToSOS;
		
		public function MainDayInLife() {
			trace("new MainDayInLife");
		}
		public function test_1():void{
			trace("create test_1---------------------");
			var d:DayInLife = new DayInLife();
			
		}
		
	}
	
}
