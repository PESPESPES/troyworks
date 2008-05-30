package com.troyworks.autocomplete { 
	/**
	 * @author Troy Gardner
	 */
	public class WordMatch {
	
		protected var wlist : WordComplete;
		public var cn : KeyNode;
	
		public var qs : String;
		public var DEBUG_TRACES_ON:Boolean = false;
		//////////////////////////////////////////////////
		public function WordMatch(wordlist : WordComplete) {
			wlist = wordlist;
		// current node
			cn = wlist.rootN;
		// the query string
			qs = null;
		};
		public function start() : void {
			cn = wlist.rootN;
		};
		public function reset() : void {
			cn = wlist.rootN;
		};
		public function addCharacter(c : String) : void {
		trace("adding char '"+c+"' to query string ");
		if (qs == null) {
				qs = c;
		} else {
				qs = qs+c;
		}
		//trace(" new qs "+qs);
			cn = cn.children[c];
		};
		public function removeCharacter() : void {
			qs = qs;
			cn = cn.parent;
		};
		public function getCurrentExactMatch():String{
			return cn.em;
		}
		public function getCurrentExactMatches():Array{
			return cn.pm;
		}
		public function toString():String{
			var res:String = "'" + qs + "'  matches: em:" + cn.em[0] + " pm:" + cn.pm[1]  ;
			return res;
		}
		public function getMatches(optionalQueryString : String) : Array {
	//	trace("public function getMatches "+cn.pm);
		if (optionalQueryString != null) {
				qs = "";
				var _array :Array= optionalQueryString.split("");
			//trace(_array);
				start();
				for (var i:Number = 0; i<_array.length; i++) {
					var c:String = _array[i];
				if (c == null) {
						break;
				}
				//trim from beginning
					addCharacter(c);
			}
		}
			var res:Array = new Array(2);
			res[0] = cn.em;
			res[1] = cn.pm;
			return res;
		};	
	}
}