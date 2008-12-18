package com.troyworks.data.constraints
{
	public class StringConstraint extends Constraint
	{
		public function StringConstraint()
		{
		}
		
		public static function passUnchanged(val:String):String{
			return val;
		}

	}
}