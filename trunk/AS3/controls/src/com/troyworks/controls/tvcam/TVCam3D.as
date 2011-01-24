package com.troyworks.controls.tvcam {
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.events.Event;
	import flash.display.Sprite;

	/*
	 * TVCam3D
	 *
	 *  Author: Troy Gardner  
	 * Copyright (c) TroyWorks 2007-2008   http://www.troyworks.com/
	 * Version: 1.0.0  Created:  Dec 20, 2010
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

	public class TVCam3D extends Sprite {

		/**
		 * VCam AS3 v1.1
		 *
		 * VCam based on original code by Sham Bhangal and Dave Dixon
		 *
		 * Special Thanks to Josh Steele and Jeff Brenner
		 *
		 * @author Bryan Heisey
		 * @version 1.1
		 * @updated 16-May-2010
		 *
		 * Requirements: Flash CS3+ & Actionscript 3
		 */

		protected var sh : Number;
		protected var sw : Number;
		protected var camH : Number;
		protected var camW : Number;
		public var CROSSHAIR : Number = 10;
		private var _isActive : Boolean = false;
		public var target:DisplayObject;

		public function TVCam3D(w : Number, h : Number) {
			super();
			camH = h;
			camW = w;
			
			visualize();
		}

		public function activate() : void {
			/**
			 * If the cam hasn't been added to the display list then wait to initialize
			 **/
			if(!stage) {
				addEventListener(Event.ADDED_TO_STAGE, onAdded, false, 0, true);
			} else {
				init();
			}
		}

		public function get isActive() : Boolean {
			return _isActive;
		}

		protected function onAdded(e : Event) : void {
			init();
		}

		public function visualize() : void {
			graphics.lineStyle(0, 0x000000);
			graphics.beginFill(0xFFFFFF, .3);
			graphics.drawRect(0, 0, camW, camH);
			graphics.endFill();
				
			graphics.drawCircle(camW / 2, camH / 2, CROSSHAIR);
			graphics.moveTo(camW / 2 - CROSSHAIR / 2, camH / 2);
			graphics.lineTo(camW / 2 + CROSSHAIR / 2, camH / 2);
			graphics.moveTo(camW / 2, camH / 2 - CROSSHAIR / 2);
			graphics.lineTo(camW / 2, camH / 2 + CROSSHAIR / 2);
		}

		public function init() : void {
			mouseEnabled = false;
			mouseChildren = false;
			visible = false;
			_isActive = true;
	
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
	
			/**
			 * Get the bounds of the camera
			 **/
			var bounds_obj : Object = this.getBounds(this);
			camH = bounds_obj.height;
			camW = bounds_obj.width;

			/**
			 * Get the stage dimensions
			 **/
			sh = stage.stageHeight;
			sw = stage.stageWidth;
	
			addEventListener(Event.REMOVED_FROM_STAGE, reset, false, 0, true);
			addEventListener(Event.ENTER_FRAME, onFrame, false, 0, true);
			//dispatchEvent(new Event(Event.ENTER_FRAME));
		}

		protected function onFrame(e : Event) : void {
			/**
			 * If no parent exists then ignore transformation
			 **/
			if(!target || !stage) {
				return;
			}

			/**
			 * Gets the current scale of the vCam
			 **/
			var h : Number = camH * scaleY;
			var w : Number = camW * scaleX;
	
			/**
			 * Gets the stage to vCam scale ratio
			 **/
			var _scaleY : Number = sh / h;
			var _scaleX : Number = sw / w;
	
			/**
			 * Copies the cam's matrix and transforms it
			 **/
		//	trace("this " + this);
		//	trace("this.transform " + this.transform);
		//	trace("this.transform.matrix " + this.transform.matrix);
			if(this.transform.matrix) {
				var matrix : Matrix = this.transform.matrix.clone();
				matrix.invert();
				matrix.scale(scaleX, scaleY);
			//	matrix.translate(w / 2 - x, h / 2 - y);
			//	matrix.translate(w / 2, h / 2);

				matrix.scale(_scaleX, _scaleY);
				//matrix.translate(-x *_scaleX, 0);//-y*_scaleY);
				/**
				 * Apply transformation matrix and filters to parent
				 **/
				target.transform.matrix = matrix;
				target.transform.colorTransform = this.transform.colorTransform;
			}else if(this.transform.matrix3D) {
				var matrix3D : Matrix3D = this.transform.matrix3D.clone();
				//matrix3D.invert();
				//matrix3D.scale(scaleX,scaleY);
				//matrix3D.translate(w/2,h/2);
				//matrix3D.scale(_scaleX,_scaleY);

				/**
				 * Apply transformation matrix and filters to target
				 **/
				target.transform.matrix3D = matrix3D;
				target.transform.colorTransform = this.transform.colorTransform;
			}
			target.filters = this.filters;
		}

		public function reset(e : Event = null) : void {
			mouseEnabled = true;
			mouseChildren = true;
			visible = true;
			_isActive = false;
			/**
			 * Clean up for garbage collection
			 **/
			removeEventListener(Event.ENTER_FRAME, onFrame);
			removeEventListener(Event.REMOVED_FROM_STAGE, reset);

			/**
			 * Resets target properties
			 **/
			var matrix : Matrix = new Matrix();
			target.transform.matrix = matrix;

			target.filters = [];
	
			var ct : ColorTransform = new ColorTransform();
			target.transform.colorTransform = ct;
		}

		public function getPositionShapshot() : Object {
			var res : Object = new Object();
			res.x = x;
			res.y = y;
		//	res.z = z;
		
			res.height = height;
			res.width = width;
			res.alpha = alpha;
			//res.scaleZ = scaleZ;
			res.scaleX = scaleX;
			res.scaleY = scaleY;
		//	res.rotationZ = rotationZ;
		//	res.rotationY = rotationY;
		//	res.rotationX = rotationX;
			res.rotation = rotation;
			return res;
		}
	}
}