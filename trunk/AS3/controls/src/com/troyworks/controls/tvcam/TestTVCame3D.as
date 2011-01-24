package com.troyworks.controls.tvcam {
	import com.troyworks.controls.tuitools.DisplayObjTool;

	import flash.display.Sprite;

	/*
	 * TestTVCame3D
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

	public class TestTVCame3D extends Sprite {
		private var cam:TVCam3D; 
		private var dOTool:DisplayObjTool;
		public var controls:Sprite;
		
		public function TestTVCame3D() {
			drawGrid();
			cam = new TVCam3D(640,360);
			cam.y = cam.x = 10;
			
			//cam.buttonMode = true;
			addChild(cam);
			controls = new Sprite();
			addChild(controls);	
			dOTool = new DisplayObjTool();
			dOTool.createBuiltInUI(controls);
			dOTool.setClipToManipulate(cam);
		//	dOTool.enableFreeScaleControls();
			dOTool.requestScaleTool();
			//dOTool.requestMoveTool();
			
		}
		public function drawGrid():void{
			graphics.lineStyle(1,0);
			graphics.moveTo(0, 0);
			graphics.lineTo(50,50);
			
			trace(stage.stageWidth, stage.stageHeight);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
		}
	}
}
