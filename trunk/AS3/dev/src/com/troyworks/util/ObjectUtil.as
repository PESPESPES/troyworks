package com.troyworks.util {

	/*
	 * ObjectUtil
	 *
	 *  Author: Troy Gardner  
	 * Copyright (c) TroyWorks 2007-2008   http://www.troyworks.com/
	 * Version: 1.0.0  Created:  Jun 20, 2009
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

	public class ObjectUtil {

		/*
		 * A utility method for comparing key value pairs to find differences
		 * SAMPLE CODE
		  var A:Object = new Object();
			A["a"] = "someA";
			A["b"] = "someB";
			A["c"] ="someC";


			var B:Object = new Object();
			B["d"] = "someD";
			B["b"] = "someB";
			B["c"] ="someCC";
			compareTwo(A, B);
	// OUTPUTS:

		key only in A (remove)
		a
		key only in B (add)
		d
		key in A and B (update)
		b and same? true
		c and same? false */

		function compareTwo(a : Object, b : Object) : void {
			var konlyInA : Object = new Object();
			var konlyInB : Object = new Object();
			var kinBoth : Object = new Object();
			var i : String;
			var o : Object;
			for (i in a) {
				//res.push("  " + i + " = " + a[i]);
				if(b[i] == undefined) {
					konlyInA[i] = true;
				} else {
					kinBoth[i] = b[i] == a[i];
				}
			}
			for (i in b) {
				//res.push("  " + i + " = " + a[i]);
				if(a[i] == undefined) {
					konlyInB[i] = true;
				}
			}
			//////////TRACE //////////////
			o = konlyInA;
			trace("key only in A (remove)");
			for (i in o) {
				trace("  " + i);
		//res.push("  " + i + " = " + a[i]);
			}
	
			o = konlyInB;
			trace("key only in B (add)");
			for (i in o) {
				trace("  " + i);
		//res.push("  " + i + " = " + a[i]);
			}
			o = kinBoth;
			trace("key in A and B (update)");
			for (i in o) {
				trace("  " + i + " and same? " + o[i]);
		//res.push("  " + i + " = " + a[i]);
			}
		}
	}
}
