package com.troyworks.core.events {
	import com.troyworks.util.Trace;	
	
	import flash.events.Event; 

	/**
	 * A utility to be used in early application development to test out that events are 
	 * getting sent in the correct fashion, tracing out to the console/logger. To eventually
	 * be replaced with the real thing
	 * 
	 * @author Troy Gardner
	 */
	public class DummyEventDispatcher implements IEventOracle {
		public static var className : String = "com.troyworks.framework.events.DummyEventDispatcher";
		public static var instance:DummyEventDispatcher; 
		public function DummyEventDispatcher() {
			trace("new DummyEventDispatcher");
		}
		public static function getInstance():DummyEventDispatcher{
			trace("DummyEventDispatcher.getInstance()");
			if(DummyEventDispatcher.instance == null){		
				DummyEventDispatcher.instance = new DummyEventDispatcher();
			}
			return DummyEventDispatcher.instance;
		}
		public function dispatchEvent(evt : Event) : Boolean {
			trace("DummyEventDispatcher.dispatch("+ evt+")");
			trace(Trace.me(evt, "Event", true));
			return true;
		}
		public function toString():String{
			return DummyEventDispatcher.className;
		}
		
		public function hasEventListener(type : String) : Boolean {
			return true;
		}
		
		public function willTrigger(type : String) : Boolean {
				return true;
		}
		
		public function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void {
		}
		
		public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
		}
	}
}