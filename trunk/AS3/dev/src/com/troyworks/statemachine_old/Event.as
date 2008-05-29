package com.troyworks.statemachine { 
	//import com.troyworks.statemachine.*;
	//lightwieght struct like 'bag' for passing the event signal
	// and the parameters around.'
	public class Event {
		public static var UNTYPED:Number = 0;
		public static var TYPED:Number = 1;
		public static var EVENT_DISPATCHER:Number = 2;
	
		public var sig:Object;
		public var args:Object;
		public var etype:Object;
		//is this necessary?
		public function Event(sig:Object, args:Object, etype:Object){
			this.sig = (sig== null)?"TRACER":sig;
			this.args = args;
			this.etype = (etype == null)? Event.UNTYPED: etype;
			trace(this + " created");
		}
		public function toString():String{
			return "\rEvent:" +this.sig + " args " + this.args;
		}
	}
}