package com.troyworks.framework.events { 
	import com.troyworks.hsmf.AEvent;
	import util.Trace;
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
		public function Q_dispatch(evt : AEvent) : void {
			trace("DummyEventDispatcher.dispatch("+ evt+")");
			util.Trace.meAsArrayToConsole(evt.args, "Event", true);
		}
		public function toString():String{
			return DummyEventDispatcher.className;
		}
	}
}