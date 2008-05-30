package com.troyworks.data.filters { 
	
	/**
	 * @author Troy Gardner
	 */
	public class NumberRangeBooleanFilter extends RangeFilter {
		public var min:Number =0;
		public var max:Number = 0;

		
		public function NumberRangeBooleanFilter(minVal:Number = NaN, maxVal:Number= NaN, minIsInclusive:Boolean = false, maxIsInclusive:Boolean = false) {
			super(minIsInclusive, maxIsInclusive);
			min = isNaN(minVal)?Number.MIN_VALUE :minVal;
			max = isNaN(maxVal)?Number.MAX_VALUE :maxVal;
		}
	
	    override public function passesFilter(itemVal:*, index:int= 0, array:Array = null):Boolean {
		//	trace("filter " + itemVal +" [" +this.min + " " + this.max +"]");
			var passes:Boolean = true;
			if(minI){
				if (itemVal<=this.min) {
					return false;
				} else {
				}
			} else {
			//	trace("B");
				if (itemVal<min) {
					return false;
				} else {
				}
			}
			if (maxI) {
			//	trace("C");
				if (max<=itemVal) {
					return false;
				} else {
				}
			} else {
			//	trace("D");
				if (max<itemVal) {
					return false;
				} else {
				}
			}
			return passes;
		};
		
	}
}