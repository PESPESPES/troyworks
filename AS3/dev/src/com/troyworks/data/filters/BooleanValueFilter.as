package com.troyworks.data.filters
{
	public class BooleanValueFilter extends Filter
	{
		public var filterValue:Boolean = false;
		 
		public function BooleanValueFilter(val:Boolean)
		{
			filterValue = val;
		}

		override public function passesFilter(itemVal : *, index : int = 0, array : Array = null) : Boolean {
			var passes : Boolean = (itemVal == filterValue);
			
			var res : Boolean = (invert) ? !passes : passes; 
			if(res) onPassedFiltered();
			return res;
		};
	}
}