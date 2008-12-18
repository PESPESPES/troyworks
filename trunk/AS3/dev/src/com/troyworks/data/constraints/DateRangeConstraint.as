package com.troyworks.data.constraints
{
	public class DateRangeConstraint extends DateConstraint
	{
		public function DateRangeConstraint(minVal:Date, maxVal:Date)
		{
			min = minVal;
			max = maxVal;
		}
		
		public function constrainToRange(val:Date):Date{
			return minDate(maxDate(min, val),max);
		}
		
		private function minDate(date1:Date, date2:Date):Date
		{
			if (date1 > date2) return date2;
			return date1;
		}

		private function maxDate(date1:Date, date2:Date):Date
		{
			if (date1 < date2) return date2;
			return date1;
		}

	}
}