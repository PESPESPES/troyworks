package com.troyworks.data.constraints
{
	public class IntRangeConstraint extends IntConstraint
	{
		public function IntRangeConstraint(minVal:int, maxVal:int)
		{
			min = minVal;
			max = maxVal;
		}

		public function constrainToRange(val:int):int{
			return Math.min(Math.max(min, val),max);
		}
		override public function toGrid(val:int):int{
			return constrainToRange(super.toGrid(val));
		}
	}
}