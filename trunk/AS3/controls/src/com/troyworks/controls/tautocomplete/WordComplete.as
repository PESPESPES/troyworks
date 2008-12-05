package com.troyworks.controls.tautocomplete { 

	/**
	 * @author Troy Gardner
	 */
	public class WordComplete {
	
		public var words_array : Array;
	
		public var rootN : KeyNode;
	
		/*
		 * 	var _ary = new Array();
		_ary.push("a1 word");
		_ary.push("a2 word");
		_ary.push("a2b word");
		_ary.push("a2c word");
		_ary.push("a3");
		_ary.push("b1 word");
		_ary.push("b2 word");
		_ary.push("b3 word");
		 */
		// when rootNed it should be 
		/* 
		///when in putting a character a it should return all words
		root: should return children upto depth (?) viewable from that point in the a tree
		cur, nextchar 
		 V  V
		[0][1][2] returns
		 a*      [0,1,2,3,4,5]
		   1*    [1]
		   2*    [2,4,5]
		     b   [4]
			 c   [5]
		   3     [6]
		 b*      [7,8,9]
		   1*    [7]
		   2*    [8]
		   3*    [9]
		   
		   
		     [exact match], [other documents starting with]
		 a*  [][0,1,2,3,4,5] <notice if this can be gotten it should be easy to show probability
		 a1* [][1]
		 a2* [][2,4,5]
		 a2b [][4]
		 a2c [][5]
		 a3  [6][]
		 b*  [][7,8,9]
		 b1* [][7]
		 b2* [][8]
		 b3* [][9]
		 
		 
		 one possible algorithm is to rootN a word by every character
		 
		 e.g, convert phrase into a array of characters. e.g."Hello World"
		 rootN like
		 H
		 He
		 Hel
		 Hell
		 Hello
		 Hello_
		 Hello_W
		 Hello_Wo
		 Hello_Wor
		 Hello_Worl
		 Hello_World
		 
		 the longer the word or phrase the more dense the rootN would become. 
		 if character are likended to numbers this might be analogous to
		 
		 400000000
		 410000000
		 411000000
		....
		
		and easily stored in a b+ tree
		but this would require the maximum size of entire rootN known.
		*/
		
		//////////////////////////////////////////////
		public function WordComplete() {
			words_array = new Array();
			// if root node doesn't exist create it
			rootN = new KeyNode();
			rootN.pm = words_array;
		};
		public function addWordToDictionary (words:Object):void {
			if (words is Array) {
				//trace(" is an array ");
				for (var i:String in words) {
					m_addWordToDictionary(words[i]);
				}
			} else if (typeof (words) == "string") {
				//trace(" is a string ");
				m_addWordToDictionary(String(words));
			} else {
				//trace(" not adding "+words);
			}
		};
		public function m_addWordToDictionary (word:String):void{
			//////////////////////////////
			// add to global dictionary
			trace("\\\\\\\\\\\\\\\\ adding word '"+word+"'");
			var wordID:Number = words_array.length;
			words_array[wordID] = word;
			trace("word ID "+wordID);
			//trace(words_array);
			//////////////////////////////
			// split the word in to characters and add
			// them to the tree.
			//ToDo: type check to make string
			var char_ary:Array = word.split("");
			//trace(char_ary);
			//get root node. 
			var cnode:KeyNode= rootN;
			var i:Number = char_ary.length;
			var lk:String = "root";
			//add child for first element, add pointer to word.
			while (i) {
				var ky:String = String(char_ary.shift());
				i--;
				trace(i+" adding '"+ky+"' below "+lk);
				var kn:KeyNode = cnode.children[ky];
				if (kn == null) {
					trace(" create node '"+ky+"'");
					kn = new KeyNode();
					kn.parent = cnode;
					cnode.children[ky] = kn;
				}
				//add payload to current node.
				if (char_ary.length == 0) {
					trace(ky+" exact match of '"+words_array[wordID]+"'");
					kn.em = words_array[wordID];
				} else {
					trace(ky+" possible match of '"+words_array[wordID]+"'");
					kn.pm.push(words_array[wordID]);
				}
				// make this the current node to add below it.
				cnode = kn;
				lk = ky;
			}
			//get that node
			//goto next rootN
			// add that child to 
		};
		public function toString():String{
			var res:Array = new Array();
			res.push(rootN.toString());
			return res.join("\r");
		}
	}
}