/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.core.persistance {
	import flash.events.*;
	public class CacheEvent extends Event {
		
		private var _overriddenTarget:Object;
		private var _overriddentype:String;
		private var _overriddenbubbles:*;
		private var _overriddencancelable:*;

		
		public function CacheEvent(type:String,bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		override public function get target():Object{
			return (_overriddenTarget != null)? _overriddenTarget: super.target;
		}
		public function set target(target:Object):void{
			_overriddenTarget = target;
		}
		override public function get bubbles():Boolean{
			return (_overriddenbubbles != null)? Boolean(_overriddenbubbles): super.bubbles;
		}
		public function set bubbles(bubblesV:Boolean):void{
			_overriddenbubbles = bubblesV;
		}
		override public function get cancelable():Boolean{
			return (_overriddencancelable != null)? Boolean(_overriddencancelable): super.cancelable;
		}
		public function set cancelable(cancelableV:Boolean):void{
			_overriddencancelable = cancelableV;
		}
		override public function get type():String{
			return (_overriddentype != null)? _overriddentype: super.type;
		}
		public function set type(typeV:String):void{
			_overriddentype = typeV;
		}		
		 // override clone so the event can be redispatched
        public override function clone():Event {
			var res:CacheEvent =new CacheEvent(type, bubbles, cancelable);
			res.target = this.target;
            return res;
			
        }
		
	}
	
}
