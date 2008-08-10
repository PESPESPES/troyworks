package com.troyworks.io.airlib
{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import com.troyworks.io.airlib.IFile;
	
	public class IFileTimer extends Timer
	{
		public var file:IFile;
		
		public function IFileTimer(aFile:IFile)
		{
			super(0, 1);
			this.file = aFile;
			this.addEventListener(TimerEvent.TIMER, onTimer);
			this.start();
		}
		
		protected function onTimer(ev:TimerEvent):void
		{
			this.file.dispatchEvent(new Event(Event.COMPLETE));
		}		
	}
}