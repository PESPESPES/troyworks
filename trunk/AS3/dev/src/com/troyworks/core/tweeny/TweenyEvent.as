/**
*  This event is used by Tweeny to keep other listeners in synch with it's tweening
* playback, it's a snapshot of a movement of the 'virtual playhead'.
* 
* Since the duration is fixed in a Tweeny instance, listeners can use a normalized (outputs 0-1)
* version and scale appropriately the output to whatever they need. Via the update listener.
* 
* @author Default
* @version 0.1
*/

package com.troyworks.core.tweeny {
	import flash.events.Event;
//	import com.troyworks.core.cogs.CogSignal;

	public class TweenyEvent extends Event{
		public var currentTime:Number;
		public var beginVal:Number;
		public var curVal:Number;
		public var endVal:Number;
		public var duration:Number;
		
		public function TweenyEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		 // override clone so the event can be redispatched
        public override function clone():Event {
			var res:TweenyEvent = new TweenyEvent(type, bubbles, cancelable);
			// start time is 0, currenttime is 0 to duration
			res.currentTime = currentTime;
			res.duration = duration;
			
			res.beginVal = beginVal;
			res.curVal = curVal;
			res.endVal = endVal;

            return res;
        }
		public function toString2():String{
			return "time" + currentTime +"/" + duration + "  calc:" + beginVal + "/" + curVal + "/" + endVal;
		}
	}
	
}
