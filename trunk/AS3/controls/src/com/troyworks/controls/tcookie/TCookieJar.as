package com.troyworks.controls.tcookie {
	import flash.system.System;	
	import flash.net.SharedObject;	
	import flash.display.Sprite;

	/*
	 * TCookieJar
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

	public class TCookieJar extends Sprite {
		public var mySO : SharedObject;
		public var jarconfig : TCookieConfig = new TCookieConfig();

		public function TCookieJar() {
			//PROVIDER ///////////////

			trace("CookieProvider");
			// Does this client allow sharedobjects to be stored?
			// Create a dummy SO and try to store it

			try {
				mySO = SharedObject.getLocal("tmp");
				if (!mySO.flush(1)) {
					// SOs not allowed on this system!
					// Prompt user to change settings
				//	System.showSettings(1);
					
				} else {
					// SOs allowed
					trace("Your system allows sharedobjects");
					mySO = SharedObject.getLocal(jarconfig.COOKIE_JAR_DOMAIN, jarconfig.COOKIE_JAR_PATH);
					//returns so == null if the previous line failed.
					trace("Retrieved SO? " + mySO + "\r " + mySO.data.downloadVars);
				}
			} catch (er : Error) {
				trace("error retrieving SO");
			}			
		}

		function createSOCookie(name : String,value : Object,days : int) : Boolean {
			if(mySO && mySO[name]){
				return mySO[name];
			}else{
				return null;
			}
		}

		function readSOCookie(name : String) : * {
			if(mySO && mySO[name]){
				return mySO[name];
			}else{
				return null;
			}
		}

		function eraseSOCookie(name : String) : Boolean {
			if(mySO && mySO[name]){
				 delete(mySO[name]);
				return true;
			}else{
				return false;
			}
		} 
	}
}
