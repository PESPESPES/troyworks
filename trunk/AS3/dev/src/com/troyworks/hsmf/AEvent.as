package com.troyworks.hsmf { 
	/**
	 * Abstract Event for events, essentially a struct
	 * @author Troy Gardner
	 */
	public class AEvent extends Object{
		/* indicates a changed in the model */
		public static var CHANGE:Number = 0;
		/* models the expiry of a given time */
		public static var TIME:Number = 1;
		
		public var sig : Signal;
		public var type:Number;	
		public var args:Object;
		public function AEvent(aSig:Signal) {
			super();
			sig = aSig;
			//trace("new AEvent " + aSig.name + " " + this.toString());
		}
		public static function getNext(name:String):AEvent{
			var e:AEvent = new AEvent(Signal.getNext(name));
			return e;
		}
		public function toString() : String{
			return sig.toString()+ "_EVT";
		}
	}
}