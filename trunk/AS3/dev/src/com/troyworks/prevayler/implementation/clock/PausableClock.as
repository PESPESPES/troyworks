/**
//Prevayler(TM) - The Free-Software Prevalence Layer.
//Copyright (C) 2001-2003 Klaus Wuestefeld
//This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
* @author Default
* @version 0.1
*/

package com.troyworks.prevayler.implementation.clock {
	import com.troyworks.prevayler.Clock;
	
	public class PausableClock implements Clock  {
		private final var _realClock:Clock;
		private final var  _brokenClock:BrokenClock = new BrokenClock();
		private var _activeClock:Clock;
		
		public function PausableClock (realClock:Clock) {		
			_realClock = realClock;
			resume();
		}
		/*synchronized Date */
		public function  time():Date {
			return _activeClock.time(); 
		}
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
