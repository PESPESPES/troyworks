package com.troyworks.util.datetime {

	public class TimeLogEntry
	{
		private var date:Date;
		private var elapsedTime:Number;
		
		public function TimeLogEntry(dateTime:Date = null, elapsedTimeInMS = 0)
		{
			if (dateTime == null) dateTime = new Date();
			date = dateTime;
			elapsedTime = elapsedTimeInMS;			
		}
		
		public function getDate():Date
		{
			return date;
		}
		
		public function getTime():Number
		{
			return elapsedTime;
		}
		
		public function getDelta(other:TimeLogEntry):TimeQuantity
		{
			var diff:Number = this.date.time - other.date.time;
			var delta:TimeQuantity = new TimeQuantity(diff);
			return delta;
		}
	}
}