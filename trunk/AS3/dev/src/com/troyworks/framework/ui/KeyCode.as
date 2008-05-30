package com.troyworks.framework.ui { 
	import com.troyworks.core.cogs.CogSignal;
	/**
	 * @author Troy Gardner
	 * http://flash-creations.com/notes/asclass_key.php
	 */
	public class KeyCode extends CogSignal{
		//needs to go first
		protected static var map:Object = new Object();
		
		
		public static var __LETTER:String = "LETTER";
		public static var __NUMBER:String = "NUMBER";
		public static var __PUNCTUATION:String = "PUNCTUATION";
		public static var __COMMAND:String = "COMMAND";
	
		public static var TAB:KeyCode = new KeyCode( 9,"TAB", __COMMAND);
		public static var CANCEL:KeyCode = new KeyCode( 24,"CANCEL", __COMMAND);
		public static var ESC:KeyCode = new KeyCode(27,"ESC", __COMMAND);
		public static var SPACE:KeyCode = new KeyCode(32," ", __PUNCTUATION);
		public static var EXCLAMATION:KeyCode = new KeyCode( 33,"!", __PUNCTUATION);
		public static var PARENTHESIS:KeyCode = new KeyCode(34,'"', __PUNCTUATION);
		public static var POUND:KeyCode = new KeyCode(35,"#", __PUNCTUATION);
		public static var DOLLAR:KeyCode = new KeyCode( 36,"$", __PUNCTUATION);
		public static var PERCENT:KeyCode = new KeyCode(37,"%", __PUNCTUATION);
		public static var AMPERSAND:KeyCode = new KeyCode(38,"&", __PUNCTUATION);
		public static var QUOTE:KeyCode = new KeyCode(39,"'", __PUNCTUATION);
		public static var LEFT_SOFT_BRACE:KeyCode = new KeyCode( 40,"(", __PUNCTUATION);
		public static var RIGHT_SOFT_BRACE:KeyCode = new KeyCode(41,")", __PUNCTUATION);
		public static var ASTERISK:KeyCode = new KeyCode(42,"*", __PUNCTUATION);
		public static var PLUS:KeyCode = new KeyCode(43,"+", __PUNCTUATION);
		public static var PLUS2:KeyCode = new KeyCode(187,"+", __PUNCTUATION);
		public static var COMMA:KeyCode = new KeyCode( 44,",", __PUNCTUATION);
		public static var MINUS:KeyCode = new KeyCode(45,"-", __PUNCTUATION);
		public static var MINUS2:KeyCode = new KeyCode(189,"-", __PUNCTUATION);
		public static var PERIOD:KeyCode = new KeyCode(46,".", __PUNCTUATION);
		public static var RIGHT_SLASH:KeyCode = new KeyCode(47,"/", __PUNCTUATION);
	//////////////////////////////////////
		public static var _0:KeyCode = new KeyCode(48,"0", __NUMBER,0);
		public static var _1:KeyCode = new KeyCode(49,"1", __NUMBER,1);
		public static var _2:KeyCode = new KeyCode(50,"2", __NUMBER,2);
		public static var _3:KeyCode = new KeyCode(51,"3", __NUMBER,3);
		public static var _4:KeyCode = new KeyCode(52,"4", __NUMBER,4);
		public static var _5:KeyCode = new KeyCode(53,"5", __NUMBER,5);
		public static var _6:KeyCode = new KeyCode(54,"6", __NUMBER,6);
		public static var _7:KeyCode = new KeyCode(55,"7", __NUMBER,7);
		public static var _8:KeyCode = new KeyCode(56,"8", __NUMBER,8);
		public static var _9:KeyCode = new KeyCode(57,"9", __NUMBER,9);
		///////////////////////////////////////
		public static var COLON:KeyCode = new KeyCode(58,":", __PUNCTUATION);
		public static var SEMI_COLON:KeyCode = new KeyCode(59,";", __PUNCTUATION);
		public static var LESS_THAN:KeyCode = new KeyCode(60,"<", __PUNCTUATION);
		public static var EQUALS:KeyCode = new KeyCode(61,"=", __PUNCTUATION);
		public static var GREATER_THAN:KeyCode = new KeyCode(62,">", __PUNCTUATION);
		public static var QUESTION:KeyCode = new KeyCode(63,"?", __PUNCTUATION);
		public static var AT_SIGN:KeyCode = new KeyCode(64,"@", __PUNCTUATION);
		
		///////////////////////////////
		public static var A:KeyCode = new KeyCode( 65,"A",__LETTER);
		public static var B:KeyCode = new KeyCode(66,"B",__LETTER);
		public static var C:KeyCode = new KeyCode(67,"C",__LETTER);
		public static var D:KeyCode = new KeyCode(68,"D",__LETTER);
		public static var E:KeyCode = new KeyCode(69,"E",__LETTER);
		public static var F:KeyCode = new KeyCode(70,"F",__LETTER);
		public static var G:KeyCode = new KeyCode(71,"G",__LETTER);
		public static var H:KeyCode = new KeyCode(72,"H",__LETTER);
		public static var I:KeyCode = new KeyCode(73,"I",__LETTER);
		public static var J:KeyCode = new KeyCode(74,"J",__LETTER);
		public static var K:KeyCode = new KeyCode(75,"K",__LETTER);
		public static var L:KeyCode = new KeyCode(76,"L",__LETTER);
		public static var M:KeyCode = new KeyCode(77,"M",__LETTER);
		public static var N:KeyCode = new KeyCode(78,"N",__LETTER);
		public static var O:KeyCode = new KeyCode(79,"O",__LETTER);
		public static var P:KeyCode = new KeyCode(80,"P",__LETTER);
		public static var Q:KeyCode = new KeyCode(81,"Q",__LETTER);
		public static var R:KeyCode = new KeyCode(82,"R",__LETTER);
		public static var S:KeyCode = new KeyCode(83,"S",__LETTER);
		public static var T:KeyCode = new KeyCode(84,"T",__LETTER);
		public static var U:KeyCode = new KeyCode(85,"U",__LETTER);
		public static var V:KeyCode = new KeyCode(86,"V",__LETTER);
		public static var W:KeyCode = new KeyCode(87,"W",__LETTER);
		public static var X:KeyCode = new KeyCode(88,"X",__LETTER);
		public static var Y:KeyCode = new KeyCode(89,"Y",__LETTER);
		public static var Z:KeyCode = new KeyCode(90,"Z",__LETTER);
		public static var a:KeyCode = new KeyCode( 97,"a",__LETTER);
		public static var b:KeyCode = new KeyCode(98,"b",__LETTER);
		public static var c:KeyCode = new KeyCode(99,"c",__LETTER);
		public static var d:KeyCode = new KeyCode(100,"d",__LETTER);
		public static var e:KeyCode = new KeyCode(101,"e",__LETTER);
		public static var f:KeyCode = new KeyCode(102,"f",__LETTER);
		public static var g:KeyCode = new KeyCode(103,"g",__LETTER);
		public static var h:KeyCode = new KeyCode(104,"h",__LETTER);
		public static var i:KeyCode = new KeyCode(105,"i",__LETTER);
		public static var j:KeyCode = new KeyCode(106,"j",__LETTER);
		public static var k:KeyCode = new KeyCode(107,"k",__LETTER);
		public static var l:KeyCode = new KeyCode(108,"l",__LETTER);
		public static var m:KeyCode = new KeyCode(109,"m",__LETTER);
		public static var n:KeyCode = new KeyCode(110,"n",__LETTER);
		public static var o:KeyCode = new KeyCode(111,"o",__LETTER);
		public static var p:KeyCode = new KeyCode(112,"p",__LETTER);
		public static var q:KeyCode = new KeyCode(113,"q",__LETTER);
		public static var r:KeyCode = new KeyCode(114,"r",__LETTER);
		public static var s:KeyCode = new KeyCode(115,"s",__LETTER);
		public static var t:KeyCode = new KeyCode(116,"t",__LETTER);
		public static var u:KeyCode = new KeyCode(117,"u",__LETTER);
		public static var v:KeyCode = new KeyCode(118,"v",__LETTER);
		public static var w:KeyCode = new KeyCode(119,"w",__LETTER);
		public static var x:KeyCode = new KeyCode(120,"x",__LETTER);
		public static var y:KeyCode = new KeyCode(121,"y",__LETTER);
		public static var z:KeyCode = new KeyCode(122,"z",__LETTER);
		
		public static var DEL:KeyCode = new KeyCode(127,"DEL", __COMMAND);
	
		public var type:String;
		public var realVal:Object;
		
		public function KeyCode (enumval : int, name : String, type:String, realval:Object = null)
		{
			super (enumval, name);
			type = type;
			realVal = realval;
			//KeyCode._Class = KeyCode;
			//KeyCode._ClassName = "KeyCode";
			var key:String = enumval.toString();
			//trace("ERROR key " + key);
			KeyCode.map[key] = this;
		}
		public static function parse(o:Object):KeyCode{
		//	trace(KeyCode._Class  + " " + KeyCode._ClassName + " KeyCode.parse " + o);
			trace("KeyCode.map " + KeyCode.map);
		/*	for(var i in KeyCode.map){
				trace("value " + i );
			}*/
			var key = o.toString();
			var res = map[key];
			trace("key " + key + "= res " +res);
			return res;
	/*	
	 * 		var n:Number = -1;
			if( typeof(o) == "string"){
				n = parseInt(String(o));
			}else if(typeof(o)== "number"){
				n = Number(o);
			}else {
				return null;
			}
		for(var i in KeyCode){
			//	trace("comparing " + i + " "  + KeyCode[i]);
				var oc =  KeyCode[i];
				if(o ==  oc.value ){
			//		trace("found " + oc);
					return oc;
				}
			}
			return null;*/
		}
	}
}