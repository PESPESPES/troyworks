package com.troyworks.core.events { 

	/**
	 * @author Troy Gardner
	 */
	public class EVTD {
		public static var CHANGED : String = "CHANGED";
		public static var LOADED : String = "LOADED"; 
		public static var READY : String = "READY"; 

		//	public static var CHANGEventnEventententeEventventventvent(CHANGED);
		//	public static EventEEventEEventEEventt:Eventt Eventw Event(LOADED); 
		//	pubEventsEvententvEveEventtDEveEventt:EveEvent new Event(READY); 

		
		public var type : String;
		public var target : Object;

		public function EVTD(type : String, target : Object) {
			this.type = type;
			this.target = target;
		}
	}
}