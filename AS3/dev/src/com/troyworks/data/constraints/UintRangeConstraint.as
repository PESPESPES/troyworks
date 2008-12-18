package com.troyworks.data.constraints
{
	public class UintRangeConstraint extends UintConstraint
	{
		public function UintRangeConstraint(minVal:uint, maxVal:uint)
		{
			min = minVal;
			max = maxVal;
		}
		
		public function constrainToRange(val:uint):uint{
			return Math.min(Math.max(min, val),max);
		}
		override public function toGrid(val:uint):uint{
			return constrainToRange(super.toGrid(val));
		}

	}
}