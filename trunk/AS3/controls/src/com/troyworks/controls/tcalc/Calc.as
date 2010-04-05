package com.troyworks.controls.tcalc {
	import flash.display.Sprite;	
	import flash.events.Event;	

	import com.troyworks.core.cogs.CogEvent;	
	import com.troyworks.core.Signals;	
	import com.troyworks.core.cogs.CogSignal;	
	import com.troyworks.core.cogs.Hsm; 

	/**
	 * This is a AS2.0 port of the Calc Example in Miro Samek's Practical
	 * StateCharts for C and C++ with suitable changes based on the differences
	 * between C and Actionscript, UCM/MVC, and some other changes in behavior.
	
	 * Calc is a non-visual calculator component that mirrors
	 * basic calculator use, it is intended to be used in two fashions
	 * 1) one is in conjunction with the CalcUI skin to provide a skinnable calc.
	 * 2) the other is as a non-visual component that can be called on to evaluate expresssion
	 * such as "3+30.5-3/2=" which behaves just as if you had typed the values into a calculator in that L-R 
	 * order BUT it does not respect order of operators thus each new operators operates on the previous result
	 * 
	 *  
	 * 
	 * 
	 * @author Troy Gardner
	 */
	public class Calc extends Hsm {
		public static var SIG_0 : CogSignal = Signals.getNextSignal("SIG_0");
		public static var SIG_1_9 : CogSignal = Signals.getNextSignal("SIG_1_9");
		public static var SIG_POINT : CogSignal = Signals.getNextSignal("SIG_POINT");
		public static var SIG_C : CogSignal = Signals.getNextSignal("SIG_C");
		public static var SIG_CE : CogSignal = Signals.getNextSignal("SIG_CE");
		public static var SIG_PLUS : CogSignal = Signals.getNextSignal("SIG_PLUS");
		public static var SIG_MINUS : CogSignal = Signals.getNextSignal("SIG_MINUS");
		public static var SIG_MULT : CogSignal = Signals.getNextSignal("SIG_MULT");
		public static var SIG_DIVIDE : CogSignal = Signals.getNextSignal("SIG_DIVIDE");
		public static var SIG_EQUALS : CogSignal = Signals.getNextSignal("SIG_EQUALS");
		public static var SIG_CANCEL : CogSignal = Signals.getNextSignal("SIG_CANCEL");

		public static var SIG_OPER : CogSignal = Signals.getNextSignal("SIG_OPER");
		public static var SIG_TERMINATE : CogSignal = Signals.getNextSignal("SIG_TERMINATE");

		public static var EVTD_CALC_STATE_CHANGED : String = "EVTD_CALC_STATE_CHANGED";
		public static var EVTD_DISPLAYCHANGED : String = "EVTD_DISPLAYCHANGED";
		public static var EVTD_DESTROYVIEW : String = "EVTD_DESTROYVIEW";
		protected var myHwnd : Object;
		//HWND
		protected var myDisplay : Array = new Array();
		//40 characters
		protected var myIns : String;
		protected var myOperand1 : Number;
		//double
		protected var myOperand2 : Number;
		//double
		protected var myOperator : CogSignal;
		//int
		protected var myLastResult : Number;
		protected var isHandled : Boolean;
		public var view : Sprite;

		/************************************************
		 *  Constructor 
		 */
		public function Calc(initState : String, name : String, aInit : Boolean) {
			super(initState, (name == null) ? "Calc" : name);
		}

		///////////////////// DATA ACCESSOS /////////////////////////
		/////////////////////PUBLIC METHODS ////////////////////////
		public function evalStr(expression : String) : Number {
			var res : Number = NaN;
			//reset the state machine
			reset();
			/////////// PARSE THE ARGUMENTS ///////////////
			var evts : Array = new Array();
			for (var i : Number = 0;i < expression.length; i++) {
				var c : String = expression.charAt(i);
				var e : CogEvent = CalcEvt.createEvent(c);
				if(e != null) {
					evts.push(e);
				}
			}
			//////////// EVALUATE THE EXPRESSION ////////////
			for (var j : Number = 0;j < evts.length; j++) {
				var ce : CogEvent = CogEvent(evts[j]);
				dispatchEvent(ce);
			}
			res = myLastResult;
			return res;
		}

		public function reset() : void {
			var e : CalcEvt = new CalcEvt(SIG_C.name,SIG_C);
			dispatchEvent(e);
		}

		//////////////////////PRIVATE METHODS ///////////////////////////////
		protected function clear() : void {
			myDisplay = new Array();
			var evt : CogEvent = new CogEvent(CogEvent.EVTD_DISPLAYCHANGED, null);
			evt.args = myDisplay.join("");
			this.dispatchEvent(evt);
		}

		protected function insert(keyID : Object) : void {
	
			myDisplay.push(keyID);
			var evt : CogEvent = new CogEvent(CogEvent.EVTD_DISPLAYCHANGED, null);
			evt.args = myDisplay.join("");
			this.dispatchEvent(evt);
		}

		protected function setdisplay(val : Number) : void {
			trace("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
			trace("AAAAAAAAAAAAAAAAAAAAA setdisplay AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
			trace("AAAAAAAAAAAAAAAAAAAAAAAA " + val + " AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
			trace("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
			myDisplay = new Array();
			myDisplay.push(val);
			var evt : CogEvent = new CogEvent(EVTD_DISPLAYCHANGED, null);
			evt.args = myDisplay.join("");
			this.dispatchEvent(evt);
		}

		protected function negate() : void {
			myDisplay.unshift("-");
			var evt : CogEvent = new CogEvent(EVTD_DISPLAYCHANGED, null);
			evt.args = myDisplay.join("");
			this.dispatchEvent(evt);
		}

		protected function evalExpression() : void {
	
			
			var res : Number;
			switch(myOperator) {
				case SIG_PLUS:
					res = myOperand1 + myOperand2;
					break;
				case SIG_MINUS:
					res = myOperand1 - myOperand2;
					break;
				case SIG_MULT:
					res = myOperand1 * myOperand2;
					break;
				case SIG_DIVIDE:
					if(myOperand2 != 0.0) {
						res = myOperand1 / myOperand2;
					}else {
						//XXX todo pop message box "Cannot Divide by Zero"
						res = 0.0;
					}
					break;
				default:
					ASSERT(false, "evalExpression had invalid opeator");
					break;
			}
			trace("EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
			trace("EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
			trace("EEEEEEEEEEEEEEEEE evalExpression EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
			trace("EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
			trace("EEEEEEEEEEEEEEEE " + myOperand1 + "  " + myOperator.name + "  " + myOperand2 + " EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
			trace("EEEEEEEEEEEEEEEEEEEEEEEEEEE = " + res + " EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
			trace("EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
			trace("EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
			myLastResult = res;
			//Data Range Validate
			if(Number.MIN_VALUE < res && res < Number.MAX_VALUE) {
				//XXX todo insert Number Formatting here
				setdisplay(res);
			}else {
				//Data Out of Range
				//XXX todo pop message box "Result Out of Range"
				view.graphics.clear();			
			}
		}

		protected function dispState(curStateName : String) : void {
			// trace("CALC.dispState " + curStateName);
			var evt : CogEvent = new CogEvent(EVTD_CALC_STATE_CHANGED, null);
			evt.args = curStateName;
			//myDisplay.join("");
			this.dispatchEvent(evt);
	
		//	this.diEventchEvenEvent			{
	//Eventype : Event_CALC_STATE_CHANGED, target : this, args:curStateName
	//		});
		}

		///////////////// STATES//////////////////////////////////
		/*..PSEUDOSTATE...............................................................*/
		public function s_initial(e : CogEvent) : Function {
			//trace("************************* s_initial " + util.Trace.me(e)+" ******************");
			//			onFunctionEnter ("s_initial-", e, []);
			if(e.sig != SIG_TRACE) {
				return s_calc;
			}
		}

		/*.................................................................*/
		public function s_calc(e : CogEvent) : Function {
			//		onFunctionEnter ("s_calc-", e, []);
			switch (e.sig) {
				case SIG_ENTRY :
					{
					dispState("calc");
					return null;
				}
				case SIG_INIT :
				{
					view.graphics.clear();
//					Q_INIT(s__ready);
					return s__ready;
				}
				case SIG_C:
				case SIG_CE:{
					view.graphics.clear();
					tran(s_calc);
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
		public function s__ready(e : CogEvent) : Function
		{
			//this.onFunctionEnter ("s__ready-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
					dispState("ready");
					return null;
				case SIG_INIT :
				
					return s___begin;
				case SIG_0:
					view.graphics.clear();
					tran(s___zero1);
					return null;
				case SIG_1_9:
					view.graphics.clear();
					insert(Number(e.args));
					tran(s___int1);
					return null;
				case SIG_POINT:
					view.graphics.clear();
					insert(0);
					insert('.');
					tran(s___frac1);
					return null;
				case SIG_OPER:
				    myOperand1 = Number(myDisplay.join(""));
					myOperator = CogSignal(e.args);
					tran(s__opEntered);
					return null;		
			}
			return s_calc;
		}
		/*.................................................................*/
		public function s___result(e : CogEvent) : Function
		{
		//	this.onFunctionEnter ("s___result-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					dispState("result");
					evalExpression();
					myOperand1 = myLastResult;
					myOperand2 = NaN;
					myOperator  = null;
					return null;
				}
				default:
				// trace("s_result not handling " +util.Trace.me(e, "EVT", true));
			}
			return s__ready;
		}
		/*.................................................................*/
		public function s___begin(e : CogEvent) : Function
		{
			//this.onFunctionEnter ("s___begin-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					dispState("begin");
					return null;
				}
				case SIG_OPER:
				{
					var arg : CogSignal = CogSignal(e.args);
					if(arg == SIG_MINUS){
						tran(s__negated1);
						return null; // event handled
					}else if(arg == SIG_PLUS){
						//unary "+"
						return null; //event handled
					}
					break; //event unhandled
				}
			}
			return s__ready;
		}
	
		/*.................................................................*/
		public function s__negated1(e : CogEvent) : Function
		{
		//	this.onFunctionEnter ("s__negated1-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY:
					dispState("negated1");
					negate();
					return null;
				case SIG_CE:
					view.graphics.clear();
					tran(s___begin);
					return null;
				case SIG_0:
					insert(Number(e.args));
					tran(s___zero1);
					return null;
				case SIG_1_9:
					insert(Number(e.args));
					tran(s___int1);
					return null;
				case SIG_POINT:
					insert(Object(e.args));
					tran(s___frac1);
					return null;
	
			}
			return s_calc;
		}
		/*.................................................................*/
		public function s__operand1(e : CogEvent) : Function
		{
		//	this.onFunctionEnter ("s__operand1-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY:
					dispState("operand1");
					return null;
				case SIG_CE:
					view.graphics.clear();
					tran(s___begin);
					return null;
				case SIG_OPER:
					// trace("sscanf lf " + myDisplay);
	    //  trace("sscanf(myDisplay, "%lf", &myOperand1);
			    myOperand1 = Number(myDisplay.join(""));
					myOperator = CogSignal(e.args);
					tran(s__opEntered);
					return null;
				case SIG_EXIT:
					myOperand1 = Number(myDisplay.join(""));
				    return null;	
			}
			return s_calc;
		}
	
		/*.................................................................*/
		public function s___zero1(e : CogEvent) : Function
		{
		//	this.onFunctionEnter ("s___zero1-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY:
					dispState("zero1");
					return null;
				case SIG_1_9:
					insert(Number(e.args));
					myOperand1 = Number(myDisplay.join(""));
					tran(s___int1);
					return null;
				case SIG_POINT:
					insert(String(e.args));
					tran(s___frac1);
					return null;
			}
			return s__operand1;
		}
		/*.................................................................*/
		public function s___int1(e : CogEvent) : Function
		{
		//	this.onFunctionEnter ("s___int1-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY:
					dispState("int1");
					return null;
				case SIG_0:
				case SIG_1_9:
					insert(Number(e.args));
						myOperand1 = Number(myDisplay.join(""));
					
					return null;
				case SIG_POINT:
					insert(String(e.args));
					tran(s___frac1);
					return null;
			}
			return s__operand1;
		}
		/*.................................................................*/
		public function s___frac1(e : CogEvent) : Function
		{
		//	this.onFunctionEnter ("s___frac1-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY:
					dispState("frac1");
					return null;
				case SIG_0:
				case SIG_1_9:
					insert(Number(e.args));
					myOperand1 = Number(myDisplay.join(""));
					return null;
			}
			return s__operand1;
		}
			/*.................................................................*/
		public function s__opEntered(e : CogEvent) : Function
		{
			//this.onFunctionEnter ("s__opEntered-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY:
					dispState("opEntered");
	
					return null;
				case SIG_OPER:
				      if (CogSignal(e.args) == SIG_MINUS) {
						view.graphics.clear();
						tran(s__negated2);
				      }
					return null;
				case SIG_0:
					view.graphics.clear();
					tran(s___zero2);
					return null;
				case SIG_1_9:
					view.graphics.clear();
					insert(Number(e.args));
					tran(s___int2);
					return null;
				case SIG_POINT:
					view.graphics.clear();
					insert(SIG_0);
					insert(Object(e.args));
					tran(s___frac2);
					return null;
			}
			return s_calc;
		}
		/*.................................................................*/
		public function s__negated2(e : CogEvent) : Function
		{
			//this.onFunctionEnter ("s__negated2-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY:
					dispState("negated2");
					negate();
					return null;
				case SIG_CE:
					tran(s__opEntered);
					return null;
				case SIG_0:
					tran(s___zero2);
					return null;
				case SIG_1_9:
					insert(Object(e.args));
						myOperand2 = Number(myDisplay.join(""));
					tran(s___int2);
					return null;
				case SIG_POINT:
					insert(Object(e.args));
					tran(s___frac2);
					return null;
			}
			return s_calc;
		}
	
		
		/*.................................................................*/
		public function s__operand2(e : CogEvent) : Function
		{
		//	this.onFunctionEnter ("s__operand2-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY:
					dispState("operand2");
					return null;
				case SIG_CE:
					//view.graphics.clear();
					tran(s__opEntered);
					return null;
				case SIG_OPER:
			      //XXX trace("sscanf(myDisplay, "%lf", &myOperand2);
				    myOperand2 = Number(myDisplay.join(""));
			     // XXX trace("sscanf(myDisplay, "%lf", &myOperand1);
			     	evalExpression();
			     	myOperand1 = myLastResult;
					myOperand2 = NaN;
					myOperator = CogSignal(e.args);
					
					tran(s__opEntered);
					return null;
				case SIG_EQUALS:
		      //XXX trace("sscanf(myDisplay, "%lf", &myOperand2);
		    	    myOperand2 = Number(myDisplay.join(""));
					tran(s___result);
					return null;
				case SIG_EXIT:
					myOperand2 = Number(myDisplay.join(""));
				    return null;		
			}
			return s_calc;
		}
		
		/*.................................................................*/
		public function s___zero2(e : CogEvent) : Function
		{
		//	this.onFunctionEnter ("s___zero2-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY:
					dispState("zero2");
					return null;
				case SIG_1_9:
					insert(Number(e.args));
					myOperand2 = Number(myDisplay.join(""));
					tran(s___int2);
					return null;
				case SIG_POINT:
					insert(String(e.args));
					tran(s___frac2);
					return null;
			}
			return s__operand2;
		}
		/*.................................................................*/
		public function s___int2(e : CogEvent) : Function
		{
			//this.onFunctionEnter ("s___int2-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY:
					dispState("int2");
					return null;
				case SIG_0:
				case SIG_1_9:
					insert(Number(e.args));
					myOperand2 = Number(myDisplay.join(""));
					return null;
				case SIG_POINT:
					insert(String(e.args));
					tran(s___frac2);
					return null;
		/*		case SIG_OPER:
				   	evalExpression();
				   	my
				    tran
				    return null;*/
	
			}
			return s__operand2;
		}
		/*.................................................................*/
		public function s___frac2(e : CogEvent) : Function
		{
			//this.onFunctionEnter ("s___frac2-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY:
					dispState("frac2");
					return null;
				case SIG_0:
				case SIG_1_9:
					insert(Number(e.args));
					return null;
			}
			return s__operand2;
		}
		
		/*.................................................................*/
		public function s_final(e : CogEvent) : Function
		{
		//	this.onFunctionEnter ("s_final-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{ 
					dispState("EXIT");
					dispatchEvent(new Event(EVTD_DESTROYVIEW, true, true));
					return null;
				}
			}
			return s_root;
		}
		override public function toStringShort(stateName:String) : String
		{
			return super.toStringShort(stateName)+ " op1 " + myOperand1 + " op2 " + myOperand2 + " oper " + myOperator.name;
		}
	}
}