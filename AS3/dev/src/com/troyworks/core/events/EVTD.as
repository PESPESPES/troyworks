package com.troyworks.events { 
	/**
	 * @author Troy Gardner
	 */
	public class EVTD {
			public static var CHANGED:String ="CHANGED";
		public static var LOADED:String = "LOADED"; 
		public static var READY:String = "READY"; 
		
		public static var CHANGED_EVTD:EVTD = new EVTD(CHANGED);
		public static var LOADED_EVTD:EVTD = new EVTD(LOADED); 
		public static var READY_EVTD:EVTD = new EVTD(READY); 
		
		
		public var type:String;
		public var target:Object;
		public function EVTD(type:String, target:Object) {
			this.type = type;
			this.target = target;
		}
		
	}
}