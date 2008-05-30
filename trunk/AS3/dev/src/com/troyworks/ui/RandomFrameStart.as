package com.troyworks.ui { 
	/**
	 * @author Troy Gardner
	 */
	import flash.events.Event;	
	import flash.display.MovieClip;
	public class RandomFrameStart extends MovieClip {
		
		public function onLoad():void{
			trace("RandomFrameStart.onLoad");
			gotoAndPlay(Math.round(Math.random()* totalFrames));
		}
		public static function onMCLoaded(evt : Event) : void {
			trace("RandomFrameStart.onLoad");
			if(evt.target is MovieClip){
			var mc:MovieClip = evt.target as MovieClip;
			mc.gotoAndPlay(Math.round(Math.random()* mc.totalFrames));
			}
		}
	}
}