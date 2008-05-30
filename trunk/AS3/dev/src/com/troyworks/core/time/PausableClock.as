/**
//Prevayler(TM) - The Free-Software Prevalence Layer.
//Copyright (C) 2001-2003 Klaus Wuestefeld
//This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
* @author Default
* @version 0.1
*/

package com.troyworks.core.time {
	

	public class PausableClock implements IClock  {
		private final var _realClock:IClock;
		private final var  _brokenClock:BrokenClock = new BrokenClock();
		private var _activeClock:IClock;
		
		public function PausableClock (realClock:IClock) {		
			_realClock = realClock;
			resume();
		}
		/*synchronized Date */
		public function  time():Date {
			return _activeClock.time(); 
		}
		public function  getTime():int {
			return _activeClock.getTime(); 
		}

		///////////////////////////////
		/*synchronized  */
		public function pause():void {
			advanceTo(_realClock.time());
			_activeClock = _brokenClock;
		}
		public function advanceTo(time:Date):void {
			_brokenClock.advanceTo(time);
		}
		/*synchronized */
		public function resume() :void{
			_activeClock = _realClock;
		}
		
		public function realTime() : Date{
			return _realClock.time(); 
		}
	}
}
