package com.troyworks.data {
	import flash.events.Event;
	/**
	 * @author Troy Gardner
	 */
	public class DataChangedEvent extends Event {
		public var oldVal : Object;
		public var currentVal : Object;
		public static const CHANGED : String ="CHANGED";

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
