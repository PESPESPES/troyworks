package com.troyworks.data.filters
{
	public class UintRangeFilter extends RangeFilter
	{
		public var min : uint = 0;
		public var max : uint = 0;
		
		protected var finalRes : Boolean;
		protected var minPassesMin : Boolean;
		protected var maxPassesMax : Boolean;
				
		public function UintRangeFilter(minVal:uint, maxVal:uint,
						minIsInclusive : Boolean = false, maxIsInclusive : Boolean = false)
		{
			super(minIsInclusive, maxIsInclusive);
			min = minVal;
			max = maxVal;
			
			minRelationToMin = (minIsInclusive) ? GREATER_THAN_OR_EQUAL_TO : GREATER_THAN;
			maxRelationToMax = (maxIsInclusive) ? LESS_THAN_OR_EQUAL_TO : LESS_THAN;
		}
		
		public function passesMinCheck(val : uint, relationshipToA : String, processInvert : Boolean = true) : Boolean {
			var res : Boolean = false;
			switch(relationshipToA) {
				case ANY:
					res = true;
					break;
				case LESS_THAN:
					res = val < min;
					break;
				case LESS_THAN_OR_EQUAL_TO:
					res = val <= min;
					break;
				case EQUAL_TO:
					res = val == min;
					break;
				case GREATER_THAN_OR_EQUAL_TO:
					res = val >= min;
					break;
				case GREATER_THAN:
					res = val > min;
					break;
				case NOT_EQUAL_TO:
					res = val != min;
					break;
			}
			if(processInvert && invert) {
				res = !res;
			}
			return res;
		}

		public function passesMaxCheck(val : uint,  relationshipToB : String, processInvert : Boolean = true) : Boolean {
			var res : Boolean = false;
			switch(relationshipToB) {
				case ANY:
					res = true;
					break;
				case LESS_THAN:
					res = val < max;
					break;
				case LESS_THAN_OR_EQUAL_TO:
					res = val <= max;
					break;
				case EQUAL_TO:
					res = val == max;
					break;
				case GREATER_THAN_OR_EQUAL_TO:
					res = val >= max;
					break;
				case GREATER_THAN:
					res = val > max;
					break;
				case NOT_EQUAL_TO:
					res = val != max;
					break;
			}
			if(processInvert && invert) {
				res = !res;
			}
			return res;
		}
		
		override public function passesFilter(itemVal : *, index : int = 0, array : Array = null) : Boolean {
			finalRes = false;
			minPassesMin = passesMinCheck(itemVal, minRelationToMin, false);
			maxPassesMax = passesMaxCheck(itemVal, maxRelationToMax, false);
			finalRes = minPassesMin && maxPassesMax;
			if(invert) {
				finalRes = !finalRes;
			}
			if(finalRes) {
				onPassedFiltered();
			}
			return finalRes;
		}

	}
}