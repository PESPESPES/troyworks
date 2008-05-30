package com.troyworks.controls.tbutton {
	import flash.display.MovieClip;
	
	/**
	 * @author Troy Gardner
	 */

	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	
	public class MCButton2 extends MovieClip {
		private var clicked:Boolean = false;
		public var label_txt:TextField; 
		
		public function MCButton2() {
			this.buttonMode = true;
			this.mouseChildren = false; 
			clicked = false;
			this.addEventListener(MouseEvent.MOUSE_OVER, rollover);
			this.addEventListener(MouseEvent.MOUSE_OUT, rollout);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseClickDown);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseClickUp);
		}
		
		public function setLabel(thisLabel:String) {
			label_txt.text = thisLabel;
		}
		
		public function rollover(event:MouseEvent) {
			if (clicked) {
				gotoAndStop("down");
			} else {
				gotoAndStop("over");
			}
		}

		public function rollout(event:MouseEvent) {
			gotoAndStop("normal");
		}

		public function mouseClickDown(event:MouseEvent) {
			clicked = true;
			gotoAndStop("down");
		}

		public function mouseClickUp(event:MouseEvent) {
			clicked = false;
			gotoAndStop("over");
		}
		
	}

}
