package com.troyworks.controls.tautocomplete { 

	/**
	 * Used by WordComplete to store the tree
	 * 
	 * @author Troy Gardner
	 */
	public class KeyNode {
			/*this is the singular match for a given phrase*/
		public var em : String;
	
	/*partial matches */
		public var pm : Array;
	
		public var parent : KeyNode;
		/* these are child nodes possible terms that also match */
		public var children : Object;
		
		public function KeyNode() {
	
			this.em = null;
			this.pm = new Array();
			this.parent = null;
			this.children = new Object();
		};
		public function toString():String{
			var res:Array = new Array();
			res.push(em);
			for (var i : String in children) {
			  var v:KeyNode = KeyNode(children[i]);
				res.push("\t" + i );
				res.push(v.toString());
			}
			return res.join("\r");
		}
	}
}