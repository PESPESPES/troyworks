package com.troyworks.data.filters {
	import com.troyworks.data.filters.Filter;	/**
	 * StringValueFilter
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Oct 30, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class StringValueFilter extends Filter {
		var idx : Object = new Object();
		var prop:String;		public function StringValueFilter(values : Array, property:String =null) {
			addValues(values);
			prop = property;
		}
		public function addValues(values : Array) : void {
			var val : String;
			while(values.length > 0) {
				val = values.pop();
				trace("StringValueFilter.adding " + val);
				idx[val] = true;
			}
		}
		override public function passesFilter(itemVal : *, index : int = 0, array : Array = null) : Boolean {
			trace(".StringValueFilterpassesFilter " + itemVal);
			var passes : Boolean = false;
			if(prop != null){
			if(idx[itemVal[prop]]) {
				passes = true;
			}	
			}else{
			if(idx[itemVal]) {
				passes = true;
			}
			}
			return passes;
		};	}
}
