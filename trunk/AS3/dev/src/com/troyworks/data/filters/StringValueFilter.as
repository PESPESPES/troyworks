package com.troyworks.data.filters {
	import com.troyworks.data.filters.Filter;
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
		var prop:String;
			addValues(values);
			prop = property;
		}

			var val : String;
			while(values.length > 0) {
				val = values.pop();
				trace("StringValueFilter.adding " + val);
				idx[val] = true;
			}
		}

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
		};
}