package com.troyworks.data.filters { 
	/**
	 *  A filter is designed to be used with the Array.filter or other data iterators
	 * to determine if a particular value passes. It's like SQL lite in querying data
	 * collections.
	 * 
	 * Filters can be stacked using a composite Filter
	 * @author Troy Gardner
	 */
	public class Filter {
		public function passesFilter(item:*,  index:int= 0, array:Array = null):Boolean{
			var passes:Boolean = true;
			return passes;
		}
	}
}