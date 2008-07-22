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
	 *This upon hearing an event will redispatch another different event.
	 */
	public class EventTranslator {
		
		public var evtClass:Class = EventWithArgs;
		public var evtType:String;
		public var scope : IEventDispatcher;
		public var bubbles:Boolean = true;
		public var cancelable:Boolean = true;
		public var args:Array;
		public function EventTranslator() {
			
		}
		public function dispatchEvent(evt:Event = null):void{
			//trace("TranslateEvent " + evt);
			var revt:Event = new evtClass(evtType, bubbles, cancelable) as Event;
			if(revt is EventWithArgs && args!= null){
				(revt as EventWithArgs).args = args;
			}
			scope.dispatchEvent(revt);
		}
	}
}
