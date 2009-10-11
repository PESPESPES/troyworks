package com.troyworks.controls.tcookie {
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;		

	/*
	 * TCookieUser
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

	public class TCookieUser extends Sprite {



		private var _loader : Loader;
		private var cookieJarMC : MovieClip;
		public var cookieJarAccessible : Boolean = false;
		public var jarconfig:TCookieConfig = new TCookieConfig();
		public function TCookieUser() {
			loadCookieJar();
		}

		private function loadCookieJar() :void{

			/////////////////////////////////////
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCookieJarLoaded);
			var request : URLRequest = new URLRequest(jarconfig.COOKIE_JAR_URL);
			_loader.load(request);

	// addChild(_loader);
		}

		
		private function onCookieJarLoaded(event : Event) : void {
			trace("completeHandler: " + event);
			cookieJarMC = MovieClip(Loader(event.target.loader).content);
			//addChild(mc);
			cookieJarAccessible = true;
			trace("Retrieved Cookie ID: 1" + cookieJarMC.mySO);
			trace("Retrieved Cookie ID: 2" + cookieJarMC.mySO.data);
			trace("Retrieved Cookie ID: 3" + cookieJarMC.mySO.data.downloadVars);
			trace("Retrieved Cookie ID: 4 " + cookieJarMC.mySO.data.downloadVars.EmailAddress);
	
			for each(var e:String in cookieJarMC.mySO.data.downloadVars) {
				trace("found " + e + " " + cookieJarMC.mySO.data.downloadVars[e]);
			}
		}
	}
}
