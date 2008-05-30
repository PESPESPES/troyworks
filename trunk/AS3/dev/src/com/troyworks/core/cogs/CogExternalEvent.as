package com.troyworks.core.cogs
{
	import flash.events.Event;

	public class CogExternalEvent extends Event
	{
		public static const INIT:String = "COG_INIT";
		public static const CHANGED:String = "COG_STATE_CHANGED";
		private var _oldVal:Function;
		private var _newVal:Function;
		public var result:Object;
		
		public function CogExternalEvent(type:String, oldState:Function = null,  newState:Function = null, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			_oldVal = oldState;
			_newVal = newState;
		}
		public override function clone():Event {

			var ret:CogExternalEvent = new CogExternalEvent(type,_oldVal, _newVal, super.bubbles, super.cancelable);
			ret.result = result;
			return ret;

		}
		public override function toString():String{
			return "CogExternalEvent." + type;
		}
	}
}