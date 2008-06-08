package com.troyworks.ui { 
	/**
	 * @author Troy Gardner
	 */
	import flash.events.Event;	
	import flash.display.MovieClip;
	public class RandomFrameStart extends MovieClip {
		
		public function RandomFrameStart() {
			addFrameScript(0, onFrame1);
		}
		public function onFrame1():void{
			trace("RandomFrameStart.onLoad");
			jumpToRandomFrame(this);
		}
		public static function jumpToRandomFrame(mc:MovieClip):void{
			mc.gotoAndPlay(Math.round(Math.random()* mc.totalFrames));
		}
		public static function onMCLoaded(evt : Event) : void {
			trace("RandomFrameStart.onLoad");
			if(evt.target is MovieClip){
				var mc:MovieClip = evt.target as MovieClip;
				jumpToRandomFrame(mc);
			}
		}
	}
}