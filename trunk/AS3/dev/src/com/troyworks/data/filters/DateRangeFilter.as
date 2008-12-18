package com.troyworks.data.filters
{
	public class DateRangeFilter extends RangeFilter
	{
		public var fromDate:Date;
		public var toDate:Date;
		
		protected var finalRes : Boolean;
		protected var minPassesMin : Boolean;
		protected var maxPassesMax : Boolean;
		
		public function DateRangeFilter(fromD:Date, toD:Date, minIsInclusive : Boolean = false, 
										maxIsInclusive : Boolean = false)
		{
			super(minIsInclusive, maxIsInclusive);
			fromDate = fromD;
			toDate = toD;
			
			minRelationToMin = (minIsInclusive) ? GREATER_THAN_OR_EQUAL_TO : GREATER_THAN;
			maxRelationToMax = (maxIsInclusive) ? LESS_THAN_OR_EQUAL_TO : LESS_THAN;
		}

		override public function passesFilter(date:*, index:int= 0, array:Array = null) : Boolean 
		{
			finalRes = false;
			minPassesMin = passesMinCheck(date, minRelationToMin, false);
			maxPassesMax = passesMaxCheck(date, maxRelationToMax, false);
			
			finalRes = minPassesMin && maxPassesMax;
			
			var res : Boolean = (invert) ? !finalRes : finalRes; 
			if(res) {
				onPassedFiltered();
			}
			return res;
		}
		
		public function passesMinCheck(val : Date, relationshipToA : String, processInvert : Boolean = true) : Boolean {
			var res : Boolean = false;
			switch(relationshipToA) {
				case ANY:
					res = true;
					break;
				case LESS_THAN:
					res = val < fromDate;
					break;
				case LESS_THAN_OR_EQUAL_TO:
					res = val <= fromDate;
					break;
				case EQUAL_TO:
					res = val == fromDate;
					break;
				case GREATER_THAN_OR_EQUAL_TO:
					res = val >= fromDate;
					break;
				case GREATER_THAN:
					res = val > fromDate;
					break;
				case NOT_EQUAL_TO:
					res = val != fromDate;
					break;
			}
			if(processInvert && invert) {
				res = !res;
			}
			return res;
		}

		public function passesMaxCheck(val : Date,  relationshipToB : String, processInvert : Boolean = true) : Boolean 
		{
			var res : Boolean = false;
			switch(relationshipToB) {
				case ANY:
					res = true;
					break;
				case LESS_THAN:
					res = val < toDate;
					break;
				case LESS_THAN_OR_EQUAL_TO:
					res = val <= toDate;
					break;
				case EQUAL_TO:
					res = val == toDate;
					break;
				case GREATER_THAN_OR_EQUAL_TO:
					res = val >= toDate;
					break;
				case GREATER_THAN:
					res = val > toDate;
					break;
				case NOT_EQUAL_TO:
					res = val != toDate;
					break;
			}
			if(processInvert && invert) {
				res = !res;
			}
			return res;
		}

	}
}