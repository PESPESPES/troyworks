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
	public class StringContainsValueFilter extends Filter {
		public var idx : Object = new Object();
		public var isCaseInsensitive : Boolean = true;
		
		public var whatWillTrigger:String;
		public var startChar:int;
		public var centerChar:int;
		public var endChar:int; 

		public function StringContainsValueFilter(values : Array) {
			addValues(values);
		}

		public function addValues(values : Array) : void {
			var val : String;
			while (values.length > 0) {
				val = values.pop();
				trace("StringContainsValueFilter.adding " + val);
				idx[val] = true;
			}
		}

		override public function passesFilter(itemVal : *, index : int = 0, array : Array = null) : Boolean {
			// trace(".StringContainsValueFilter: '" + itemVal+"'");
			var passes : Boolean = false;
			whatWillTrigger = null;
			startChar = -1;
			centerChar = -1;
			endChar = -1;

			var itemS : String = String(itemVal);
			if (isCaseInsensitive) {
				itemS = itemS.toLowerCase();
			}
			for (var i : String in idx) {
				if (isCaseInsensitive) {
					i = i.toLowerCase();
				}
				startChar= itemS.indexOf(i);
				if (startChar > -1) {
					whatWillTrigger = i;
					endChar = startChar + whatWillTrigger.length;
					centerChar = int(startChar + (whatWillTrigger.length)/2);
					passes = true;
					break;
				}
			}

			var res : Boolean = (invert) ? !passes : passes;
			// trace("res " + res + " " + invert);
			if (res) {
				onPassedFiltered();
			}
			return res;
		};
	}
}
