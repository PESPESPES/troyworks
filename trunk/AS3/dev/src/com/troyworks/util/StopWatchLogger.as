package com.troyworks.util {
	import com.troyworks.util.TimeLogEntry;
	import flash.events.Event;
	import flash.events.EventDispatcher;	
	
	public class StopWatchLogger extends EventDispatcher
	{
		private var log:Array;
		private var watch:StopWatch;
		
		public function StopWatchLogger()
		{
		}
		
		public function addWatch(stopWatch:StopWatch)
		{
			watch = stopWatch;
			watch.addEventListener(StopWatch.START,onStart);
			watch.addEventListener(StopWatch.STOP,onStop);
			watch.addEventListener(StopWatch.RESET,onReset);
		}
		
		public function removeWatch(stopWatch:StopWatch):Boolean
		{
			if (watch == stopWatch)
			{
				watch.removeEventListener(StopWatch.START,onStart);
				watch.removeEventListener(StopWatch.STOP,onStop);
				watch.removeEventListener(StopWatch.RESET,onReset);
				return true;
			}
			else return false;
		}
		
		public function onStart(evt:Event):void
		{
			trace("hear Start logging evt "+evt);
			log = new Array();
			log["start"] = new TimeLogEntry(watch);
		}
		
		public function onStop(evt:Event):void
		{
			trace("onStop evt "+evt);
			if (log == null) return;
			log["stop"] = new TimeLogEntry(watch);
		}
		
		public function onReset(evt:Event):void
		{
			trace("onReset evt "+evt);
			log = new Array();
		}
		
		public function getElapsedTimeDate(): String
		{
			var time:Number = watch.getElapsedTime();
			var timeDate:TimeDateUtil = new TimeDateUtil(time);
			return timeDate.toDateTimeString();
		}
		
		public function addLogEntry(name:String):void
		{
			if (log == null) return;
			log[name] = new TimeLogEntry(watch);
		}
		
		public function traceLog():void
		{
			trace("Log Entries:");
			if (log == null) trace("Counter has not been started. Log is empty");
			var entry:TimeLogEntry;
			for (var obj:Object in log)
			{
				entry = log[obj.toString()];
				trace(obj.toString()+" date "+entry.getDate().toString()+" time "+entry.getTime().toDateTimeString());
			}
		}
		
		public function getDelta(name1:String, name2:String):String
		{
			var entry1:TimeLogEntry = log[name1];
			var entry2:TimeLogEntry = log[name2];
			if (entry1 == null || entry2 == null) return "undefined";
			var delta:TimeDateUtil = entry2.getDelta(entry1); 
			return delta.toDateTimeString();			
		}
		
		public function test():void
		{
			var date:Number = TimeDateUtil.oneYear+TimeDateUtil.oneMonth*4+TimeDateUtil.oneDay*15
				+TimeDateUtil.oneHour*3+TimeDateUtil.oneMinute*24+TimeDateUtil.oneSecond*76;
			var td:TimeDateUtil = new TimeDateUtil(date);
			trace("toDateTimeString "+td.toDateTimeString());
		}	
	}
}