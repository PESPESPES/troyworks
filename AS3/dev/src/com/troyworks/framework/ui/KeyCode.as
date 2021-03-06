package com.troyworks.framework.ui {
	import flash.utils.Dictionary; 

	import com.troyworks.core.cogs.CogSignal;

	/**
	 * @author Troy Gardner
	 * http://flash-creations.com/notes/asclass_key.php
	 * 
	 * stage.addEventListener(KeyboardEvent.KEY_UP, onKeyListener);
	function onKeyListener(evt : KeyboardEvent):void {
	trace("enterKeyListener " + evt.charCode);
	var keyC:KeyCode = KeyCode.parse(evt.charCode);
	if (keyC== KeyCode._1) {
	//processForm();
	trace('1');
	}
	if (keyC == KeyCode._3) {
	//processForm();
	trace('3');
	}
	if (keyC == KeyCode._5) {
	//processForm();
	trace('5');
	}
	
	


	}
	 */
	public class KeyCode extends CogSignal {
		//needs to go first
		protected static var keyMap : Dictionary = new Dictionary();

		
		public static const __LETTER : String = "LETTER";
		public static const __NUMBER : String = "NUMBER";
		public static const __PUNCTUATION : String = "PUNCTUATION";
		public static const __COMMAND : String = "COMMAND";

		public static const INVALID_KEY : KeyCode = new KeyCode(-1, "INVALID_KEY", __COMMAND);
		public static const NULL_KEY : KeyCode = new KeyCode(0, "NULL_KEY", __COMMAND);
		public static const SOH : KeyCode = new KeyCode(1, "SOH", __COMMAND); //Start of Header
		public static const STX : KeyCode = new KeyCode(2, "STX", __COMMAND); //Start of Text
		public static const ETX : KeyCode = new KeyCode(3, "ETX", __COMMAND); //End of Text
		public static const EOT : KeyCode = new KeyCode(4, "EOT", __COMMAND); //end of transmission
		public static const ENQ : KeyCode = new KeyCode(5, "ENQ", __COMMAND); //enquiry
		public static const ACK : KeyCode = new KeyCode(6, "ACK", __COMMAND);
		public static const BEL : KeyCode = new KeyCode(7, "BEL", __COMMAND);
		public static const BACKSPACE : KeyCode = new KeyCode(8, "BACKSPACE", __COMMAND);
		public static const TAB : KeyCode = new KeyCode(9, "TAB", __COMMAND);
		public static const LINEFEED : KeyCode = new KeyCode(10, "LINEFEED", __COMMAND);
		//
		public static const VT : KeyCode = new KeyCode(11, "VERTICLE TAB", __COMMAND); //VERTICLE TAB
		public static const FF : KeyCode = new KeyCode(12, "FORM FEED", __COMMAND); //FORM FEED
		public static const RETURN : KeyCode = new KeyCode(13, "CARRIAGE RETURN", __COMMAND); //CARRIAGE RETURN
		public static const SO : KeyCode = new KeyCode(14, "SHIFT_OUT", __COMMAND);
		public static const SI : KeyCode = new KeyCode(15, "SHIFT_IN", __COMMAND);
		public static const SHIFT : KeyCode = new KeyCode(16, "SHIFT", __COMMAND);
		public static const CONTROL : KeyCode = new KeyCode(17, "CONTROL", __COMMAND);

		
		public static const ALT : KeyCode = new KeyCode(18, "ALT", __COMMAND);
		public static const CANCEL : KeyCode = new KeyCode(24, "CANCEL", __COMMAND);
		public static const ESC : KeyCode = new KeyCode(27, "ESC", __COMMAND);
		public static const SPACE : KeyCode = new KeyCode(32, " ", __PUNCTUATION);
		public static const EXCLAMATION : KeyCode = new KeyCode(33, "!", __PUNCTUATION);
		public static const PARENTHESIS : KeyCode = new KeyCode(34, '"', __PUNCTUATION);
		public static const POUND : KeyCode = new KeyCode(35, "#", __PUNCTUATION);
		public static const DOLLAR : KeyCode = new KeyCode(36, "$", __PUNCTUATION);
		public static const PERCENT : KeyCode = new KeyCode(37, "%", __PUNCTUATION);
		public static const AMPERSAND : KeyCode = new KeyCode(38, "&", __PUNCTUATION);
		public static const QUOTE : KeyCode = new KeyCode(39, "'", __PUNCTUATION);
		public static const LEFT_SOFT_BRACE : KeyCode = new KeyCode(40, "(", __PUNCTUATION);
		public static const RIGHT_SOFT_BRACE : KeyCode = new KeyCode(41, ")", __PUNCTUATION);
		public static const ASTERISK : KeyCode = new KeyCode(42, "*", __PUNCTUATION);
		public static const PLUS : KeyCode = new KeyCode(43, "+", __PUNCTUATION);
		
		
		
		public static const PLUS2 : KeyCode = new KeyCode(187, "+", __PUNCTUATION);
		public static const COMMA : KeyCode = new KeyCode(44, ",", __PUNCTUATION);
		public static const MINUS : KeyCode = new KeyCode(45, "-", __PUNCTUATION);
		public static const MINUS2 : KeyCode = new KeyCode(189, "-", __PUNCTUATION);
		public static const PERIOD : KeyCode = new KeyCode(46, ".", __PUNCTUATION);
		public static const RIGHT_SLASH : KeyCode = new KeyCode(47, "/", __PUNCTUATION);
		//////////////////////////////////////
		public static const _0 : KeyCode = new KeyCode(48, "0", __NUMBER, 0);
		public static const _1 : KeyCode = new KeyCode(49, "1", __NUMBER, 1);
		public static const _2 : KeyCode = new KeyCode(50, "2", __NUMBER, 2);
		public static const _3 : KeyCode = new KeyCode(51, "3", __NUMBER, 3);
		public static const _4 : KeyCode = new KeyCode(52, "4", __NUMBER, 4);
		public static const _5 : KeyCode = new KeyCode(53, "5", __NUMBER, 5);
		public static const _6 : KeyCode = new KeyCode(54, "6", __NUMBER, 6);
		public static const _7 : KeyCode = new KeyCode(55, "7", __NUMBER, 7);
		public static const _8 : KeyCode = new KeyCode(56, "8", __NUMBER, 8);
		public static const _9 : KeyCode = new KeyCode(57, "9", __NUMBER, 9);
		///////////////////////////////////////
		public static const COLON : KeyCode = new KeyCode(58, ":", __PUNCTUATION);
		public static const SEMI_COLON : KeyCode = new KeyCode(59, ";", __PUNCTUATION);
		public static const LESS_THAN : KeyCode = new KeyCode(60, "<", __PUNCTUATION);
		public static const EQUALS : KeyCode = new KeyCode(61, "=", __PUNCTUATION);
		public static const GREATER_THAN : KeyCode = new KeyCode(62, ">", __PUNCTUATION);
		public static const QUESTION : KeyCode = new KeyCode(63, "?", __PUNCTUATION);
		public static const AT_SIGN : KeyCode = new KeyCode(64, "@", __PUNCTUATION);

		///////////////////////////////
		public static const A : KeyCode = new KeyCode(65, "A", __LETTER);
		public static const B : KeyCode = new KeyCode(66, "B", __LETTER);
		public static const C : KeyCode = new KeyCode(67, "C", __LETTER);
		public static const D : KeyCode = new KeyCode(68, "D", __LETTER);
		public static const E : KeyCode = new KeyCode(69, "E", __LETTER);
		public static const F : KeyCode = new KeyCode(70, "F", __LETTER);
		public static const G : KeyCode = new KeyCode(71, "G", __LETTER);
		public static const H : KeyCode = new KeyCode(72, "H", __LETTER);
		public static const I : KeyCode = new KeyCode(73, "I", __LETTER);
		public static const J : KeyCode = new KeyCode(74, "J", __LETTER);
		public static const K : KeyCode = new KeyCode(75, "K", __LETTER);
		public static const L : KeyCode = new KeyCode(76, "L", __LETTER);
		public static const M : KeyCode = new KeyCode(77, "M", __LETTER);
		public static const N : KeyCode = new KeyCode(78, "N", __LETTER);
		public static const O : KeyCode = new KeyCode(79, "O", __LETTER);
		public static const P : KeyCode = new KeyCode(80, "P", __LETTER);
		public static const Q : KeyCode = new KeyCode(81, "Q", __LETTER);
		public static const R : KeyCode = new KeyCode(82, "R", __LETTER);
		public static const S : KeyCode = new KeyCode(83, "S", __LETTER);
		public static const T : KeyCode = new KeyCode(84, "T", __LETTER);
		public static const U : KeyCode = new KeyCode(85, "U", __LETTER);
		public static const V : KeyCode = new KeyCode(86, "V", __LETTER);
		public static const W : KeyCode = new KeyCode(87, "W", __LETTER);
		public static const X : KeyCode = new KeyCode(88, "X", __LETTER);
		public static const Y : KeyCode = new KeyCode(89, "Y", __LETTER);
		public static const Z : KeyCode = new KeyCode(90, "Z", __LETTER);
		public static const a : KeyCode = new KeyCode(97, "a", __LETTER);
		public static const b : KeyCode = new KeyCode(98, "b", __LETTER);
		public static const c : KeyCode = new KeyCode(99, "c", __LETTER);
		public static const d : KeyCode = new KeyCode(100, "d", __LETTER);
		public static const e : KeyCode = new KeyCode(101, "e", __LETTER);
		public static const f : KeyCode = new KeyCode(102, "f", __LETTER);
		public static const g : KeyCode = new KeyCode(103, "g", __LETTER);
		public static const h : KeyCode = new KeyCode(104, "h", __LETTER);
		public static const i : KeyCode = new KeyCode(105, "i", __LETTER);
		public static const j : KeyCode = new KeyCode(106, "j", __LETTER);
		public static const k : KeyCode = new KeyCode(107, "k", __LETTER);
		public static const l : KeyCode = new KeyCode(108, "l", __LETTER);
		public static const m : KeyCode = new KeyCode(109, "m", __LETTER);
		public static const n : KeyCode = new KeyCode(110, "n", __LETTER);
		public static const o : KeyCode = new KeyCode(111, "o", __LETTER);
		public static const p : KeyCode = new KeyCode(112, "p", __LETTER);
		public static const q : KeyCode = new KeyCode(113, "q", __LETTER);
		public static const r : KeyCode = new KeyCode(114, "r", __LETTER);
		public static const s : KeyCode = new KeyCode(115, "s", __LETTER);
		public static const t : KeyCode = new KeyCode(116, "t", __LETTER);
		public static const u : KeyCode = new KeyCode(117, "u", __LETTER);
		public static const v : KeyCode = new KeyCode(118, "v", __LETTER);
		public static const w : KeyCode = new KeyCode(119, "w", __LETTER);
		public static const x : KeyCode = new KeyCode(120, "x", __LETTER);
		public static const y : KeyCode = new KeyCode(121, "y", __LETTER);
		public static const z : KeyCode = new KeyCode(122, "z", __LETTER);

		public static const DEL : KeyCode = new KeyCode(127, "DEL", __COMMAND);
		public static const DELETE : KeyCode = new KeyCode(46, "DELETE", __COMMAND);
		
	
		
		public var type : String;
		public var realVal : Object;

		public function KeyCode(enumval : int, name : String, type : String, realval : Object = null) {
			super(CogSignal.SignalUserIDz + enumval, name);
			//trace("new KeyCode " + enumval);
			//trace("Dictionary " + Dictionary);

			type = type;
			realVal = enumval;

			keyMap[enumval] = this;
		}

		public static function parse(intV : Object) : KeyCode {
			var res : KeyCode = KeyCode.keyMap[int(intV)] as KeyCode;
			trace("key " + intV + "= res " + res);
			return res;
		}
	}
}