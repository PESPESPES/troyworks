package com.troyworks.controls.tshapes {
	import flash.filters.DropShadowFilter;	
	import flash.text.TextFormat;	
	import flash.display.Bitmap;	
	import flash.display.BitmapData;	
	import flash.text.TextFieldAutoSize;	
	import flash.text.TextField;	
	import flash.display.Sprite;	
	import flash.display.DisplayObject;	

	/*
	 * Tag
	 *
	 *  Author: Troy Gardner  
	 * Copyright (c) TroyWorks 2007-2008   http://www.troyworks.com/
	 * Version: 1.0.0  Created:  Feb 4, 2009
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
	 * This creates a graphical arrow like a tag.
	 * 
	 */

	public class Tag {

		public static function drawTag(onDisplayObj : DisplayObject, atDisplayObj : DisplayObject = null, msg : String = null) : void {
			var onSprite = onDisplayObj;
			var pad : Sprite = new Sprite();
			var label = new TextField();
			label.autoSize = TextFieldAutoSize.LEFT;
			//label.background = true;
			//label.border = true;

			var format : TextFormat = new TextFormat();
			format.font = "_sans";
			format.color = 0xFFFFFF;
			format.size = 10;
			//format.underline = true;

			
			label.defaultTextFormat = format;

			//label.rotation = -90;
			label.text = msg;
			//"HLddddddddddddddddddddddddddddddL";
			var bitmapD : BitmapData = new BitmapData(label.width, label.height, true, 0x000000);
			bitmapD.draw(label);
			//label.filters = [new BlurFilter(0,0,0)];
			//cacheAsBitmap = true;
			//label.width = wid *.9;
			//label.height = (2*width )*.9;

			//pad.addChild(label);

			//label.rotation = -90;
			//txt.blendMode = BlendMode.ERASE;
			//pad.addChild(label);
			var bm : Bitmap = new Bitmap(bitmapD);
			bm.x = -bm.width / 2;
			bm.rotation = -90;

			pad.addChild(bm);
			pad.graphics.beginFill(0xCC0000, .8);
			var wid : Number = 50;

			pad.graphics.drawRoundRect(-wid / 2, 0, wid, label.width, 5, 5);

			pad.graphics.moveTo(-wid / 2, 0);
			pad.graphics.lineTo(wid / 2, 0);
			pad.graphics.lineTo(0, wid / 2);
			pad.graphics.lineTo(-wid / 2, 0);
			pad.graphics.endFill();
			if (atDisplayObj) {
				pad.x = atDisplayObj.x;
				pad.y = atDisplayObj.y;
			}
			pad.filters = [new DropShadowFilter(5, 45, 0, .8)];
			onSprite.addChild(pad);
		}
	}
}
