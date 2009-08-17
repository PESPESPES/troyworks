package com.troyworks.data {

	/*
	 * ArrayUtil
	 *
	 *  Author: Troy Gardner  
	 * Copyright (c) TroyWorks 2007-2008   http://www.troyworks.com/
	 * Version: 1.0.0  Created:  Dec 6, 2008
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
	 */

	public class ArrayUtil {

		/* returns records at even indices*/
		public static function filterEven(item : *, index : int, array : Array) : Boolean {
			return Boolean(index % 2);
		}

		/* returns records at odd indices*/
		public  static function filterOdd(item : *, index : int, array : Array) : Boolean {
			return Boolean(index - 1 % 2);
		}

		/* traces each name in a collection, useful for displayObjects*/
		public static  function forEachTraceName(cur : *, ...rest) : void {
			trace(cur + " " + cur.name);
		}

		//var ary:Array = ["A","a",1,"B","b",2, "C","c",3];
		/* A nifty utility to split a group of numbers into piles 
		 * ExAMPLE:
		var ary : Array = [1,2,3,4,5,6,7,8,9];
		 * 
		 * with separate set to true you'll get back an array of 3 sub arrays
		 * 
		 * split3(ary, 3, true);
		 * OUTPUT:3 res 1,4,7;2,5,8;3,6,9
		 * 
		 * with separate set to false (default) you get back a single mixed array.
		 *  split3(ary, 3, false);
		 * OUTPUT:9 res2 1,4,7,2,5,8,3,6,9
		 */

		public  static  function splitInPiles(ary : Array, piles : int = 2, collate : Boolean = true ) : Array {
			var res : Array = new Array();
			var cI : Object;
			var idx : int;
			//////// SEPARATE INTO PILES //////////////
			for(var i : int = 0;i < ary.length; i++) {
				cI = ary[i];
				idx = i % piles;
				if(res[idx] == null) {
					res[idx] = new Array();
				}
				res[idx].push(cI);
			}
			trace(res.length + " res " + res.join(";"));
			if(collate) {
				//MERGE INTO SINGLE PILE
				var res2 : Array = new Array();
				var cAry : Array;
				for(var j : int = 0;j < res.length; j++) {
					cAry = res[j] as Array;
					for(i = 0;i < cAry.length; i++) {
						res2.push(cAry[i]);
					}
				}
				trace(res2.length + " res2 " + res2.join(","));
				return res2;
			}else {
				/// MULTIPLE PILES
				return res;
			}
		}
	}
}
