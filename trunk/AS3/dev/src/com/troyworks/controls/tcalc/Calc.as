package com.troyworks.calc { 
	import com.troyworks.hsmf.Hsmf;
	import com.troyworks.hsmf.AEvent;
	import com.troyworks.hsmf.Signal;
	
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
	public class Calc extends Hsmf {
		public static var SIG_0 : Signal = Signal.getNext("SIG_0");
		public static var SIG_1_9 : Signal = Signal.getNext("SIG_1_9");
		public static var SIG_POINT : Signal = Signal.getNext("SIG_POINT");
		public static var SIG_C : Signal = Signal.getNext("SIG_C");
		public static var SIG_CE : Signal = Signal.getNext("SIG_CE");
		public static var SIG_PLUS : Signal = Signal.getNext("SIG_PLUS");
		public static var SIG_MINUS : Signal = Signal.getNext("SIG_MINUS");
		public static var SIG_MULT : Signal = Signal.getNext("SIG_MULT");
		public static var SIG_DIVIDE : Signal = Signal.getNext("SIG_DIVIDE");
		public static var SIG_EQUALS : Signal = Signal.getNext("SIG_EQUALS");
		public static var SIG_CANCEL : Signal = Signal.getNext("SIG_CANCEL");
	
		public static var SIG_OPER : Signal = Signal.getNext("SIG_OPER");
		public static var SIG_TERMINATE : Signal = Signal.getNext("SIG_TERMINATE");
	
		public static var EVTD_CALC_STATE_CHANGED : String = "EVTD_CALC_STATE_CHANGED";
		public static var EVTD_DISPLAYCHANGED : String = "EVTD_DISPLAYCHANGED";
		public static var EVTD_DESTROYVIEW : String = "EVTD_DESTROYVIEW";
		protected var myHwnd : Object;//HWND
		protected var myDisplay : Array = new Array();//40 characters
		protected var myIns : String;
		protected var myOperand1 : Number;//double
		protected var myOperand2 : Number;//double
		protected var myOperator : Signal;//int
		protected var myLastResult:Number;
		protected var isHandled : Boolean;
		/************************************************
		 *  Constructor 
		 */
		public function Calc(initState : Function, name:String, aInit:Boolean) {
			super((initState == null)?s_initial:initState, (name== null)?"Calc": name);
		}
		///////////////////// DATA ACCESSOS /////////////////////////
		/////////////////////PUBLIC METHODS ////////////////////////
		public function evalStr(expression:String):Number{
			var res:Number = null;
			//reset the state machine
			reset();
			/////////// PARSE THE ARGUMENTS ///////////////
			var evts:Array = new Array();
			for (var i : Number = 0; i < expression.length; i++) {
				var c:String = expression.charAt(i);
				var e:AEvent = CalcEvt.createEvent(c);
				if(e != null){
					evts.push(e);
				}
			}
			//////////// EVALUATE THE EXPRESSION ////////////
			for (var j : Number = 0; j < evts.length; j++) {
				var ce:AEvent = AEvent(evts[j]);
				Q_dispatch(ce);
			}
			res = myLastResult;
			return res;
		}
		public function reset():void{
			var e:CalcEvt = new CalcEvt();
			e.sig = SIG_C;
			Q_dispatch(e);
		}
		//////////////////////PRIVATE METHODS ///////////////////////////////
		protected function graphics.clear() : void{
			myDisplay = new Array();
			this.dispatchEvent (
			{
				type : EVTD_DISPLAYCHANGED, target : this, args:myDisplay.join("")
			});
			
		}
		protected function insert(keyID : Object) : void{
	
			myDisplay.push(keyID);
			this.dispatchEvent (
			{
				type : EVTD_DISPLAYCHANGED, target : this, args:myDisplay.join("")
			});
			
		}
		protected function setdisplay(val : Number) : void{
			trace("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
			trace("AAAAAAAAAAAAAAAAAAAAA setdisplay AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
			trace("AAAAAAAAAAAAAAAAAAAAAAAA " + val + " AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
			trace("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
			myDisplay = new Array();
			myDisplay.push(val);
			this.dispatchEvent (
			{
				type : EVTD_DISPLAYCHANGED, target : this, args:myDisplay.join("")
			});
		}
		protected function negate() : void{
			myDisplay.unshift("-");
			this.dispatchEvent (
			{
				type : EVTD_DISPLAYCHANGED, target : this, args:myDisplay.join("")
			});
		}
		protected function evalExpression() : void{
	
			
			var res : Number;
			switch(myOperator){
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
					if(myOperand2 != 0.0){
							res = myOperand1 / myOperand2;
					}else{
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
					 trace("EEEEEEEEEEEEEEEE " + myOperand1 + "  " +myOperator.name  + "  " + myOperand2 + " EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
					 trace("EEEEEEEEEEEEEEEEEEEEEEEEEEE = " + res + " EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
					 trace("EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
					 trace("EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
			myLastResult = res;
			//Data Range Validate
			if(Number.MIN_VALUE < res && res < Number.MAX_VALUE){
				//XXX todo insert Number Formatting here
				setdisplay(res);
			}else{
				//Data Out of Range
				//XXX todo pop message box "Result Out of Range"
				graphics.clear();			
			}
		}
		protected function dispState(curStateName : String) : void{
			// trace("CALC.dispState " + curStateName);
			this.dispatchEvent (
			{
				type : EVTD_CALC_STATE_CHANGED, target : this, args:curStateName
			});
		}
		///////////////// STATES//////////////////////////////////
		/*..PSEUDOSTATE...............................................................*/
		public function s_initial(e : AEvent) : void
		{
			//trace("************************* s_initial " + util.Trace.me(e)+" ******************");
			onFunctionEnter ("s_initial-", e, []);
			if(e.sig != Q_TRACE_SIG){
				Q_INIT(s_calc);
			}
		}
		/*.................................................................*/
		public function s_calc(e : AEvent) : Function
		{
			onFunctionEnter ("s_calc-", e, []);
			switch (e.sig)
			{
				case Q_ENTRY_SIG :
				{
					dispState("calc");
					return null;
				}
				case Q_INIT_SIG :
				{
					graphics.clear();
					Q_INIT(s__ready);
					return null;
				}
				case SIG_C:
				case SIG_CE:{
					graphics.clear();
					Q_TRAN(s_calc);
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
		public function s__ready(e : AEvent) : Function
		{
			this.onFunctionEnter ("s__ready-", e, []);
			switch (e.sig)
			{
				case Q_ENTRY_SIG :
					dispState("ready");
					return null;
				case Q_INIT_SIG :
					Q_INIT(s___begin);
					return null;
				case SIG_0:
					graphics.clear();
					Q_TRAN(s___zero1);
					return null;
				case SIG_1_9:
					graphics.clear();
					insert(Number(e.args));
					Q_TRAN(s___int1);
					return null;
				case SIG_POINT:
					graphics.clear();
					insert(0);
					insert('.');
					Q_TRAN(s___frac1);
					return null;
				case SIG_OPER:
				    myOperand1 = Number(myDisplay.join(""));
					myOperator = Signal(e.args);
					Q_TRAN(s__opEntered);
					return null;		
			}
			return s_calc;
		}
		/*.................................................................*/
		public function s___result(e : AEvent) : Function
		{
			this.onFunctionEnter ("s___result-", e, []);
			switch (e.sig)
			{
				case Q_ENTRY_SIG :
				{
					dispState("result");
					evalExpression();
					myOperand1 = myLastResult;
					myOperand2 = null;
					myOperator  = null;
					return null;
				}
				default:
				// trace("s_result not handling " +util.Trace.me(e, "EVT", true));
			}
			return s__ready;
		}
		/*.................................................................*/
		public function s___begin(e : AEvent) : Function
		{
			this.onFunctionEnter ("s___begin-", e, []);
			switch (e.sig)
			{
				case Q_ENTRY_SIG :
				{
					dispState("begin");
					return null;
				}
				case SIG_OPER:
				{
					var arg : Signal = Signal(e.args);
					if(arg == SIG_MINUS){
						Q_TRAN(s__negated1);
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
		public function s__negated1(e : AEvent) : Function
		{
			this.onFunctionEnter ("s__negated1-", e, []);
			switch (e.sig)
			{
				case Q_ENTRY_SIG:
					dispState("negated1");
					negate();
					return null;
				case SIG_CE:
					graphics.clear();
					Q_TRAN(s___begin);
					return null;
				case SIG_0:
					insert(Number(e.args));
					Q_TRAN(s___zero1);
					return null;
				case SIG_1_9:
					insert(Number(e.args));
					Q_TRAN(s___int1);
					return null;
				case SIG_POINT:
					insert(Object(e.args));
					Q_TRAN(s___frac1);
					return null;
	
			}
			return s_calc;
		}
		/*.................................................................*/
		public function s__operand1(e : AEvent) : Function
		{
			this.onFunctionEnter ("s__operand1-", e, []);
			switch (e.sig)
			{
				case Q_ENTRY_SIG:
					dispState("operand1");
					return null;
				case SIG_CE:
					graphics.clear();
					Q_TRAN(s___begin);
					return null;
				case SIG_OPER:
					// trace("sscanf lf " + myDisplay);
	    //  trace("sscanf(myDisplay, "%lf", &myOperand1);
			    myOperand1 = Number(myDisplay.join(""));
					myOperator = Signal(e.args);
					Q_TRAN(s__opEntered);
					return null;
				case Q_EXIT_SIG:
					myOperand1 = Number(myDisplay.join(""));
				    return null;	
			}
			return s_calc;
		}
	
		/*.................................................................*/
		public function s___zero1(e : AEvent) : Function
		{
			this.onFunctionEnter ("s___zero1-", e, []);
			switch (e.sig)
			{
				case Q_ENTRY_SIG:
					dispState("zero1");
					return null;
				case SIG_1_9:
					insert(Number(e.args));
					myOperand1 = Number(myDisplay.join(""));
					Q_TRAN(s___int1);
					return null;
				case SIG_POINT:
					insert(String(e.args));
					Q_TRAN(s___frac1);
					return null;
			}
			return s__operand1;
		}
		/*.................................................................*/
		public function s___int1(e : AEvent) : Function
		{
			this.onFunctionEnter ("s___int1-", e, []);
			switch (e.sig)
			{
				case Q_ENTRY_SIG:
					dispState("int1");
					return null;
				case SIG_0:
				case SIG_1_9:
					insert(Number(e.args));
						myOperand1 = Number(myDisplay.join(""));
					
					return null;
				case SIG_POINT:
					insert(String(e.args));
					Q_TRAN(s___frac1);
					return null;
			}
			return s__operand1;
		}
		/*.................................................................*/
		public function s___frac1(e : AEvent) : Function
		{
			this.onFunctionEnter ("s___frac1-", e, []);
			switch (e.sig)
			{
				case Q_ENTRY_SIG:
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
		public function s__opEntered(e : AEvent) : Function
		{
			this.onFunctionEnter ("s__opEntered-", e, []);
			switch (e.sig)
			{
				case Q_ENTRY_SIG:
					dispState("opEntered");
	
					return null;
				case SIG_OPER:
				      if (Signal(e.args) == SIG_MINUS) {
						graphics.clear();
						Q_TRAN(s__negated2);
				      }
					return null;
				case SIG_0:
					graphics.clear();
					Q_TRAN(s___zero2);
					return null;
				case SIG_1_9:
					graphics.clear();
					insert(Number(e.args));
					Q_TRAN(s___int2);
					return null;
				case SIG_POINT:
					graphics.clear();
					insert(SIG_0);
					insert(Object(e.args));
					Q_TRAN(s___frac2);
					return null;
			}
			return s_calc;
		}
		/*.................................................................*/
		public function s__negated2(e : AEvent) : Function
		{
			this.onFunctionEnter ("s__negated2-", e, []);
			switch (e.sig)
			{
				case Q_ENTRY_SIG:
					dispState("negated2");
					negate();
					return null;
				case SIG_CE:
					Q_TRAN(s__opEntered);
					return null;
				case SIG_0:
					Q_TRAN(s___zero2);
					return null;
				case SIG_1_9:
					insert(Object(e.args));
						myOperand2 = Number(myDisplay.join(""));
					Q_TRAN(s___int2);
					return null;
				case SIG_POINT:
					insert(Object(e.args));
					Q_TRAN(s___frac2);
					return null;
			}
			return s_calc;
		}
	
		
		/*.................................................................*/
		public function s__operand2(e : AEvent) : Function
		{
			this.onFunctionEnter ("s__operand2-", e, []);
			switch (e.sig)
			{
				case Q_ENTRY_SIG:
					dispState("operand2");
					return null;
				case SIG_CE:
					graphics.clear();
					Q_TRAN(s__opEntered);
					return null;
				case SIG_OPER:
			      //XXX trace("sscanf(myDisplay, "%lf", &myOperand2);
				    myOperand2 = Number(myDisplay.join(""));
			     // XXX trace("sscanf(myDisplay, "%lf", &myOperand1);
			     	evalExpression();
			     	myOperand1 = myLastResult;
					myOperand2 = null;
					myOperator = Signal(e.args);
					
					Q_TRAN(s__opEntered);
					return null;
				case SIG_EQUALS:
		      //XXX trace("sscanf(myDisplay, "%lf", &myOperand2);
		    	    myOperand2 = Number(myDisplay.join(""));
					Q_TRAN(s___result);
					return null;
				case Q_EXIT_SIG:
					myOperand2 = Number(myDisplay.join(""));
				    return null;		
			}
			return s_calc;
		}
		
		/*.................................................................*/
		public function s___zero2(e : AEvent) : Function
		{
			this.onFunctionEnter ("s___zero2-", e, []);
			switch (e.sig)
			{
				case Q_ENTRY_SIG:
					dispState("zero2");
					return null;
				case SIG_1_9:
					insert(Number(e.args));
					myOperand2 = Number(myDisplay.join(""));
					Q_TRAN(s___int2);
					return null;
				case SIG_POINT:
					insert(String(e.args));
					Q_TRAN(s___frac2);
					return null;
			}
			return s__operand2;
		}
		/*.................................................................*/
		public function s___int2(e : AEvent) : Function
		{
			this.onFunctionEnter ("s___int2-", e, []);
			switch (e.sig)
			{
				case Q_ENTRY_SIG:
					dispState("int2");
					return null;
				case SIG_0:
				case SIG_1_9:
					insert(Number(e.args));
					myOperand2 = Number(myDisplay.join(""));
					return null;
				case SIG_POINT:
					insert(String(e.args));
					Q_TRAN(s___frac2);
					return null;
		/*		case SIG_OPER:
				   	evalExpression();
				   	my
				    Q_TRAN
				    return null;*/
	
			}
			return s__operand2;
		}
		/*.................................................................*/
		public function s___frac2(e : AEvent) : Function
		{
			this.onFunctionEnter ("s___frac2-", e, []);
			switch (e.sig)
			{
				case Q_ENTRY_SIG:
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
		public function s_final(e : AEvent) : Function
		{
			this.onFunctionEnter ("s_final-", e, []);
			switch (e.sig)
			{
				case Q_ENTRY_SIG :
				{ 
					dispState("EXIT");
					this.dispatchEvent (
					{
						type : EVTD_DESTROYVIEW, target : this
					});
					return null;
				}
			}
			return s_top;
		}
		public function toStringShort(stateName:String) : String
		{
			return super.toStringShort(stateName)+ " op1 " + myOperand1 + " op2 " + myOperand2 + " oper " + myOperator.name;
		}
	}
}