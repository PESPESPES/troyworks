
/**
* This class is to just test raw performance of different types/approaches used
* in switch statements, primarily to determine whether strings (as passed by events), numbers
* or signals (as done by cogs) is faster approach.
* 
* Recommendations:
*  1) use a custom class, static const on the class
*  e.g.

	//cache the value during class/static initialization
   public static const C_0:SwitchSignal = SwitchSignal.C_0;

*  and later
* 
   public function switchSwitchSignal(sig:SwitchSignal):void{
			switch(sig){
				case  C_0: //SwitchSignal.C_0, but no lookup overhead.
				
				

* 
* 2) for raw data types use int;
* 
* Summary: 
* Full Fledged Classes with Pointers are the fastest at close to 1/3 the time. This is great as it offers author time compile checking, strong typing at runtime. Lookups are likely
* by identity (===) instead of by value (==) as in data types, which means performance is about twice that of using
* a value comparison, in addition, since they are fullfledged objects they can contain all sorts of things (e.g. toString, operations).
* Downside is that no numerical id is attached, so it's harder to index and later lookup these values when they exist in a random
* collection of some sort.
* 
* In the  class containing the switch, Flash's compiler doesn't replace Class.StaticVal, with StaticVal so there is a lookup 
* overhead looking it up. So it's recommended that you capture a reference in a static const (see the above recommendations)
* 
* For primitive data types (String, number, int, etc), strings are about 70% slower than any numbers, potentially the length of 
* the string may also impact the performance (not tested). Note that even making the string a static const string offered
* no performance increase (though probably a significant memory performance increase) because your using value comparison (==) in the switch statement
* versus identity (===).

* The fastest numerical type, was an typically an int though this wasn't really repeatable, or significant. But might 
* make sense to use if your using it as bitflag.
* 
* 
* Test Results:
SwitchNumber 177
switchInt 176
switchUInt 170
switchString 277
switchStringConst 275
switchIntConst 175
switchCogSignal 166 <-- lookup of CogSignal.SIGNAL
switchCogSignalB 97 <-- 'cached' SIGNAL pointer (set via static constructor)
switchSwitchSignal 98
* 
* @author Troy Gardner
* @version 0.1
*/

