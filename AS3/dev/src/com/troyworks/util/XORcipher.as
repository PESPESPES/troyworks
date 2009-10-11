package com.troyworks.util {

	/*
	 * XORCipher
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
	 * 
	 * Inspired by http://blog.dannypatterson.com/?p=135
	 */


	public class XORcipher {

		public var KEY : String;

		public function XORcipher(xorKEY : String) {
			KEY = xorKEY;
		}


		public static function generateRandomKey( length:int,charsToUse:String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz"):String{
			var res:Array = new Array();
			var i:int;
			while(length--){
				i = Math.floor(Math.random() * charsToUse.length);
				res.push(charsToUse.charAt(i));
			}
			return res.join("");
			
		}

		public function xor_escape(source : String) : String {
			  return escape(xor(source));
		}
		public function xor_unescape(source : String) : String {
			return xor(unescape(source));
		}
		
		public function xor(source : String) : String {
			var result : Array = new Array();
			var kl : int = KEY.length;
			
			var fn:Function = String.fromCharCode;
			var i : int = 0;
			var n : int = source.length;
			
			for (;i < n; ++i) {
				result.push(fn(source.charCodeAt(i) ^ KEY.charCodeAt(i %kl)));
			}
			return result.join("");
		}
	}
}
