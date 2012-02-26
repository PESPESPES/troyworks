package com.troyworks.data.filters {
	import com.troyworks.data.filters.Filter;
	/**
	 * StringValueFilter, if the collection contains the word, or 
	 * passed in object's property has one of the collection values
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Oct 30, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class StringValueFilter extends Filter {
		public var idx : Object = new Object();
		public var prop : String;

		public function StringValueFilter(values : Array, property : String = null) {
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
			trace(".StringValueFilterpassesFilter: '" + itemVal+"'");
			var passes : Boolean = false;
			if(prop != null) {
				if(idx[itemVal[prop]] != null) {
					passes = true;
				}	
			}else {
				if(idx[itemVal]!= null) {
					passes = true;
				}
			}
			
			var res : Boolean = (invert) ? !passes : passes;
			trace("res " + res + " " + invert); 
			if(res) {
				onPassedFiltered();
			}
			return res;
		};	}
}
