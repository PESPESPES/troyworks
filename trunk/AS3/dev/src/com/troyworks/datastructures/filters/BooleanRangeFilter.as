package com.troyworks.datastructures.filters { 
	
	/**
	 * @author Troy Gardner
	 */
	public class BooleanRangeFilter extends Filter {
		public var min:Number =0;
		public var max:Number = 0;
		public var minI:Boolean = false;
		public var maxI:Boolean = false;
		
		public function BooleanRangeFilter(minVal:Number, maxVal:Number, minIsInclusive:Boolean, maxIsInclusive:Boolean) {
			min = (minVal == null)?Number.MIN_VALUE :minVal;
			max = (maxVal == null)?Number.MAX_VALUE :maxVal;
			minI = (minIsInclusive != null)? minIsInclusive: false;
			maxI = (maxIsInclusive != null)? maxIsInclusive: false;
		}
	
	    public function filter(itemVal:Object):Boolean {
		trace("filter " + itemVal +" [" +this.min + " " + this.max +"]");
		var passes:Boolean = true;
		if (this.minI != null && this.minI) {
			trace("A");
			if (itemVal<=this.min) {
				return false;
			} else {
			}
		} else {
					trace("B");
			if (itemVal<this.min) {
				return false;
			} else {
			}
		}
		if (this.maxI != null && this.maxI) {
					trace("C");
			if (this.max<=itemVal) {
				return false;
			} else {
			}
		} else {
					trace("D");
			if (this.max<itemVal) {
				return false;
			} else {
			}
		}
		return passes;
	};
		
	}
}