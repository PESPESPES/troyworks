package com.troyworks.util
{
	import com.adobe.utils.DateUtil;
	
	public class TimeLogEntry
	{
		private var date:Date;
		private var elapsedTime:TimeDateUtil;
		
		public function TimeLogEntry(time:Number)
		{
			date = new Date();
			elapsedTime = new TimeDateUtil(time);
			trace("TimeLogEntry date: "+date.toString()+" time: "+elapsedTime.toDateTimeString());
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
			var diff:Number = this.elapsedTime.getRelativeTimeMs() - other.elapsedTime.getRelativeTimeMs();
			var delta:TimeDateUtil = new TimeDateUtil(diff);
			return delta;
		}
	}
}