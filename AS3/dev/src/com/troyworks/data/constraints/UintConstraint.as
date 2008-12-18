package com.troyworks.data.constraints
{
	public class UintConstraint extends Constraint
	{
		public var grid:uint = 1;
		public var gridOffset:uint = 0;
		
		public var min:uint = 0;
		public var max:uint = 0;
		
		public function UintConstraint()
		{
		}

		public static function passUnchanged(val:uint):uint{
			return val;
		}
		public function toGrid(val:uint):uint{
			return gridOffset + (grid*Math.round(val/grid));
		}
	}
}