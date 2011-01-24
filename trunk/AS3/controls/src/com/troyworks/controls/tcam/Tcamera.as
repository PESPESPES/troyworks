package com.troyworks.controls.tcam {
	import flash.display.Sprite;

	/*
	 * Tcamera
	 *
	 *  Author: Troy Gardner  
	 * Copyright (c) TroyWorks 2007-2008   http://www.troyworks.com/
	 * Version: 1.0.0  Created:  Nov 10, 2010
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
	 * DESCRIPTION a port of an As2.0 library, which was a port of an As1.0 library (I think)
	 * The goal of this is to allow animators on the timeline to create a virtual camera
	 * that is placed over the scene clip it's mean to view.
	 * and by manipulating that virtual camera, the scene clip is panned/zoomed/faded to match the clip
	 * 
	 */

	public class Tcamera extends Sprite {
			var scaleX:Number = sX/this._width;
	var scaleY:Number = sY/this._height;
var oldMode:String = Stage.scaleMode;
Stage.scaleMode = "exactFit";
var cX:Number = Stage.width/2;
var cY:Number = Stage.height/2;
var sX:Number = Stage.width;
var sY:Number = Stage.height;
Stage.scaleMode = oldMode;
// create color instances for color 
// transforms (if any).
var camColor:Color = new Color(this);
var parentColor:Color = new Color(_parent);
		
		public function Tcamera() {

	parentColor.setTransform(camColor.getTransform());
	var scaleX:Number = sX/this._width;
	var scaleY:Number = sY/this._height;
	_parent._x = cX-(this._x*scaleX);
	_parent._y = cY-(this._y*scaleY);
	_parent._xscale = 100*scaleX;
	_parent._yscale = 100*scaleY;
}
function resetStage():Void {
	var resetTrans:Object = {ra:100, rb:0, ga:100, gb:0, ba:100, bb:0, aa:100, ab:0};
	parentColor.setTransform(resetTrans);
	_parent._xscale = 100;
	_parent._yscale = 100;
	_parent._x = 0;
	_parent._y = 0;
}
// make frame invisible
this._visible = false;
// Capture stage parameters
var oldMode:String = Stage.scaleMode;
Stage.scaleMode = "exactFit";
var cX:Number = Stage.width/2;
var cY:Number = Stage.height/2;
var sX:Number = Stage.width;
var sY:Number = Stage.height;
Stage.scaleMode = oldMode;
// create color instances for color 
// transforms (if any).
var camColor:Color = new Color(this);
var parentColor:Color = new Color(_parent);
// Make the stage move so that the 
// v-cam is centered on the
// viewport every frame
this.onEnterFrame = camControl;
// Make an explicit call to the camControl
// function to make sure it also runs on the
// first frame.
camControl();
// If the v-cam is ever removed (unloaded)
// the stage, return the stage to the default
// settings.
this.onUnload = resetStage;
			
		}
	}
}
