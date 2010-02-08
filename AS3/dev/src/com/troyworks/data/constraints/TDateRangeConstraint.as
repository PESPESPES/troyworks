package com.troyworks.data.constraints {
	import com.troyworks.util.datetime.TDate;

	public class TDateRangeConstraint extends Constraint {
		public var min : TDate = new TDate();
		public var max : TDate = new TDate();

		public function TDateRangeConstraint(minVal : TDate, maxVal : TDate) {
			min = minVal;
			max = maxVal;
		}

		public function constrainToRange(val : TDate) : TDate {
			//var res : TDate = minDate(maxDate(max, val), min); 
			var res : TDate = minDate(max,maxDate(min, val)); 
			trace("TDateRangeConstraint  " + min + " " + max + " ==>" + res);
			return res;
		}

		private function minDate(date1 : TDate, date2 : TDate) : TDate {
			trace("minDate " + date1 + " > " + date2 + " " + (date1.time > date2.time));
			if (date1.time > date2.time) {
				trace("date2 is less");
				return date2;
			} else {
				trace("date1 is less");
				return date1;
			}
		}

		private function maxDate(date1 : TDate, date2 : TDate) : TDate {
			trace("maxDate " + date1 + " < " + date2 + " " + (date1.time < date2.time));
			if (date1.time < date2.time) {
				trace("date2 is more"+ date2);
				return date2;
			} else {
				trace("date1 is more" + date1);
				return date1;
			}
		}
	}
}