package com.troyworks.controls.tkoosh {
	import flash.filters.DropShadowFilter;
	import flash.utils.setInterval;
	import flash.utils.clearTimeout;
	import flash.utils.clearInterval;
	import flash.utils.setTimeout;
	import com.troyworks.core.tweeny.Circ;
	import com.troyworks.core.tweeny.Elastic;
	import flash.display.Shape;

	import com.troyworks.core.tweeny.Tny;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;

	/*
	 * TKoosh
	 *
	 *  Author: Troy Gardner  
	 * Copyright (c) TroyWorks 2007-2008   http://www.troyworks.com/
	 * Version: 1.0.0  Created:  Feb 13, 2010
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
	 * AS3 port of Don Hopkins Koosh for OpenLazlo,
	 * which was based on Based on the original kooshtool for NeWS.
	 * http://www.donhopkins.com/lzxnet/my-apps/kooshballs.lzx?lzt=source
	 * 
	 * now with drop shadows.
	 */

	public class TKoosh extends Sprite {
		public var startX : Number = 0;
		public var startY : Number = 0;
		public var hue : Number = 0.0;
		public var wiggle : Number = 100.0;
		public var speed : Number = .8;
		public var fronds : Number = 2;
		public var radius : Number = 6.0;
		public var multicolor : Boolean = false;
		public var kooshing : Boolean = false;
		public var tnys : Array = new Array();
		private var intV : uint;
		public var curKoosh:Sprite;

		public function TKoosh() {
			trace("new TKoosh");
			//graphics.beginFill(0xc0c0c0);
			//graphics.drawRect(0, 0, 800, 800);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMOUSE_DOWN);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMOUSE_UP);
		} 

		private function onMOUSE_DOWN(evt : Event = null) : void {
			trace("onMOUSE_DOWN");
			startX = mouseX;
			startY = mouseY;
			kooshing = true;
			curKoosh = new Sprite();
			addChild(curKoosh);
			hue = Math.random() * 360;
			multicolor = (Math.random() < 0.2);
            intV = setInterval(onIdle, 100);
            			
		}

		private function onIdle() : void {
			if(!kooshing) {
				return;
			}
			var i : int;
			for(i = 0;i < fronds;i++) {
				makeFrond(startX, startY, mouseX, mouseY, i);
			}
		}

		private function onMOUSE_UP(evt : Event = null) : void {
			trace("onMOUSE_UP");
			kooshing = false;
			clearInterval(intV);
			var curTny : Tny;
			curTny = new Tny(this);
			curTny.target = curKoosh; 
			curTny.x = curKoosh.x + (50* Math.random()-25);
			curTny.y = curKoosh.y + (50* Math.random()-25);
		//	curTny.addProps("rotation")
		//	curTny.rotation =360* Math.random();
			curTny.ease =  Circ.easeOut; 
			curTny.duration = 2;
		}

		
		private function makeFrond(centerX : Number, centerY : Number, curX : Number, curY : Number, cnt : Number) : void {
			trace("makeFrond ");
			var h : Number = (this.multicolor ? (Math.random() * 360.0) : this.hue);
			var s : Number = (0.7 * Math.sqrt(Math.random())) + 0.3;
			var v : Number = (0.7 * Math.sqrt(Math.random())) + 0.3;
			var color : Number = this.hsvToColor(h, s, v);

			var dx : Number = curX - centerX;
			var dy : Number = curY - centerY;

			curX += (Math.random() * this.wiggle) - (this.wiggle / 2.0);
			curY += (Math.random() * this.wiggle) - (this.wiggle / 2.0);

			dx = curX - centerX;
			dy = curY - centerY;
			if ((dx == 0) && (dy == 0)) {
				dx = 1.0;
			} // if

			var len : Number = Math.sqrt((dx * dx) + (dy * dy));

			var rotRad : Number = Math.atan2(dy, dx);

			var rotDeg : Number = ((rotRad / (2.0 * Math.PI)) * 360.0);

			var xx : Number = dx / len;
			var yy : Number = dy / len;
			var xxx : Number = (yy * this.radius);
			var yyy : Number = (-xx * this.radius);

			var frond : Sprite = new Sprite();
			
			var canvas : Sprite = new Sprite();
			frond.addChild(canvas);
			curKoosh.addChild(frond);
			frond.filters = [ new DropShadowFilter()];
			var curTny : Tny;
			
			curTny = new Tny(this);
			tnys.push(curTny);
			canvas.graphics.beginFill(color);
			canvas.graphics.drawRect(0, 0, len, this.radius * 2.0);
			canvas.graphics.endFill();
			frond.x = centerX + xxx;
			frond.y = centerY + yyy;
			canvas.width = 1;
			frond.rotation = rotDeg;
			curTny.target = canvas;
			curTny.scaleX = 1;
			curTny.scaleY = 1;
			curTny.ease =  Circ.easeOut; 
			//curTny.onComplete = onIdle;
			curTny.duration = speed;
			//		frond.animate("width", len, this.speed, false);
			//	frond.height = this.radius * 2.0;
		}

		
		private function hsvToColor(h : Number, s : Number, v : Number) : Number {
			// assert(h >= 0.0 && h < 360.0);
			// assert(s >= 0.0 && s <= 1.0);
			// assert(v >= 0.0 && v <= 1.0);

			var r : Number = 0.0;
			var g : Number = 0.0;
			var b : Number = 0.0;

			if (s <= 0.0) {
				// If saturation is zero, then the color is gray.
				r = g = b = Math.floor(v * 255.0);
			} else {
				var f : Number, p : Number, q : Number, t : Number, fr : Number, fg : Number, fb : Number;
				var i : int;

				h /= 60.0;

				i = Math.floor(h);
				f = h - i; //Get the fraction into f.
				p = v * (1.0 - s);
				q = v * (1.0 - (s * f));
				t = v * (1.0 - (s * (1.0 - f)));
				switch (i) {
					case 0: 
						fr = v; 
						fg = t; 
						fb = p; 
						break;
					case 1: 
						fr = q; 
						fg = v; 
						fb = p; 
						break;
					case 2: 
						fr = p; 
						fg = v; 
						fb = t; 
						break;
					case 3: 
						fr = p; 
						fg = q; 
						fb = v; 
						break;
					case 4: 
						fr = t; 
						fg = p; 
						fb = v; 
						break;
					case 5: 
						fr = v; 
						fg = p; 
						fb = q; 
						break;
				} // switch
			} // if
			r = Math.floor(fr * 255.0);
			g = Math.floor(fg * 255.0);
			b = Math.floor(fb * 255.0);

			return (r << 16) | (g << 8) | b;
		}
	}
}




