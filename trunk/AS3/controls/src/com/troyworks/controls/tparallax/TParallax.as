package com.troyworks.controls.tparallax {
	import flash.display.Sprite;
		
	import flash.display.DisplayObject;
	import flash.display.MovieClip; 
	import flash.display.Sprite; 
	import flash.events.Event; 
	import flash.utils.Dictionary;
	import flash.filters.BlurFilter; 
	/*
	 * TParallax
	 *
	 *  Author: Troy Gardner  
	 * Copyright (c) TroyWorks 2007-2008   http://www.troyworks.com/
	 * Version: 1.0.0  Created:  Dec 22, 2010
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
	 * EXAMPLE
	 * 
	 * import com.troyworks.controls.tparallax.TParallax;
var pc:TParallax  = new TParallax();
pc.setViewport(viewport_mc);  //target bounds for the view
pc.addItem(righthand, 20, 10, false);   
pc.addItem(rightarm, 19, 8, false); 
pc.addItem(lefthand, 18,7, false);
pc.addItem(leftarm, 17, 6, false); 
pc.addItem(hat, 16, 5, false); 
pc.addItem(head, 15, 4, false); 
pc.addItem(torso, 14, 3, false); 

//how fast they move
pc.xrate = 6; 
pc.yrate = 8; 
// how blurry they are
pc.blurXrate = .2;
pc.blurYrate = .2;

//options, HORIZONTAL, BOTH, VERTICAL
pc.mode = ParallaxBox.BOTH; 
pc.blurred = true; 

pc.start(); 
//pc.pause(); // stop the parralax

addEventListener(MouseEvent.CLICK, onClick);
function onClick(evt:Event):void{
righthand.play();
lefthand.play();
}
buttonMode = true;
	 */

	public class TParallax extends Sprite {
		public function TParallax() {
			
		}
		public var back_mc:Sprite;
		// private properties
		private var theObjects:Array; 
		private var theMode:Number;
		private var theState:Number; 
		private var theStarts:Dictionary; 
		
		// user definable properties
		private var _blurred:Boolean = false;
		private var _xrate:Number = 1; 
		private var _yrate:Number = 1; 
		private var _blurXrate:Number = 1.25;
		private var _blurYrate:Number = 1.25;
		private var _autodetect:Boolean = false; 
		
		// public constants for parallax movement
		public static const HORIZONTAL:Number = 1; 
		public static const VERTICAL:Number = 2; 
		public static const BOTH:Number = 3; 
		
		// debug mode (use it to trace errors)
		public static const DEBUG:Boolean = false; 
		
		public function ParallaxBox() {
			theObjects = new Array(); 
			theStarts = new Dictionary(); 
			addEventListener(Event.ADDED_TO_STAGE, init); 
		}
		
		private function init(e:Event):void {
			if (DEBUG) {
				trace("init ok"); 
			}
			theState = 0; 
		}
		
		public function set mode (v:Number):void {
			theMode = v; 
			if (DEBUG) {
				trace("mode selected: " + v); 
			}
		}
		
		public function set xrate (m:Number):void {
			_xrate = m; 
		}
		
		public function set yrate (m:Number):void {
			_yrate = m; 
		}		
		
		public function set blurred (m:Boolean):void {
			_blurred = m; 
		}
		
		public function set blurXrate (m:Number):void {
			_blurXrate = m; 
		}
		public function set blurYrate (m:Number):void {
			_blurYrate = m; 
		}
		public function set autowing (m:Boolean):void {
			_autodetect = m; 
		}
		public function setViewport(back:Sprite):void{
			back_mc = back;
			DisplayObject(back.parent).mask = back_mc;
		}
		
		public function addItem(clip:DisplayObject, wingx:Number, wingy:Number, pixelHinting:Boolean = false):void {
			//var clip:MovieClip = this.getChildByName(s) as MovieClip; 
			theObjects.push( { movie: clip, wingx: wingx, wingy: wingy, startx: clip.x, starty:clip.y, pixelhinting: pixelHinting } ); 
			if (DEBUG) {
				trace("object added to render list: " + clip); 
			}
		}
		
		public function start():void {
			addEventListener(Event.ENTER_FRAME, onFrame); 
		}
		
		public function pause():void {
			removeEventListener(Event.ENTER_FRAME, onFrame); 
		}
		
		private function onFrame(e:Event):void {
			var xP:Number = -(100 / (back_mc.width * .5) * back_mc.mouseX); 
			var yP:Number = -(100 / (back_mc.height * .5) * back_mc.mouseY); 	
			
			var hwing:Number;  
			var vwing:Number;
			
			for (var m:Number = 0; m < theObjects.length; m++) {
				var clip:MovieClip = theObjects[m].movie; 
				
				hwing = theObjects[m].wingx; 
				vwing = theObjects[m].wingy; 
				
				if (_autodetect == true) {
					//hwing = (clip.width * .5) - (stage.stageWidth * .5); 
				}
				
				if (theMode == 1 || theMode == 3) {
					var targetx:Number = theObjects[m].startx + ((hwing / 100) * xP); 
					var xdiff:Number = clip.x - targetx; 
					var xamount:Number = (xdiff / _xrate); 
					var xblur:Number = Math.abs(xamount) * _blurXrate; 
					clip.x -= xdiff / _xrate ; 
					if (theObjects[m].pixelhinting) {
						clip.x = Math.floor(clip.x); 
					}					
				}
				if (theMode == 2 || theMode == 3) {
					var targety:Number = theObjects[m].starty + ((vwing / 100) * yP); 
					var ydiff:Number = clip.y - targety; 
					var yamount:Number = (ydiff / _yrate); 
					var yblur:Number = Math.abs(yamount) * _blurYrate; 
					clip.y -= ydiff / _yrate ; 	
					if (theObjects[m].pixelhinting) {
						clip.y = Math.floor(clip.y); 
					}	
				}
				
				if ((Math.floor(xblur) >= 1 || Math.floor(yblur) >= 1) && _blurred == true) {
					clip.filters = new Array( new BlurFilter(xblur, yblur, 1) ); 
				}						
				
			}
		}
		
	}
	}
}
