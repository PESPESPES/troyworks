package com.troyworks.util {
	import com.troyworks.apps.tester.SynchronousTestSuite;

	/*
	 * Test_XORcipher
	 *
	 *  Author: Troy Gardner  
	 * Copyright (c) TroyWorks 2007-2008   http://www.troyworks.com/
	 * Version: 1.0.0  Created:  Oct 11, 2009
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

	public class Test_XORcipher extends SynchronousTestSuite {

		public function Test_XORcipher() {
			super();
		}
		public function test_randKey():Boolean{
			var res : Boolean = true;
			var key:String = XORcipher.generateRandomKey(5);
			trace("5 key " + key);
			res = (key.length ==5);
			return res;
		}

		public function test_xorString() : Boolean {
			var res : Boolean = true;
			var xor:XORcipher = new XORcipher("123456789");
			var ins:String = "hello world";
			var xord:String = xor.xor_escape(ins);
			trace("XORD " + xord);
			var xord2:String = xor.xor_unescape(xord);
			trace("XORD2 " + xord2);
			res = (xord2 == xord);
			return res;
		}
	}
}
