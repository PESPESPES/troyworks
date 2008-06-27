package com.troyworks.core.events {
    import flash.events.Event;
	/**
	 * PlayheadEvent
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Jun 22, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class PlayheadEvent  extends Event{
		
		public static const EVT_PROGRESS:String = "PROGRESS";
		public static const EVT_COMPLETE:String = "COMPLETE";
		
				
		public var percentageDone:Number  = 0;
		
		
        public function PlayheadEvent(type:String) {
            super(type);
        }

        // override clone so the event can be redispatched
        public override function clone():Event {
           var res:PlayheadEvent = new PlayheadEvent(type);
			res.percentageDone = Number(this.percentageDone);
            return res;
        }
    }
}
