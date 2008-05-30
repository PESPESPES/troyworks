package com.troyworks.data.enums { 
	/******************************************************
	* EXAMPLE TypedEnumerattion Emulation
	*
	* Description:
	*  an emulation of TypedEnumerations in Flash AS2.0
	* typed enumeration is typcially a fixed size read only list that makes it clearer
	* and safter to use in switch statements than using primitives (e.g.numbers) when they have
	* semantic meaning (e.g. colors of the rainbow)
	* values are typically immutable, (though that's circumventable in actionscript)
	*
	* Advantages:
	*
	*  Smaller and Faster than than string keys in comparisons/switches (and in code size)
	*  yet still allows the human readible (unlike Numbers) via the .name property
	*  allows bitflag like operation using logical OR when values are N^2 1,2,4,8, 16, 32..etc
	*
	*
	* OUTPUT
	1 true true
	2 true
	2 true
	2 false
	-----toString Tests
	name of B B
	val of B 2
	 toString() B
	 toString 2
	testswitch---------------
	testingSwitch 1 1
	unknown type
	testingSwitch 1 Signal.A
	found type A
	testingSwitch null parse(55)
	unknown type
	testingSwitch 2 parse(2)
	found type B
	test bigflagged 3-----------------------
	bitflag a on
	bitflag b on
	bitflag c off
	bitflag ALL matched
	
	/////////////////////EXAMPLE CODE
	//Here's an example of how it's used.
	 class com.troyworks.hsmf.Signal extends com.troyworks.data.enums.TypedNumericEnumeration
	{
		public static var NONE : Signal = new Signal(0, "NONE");
		public static var A : Signal = new Signal(1, "A");
		public static var B : Signal = new Signal(2, "B");
		public static var C : Signal = new Signal(4, "C");
		public static var ALL : Signal = new Signal(A|B|C, "ALL");
	
	
		protected function Signal (val : Number, name : String)
		{
			super (val, name, Signal);
			Signal._Class = Signal;
			Signal._ClassName = "signal";
		}
	
	}
	/////////////////TEST CODE BEGINS////////////////////////////////
	import com.troyworks.hsmf.Signal;
	trace(Signal.A+" "+(Signal.A is (TypedNumericEnumeration))+" "+(Signal.A is (Signal)));
	trace(Signal.B+" "+(Signal.B is (TypedNumericEnumeration)));
	trace(Signal.B+" "+(Signal.B is (Number)));
	trace(Signal.B+" "+(Signal.B is (String)));
	trace("-----toString Tests");
	trace("name of B "+Signal.B.name );
	trace("val of B "+Signal.B.value );
	trace(" toString() " + Signal.B.toString());
	trace(" toString " + Signal.B);
	testSwitch = function (val:Number, desc:String) {
		trace("testingSwitch " + val + " " + desc);
		switch (val) {
		case Signal.A :
			trace("found type A");
			break;
		case Signal.B :
			trace("found type B");
			break;
		default :
			trace("unknown type");
			break;
		}
	};
	trace("testswitch---------------");
	testSwitch(1, "1");
	testSwitch(Signal.A, "Signal.A");
	testSwitch(Signal.parse(55), "parse(55)");
	testSwitch(Signal.parse(2), "parse(2)");
	
	
	var tempFlags = Signal.A | Signal.B;
	trace("test bigflagged "+tempFlags + "-----------------------");
	if ((tempFlags & Signal.A)>0) {
		trace("bitflag a on ");
	} else {
		trace("bitflag a off ");
	}
	if ((tempFlags & Signal.B)>0) {
		trace("bitflag b on ");
	} else {
		trace("bitflag b off ");
	}
	if ((tempFlags & Signal.C)>0) {
		trace("bitflag c on ");
	} else {
		trace("bitflag c off ");
	}
	if ((tempFlags & Signal.ALL)>0) {
		trace("bitflag ALL matched ");
	} else {
		trace("bitflag ALL not matched ");
	}
	////////////////////////////////////////////////////////////*/
	public class TypedNumericEnumeration extends Number
	{
		protected var __name : String;
		protected static var _Class:Object;
		protected static var _ClassName:String;
		protected function TypedNumericEnumeration (val : Number, name : String)
		{
			super (val);
			//trace(" new TypedNumericEnumeration " + val);
			this.__name = name;
		}
		public function get name():String{
			return this.__name;
		}
		public function get value():Number{
			return super;
		}
		public function toString():String{
			return this.name;
		}
		//////////////////////////////////////////////////////////////////
		// This takes the numeric value and finds the appropriate TypedNum
		// provided that the _Class is set.
		public static function parse(o:Object):TypedNumericEnumeration{
			trace(_Class  + " " + _ClassName + " TypedNum.parse " + o);
			var n:Number = -1;
			if( typeof(o) == "string"){
				n = parseInt(String(o));
			}else if(typeof(o)== "number"){
				n = Number(o);
			}else {
				return null;
			}
			for(var i in _Class){
			trace("comparing " + i + " "  + _Class[i]);
				var oc =  _Class[i];
				if(o ==  oc ){
					return oc;
				}
			}
			return null;
		}
	}
	
}