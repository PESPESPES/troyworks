package com.troyworks.controls.tcalc {
	import com.troyworks.core.cogs.CogSignal;

	import flash.events.Event;	
	import flash.events.KeyboardEvent;	

	import com.troyworks.controls.tbutton.MCButton;
	import com.troyworks.framework.ui.BaseComponent;
	import com.troyworks.framework.ui.KeyCode;
	import com.troyworks.framework.ui.MCBackground;
	import com.troyworks.util.Trace;

	import flash.text.TextField;
	import flash.ui.Keyboard;	 

	/**
	 * @author Troy Gardner
	 */

	
	public class CalcUI extends BaseComponent {

		public var __divide : MCButton;
		public var __multiply : MCButton;
		public var __minus : MCButton;
		public var __plus : MCButton;
		public var __CE : MCButton;
		public var __C : MCButton;
		public var __9 : MCButton;
		public var __8 : MCButton;
		public var __7 : MCButton;
		public var __6 : MCButton;
		public var __5 : MCButton;
		public var __4 : MCButton;
		public var __3 : MCButton;
		public var __2 : MCButton;
		public var __1 : MCButton;
		public var __equals : MCButton;
		public var __period : MCButton;
		public var __0 : MCButton;
		public var status_txt : TextField;
		public var display_txt : TextField;
		public var background_mc : MCBackground;
		protected var calc : Calc;

		/*****************************************************
		 *  Constructor
		 */
		public function CalcUI() {
			//super();
			calc = new Calc(null, null, false);
		}

		override public function onLoad(init : Boolean = true) : void {
			//super.onLoad();
			status_txt.text = "???";
			display_txt.text = "";
			calc.addEventListener(Calc.EVTD_CALC_STATE_CHANGED, this.onStateChanged);
			calc.addEventListener(Calc.EVTD_DISPLAYCHANGED, this.onDisplayChanged);
			calc.addEventListener(Calc.EVTD_DESTROYVIEW, this.onCalcFinished);	
			calc.initStateMachine();
			
			//trace(UIHelper.genCode(this));
		//	stage.addEventListener(this);
		}

		public function onDisplayChanged(arg : Object) : void {
			trace("111111111111111111111111111111111111111111111");
			trace("111111111111111111111111111111111111111111111");
			trace("1111111111111onDisplayChanged11111111111111111111111111111111");
			//		trace(util.Trace.me(arg, "arg ", false));
			trace(arg.args);
			trace("111111111111111111111111111111111111111111111");
			trace("111111111111111111111111111111111111111111111");
			trace("111111111111111111111111111111111111111111111");
			display_txt.text = arg.args;
		}

		public function onStateChanged(arg : Object) : void {
			trace("111111111111111111111111111111111111111111111");
			trace("111111111111111111111111111111111111111111111");
			trace("1111111111111onStateChanged11111111111111111111111111111111");
			trace(Trace.me(arg, "arg ", false));
			trace("111111111111111111111111111111111111111111111");
			trace("111111111111111111111111111111111111111111111");
			trace("111111111111111111111111111111111111111111111");
			status_txt.text = arg.args;
		}

		public function onCalcFinished() : void {
			trace("111111111111111111111111111111111111111111111");
			trace("111111111111111111111111111111111111111111111");
			trace("onCalcFinished");
			trace("111111111111111111111111111111111111111111111");
			trace("111111111111111111111111111111111111111111111");
			trace("111111111111111111111111111111111111111111111");
			//this.alpha = 30;
		}

		/***********************************************
		 * Translates KeyPresses into CalcEvents
		 * 
		 */
		public function onKeyUp(evt : KeyboardEvent) : void {
			trace("Keyboard.onKeyUP " + evt.charCode);
			 
			var sig : CogSignal;
			var args : Object;
			trace("Keyboard.getCode()" + evt.charCode + " " + KeyCode._0 + " " + (evt.charCode == KeyCode._0));
			switch(KeyCode.parse(evt.charCode)) {
				case KeyCode._0:
					trace("0 pressed");
					sig = Calc.SIG_0;
					args = 0;
					break;
				case KeyCode._1:
					trace("1 pressed");
					sig = Calc.SIG_1_9;
					args = 1;
					break;
				case KeyCode._2:
					trace("2 pressed");
					sig = Calc.SIG_1_9;
					args = 2;
					break;
				case KeyCode._3:
					trace("3 pressed");
					sig = Calc.SIG_1_9;
					args = 3;
					break;
				case KeyCode._4:
					trace("4 pressed");
					sig = Calc.SIG_1_9;
					args = 4;
					break;
				case KeyCode._5:
					trace("5 pressed");
					sig = Calc.SIG_1_9;
					args = 5;
					break;
				case KeyCode._6:
					trace("6 pressed");
					sig = Calc.SIG_1_9;
					args = 6;
					break;
				case KeyCode._7:
					trace("7 pressed");
					sig = Calc.SIG_1_9;
					args = 7;
					break;
				case KeyCode._8:
					trace("8 pressed");
					sig = Calc.SIG_1_9;
					args = 8;
					break;
				case KeyCode._9:
					trace("9 pressed");
					sig = Calc.SIG_1_9;
					args = 9;
					break;
				case KeyCode.CANCEL:
					trace("CANCEL pressed");
					sig = Calc.SIG_CANCEL;
					break;
				case KeyCode.PLUS:
					trace("PLUS pressed");
					sig = Calc.SIG_OPER;
					args = Calc.SIG_PLUS; 
					break;
				case KeyCode.MINUS:
					trace("MINUS pressed");
					sig = Calc.SIG_OPER;
					args = Calc.SIG_MINUS;
					break;
				case KeyCode.ASTERISK:
					trace("MULTIPLE pressed");
					sig = Calc.SIG_OPER;
					args = Calc.SIG_MULT;
					break;
				case KeyCode.RIGHT_SLASH:
					trace("DIVIDE pressed");
					sig = Calc.SIG_OPER;
					args = Calc.SIG_DIVIDE;
					break;
			} 
			
			if(sig != null) {
				trace("broadcasting to Calc======================");
				//trace(calc.isHandled = true);
				var e : CalcEvt = new CalcEvt(sig.name, sig);
				e.args = args;
				calc.dispatchEvent(e);
				//trace(calc.isHandled);
			} else {
				trace("ignoring event");
			}
		}

		override public function onChildClipEvent(evt : Event) : void {
			trace("000000000000000000000000000000000000000000000000000000");
			trace("0000000000000000000000000BaseComponent.onChildClipEvent00000000000000000000000000000");
			trace(Trace.me(evt, "evt ", false));
			trace("000000000000000000000000000000000000000000000000000000");
			trace("000000000000000000000000000000000000000000000000000000");
			trace("000000000000000000000000000000000000000000000000000000");
			var sig : CogSignal;
			var args : Object;
			switch(evt.type) {
				case "0":
					trace("0 pressed");
					sig = Calc.SIG_0;
					args = 0;
					break;
				case "1":
					trace("1 pressed");
					sig = Calc.SIG_1_9;
					args = 1;
					break;
				case "2":
					trace("2 pressed");
					sig = Calc.SIG_1_9;
					args = 2;
					break;
				case "3":
					trace("3 pressed");
					sig = Calc.SIG_1_9;
					args = 3;
					break;
				case "4":
					trace("4 pressed");
					sig = Calc.SIG_1_9;
					args = 4;
					break;
				case "5":
					trace("5 pressed");
					sig = Calc.SIG_1_9;
					args = 5;
					break;
				case "6":
					trace("6 pressed");
					sig = Calc.SIG_1_9;
					args = 6;
					break;
				case "7":
					trace("7 pressed");
					sig = Calc.SIG_1_9;
					args = 7;
					break;
				case "8":
					trace("8 pressed");
					sig = Calc.SIG_1_9;
					args = 8;
					break;
				case "9":
					trace("9 pressed");
					sig = Calc.SIG_1_9;
					args = 9;
					break;
				case "C":
					trace("CANCEL pressed");
					sig = Calc.SIG_CANCEL;
					break;
				case "CE":
					trace("CLEAR pressed");
					sig = Calc.SIG_CE;
					break;
				case "plus":
					trace("PLUS pressed");
					sig = Calc.SIG_OPER;
					args = Calc.SIG_PLUS; 
					break;
				case "minus":
					trace("MINUS pressed");
					sig = Calc.SIG_OPER;
					args = Calc.SIG_MINUS;
					break;
				case "multiply":
					trace("MULTIPLY pressed");
					sig = Calc.SIG_OPER;
					args = Calc.SIG_MULT;
					break;
				case "divide":
					trace("DIVIDE pressed");
					sig = Calc.SIG_OPER;
					args = Calc.SIG_DIVIDE;
					break;
				case "period":
					trace("POINT pressed");
					sig = Calc.SIG_POINT;
					args = ".";
					break;	
				case "equals":
					trace("EQUALS pressed");
					sig = Calc.SIG_EQUALS;
					args = "=";
					break;	
			}
			if(sig != null) {
				trace("broadcasting to Calc======================");
				//trace(calc.isHandled = true);
				var e : CalcEvt = new CalcEvt(sig.name, sig);
				e.args = args;
				calc.dispatchEvent(e);
				//trace(calc.isHandled);
			} else {
				trace("ignoring event");
			}
		}
	}
}