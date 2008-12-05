package com.troyworks.controls.tbutton {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.*;	

	/**
	 * @author Troy Gardner
	 */

	
	
	
	public class MCButton2 extends MovieClip {
		private var clicked : Boolean = false;
		public var label_txt : TextField; 

		public function MCButton2() {
			this.buttonMode = true;
			this.mouseChildren = false; 
			clicked = false;
			this.addEventListener(MouseEvent.MOUSE_OVER, rollover);
			this.addEventListener(MouseEvent.MOUSE_OUT, rollout);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseClickDown);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseClickUp);
		}

		public function setLabel(thisLabel : String) : void {
			label_txt.text = thisLabel;
		}

		public function rollover(event : MouseEvent ) : void {
			if (clicked) {
				gotoAndStop("down");
			} else {
				gotoAndStop("over");
			}
		}

		public function rollout(event : MouseEvent) : void {
			gotoAndStop("normal");
		}

		public function mouseClickDown(event : MouseEvent) : void {
			clicked = true;
			gotoAndStop("down");
		}

		public function mouseClickUp(event : MouseEvent) : void {
			clicked = false;
			gotoAndStop("over");
		}
	}
}
