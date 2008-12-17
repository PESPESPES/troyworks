package com.troyworks.data.constraints {
	import com.troyworks.data.constraints.NumberConstraint;
	
	/**
	 * @author Troy Gardner
	 */
	public class NumberRangeConstraint extends NumberConstraint {
		public function NumberRangeConstraint(myMin:Number, myMax:Number) {
			
			super();
			min = myMin;
			max = myMax;
		}
		public function constrainToRange(val:Number):Number{
			return Math.min(Math.max(min, val),max);
		}
		override public function toGrid(val:Number):Number{
			return constrainToRange(super.toGrid(val));
		}
	}
}
