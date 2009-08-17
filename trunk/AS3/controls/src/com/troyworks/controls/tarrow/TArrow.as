package com.troyworks.controls.tarrow {
	import flash.text.TextFieldAutoSize;	
	import flash.text.TextField;	
	import flash.display.Sprite;	
	import flash.geom.Rectangle;
	import flash.geom.*;
	import flash.display.*;

	
	/*
	 * TArrow
	 *
	 *  Author: Troy Gardner  
	 * Copyright (c) TroyWorks 2007-2008   http://www.troyworks.com/
	 * Version: 1.0.0  Created:  Apr 24, 2009
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

	public class TArrow extends Rectangle {
		var midX : Number;
		var midY : Number;
		var indentL : Number = .1;
		var indentR : Number = .1;
		var fillType : String = GradientType.LINEAR;
		var colors : Array = [0xFF0000, 0x0000FF];
		var alphas : Array = [1, 1];
		var ratios : Array = [0x00, 0xFF];
		var matr : Matrix = new Matrix();
 		 var spreadMethod : String = SpreadMethod.PAD;
		public var label : String = "test";

		public function TArrow(x : Number = 0, y : Number = 0, width : Number = 0, height : Number = 0) {
			super(x, y, width, height);
			midX = width / 2;
			midY = height / 2;
		}

		public function drawTo(view : Sprite) : void {
			
			view.graphics.lineStyle(1, 0, 1);
			view.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);  
			
			//view.graphics.beginFill(0xcccccc, .4);
			//x--+--+
			//+     +
			//+--+--+			
			view.graphics.moveTo(0, 0);
			//+--+--x
			//+     +
			//+--+--+

			view.graphics.lineTo(right, 0);
			//+--+--+
			//+     x
			//+--+--+
			view.graphics.lineTo(width + indentR * height, midY);
			view.graphics.lineTo(right, height);
			view.graphics.lineTo(0, height);
			view.graphics.lineTo(0 + indentR * height, midY);
			view.graphics.lineTo(0, 0);
			view.graphics.endFill();
			var txt : TextField = new TextField();
			txt.name = "label_txt";
			txt.text = String(view.name);//label;
			txt.selectable = false;
			txt.mouseEnabled = false;
			//txt.border = true;
			txt.autoSize = TextFieldAutoSize.CENTER;
			txt.x = (width - txt.width) / 2;
			txt.y = (height - txt.height) / 2;
			
			view.addChild(txt);
		}
	}
}
