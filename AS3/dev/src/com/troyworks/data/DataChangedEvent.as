package com.troyworks.data {
	import flash.events.Event;
	/**
	 * @author Troy Gardner
	 */
	public class DataChangedEvent extends Event {
		public var propertyName:String;
		public static const DATA_CHANGED:String = "dataChanged";
		public static const PRE_DATA_CHANGED:String = "preDataChanged";

		public var oldVal : Object;
		public var currentVal : Object;
		public var isCancelled:Boolean = false;
		
		public function DataChangedEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
		public override function stopPropagation():void {
			isCancelled = true;
			super.stopPropagation();
		}
		public override function stopImmediatePropagation():void {
			isCancelled = true;
			super.stopImmediatePropagation();
		}

		// override clone so the event can be redispatched

		public override function clone() : Event {
			var res : DataChangedEvent = new DataChangedEvent(type, bubbles, cancelable);
			res.propertyName = propertyName;
			res.oldVal = oldVal;
			res.currentVal = currentVal;
			return res;
		}
		public override function toString():String{
			return "DataChangedEvent phase " + this.type + " from " + oldVal + " to: " + currentVal;
		}
	}
}
