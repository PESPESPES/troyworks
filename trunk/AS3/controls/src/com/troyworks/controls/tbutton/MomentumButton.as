package com.troyworks.controls.tbutton {
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.media.SoundChannel;

	/*
	 * MomentumButton
	 *
	 *  Author: Troy Gardner  
	 * Copyright (c) TroyWorks 2007-2008   http://www.troyworks.com/
	 * Version: 1.0.0  Created:  Nov 6, 2011
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

	public class MomentumButton extends EventDispatcher {
		public var direct : String = "forward";
		public var _channel : SoundChannel;
		public var bnds : Rectangle ;

		public var upFrame : Number;
		public var overFrame : Number;
		public var downFrame : Number;
		public var mouseIsDown : Boolean = false;
		public var view : MovieClip;
		public var disabledFilt : Array;
		public var data : Object;
		public var label : String = "LABEL";

		public function MomentumButton(view : MovieClip, disabledFilters : Array) {
			super();
			this.view = view;
			if(this.view.stage != null) {
				onAdded();
			}
			disabledFilt = disabledFilters;
		}

		public function onAdded() : void {
			bnds = view.getBounds(view.parent);
			view.buttonMode = true;
			view.mouseChildren = false;
			view.addEventListener(Event.ENTER_FRAME, onENTER_FRAME);
			view.addEventListener(MouseEvent.MOUSE_DOWN, onMOUSE_DOWN);
			view.addEventListener(MouseEvent.CLICK, onRELAY);
			view.addEventListener(MouseEvent.ROLL_OUT, onRELAY);
			view.addEventListener(MouseEvent.ROLL_OVER, onRELAY);

			view.stage.addEventListener(MouseEvent.MOUSE_UP, onMOUSE_UP);
			
			for (var i : int = 0;i < view.currentLabels.length;i++) {
				var nm : String = view.currentLabels[i].name;
				var fn : Number = view.currentLabels[i].frame;
				if (nm == "up") {
					upFrame = fn;
				} else if (nm == "over") {
					overFrame = fn;
				} else if (nm == "down") {
					downFrame = fn;
				}
			}
			trace("upframe " + upFrame + " " + overFrame + " " + downFrame);
		}

		public function onRELAY(evt : Event) : void {
			dispatchEvent(evt);
		}

		public function onMOUSE_DOWN(evt : Event) : void {
			trace("onMOUSE_DOWN");
			mouseIsDown = true;
		}

		public function onMOUSE_UP(evt : Event) : void {
			trace("onMOUSE_UP");
			mouseIsDown = false;
		}

		/**
		 * Overides the setter method of its enabled property
		 * @param  value	Boolean true or false 
		 */
		public function set enabled(value : Boolean) : void {
			//super.enabled = value;
			// hide or enable mouse events			
			view.mouseEnabled = value;
			// With mouseEnabled = false you'll have only one state named "upState".
			// Use this state for setting the new states called "enabledState" or "disabledState" ;-)
			view.filters = (value) ? [] : disabledFilt;
		}

		
		public function onENTER_FRAME(evt : Event) : void {
			var mc : MovieClip = view;
			var stpFrame : Number;
			//trace( bnds + " " + mc.mouseX + " " + mc.mouseY);
			if (bnds.containsPoint(new Point(view.parent.mouseX, view.parent.mouseY)) && view.mouseEnabled) {
				//trace("fast forward");
				if (mouseIsDown) {
					//mouse is over
					if (mc.currentFrame < downFrame) {
						mc.nextFrame();
					} else {
						if (_channel != null) {
							_channel.stop();
						}
						mc.stop();
					}
					if (direct != "forward") {
						if (_channel != null) {
							_channel.stop();//UNCOMMENT ME TO STOP THE PREVIOUS PLAYING TRACK
					//s.load(); //won't work with progressive
					//s.close(); //won't work with progressive
						}
						//_channel = rover.play();
						direct = "forward";
					}
				
				} else {
					//mouse is over
					if (mc.currentFrame < overFrame) {
						mc.nextFrame();
					} else if (mc.currentFrame > overFrame) {
						mc.prevFrame();
				
					} else {
						if (_channel != null) {
							_channel.stop();
						}
					}
					if (direct != "forward") {
						if (_channel != null) {
							_channel.stop();//UNCOMMENT ME TO STOP THE PREVIOUS PLAYING TRACK
					//s.load(); //won't work with progressive
					//s.close(); //won't work with progressive
						}
						//_channel = rover.play();
						direct = "forward";
					}
				}
			} else {
				//trace("rewinding " + mouseIsDown);
				/*if (buttontray_mc.redgreen_mc.currentFrame != 1) {
		
				buttontray_mc.redgreen_mc.gotoAndStop(1);
				}*/
				stpFrame = (mouseIsDown) ? overFrame : upFrame;
				if (mc.currentFrame > stpFrame) {
					mc.prevFrame();
				} else {
					if (_channel != null) {
						_channel.stop();
					}
					mc.stop();
				}
				if (direct != "rewind") {
					if (_channel != null) {
						_channel.stop();//UNCOMMENT ME TO STOP THE PREVIOUS PLAYING TRACK
				//s.load(); //won't work with progressive
				//s.close(); //won't work with progressive
					}
					//_channel = rout.play();
					direct = "rewind";
				}
			}
			updateLabel();
		}

		private function updateLabel() : void {
			if(view.label_txt ) {
				if(view.label_txt.text != label) {
					trace("setting lable2 " + view.label_txt.text  + " to "  + label);
					view.label_txt.text = label;
				}
			}
		}
	}
}
