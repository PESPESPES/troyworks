package com.troyworks.data.constraints
{
	public class IntConstraint extends Constraint
	{
		public var grid:int = 1;
		public var gridOffset:int = 0;
		
		public var min:int = 0;
		public var max:int = 0;
		
		public function IntConstraint()
		{
		}
		
		public static function passUnchanged(val:int):int{
			return val;
		}

		public function toGrid(val:int):int{
			return gridOffset + (grid*Math.round(val/grid));
		}
	}
}