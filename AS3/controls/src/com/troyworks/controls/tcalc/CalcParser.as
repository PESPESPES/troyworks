package com.troyworks.controls.tcalc {
	import com.troyworks.core.cogs.CogEvent;	
	import com.troyworks.core.Signals;	
	import com.troyworks.core.cogs.Hsm; 

	/**
	 * CalcParser's job is to take a string of values and separate them into
	 * an appropriate template e.g. 1+X=?
	 * number + variable = answer
	 * where variables can be replaced with number/sequence/database generators
	 * (possibly with range constraints)
	 * @author Troy Gardner
	 */
	public class CalcParser  extends Hsm {

		public static var SIG_RECIEVED_DATA : Signals = Signals.getNextSignal("SIG_RECIEVED_DATA");
		public static var SIG_CLEAR : Signals = Signals.getNextSignal("SIG_CLEAR");
	
		protected var toParse : String;
		/************************************************
		 *  Constructor 
		 */
		public function CalcParser(aInitState : String = "s_initial", aName : String = "CalcParser", aInit : Boolean= true) {
			super(aInitState, aName, aInit);
			trace("CALC PARSER _------------------------------------------");

		}
		public static function getVersion():String{
			return "CalcParser .01";
		}
		public function evalStr(expression : String) : void{
			var ce : CalcEvt = new CalcEvt();
			ce.sig = SIG_RECIEVED_DATA;
			ce.args = expression;
			dispatchEvent(ce);
		}
		public function parseStr(expression : String) : Number{
			var res : Number = NaN;
			//reset the state machine
			reset();
			/////////// PARSE THE ARGUMENTS ///////////////
			var evts : Array = new Array();
			for (var i : Number = 0; i < expression.length; i++) {
				var c : String = expression.charAt(i);
				var e : CogEvent = CalcEvt.createEvent(c);
				if(e != null){
					evts.push(e);
				}
			}
			//////////// EVALUATE THE EXPRESSION ////////////
			for (var j : Number = 0; j < evts.length; j++) {
				var ce : CogEvent = CogEvent(evts[j]);
				dispatchEvent(ce);
			}
			//res = myLastResult;
			return res;
		}
		public function reset() : void{
			var e : CalcEvt = new CalcEvt();
			e.sig = SIG_CLEAR;
			dispatchEvent(e);
		}
		//////////////////////// STATE METHODS ///////////////////////////////////
		/*..PSEUDOSTATE...............................................................*/
		public function s_initial(e : CogEvent) : Function
		{
			//trace("************************* s_initial " + util.Trace.me(e)+" ******************");
			//onFunctionEnter ("s_initial-", e, []);
			if(e.sig != SIG_TRACE){
				return s_ready;
			}
		}
		/*.................................................................*/
		public function s_ready(e : CogEvent) : Function
		{
			//onFunctionEnter ("s_ready-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					//graphics.clear();
					return null;
				}
				case SIG_INIT :
				{
					//Q_INIT();
					return s__idle;
				}
				case SIG_CLEAR:{
	//				graphics.clear();
					tran(s_ready);
					return null;
				}
				case SIG_TERMINATE:
				{
					tran(s_final);
					return null;
				}
			}
			return s_root;
		}
		
		/*.................................................................*/
		public function s__idle(e : CogEvent) : Function
		{
			//onFunctionEnter ("s__idle-", e, []);
			switch (e.sig)
			{
				case SIG_RECIEVED_DATA:
				{
					toParse = String(e.args);
					tran(s___breakingApartByOperators);
					return null;
				}
			}
			return s_ready;
		}
		/*.................................................................*/
		public function s__parsing(e : CogEvent) : Function
		{
			//onFunctionEnter ("s__parsing-", e, []);
			switch (e.sig)
			{
				case SIG_INIT:
					return s___breakingApartByOperators;
//					break;
	
			}
			return s_ready;
		}
			/*.................................................................*/
		public function s___breakingApartByOperators(e : CogEvent) : Function
		{
			//onFunctionEnter ("s___breakingApartByOperators-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY:
				trace("	     /////////// PARSE THE ARGUMENTS /////////////// ");
			     /////////// PARSE THE ARGUMENTS ///////////////
					var sections : Array = new Array();
					var subsection:Array = new Array();
					for (var i : Number = 0; i < toParse.length; i++) {
						var c : String = toParse.charAt(i);
						switch(c){
							case "0":
							case "1":
							case "2":
							case "3":
							case "4":
							case "5":
							case "6":
							case "7":
							case "8":
							case "9":				
								trace("found a number" + c);
								subsection.push(c);
								break;
							
							break;
							case "+":
							case "-":
							case "/":
							case "*":
							case "%":
							trace("found a symbol" + c);
							   sections.push(subsection);
							   subsection = new Array();
							break;
							case "=":
								trace("found a equals" + c);
							   sections.push(subsection);
							   subsection = new Array();
							
							break;							
							default:					
								trace("found a variable" + c);
								subsection.push(c);
								break;
						}
					}
					trace("Found Sections :\r\t " + sections.join("\r\t"));
					break;
					return null;
	
			}
			return s__parsing;
		}
		/*.................................................................*/
		public function s_final(e : CogEvent) : Function
		{
		//	onFunctionEnter ("s_final-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					return null;
				}
			}
			return s_root;
		}
	}
}