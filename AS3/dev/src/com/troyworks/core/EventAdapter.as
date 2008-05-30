/**
 * This is similar to EventProxyOptionalArgs and Delegate.
 * @author Default
 * @version 0.1
 */

package com.troyworks.core {
	import flash.events.Event;

	public class EventAdapter {

		private var _fn : Function;
		private var _args : Array;

		public function EventAdapter(functionToCall : Function = null, callbackArguments : Array = null) {
			_fn = functionToCall;
			_args = (callbackArguments == null) ? [] : callbackArguments;
		}

		public function initTo(functionToCall : Function, callbackArguments : Array) : void {
			_fn = functionToCall;
			_args = (callbackArguments == null) ? [] : callbackArguments;
		}

		public static function create(functionToCall : Function, callbackArguments : Array, includeEvent : Boolean = false) : Function {
			var res : EventAdapter = new EventAdapter(functionToCall, callbackArguments);
			if(includeEvent) {
				return res.relayEvent;
			}else {
				return res.callFunction;
			}
		}

		public function addCallBackArg(arg : Object) : void {
			//		  if (_args != null){
			_args.push(arg);
//		  }else{
//			 _args = [arg];
//		  }
		}

		public function callFunction(evt : Event = null) : * {
				trace("relayingEvent");
			return _fn.apply(null, _args);
		}

		public function relayEvent(evt : Event) : * {
				trace("relayingEvent");
			var args : Array = _args.concat();
			args.unshift(evt);
			return _fn.apply(null, args);
		}
	}
}
