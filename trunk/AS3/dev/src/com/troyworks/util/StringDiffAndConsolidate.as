package com.troyworks.util{
	import flash.text.TextField;
	import flash.display.Sprite;

	/*
	 * StringDiff2
	 *
	 *  Author: Troy Gardner  
	 * Copyright (c) TroyWorks 2007-2008   http://www.troyworks.com/
	 * Version: 1.0.0  Created:  Feb 18, 2012
	 * 
	 * License Agreement
	 * 
	 * Permission is hereby granted, free of charge, to any person obtaining a copy
	 * of this software and associated documentation files (the "Software"), to deal
	 * in the Software without restriction, including without limitation the rights
	 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	 * copies of the Software, and to permit persons to whom the Software is
	 * furnished to do so, subject to the following conditions:
	 * 
	 * The above copyright notice and this permission notice shall be included in
	 * all copies or substantial portions of the Software.
	 * 
	 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	 * THE SOFTWARE.
	 *
	 * DESCRIPTION
	 * 
	 * This takes 2 strings typically html 
	 * 0) splits/tokenizes them (ignoring html tags) into words+whitespace
	 * 1) compares/contrasts the tokens,  finding just what's in A, what's in B, what's common 
	 * 2) reconsolidates the common to find longest phrase 
	 * 
	 * 
	 * EXAMPLE
	 * INPUT:
	 *   A: mary had a little lamb
	 *   B: a little lamb who' fleece was white as snow.
	 *   
	 *  VENN SPACE: [mary had (a little lamb] who's fleece was white as snow)
	 *    so that outputs segments an cut points for A and B
	 *    0:"mary had " <-note space
	 *    1:"a little lamb " <-note space
	 *    2:"who's fleece was white as snow"
	 *    
	 *   This is stored in the Asegs and Bsegs properties.
	 *    
	 * This is heavily useful for kinetic typography morphing textframes/states
	 * even if they don't really need to be morphed.
	 */
	public class StringDiffAndConsolidate extends Sprite {
		public var WHITESPACE : String = " \r\t\n";
		public	var onlyInStateA : Object = new Object();
		public	var onlyInStateB : Object = new Object();
		public	var inBothAandB : Object = new Object();
		public	var inBothAandB_consolidated : Object = new Object();
		public var consolidatedPhrases : Array = new Array();
		public var A : Object;
		public var Astr:String;
		public var Aary:Array;
		public var Asegs:Array;
		public var B : Object;
		public var Bary:Array;
		public var Bstr:String;
		public var Bsegs:Array;
		
		public function StringDiffAndConsolidate(strA : String, strB : String) {
			super();
			trace("=========STRING DIF=============");
	//		 = "generating a <b>full time income</b>\r<font size='50'>from home</font> anywhere";
	//		var strB : String = "generating a <b>full time income</b>\r<i>in their spare time</i> <font size='50'>from home</font>";
		

			// tftokenize(strA);
			var res : Array;
			res = tokenizeToWords(strA);
			 A = res[0];
			 Aary =res[1]; 
			 Astr = Aary.join(" ");
			trace("'"+Aary.join(",") + "'         " + Astr);
			
			res = tokenizeToWords(strB);
			B = res[0];
			Bary = res[1];
			Bstr = Bary.join(" ");
			trace("'"+Bary.join(",") + "'          " + Bstr);
			
			// once parsed //
			compare(A, B);
			report();
			commonConsolidate();
			Asegs = resplit(Astr);
			Bsegs = resplit(Bstr);
		}

		// generating a full time incomefrom home anywhere
		public function tftokenize(str : String) : Object {
			var tf : TextField = new TextField();
			tf.htmlText = str;
			trace(tf.text);
			return null;
		}

		public function tokenizeToWords(str : String) : Array {
			var res : Object = new Object();
			var wordr : Array = new Array();

			var word : Array = new Array();
			var ch : String;
			str = str.split("<br/>").join("\r");
			var len : int = str.length;
			var intag : int = 0;
			for (var i : int = 0; i < len + 1; i++) {
				ch = str.charAt(i);
				// trace(i + " " + ch  + " " + intag);
				if ( WHITESPACE.indexOf(ch) == -1 || intag > 0) {
					// word continuing
					if (ch == "<") {
						intag++;
					} else if (intag > 0 && ch == ">") {
						intag--;
					} else if (intag == 0) {
						word.push(ch);
					}
				} else {
					// trace("--break--");
					// break in token
					//	word.push(ch);
					var wrd : String = word.join("");
					wordr.push(wrd);
					if (res[wrd] == null) {
						res[wrd] = wordr.length;
						// word order, first occurance
					}
					word = new Array();
				}
			}
			return [res, wordr];
		}

		public function compare(A : Object, B : Object) : void {
			onlyInStateA = new Object();
			onlyInStateB = new Object();
			inBothAandB = new Object();

			var e : String;
			// trace("----------A-------------");
			for (e in A) {
				// trace(e + " " + (btextSplit.textIndex[e] != null));
				if (B[e] != null) {
					// trace(e + " BOTH ");
					inBothAandB[e] = [A[e]];
				} else {
					// trace(e + " IN ONLY A ");
					onlyInStateA[e] = A[e];
				}
			}
			// trace("----------B-------------");
			for (e in B) {
				if (A[e] != null) {
					// trace(e + " IN BOTH "); // already got these.
					inBothAandB[e].push(B[e]);
				} else {
					// trace(e + " IN ONLY B ");
					onlyInStateB[e] = B[e];
				}
			}
		}

		public function report() : void {
			var e : String;
			trace("----------A-------------");
			for (e in onlyInStateA) {
				trace(e + " ONLY IN A");
			}
			trace("----------B-------------");
			for (e in onlyInStateB) {
				trace(e + " ONLY IN B");
			}
			trace("----------C-------------");
			for (e in inBothAandB) {
				trace(e + " IN A and B");
			}
		}

		public function commonConsolidate() : void {
			trace("----------commonConsolidate-------------");
			var e : String;
			// var earliest
			var todo : Object = new Object();
			var sort : Array = new Array();
			for (e in inBothAandB) {
				var ary : Array = inBothAandB[e];
				trace(e + " IN A and B " + ary[0] + "  " + ary[1]);
				todo[e] = inBothAandB[e];
				sort.push({rankA:ary[0], key:e, rankB:ary[1]});
			}
			sort.sortOn("rankA", Array.NUMERIC);
			trace("--------rank-------------");
			var ai : int = 0;
			var bi : int = 0;
			var startA : int = NaN;
			var startB : int = NaN;
			var endA : int = NaN;
			var endB : int = NaN;
			var phrase : Array = new Array();

			

			for (var i : int = 0; i < sort.length + 1; i++) {
				// trace(sort[i].rankA + " " + sort[i].key);
				var cs : Object = (i < sort.length) ? sort[i] : null;
				if (cs != null && cs.rankA == (ai + 1) && cs.rankB == (bi + 1)) {
					phrase.push(cs.key);
				} else {
					// new phrase
					endA = ai;
					endB = bi;
					consolidatedPhrases.push({key:phrase.join(" "), startA:startA, startB:startB, endA:endA, endB:endB});
					trace(phrase.join(" "));
					if (cs != null) {
						phrase = new Array();
						phrase.push(cs.key);
						startA = cs.rankA;
						startB = cs.rankB;
						endA = NaN;
					endB = NaN;
					}
				}
				if (cs != null) {
					ai = cs.rankA;
					bi = cs.rankB;
				}
			}
			trace("------------- consolidated -------------------");
			for (var j : int = 0; j < consolidatedPhrases.length; j++) {
				var obj:Object =consolidatedPhrases[j]; 
				trace(obj.key, obj.startA, obj.startB,obj.endA,obj.endB);
			}
		}
		public function resplit(str:String):Array{
			var res:Array = new Array();
			var tmp:Array;
			trace("------------- resplit -------------------");
			var cuts:Array = new Array();
			cuts.push(0);
			var ci:int = 0;
			var c2:int= 0;
			for (var j : int = 0; j < consolidatedPhrases.length; j++) {
				var obj:Object =consolidatedPhrases[j];
				ci = str.indexOf(obj.key, ci);
				if(ci != 0 && ci != cuts[cuts.length-1]){
				//	trace("Pushing cut " + ci);
					cuts.push(ci);
				}
				c2 = Math.min(ci+ obj.key.length, str.length);
				cuts.push(c2);
			//	trace("Pushing cut2 " + cuts[cuts.length-1]);
			}
			if(cuts[cuts.length-1] != str.length){
				trace("adding trailing cut " + str.length);
				cuts.push(str.length);
			}
			
			//trace("found new cuts " + cuts.join(","));
			var seg:String;
			for (var i : int = 0; i < cuts.length-1; i++) {
				var s:int = cuts[i];
				var b:int = cuts[i+1];
				
				seg = str.substring(s,b);
				res.push(seg);
				trace(i + " '" + seg + "'  " + s + " " + b);
			}
			return res;
		}
	}
}