package com.troyworks.util
{
	public class CountDownTimer extends StopWatch
	{
		private var log:Array;
		public function CountDownTimer()
		{
			super();
		}
		
		override public function start():void
		{
			trace("Start logging");
			log = new Array();
			super.start();
			log["start"] = new TimeLogEntry(this);
		}
		
		override public function stop():void
		{
			if (log == null) return;
			super.stop();
			log["stop"] = new TimeLogEntry(this);
		}
		
		public function getElapsedTimeDate(): String
		{
			var time:Number = super.getElapsedTime();
			var timeDate:TimeDateUtil = new TimeDateUtil(time);
			return timeDate.toDateTimeString();
		}
		
		public function addLogEntry(name:String)
		{
			if (log == null) return;
			log[name] = new TimeLogEntry(this);
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