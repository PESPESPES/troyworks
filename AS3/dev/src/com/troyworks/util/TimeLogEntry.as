package com.troyworks.util
{
	public class TimeLogEntry
	{
		private var watch:StopWatch;
		private var date:Date;
		private var elapsedTime:TimeDateUtil;
		
		public function TimeLogEntry(timer:StopWatch, dateTime:Date = null)
		{
			if (dateTime == null) dateTime = new Date();
			date = dateTime;
			watch = timer;
			elapsedTime = new TimeDateUtil(watch.getElapsedTime());			
		}
		
		public function getDate():Date
		{
			return date;
		}
		
		public function getTime():TimeDateUtil
		{
			return elapsedTime;
		}
		
		public function getDelta(other:TimeLogEntry):TimeDateUtil
		{
			var diff:Number = this.date.time - other.date.time;
			var delta:TimeDateUtil = new TimeDateUtil(diff);
			return delta;
		}
	}
}