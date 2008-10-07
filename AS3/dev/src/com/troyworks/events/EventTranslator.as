package com.troyworks.events {
	import flash.events.Event;	
	import flash.events.IEventDispatcher;	

	/**
	 * TranslateEvent
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Jul 5, 2008
	 * DESCRIPTION ::
	 *
	 *This upon hearing an event will redispatch another different event or to a differnet scope
	 */
	public class EventTranslator {

		public var evtClass : Class = EventWithArgs;
		public var evtType : String;
		public var evtFactory : Function;

		public var scope : IEventDispatcher;
		public var bubbles : Boolean = true;
		public var cancelable : Boolean = true;
		public var args : Array;

		public function EventTranslator(evtDispatcher : IEventDispatcher, evtClass : Class = null, evtFactory : Function = null) {
			scope = evtDispatcher;
			this.evtClass = (evtClass == null)? EventWithArgs: evtClass;
			this.evtFactory = evtFactory;
		}

		public function dispatchEvent(evt : Event = null) : void {
			trace("TranslateEvent.dispatchEvent " + evt);
			var revt : Event;
			if(evtClass != null) {
				trace("using evtClass");
				revt = new evtClass(evtType, bubbles, cancelable) as Event;
			}else if(evtFactory != null) {
				trace("using evtFactory");
				revt = evtFactory() as Event;
			}
			if(revt is EventWithArgs && args != null) {
				(revt as EventWithArgs).args = args;
			}
			trace(" as " + revt);			
			scope.dispatchEvent(revt);
		}
	}
}
