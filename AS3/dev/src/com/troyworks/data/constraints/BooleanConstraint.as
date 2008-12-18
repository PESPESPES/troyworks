package com.troyworks.data.constraints
{
	public class BooleanConstraint
	{
		public function BooleanConstraint()
		{
		}
		
		public static function passUnchanged(val:Boolean):Boolean{
			return val;
		}
	}
}