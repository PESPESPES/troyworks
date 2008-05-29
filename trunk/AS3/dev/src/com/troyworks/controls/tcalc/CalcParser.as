package com.troyworks.calc { 
	import com.troyworks.framework.controller.BaseController;
	import com.troyworks.hsmf.AEvent;
	import com.troyworks.hsmf.Signal;
	import com.troyworks.hsmf.Hsmf;
	
	/**
	 * CalcParser's job is to take a string of values and separate them into
	 * an appropriate template e.g. 1+X=?
	 * number + variable = answer
	 * where variables can be replaced with number/sequence/database generators
	 * (possibly with range constraints)
	 * @author Troy Gardner
	 */
	public class CalcParser extends Hsmf {
	
		public static var SIG_RECIEVED_DATA : Signal = Signal.getNext("SIG_RECIEVED_DATA");
		public static var SIG_CLEAR : Signal = Signal.getNext("SIG_CLEAR");
	
		protected var toParse : String;
		/************************************************
		 *  Constructor 
		 */
		public function CalcParser(aInitState : Function, aName : String, aInit : Boolean) {
			super((aInitState == null)?s_initial:aInitState, (aName== null)?"CalcParser": aName);
		trace("CALC PARSER _------------------------------------------");
			if(aInit == null || aInit == true){
				init();
			}
		}
		public static function getVersion():String{
			return "CalcParser .01";
		}
		public function evalStr(expression : String) : void{
			var ce : CalcEvt = new CalcEvt();
			ce.sig = SIG_RECIEVED_DATA;
			ce.args = expression;
			Q_dispatch(ce);
		}
		public function parseStr(expression : String) : Number{
			var res : Number = null;
			//reset the state machine
			reset();
			/////////// PARSE THE ARGUMENTS ///////////////
			var evts : Array = new Array();
			for (var i : Number = 0; i < expression.length; i++) {
				var c : String = expression.charAt(i);
				var e : AEvent = CalcEvt.createEvent(c);
				if(e != null){
					evts.push(e);
				}
			}
			//////////// EVALUATE THE EXPRESSION ////////////
			for (var j : Number = 0; j < evts.length; j++) {
				var ce : AEvent = AEvent(evts[j]);
				Q_dispatch(ce);
			}
			//res = myLastResult;
			return res;
		}
		public function reset() : void{
			var e : CalcEvt = new CalcEvt();
			e.sig = SIG_CLEAR;
			Q_dispatch(e);
		}
		//////////////////////// STATE METHODS ///////////////////////////////////
		/*..PSEUDOSTATE...............................................................*/
		public function s_initial(e : AEvent) : void
		{
			//trace("************************* s_initial " + util.Trace.me(e)+" ******************");
			onFunctionEnter ("s_initial-", e, []);
			if(e.sig != Q_TRACE_SIG){
				Q_INIT(s_ready);
			}
		}
		/*.................................................................*/
		public function s_ready(e : AEvent) : Function
		{
			onFunctionEnter ("s_ready-", e, []);
			switch (e.sig)
			{
				case Q_ENTRY_SIG :
				{
					//graphics.clear();
					return null;
				}
				case Q_INIT_SIG :
				{
					Q_INIT(s__idle);
					return null;
				}
				case SIG_CLEAR:{
	//				graphics.clear();
					Q_TRAN(s_ready);
					return null;
				}
				case Q_TERMINATE_SIG:
				{
					Q_TRAN(s_final);
					return null;
				}
			}
			return s_top;
		}
		
		/*.................................................................*/
		public function s__idle(e : AEvent) : Function
		{
			onFunctionEnter ("s__idle-", e, []);
			switch (e.sig)
			{
				case SIG_RECIEVED_DATA:
				{
					toParse = String(e.args);
					Q_TRAN(s___breakingApartByOperators);
					return null;
				}
			}
			return s_ready;
		}
		/*.................................................................*/
		public function s__parsing(e : AEvent) : Function
		{
			onFunctionEnter ("s__parsing-", e, []);
			switch (e.sig)
			{
				case Q_INIT_SIG:
					Q_INIT(s___breakingApartByOperators);
					break;
	
			}
			return s_ready;
		}
			/*.................................................................*/
		public function s___breakingApartByOperators(e : AEvent) : Function
		{
			onFunctionEnter ("s___breakingApartByOperators-", e, []);
			switch (e.sig)
			{
				case Q_ENTRY_SIG:
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
		public function s_final(e : AEvent) : Function
		{
			onFunctionEnter ("s_final-", e, []);
			switch (e.sig)
			{
				case Q_ENTRY_SIG :
				{
					return null;
				}
			}
			return s_top;
		}
	}
}