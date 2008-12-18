package com.troyworks.data.constraints
{
	public class DateConstraint extends Constraint
	{
		public var min:Date = new Date();
		public var max:Date = new Date();
		
		public function DateConstraint()
		{
		}
		
		public static function passUnchanged(val:Date):Date{
			return val;
		}

	}
}