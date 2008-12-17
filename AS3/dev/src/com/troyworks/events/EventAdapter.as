/**
 * This is similar to EventProxyOptionalArgs and Delegate.
 * 
 * This class actus like a wire between an event and a myriad of other outputs, functions, events. 
 * It's a good glue for decoupling.
 * 
 *  Event->Function
 *  Event-> new Event
 *  Event-> new scope (Event)
 *  
 * So when it recieves  an event, and converts it into either 
 * - scoped function calls with custom arguments
 * - scoped function calls passing it the original event with callback args e.g (evt, callback1, callback2)
 * - relay of event to another scope function, with optional appended arguments
 * - conversion of the event to another event (created by a class or factory function) and dispatched to a new scope.
 * 
 * * 
 * Takes an event, and calls back the with additional parameters, 
 * useful when a single loader is being
 * used for many different things and each listener needs 
 * slightly different information
 *
 * Here we have a function onSoundLoaded we are passing it the original swfURL
 * so that it can identify what has loaded, when multiple are being loaded at once.
 *   
 *   s.addEventListener(Event.COMPLETE, EventAdapter.create(onSoundLoaded, [optionalAudioSwfURL]));
 * 
 * Later:
 *   function onSoundLoaded(event:Event ):void {

       if(event is EventProxyOptionalArgs){
          var oArgs:Array = EventProxyOptionalArgs(event).args;
          trace("OptionalArgs " + oArgs.length + " " + oArgs.join());
        }
 *  }
 *  
 *  evt.target.addEventListener(MouseEvent.CLICK, EventAdapter.create(this[fnName], [arg1,arg2]));
 *   or
 *   Tny.onCallBack =  EventAdapter.create(this.animationFinished, [nextAction,1.2])
 *   
 *   var evA:EventAdapter = new EventAdapter();
 *   evA.initAsRedispatcher(someEventDispatcher, DataChangeEvent);
 *     Tny.onCallBack = evA.dispatchEvent; 

 * @author Troy Gardner
 * @version 0.1
 * 	 * CREATED :: Jul 5, 2008
 * DESCRIPTION ::
 */

package com.troyworks.events {
	import flash.events.IEventDispatcher;	
	import flash.events.Event;

	public class EventAdapter {

		/////////// function callback ///////////
		private var _fn : Function;
		public var args : Array;

		/////////// event factory //////////
		public var evtClass : Class = EventWithArgs;
		public var evtType : String;
		public var evtFactory : Function;

		public var bubbles : Boolean = true;
		public var cancelable : Boolean = true;

		public function EventAdapter(functionToCall : Function = null, callbackArguments : Array = null) {
			_fn = functionToCall;
			args = (callbackArguments == null) ? [] : callbackArguments;
		}

		/* post process add callback arguments, or replace them */

		public function initAsFunctionCaller(functionToCall : Function, callbackArguments : Array) : void {
			_fn = functionToCall;
			args = (callbackArguments == null) ? [] : callbackArguments;
		}

		public function initAsRedispatcher(evtDispatcher : IEventDispatcher, evtClass : Class = null, evtFactory : Function = null) : void {
			_fn = evtDispatcher.dispatchEvent;
			this.evtClass = (evtClass == null) ? EventWithArgs : evtClass;
			this.evtFactory = evtFactory;
		}

		/* post process add callback arguments, or replace them */
		public function addCallBackArg(arg : Object) : void {
			//		  if (_args != null){
			args.push(arg);
//		  }else{
//			 _args = [arg];
//		  }
		}

		/* this function is used to convert someInteractive.addEventListener(someEvent, someFunction(evt)--> your function(your args);
		 *  evt.target.addEventListener(MouseEvent.CLICK, EventAdapter.create(this[fnName], [arg1,arg2]));
		 *   or
		 *   Tny.onCallBack =  EventAdapter.create(this.animationFinished, [nextAction,1.2])
		 *   
		 *   var evA:EventAdapter = new EventAdapter();
		 *   evA.initAsRedispatcher(someEventDispatcher, DataChangeEvent);
		 *     Tny.onCallBack = evA.dispatchEvent; 
		 */
		public static function create(functionToCall : Function, callbackArguments : Array, includeEvent : Boolean = false) : Function {
			//trace("EventAdapter.create");
			var res : EventAdapter = new EventAdapter(functionToCall, callbackArguments);
			if(includeEvent) {
				return res.dispatchEvent;
			}else {
				return res.callFunction;
			}
		}

		/*
		 * for a given event, call a function with the arguments
		 * this was constructed with.
		 */
		public function callFunction(evt : Event = null) : * {
			//trace("EventAdapter.callFunction");
			return _fn.apply(null, args);
		}

		/* for a given event, 
		 * do one of the following:
		 * 
		 * 1)  pass that event 
		 * to the cached function, appending the extra arguments
		 * to it. Useful for when during setup of the event you
		 * want to pass it extra state.
		 * for a given event, dispatch a NEW event
		 * in it's place routed to a new scope
		 */
		public function dispatchEvent(evt : Event = null) : * {
			trace("EventAdapter.dispatchEvent " + evt);
			var revt : Event;
			var aargs : Array;
			if(evtClass != null) {
				trace("using evtClass");
				revt = new evtClass(evtType, bubbles, cancelable) as Event;
			}else if(evtFactory != null) {
				trace("using evtFactory");
				revt = evtFactory() as Event;
			}else {
				trace("relaying event");
				revt = evt;
			}
			if(revt is EventWithArgs && args != null) {
				(revt as EventWithArgs).args = args;
				aargs = [revt];
			}else {
				aargs = args.concat();
				aargs.unshift(revt);
			}
			//trace(" as " + revt);			

			return _fn.apply(null, aargs);
			//return _fn(revt);
		}

		/* setup for garbage collection */
		public function destroy(evt : Event = null) : void {
			_fn = null;
			args = null;
			evtClass = null;
			evtType = null;
			evtFactory = null;
		}
	}
}
