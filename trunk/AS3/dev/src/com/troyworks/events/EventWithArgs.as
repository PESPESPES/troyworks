package com.troyworks.events {
	import flash.events.Event;
	
	/**
	 * GenericEvent - extends the Event with a generic argument holder, that is shared
	 * across all events that recieve this.
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Jul 5, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class EventWithArgs extends Event {
		public var args:Array;
		public function EventWithArgs(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}


        // override clone so the event can be redispatched
        public override function clone():Event {
           var res:EventWithArgs = new EventWithArgs(type, bubbles, cancelable);
			res.args = args.concat();
            return res;
        }
    }
}
