package com.troyworks.controls.tuseridle {
	import flash.events.Event;
	
	/**
	 * @author Troy Gardner
	 */
	public class UserIdleEvent extends Event {
		public function UserIdleEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
