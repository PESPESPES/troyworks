/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.core.time {
	
    import flash.events.Event;
   
    public class TimeChangedEvent extends Event {

		protected var _time:Date;
		protected var _millis:int;
		public static const TIME_CHANGED:String = "TimeChangedEvent";
		
        public function TimeChangedEvent(type:String = TIME_CHANGED, time:Date = null, millis:int = NaN,  bubbles:Boolean =true, cancelable:Boolean= false) {
            super(type, bubbles, cancelable);
            _time = time;
			_millis = millis;
		}

		// override clone so the event can be redispatched
        public override function clone():Event {
			var res:TimeChangedEvent  =  new TimeChangedEvent(type);
			res._time = _time;
			res._millis = _millis;
            return res;
        }
	}
	
}
