package com.troyworks.framework.ui.behaviors { 
	/**
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;
	public class RandomFrameStart extends MovieClip {
		public function onLoad():void{
			
			trace("RandomFrameStart.onLoad");
			gotoAndPlay(Math.round(Math.random()* totalFrames));
		}
	}
}