package com.troyworks.util
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.display.MovieClip;
	
	public class CountDownTimer extends MovieClip
	{
		private var duration_mS:int = 0;
		public var duration:TimeDateUtil;
		private var requestedTime:int = 0;
		private var elapsedTime:int = 0;
		private var timer:StopWatch;
		
		public function CountDownTimer(durationSec:int = 0)
		{
			duration_mS = durationSec*1000;
			duration = new TimeDateUtil(duration_mS);
			duration.addEventListener(TimeDateUtil.CHANGED, updateRequestedTime);
			requestedTime = duration.getRelativeTimeMs();
			timer = new StopWatch();			
		}
		
		public function set requestedDuration(duration:TimeDateUtil):void
		{
			this.duration = duration;			
			duration_mS = duration.getRelativeTimeMs();
			requestedTime = duration.getRelativeTimeMs();
		}
		
		public function get requestedDuration():TimeDateUtil
		{
			return duration;
		}
		
		public function start():void
		{
			requestedTime = duration.getRelativeTimeMs();
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			timer.start();			
		}
		
		public function complete():void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function reset():void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			timer.stop();
		}
		
		public function pause():void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			timer.stop();
			requestedTime = elapsedTime;
		}
		
		public function resume():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			timer.start();
		}
		
		private function updateRequestedTime(evt:Event)
		{
			requestedTime += duration.getRelativeTimeMs() - duration_mS;
			duration_mS = duration.getRelativeTimeMs();
		}
		
		private function onEnterFrame(evt:Event):void
		{
			elapsedTime = requestedTime - timer.getElapsedTime();
			trace("requestedTime "+requestedTime+" elapsedTime "+elapsedTime);
			if (elapsedTime <= 0) 
			{
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				complete();
			}
		}
	}
}