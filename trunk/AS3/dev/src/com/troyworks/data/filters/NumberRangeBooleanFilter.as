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
		public function setToSingleDigits() : void {
			max =  (max>9)?9:max;
			
			min =  (min<-9)?-9:min;
		}

		public function setToDoubleDigits() : void {
			max =   (max>99)?99:max;
			
			min =  (min<-99)?-99:min;
		}

		public function setToTripleDigits() : void {
			max =   (max>999)?999:max;
			
			min =  (min<-999)?-999:min;
			
		}
		
		public function expand(minVal:Number = NaN, maxVal:Number= NaN):void{
			if(minVal < min){
			 min = minVal;	
			}
			
			if(maxVal > max){
			  max = maxVal;	
			}
		}
		
		public function get	length():Number{
			
			return max - min;
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
		
		public function toString():String{
			var res:Array = new Array();
			
			res.push((minI?("["+min):(min+"]")));
			
			res.push((maxI?(max+"]"):("["+max)));
			
			return res.join("");	
		}
		
	}
}