package com.troyworks.util {
	import com.troyworks.cogs.CogSignal;
	import flash.utils.getTimer;
	import com.troyworks.tester.SynchronousTestSuite;
		
	public class Test_SwitchPerformance extends SynchronousTestSuite{
		private var iterations:Number = 100000;
		public static const A_0:String = "A_0";
		public static const A_1:String = "A_1";
		public static const A_2:String = "A_2";
		public static const A_3:String = "A_3";
		public static const A_4:String = "A_4";
		public static const A_5:String = "A_5";
		public static const A_6:String = "A_6";
		public static const A_7:String = "A_7";
		public static const A_8:String = "A_8";
		public static const A_9:String = "A_9";
		public static const A_10:String = "A_10";
		public static const A_11:String = "A_11";
		public static const A_12:String = "A_12";
		public static const A_13:String = "A_13";
		public static const A_14:String = "A_14";
		public static const A_15:String = "A_15";
		public static const A_16:String = "A_16";
		public static const A_17:String = "A_17";
		public static const A_18:String = "A_18";
		public static const A_19:String = "A_19";
		public static const A_20:String = "A_20";
		public static const A_21:String = "A_21";
		public static const A_22:String = "A_22";
		public static const A_23:String = "A_23";
		public static const A_24:String = "A_24";
		public static const A_25:String = "A_25";
		public static const A_26:String = "A_26";
		public static const A_27:String = "A_27";
		public static const A_28:String = "A_28";
		public static const A_29:String = "A_29";
		public static const A_30:String = "A_30";
		public static const A_31:String = "A_31";
		public static const A_32:String = "A_32";
		public static const A_33:String = "A_33";
		public static const A_34:String = "A_34";
		public static const A_35:String = "A_35";
		public static const A_36:String = "A_36";
		public static const A_37:String = "A_37";
		public static const A_38:String = "A_38";
		public static const A_39:String = "A_39";
		public static const A_40:String = "A_40";
/////////////////////////////////////////////////////
		public static const B_0:int = 0;
		public static const B_1:int = 1;
		public static const B_2:int = 2;
		public static const B_3:int = 3;
		public static const B_4:int = 4;
		public static const B_5:int = 5;
		public static const B_6:int = 6;
		public static const B_7:int = 7;
		public static const B_8:int = 8;
		public static const B_9:int = 9;
		public static const B_10:int = 10;
		public static const B_11:int = 11;
		public static const B_12:int = 12;
		public static const B_13:int = 13;
		public static const B_14:int = 14;
		public static const B_15:int = 15;
		public static const B_16:int = 16;
		public static const B_17:int = 17;
		public static const B_18:int = 18;
		public static const B_19:int = 19;
		public static const B_20:int = 20;
		public static const B_21:int = 21;
		public static const B_22:int = 22;
		public static const B_23:int = 23;
		public static const B_24:int = 24;
		public static const B_25:int = 25;
		public static const B_26:int = 26;
		public static const B_27:int = 27;
		public static const B_28:int = 28;
		public static const B_29:int = 29;
		public static const B_30:int = 30;
		public static const B_31:int = 31;
		public static const B_32:int = 32;
		public static const B_33:int = 33;
		public static const B_34:int = 34;
		public static const B_35:int = 35;
		public static const B_36:int = 36;
		public static const B_37:int = 37;
		public static const B_38:int = 38;
		public static const B_39:int = 39;
		public static const B_40:int = 40;
		//////////////////////////////
		public static const EMPTY:CogSignal = CogSignal.EMPTY;

		public static const INIT:CogSignal = CogSignal.INIT;

		public static const ENTRY:CogSignal = CogSignal.ENTRY;

		public static const TRACE:CogSignal = CogSignal.TRACE;

		public static const PULSE:CogSignal = CogSignal.PULSE;

		public static const CALLBACK:CogSignal = CogSignal.CALLBACK;

		public static const GETOPTS:CogSignal = CogSignal.GETOPTS;

		public static const TERMINATE:CogSignal = CogSignal.TERMINATE;

		public static const STATE_CHANGED:CogSignal = CogSignal.STATE_CHANGED;
		//////////////////////////////////
		public static const C_0:SwitchSignal = SwitchSignal.C_0;
		public static const C_1:SwitchSignal = SwitchSignal.C_1;
		public static const C_2:SwitchSignal = SwitchSignal.C_2;
		public static const C_3:SwitchSignal = SwitchSignal.C_3;
		public static const C_4:SwitchSignal = SwitchSignal.C_4;
		public static const C_5:SwitchSignal = SwitchSignal.C_5;
		public static const C_6:SwitchSignal = SwitchSignal.C_6;
		public static const C_7:SwitchSignal = SwitchSignal.C_7;
		public static const C_8:SwitchSignal = SwitchSignal.C_8;


		public function Test_SwitchPerformance(){
			super();
		}
		public function test_AllSwitch():void{
			var startTime:Number;
			var endTime:Number;
			var iter:Number ;
			////////////////////
			iter =iterations;
			startTime= getTimer();	
				var numNum:Number = 22;//Math.round(Math.random()*40);
			while(iter--){
				switchNumber(numNum);
			}
			endTime = getTimer();
			trace("SwitchNumber " + (endTime - startTime));
			////////////////////
			iter =iterations;
			startTime= getTimer();	
			var numInt:int= 22;//int(Math.random()*40);
			while(iter--){
				switchInt(numInt);
			}
			endTime = getTimer();
			trace("switchInt " + (endTime - startTime));
			////////////////////
			iter =iterations;
			startTime= getTimer();	
			var numUint:uint = 22;// uint(Math.random()*40);
			while(iter--){
				switchUInt(numUint);
			}
			endTime = getTimer();
			trace("switchUInt " + (endTime - startTime));
		////////////////////
			iter =iterations;
			startTime= getTimer();	
			while(iter--){
				switchString("A_22");
			}
			endTime = getTimer();
			trace("switchString " + (endTime - startTime));
			
					////////////////////
			iter =iterations;
			startTime= getTimer();	
			//var numS:String = String(Math.random()*40);
			var c:String = A_22;
			while(iter--){
				switchStringConst(c);
			}
			endTime = getTimer();
			trace("switchStringConst " + (endTime - startTime));
					////////////////////
			iter =iterations;
			startTime= getTimer();	
			var numI:int = B_22;
			while(iter--){
				switchIntConst(numI);
			}
			endTime = getTimer();
			trace("switchIntConst " + (endTime - startTime));
			////////////////////
			iter =iterations;
			startTime= getTimer();	
			var cs:CogSignal = CogSignal.STATE_CHANGED;
			while(iter--){
				switchCogSignal(cs);
			}
			endTime = getTimer();
			trace("switchCogSignal " + (endTime - startTime));
			////////////////////
			iter =iterations;
			startTime= getTimer();	
			var cs2:CogSignal = CogSignal.STATE_CHANGED;
			while(iter--){
				switchCogSignalB(cs2);
			}
			endTime = getTimer();
			trace("switchCogSignalB " + (endTime - startTime));	
////////////////////
			iter =iterations;
			startTime= getTimer();	
			var cs3:SwitchSignal = C_8;
			while(iter--){
				switchSwitchSignal(C_8);
			}
			endTime = getTimer();
			trace("switchSwitchSignal " + (endTime - startTime));	
			
		}
		public function switchSwitchSignal(sig:SwitchSignal):void{
			switch(sig){
				case  C_0:
				break;
				case  C_1:
				break;
				case  C_2:
				break;
				case  C_3:
				break;
				case  C_4:
				break;
				case  C_5:
				break;
				case  C_6:
				break;
				case  C_7:
				break;
				case  C_8:
				break;
			}
		}
		public function switchCogSignal(sig:CogSignal):void{
			

			switch(sig){
				case CogSignal.EMPTY:
				break;
				case CogSignal.INIT:
				break;
				case CogSignal.ENTRY:
				break;
				case CogSignal.TRACE:
				break;
				case CogSignal.PULSE:
				break;
				case CogSignal.CALLBACK:
				break;
				case CogSignal.GETOPTS:
				break;
				case CogSignal.TERMINATE:
				break;
				case CogSignal.STATE_CHANGED:
				//trace("sc");
				break;
			}
		}
		public function switchCogSignalB(sig:CogSignal):void{
			

			switch(sig){
				case EMPTY:
				break;
				case INIT:
				break;
				case ENTRY:
				break;
				case TRACE:
				break;
				case PULSE:
				break;
				case CALLBACK:
				break;
				case GETOPTS:
				break;
				case TERMINATE:
				break;
				case STATE_CHANGED:
				//trace("sc");
				break;
			}
		}
		public function switchNumber(num:Number):void{
			
		
			switch(num){
				case 0:
				break;
				case 1:
				break;
				case 2:
				break;
				case 3:
				break;
				case 4:
				break;
				case 5:
				break;
				case 6:
				break;
				case 7:
				break;
				case 8:
				break;
				case 9:
				break;
				case 10:
				break;
				case 11:
				break;
				case 12:
				break;
				case 13:
				break;
				case 14:
				break;
				case 15:
				break;
				case 16:
				break;
				case 17:
				break;
				case 18:
				break;
				case 19:
				break;
				case 20:
				break;
				case 21:
				break;
				case 22:
				break;
				case 23:
				break;
				case 24:
				break;
				case 25:
				break;
				case 26:
				break;
				case 27:
				break;
				case 28:
				break;
				case 29:
				break;
				case 30:
				break;
				case 31:
				break;
				case 32:
				break;
				case 33:
				break;
				case 34:
				break;
				case 35:
				break;
				case 36:
				break;
				case 37:
				break;
				case 38:
				break;
				case 39:
				break;
				case 40:
				break;

			}
		}
		public function switchInt( num:int ):void{
		
			switch(num){
				case 0:
				break;
				case 1:
				break;
				case 2:
				break;
				case 3:
				break;
				case 4:
				break;
				case 5:
				break;
				case 6:
				break;
				case 7:
				break;
				case 8:
				break;
				case 9:
				break;
				case 10:
				break;
				case 11:
				break;
				case 12:
				break;
				case 13:
				break;
				case 14:
				break;
				case 15:
				break;
				case 16:
				break;
				case 17:
				break;
				case 18:
				break;
				case 19:
				break;
				case 20:
				break;
				case 21:
				break;
				case 22:
				break;
				case 23:
				break;
				case 24:
				break;
				case 25:
				break;
				case 26:
				break;
				case 27:
				break;
				case 28:
				break;
				case 29:
				break;
				case 30:
				break;
				case 31:
				break;
				case 32:
				break;
				case 33:
				break;
				case 34:
				break;
				case 35:
				break;
				case 36:
				break;
				case 37:
				break;
				case 38:
				break;
				case 39:
				break;
				case 40:
				break;

			}
		}
		public function switchUInt(num:uint):void{
			

			switch(num){
				case 0:
				break;
				case 1:
				break;
				case 2:
				break;
				case 3:
				break;
				case 4:
				break;
				case 5:
				break;
				case 6:
				break;
				case 7:
				break;
				case 8:
				break;
				case 9:
				break;
				case 10:
				break;
				case 11:
				break;
				case 12:
				break;
				case 13:
				break;
				case 14:
				break;
				case 15:
				break;
				case 16:
				break;
				case 17:
				break;
				case 18:
				break;
				case 19:
				break;
				case 20:
				break;
				case 21:
				break;
				case 22:
				break;
				case 23:
				break;
				case 24:
				break;
				case 25:
				break;
				case 26:
				break;
				case 27:
				break;
				case 28:
				break;
				case 29:
				break;
				case 30:
				break;
				case 31:
				break;
				case 32:
				break;
				case 33:
				break;
				case 34:
				break;
				case 35:
				break;
				case 36:
				break;
				case 37:
				break;
				case 38:
				break;
				case 39:
				break;
				case 40:
				break;

			}
		}
		public function switchStringConst(num:String):void{
			

			switch(num){
				case A_0:
				break;
				case A_1:
				break;
				case A_2:
				break;
				case A_3:
				break;
				case A_4:
				break;
				case A_5:
				break;
				case A_6:
				break;
				case A_7:
				break;
				case A_8:
				break;
				case A_9:
				break;
				case A_10:
				break;
				case A_11:
				break;
				case A_12:
				break;
				case A_13:
				break;
				case A_14:
				break;
				case A_15:
				break;
				case A_16:
				break;
				case A_17:
				break;
				case A_18:
				break;
				case A_19:
				break;
				case A_20:
				break;
				case A_21:
				break;
				case A_22:
				break;
				case A_23:
				break;
				case A_24:
				break;
				case A_25:
				break;
				case A_26:
				break;
				case A_27:
				break;
				case A_28:
				break;
				case A_29:
				break;
				case A_30:
				break;
				case A_31:
				break;
				case A_32:
				break;
				case A_33:
				break;
				case A_34:
				break;
				case A_35:
				break;
				case A_36:
				break;
				case A_37:
				break;
				case A_38:
				break;
				case A_39:
				break;
				case A_40:
				break;

			}
		}
		public function switchIntConst(num:int):void{
			
			switch(num){
				case B_0:
				break;
				case B_1:
				break;
				case B_2:
				break;
				case B_3:
				break;
				case B_4:
				break;
				case B_5:
				break;
				case B_6:
				break;
				case B_7:
				break;
				case B_8:
				break;
				case B_9:
				break;
				case B_10:
				break;
				case B_11:
				break;
				case B_12:
				break;
				case B_13:
				break;
				case B_14:
				break;
				case B_15:
				break;
				case B_16:
				break;
				case B_17:
				break;
				case B_18:
				break;
				case B_19:
				break;
				case B_20:
				break;
				case B_21:
				break;
				case B_22:
				break;
				case B_23:
				break;
				case B_24:
				break;
				case B_25:
				break;
				case B_26:
				break;
				case B_27:
				break;
				case B_28:
				break;
				case B_29:
				break;
				case B_30:
				break;
				case B_31:
				break;
				case B_32:
				break;
				case B_33:
				break;
				case B_34:
				break;
				case B_35:
				break;
				case B_36:
				break;
				case B_37:
				break;
				case B_38:
				break;
				case B_39:
				break;
				case B_40:
				break;

			}
		}
		public function switchString(num:String):void{
			

			switch(num){
				case "A_0":
				break;
				case "A_1":
				break;
				case "A_2":
				break;
				case "A_3":
				break;
				case "A_4":
				break;
				case "A_5":
				break;
				case "A_6":
				break;
				case "A_7":
				break;
				case "A_8":
				break;
				case "A_9":
				break;
				case "A_10":
				break;
				case "A_11":
				break;
				case "A_12":
				break;
				case "A_13":
				break;
				case "A_14":
				break;
				case "A_15":
				break;
				case "A_16":
				break;
				case "A_17":
				break;
				case "A_18":
				break;
				case "A_19":
				break;
				case "A_20":
				break;
				case "A_21":
				break;
				case "A_22":
				break;
				case "A_23":
				break;
				case "A_24":
				break;
				case "A_25":
				break;
				case "A_26":
				break;
				case "A_27":
				break;
				case "A_28":
				break;
				case "A_29":
				break;
				case "A_30":
				break;
				case "A_31":
				break;
				case "A_32":
				break;
				case "A_33":
				break;
				case "A_34":
				break;
				case "A_35":
				break;
				case "A_36":
				break;
				case "A_37":
				break;
				case "A_38":
				break;
				case "A_39":
				break;
				case "A_40":
				break;

			}
		}
	}
	
}
