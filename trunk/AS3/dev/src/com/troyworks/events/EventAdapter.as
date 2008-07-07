/**
 * This is similar to EventProxyOptionalArgs and Delegate.
 * @author Default
 * @version 0.1
 */

package com.troyworks.events {
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
			//trace("EventAdapter.create");
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
		/*
		* for a given event, call a function with the arguments
		* this was constructed with.
		*/
		public function callFunction(evt : Event = null) : * {
				//trace("EventAdapter.callFunction");
			return _fn.apply(null, _args);
		}
		/* for a given event, pass that event 
		 * to the cached function, appending the extra arguments
		 * to it.
		 */
		public function relayEvent(evt : Event) : * {
			//	trace("EventAdapter.relayingEvent");
			var args : Array = _args.concat();
			args.unshift(evt);
			return _fn.apply(null, args);
		}
	}
}
