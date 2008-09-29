package com.troyworks.util
{
	import com.adobe.utils.DateUtil;
	
	public class TimeLogEntry
	{
		private var watch:CountDownTimer;
		private var date:Date;
		private var elapsedTime:TimeDateUtil;
		
		public function TimeLogEntry(timer:CountDownTimer)
		{
			date = new Date();
			watch = timer;
			elapsedTime = new TimeDateUtil(watch.getElapsedTime());			
//			trace("TimeLogEntry date: "+date.toString()+" time: "+elapsedTime.toDateTimeString());
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