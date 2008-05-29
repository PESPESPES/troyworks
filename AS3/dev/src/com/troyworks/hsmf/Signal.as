package com.troyworks.hsmf { 
	
	/*****************************************************
		 * Paramterless event
		 */
	public class Signal extends com.troyworks.datastructures.enums.TypedNumericEnumeration 
	{
		public static var SignalUserIDz:Number = 512;
	
		/*****************************************************
		 *  Constructor
		 */
		public function Signal (val : Number, name : String)
		{
			super (val, name, Signal);
			//trace("new Signal " + name + " " + this.toString());
			Signal._Class = Signal;
			Signal._ClassName = "signal";
		}
		public static function getNext(name:String):Signal{
			var s:Signal = new Signal(SignalUserIDz++, name);
			return s;
		}
	}
	
}