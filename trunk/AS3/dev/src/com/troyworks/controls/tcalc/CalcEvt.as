package com.troyworks.calc { 
	import com.troyworks.hsmf.Signal;
	import com.troyworks.hsmf.AEvent;
	import com.troyworks.hsmf.Hsmf;
	
	/**
	 * @author Troy Gardner
	 */
	public class CalcEvt extends AEvent {
	
		/*****************************************************
		 *  Constructor
		 */
		public function CalcEvt() {
			super();
		}
		public static function createEvent(arg:Object):CalcEvt{
			public var e : CalcEvt = new CalcEvt();
			switch(arg){
				case 0:
				case "0":
					trace("0 pressed");
					e.sig = Calc.SIG_0;
					e.args = 0;
					break;
				case 1:
				case "1":
					trace("1 pressed");
					e.sig = Calc.SIG_1_9;
					e.args = 1;
					break;
				case 2:	
				case "2":
					trace("2 pressed");
					e.sig = Calc.SIG_1_9;
					e.args = 2;
					break;
				case 3:
				case "3":
					trace("3 pressed");
					e.sig = Calc.SIG_1_9;
					e.args = 3;
					break;
				case 4:
				case "4":
					trace("4 pressed");
					e.sig = Calc.SIG_1_9;
					e.args = 4;
					break;
				case 5:
				case "5":
					trace("5 pressed");
					e.sig = Calc.SIG_1_9;
					e.args = 5;
					break;
				case 6:
				case "6":
					trace("6 pressed");
					e.sig = Calc.SIG_1_9;
					e.args = 6;
					break;
				case 7:	
				case "7":
					trace("7 pressed");
					e.sig = Calc.SIG_1_9;
					e.args = 7;
					break;
				case 8:	
				case "8":
					trace("8 pressed");
					e.sig = Calc.SIG_1_9;
					e.args = 8;
					break;
				case 9:	
				case "9":
					trace("9 pressed");
					e.sig = Calc.SIG_1_9;
					e.args = 9;
					break;
				case "C":
					trace("CANCEL pressed");
					e.sig = Calc.SIG_CANCEL;
					break;
				case "CE":
					trace("CLEAR pressed");
					e.sig = Calc.SIG_CE;
					break;
				case "+":
				case "plus":
					trace("PLUS pressed");
					e.sig = Calc.SIG_OPER;
					e.args = Calc.SIG_PLUS; 
					break;
				case "-":	
				case "minus":
					trace("MINUS pressed");
					e.sig = Calc.SIG_OPER;
					e.args = Calc.SIG_MINUS;
					break;
				case "*":	
				case "multiply":
					trace("MULTIPLY pressed");
					e.sig = Calc.SIG_OPER;
					e.args = Calc.SIG_MULT;
					break;
				case "/":	
				case "divide":
					trace("DIVIDE pressed");
					e.sig = Calc.SIG_OPER;
					e.args = Calc.SIG_DIVIDE;
					break;
				case ".":	
				case "period":
					trace("POINT pressed");
					e.sig = Calc.SIG_POINT;
					e.args = ".";
					break;
				case "=":		
				case "equals":
					trace("EQUALS pressed");
					e.sig = Calc.SIG_EQUALS;
					e.args = "=";
					break;	
					
			}
			if(e.sig != null){
				return e;
			}else{
				return null;
				trace("ignoring event");
			}
		}	
	}
}