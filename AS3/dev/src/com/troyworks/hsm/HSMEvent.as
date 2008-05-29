package com.troyworks.hsm { 
	//import com.troyworks.statemachine.*;
	//lightwieght struct like 'bag' for passing the event signal
	// and the parameters around.'
	import com.troyworks.hsmf.Signal;
	public class HSMEvent extends Number{
		public static var UNTYPED:Number = 0;
		public static var TYPED:Number = 1;
		public static var EVENT_DISPATCHER:Number = 2;
	
		public var sig:Signal;
		public var args:Object;
		public var etype:Object;
		//is this constructor necessary?
		public function HSMEvent(sig:Signal, args:Object, etype:Object){
			this.sig = (sig== null)?"TRACER":sig;
			this.args = args;
			this.etype = (etype == null)? HSMEvent.UNTYPED: etype;
			trace(this + " Event created");
		}
		public function toString():String{
			return "\rEvent:" +this.sig + " args " + this.args;
		}
	}
	
}