package com.troyworks.data.constraints
{
	import com.troyworks.util.datetime.TDate;
	
	public class DateListConstraint extends DateConstraint
	{		
		public var whitelist:Array = null;
		public var blacklist:Array = null;
		
		public var useTime:Boolean = false;
		
		public function DateListConstraint()
		{
		}
		
		public function constrainToList(val:TDate):TDate
		{
			var res:Boolean;
			var d:TDate;
			if (whitelist != null)
			{
				res = false;
				for each (d in whitelist)
					if (equal(val,d)) res = true;
				if (!res) return whitelist[0];				
			}
			
			if (blacklist != null)
			{
				res = true;
				for each (d in blacklist)
					if (equal(val,d)) res = false;
				if (!res) return null;
			}
			
			return val;
		}
		
		private function equal(date1:TDate, date2:TDate):Boolean
		{
			if (useTime) return date1 == date2;
			return (date1.fullYear == date2.fullYear && date1.month == date2.month && date1.date == date2.date);
		}

	}
}