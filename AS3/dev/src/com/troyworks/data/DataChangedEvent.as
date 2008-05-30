package com.troyworks.data {
	import flash.events.Event;
l,
	/**
	 * @author Troy Gardner
	 */
	public class DataChangedEvent extends Event {
		public var oldVal : Number;
		public var currentVal : Number;
		public static const CHANGED : String = "CHANGED";

		public function DataChangedEvent(type : String = CHANGED, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}

		// override clone so the event can be redispatched

		public override function clone() : Event {
			var res : DataChangedEvent = new DataChangedEvent(type, bubbles, cancelable);
			res.oldVal = oldVal;
			res.currentVal = currentVal;
			return res;
		}
	}
}
