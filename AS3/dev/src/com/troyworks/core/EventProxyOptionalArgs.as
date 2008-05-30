/**
* ...
* 
* Takes an event, and calls back the with additional parameters, useful when a single loader is being
* used for many different things and 
*   s.addEventListener(Event.COMPLETE, EventProxyOptionalArgs.create(onSoundLoaded, optionalAudioSwfURL,));
* 
* Later:
*   function onSoundLoaded(event:Event ):void {
	
	//speaker_mc.display_txt.text = "";
	if(event is EventProxyOptionalArgs){
		var oArgs:Array = EventProxyOptionalArgs(event).args;
		trace("OptionalArgs " + oArgs.length + " " + oArgs.join());
	}
*  }
* @author Default
* @version 0.1
*/

package com.troyworks.core {

	import com.troyworks.core.persistance.CacheEvent;
	import flash.events.Event;
	
	public class EventProxyOptionalArgs extends CacheEvent {
		private var _origEvent:Event;
		private var _origScope:Function;
		private var _origArgs:Array = new Array();
		
		public function EventProxyOptionalArgs(type:String, bubbles:Boolean, cancelable:Boolean) {
            super(type, bubbles, cancelable);
		//	trace("EventProxyOptionalArgs");
		}
		public function initializeWith(...statements):void{
			if(statements.length > 0){
				_origScope = statements.shift();
				if(statements.length > 0){
					_origArgs =statements;
				}
			}
		}
		public function set origEvent(evt:Event):void{
			_origEvent = evt;
		}
		public function get origEvent():Event{
			return _origEvent;
		}
		public function get args():Array{
			return _origArgs;
		}
		public static function create(...statements):Function{
			//trace("EventProxyOptionalArgs.create " );
			var callBack:EventProxyOptionalArgs = new EventProxyOptionalArgs("EventProxy",false, false);
			callBack.initializeWith.apply(null,statements);
			//trace("callBack creat: '" + callBack+"'");
			return callBack.onOriginalEventCall;
		}
		public function onOriginalEventCall(evt:Event = null):void{
			//trace("Proxy.called onOriginalEventCall " + evt.toString() );
			_origEvent = evt;
			super.type = evt.type;
			super.bubbles = evt.bubbles;
			super.cancelable = evt.cancelable;
			super.target = evt.target;
			_origScope(this);
		}
		public override function clone():Event {
			var res:EventProxyOptionalArgs =new EventProxyOptionalArgs(type, bubbles, cancelable);
			var ary:Array  = _origArgs.concat();
			ary.unshift(_origScope);
			res.initializeWith.apply(res, ary);
			res.origEvent = this.origEvent;
			res.target = this.target;
            return res;
			
		}
	}
}
