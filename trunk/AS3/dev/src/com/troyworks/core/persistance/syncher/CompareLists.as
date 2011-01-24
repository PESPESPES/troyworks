package com.troyworks.core.persistance.syncher {

	/*
	 * CompareLists
	 *
	 *  Author: Troy Gardner  
	 * Copyright (c) TroyWorks 2007-2008   http://www.troyworks.com/
	 * Version: 1.0.0  Created:  Dec 17, 2009
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
	 * A utility to help synch/compare two lists of strings looking for whats
	 * changed.
	 * 
	 * Good for comparing a display list with a model
	 */

	public class CompareLists extends Object {
		public var a:Object = new Object();
		public var b:Object = new Object();
		public var result:Object = new Object();
		
		public static var IN_BOTH_LISTS:String = "IN_BOTH_LISTS";
		public static var IN_LIST_A:String = "IN_LIST_A";
		public static var IN_LIST_B:String = "IN_LIST_B";
		public static var IN_NEITHER_LIST:String = "IN_NEITHER_LIST";
		
		public var inAOnly:Array = new Array();
		public var inBOnly :Array = new Array();
		public var inBoth:Array = new Array();
		public var inNeither:Array = new Array();
		
		public function CompareLists() {
			
			
		}
		public function compare(key:String):String{
			var inA:Boolean = a[key];
			var inB:Boolean = b[key];
			var res:String;
			if(inA && inB){
				inBoth.push(key);
				res = IN_BOTH_LISTS;	
			}else if (inA && !inB){
				inAOnly.push(key);
				res = IN_LIST_A;
			}else if (!inA && inB){
				inBOnly.push(key);
				res = IN_LIST_B;
			}else{
				inNeither.push(key);
				res = IN_NEITHER_LIST;
			}
			return res;
		}
	}
}
