package com.troyworks.ui.menus { 
	/**
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;
	public class ToolTip extends MovieClip {
		public function ToolTip() {
			
		}
	//		contextMenu.tooltip.onEnterFrame = moveTip;
		/**** MOVES THE TOOLTIP **********/
		public function moveTip(clip : MovieClip) : void {
			this.x = clip.x;
			this.y = clip.y;//-this.height/2;
		}
	}
}