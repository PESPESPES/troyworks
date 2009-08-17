package com.troyworks.data {
	import flash.events.EventDispatcher;	

	/**
	 *  A utility to help with constrained number ranges, primarily
	 *  e.g. 0-360 degrees, where adding/subtracting recycles the value within that range.
	 *  e.g.
	 *   2 -1 = 1;
	 *   1 -1 = 0;//also 360
	 *   0 -1 = 359
	 *  
	 * @author Troy Gardner
	 */
	public class ConstrainedNumber extends EventDispatcher {
		private var innerValue : Number = 0;

		public var min : Number = Number.MIN_VALUE;
		public var max : Number = Number.MAX_VALUE;
		public var minI : Boolean = false;
		public var maxI : Boolean = false;

		public var recycleOnOverflow : Boolean = false;
		public var recycleOnUnderflow : Boolean = false;
		/* a list of constraints to apply to the value upon set, e.g. quantize to whole number*/
		public var constrain:Function = null;

		public function ConstrainedNumber() {
			super();
		}

		public static function get0To360(recycle:Boolean = true) : ConstrainedNumber {
			var res : ConstrainedNumber = new ConstrainedNumber();
			res.min = 0;
			res.max = 360;
			res.minI = true;
			res.maxI = true;
			if(recycle){
				res.recycleOnOverflow = true;
				res.recycleOnUnderflow = true;
			}
			return res;
		}
		
		public function set recycle(val : Boolean) : void {
			recycleOnOverflow = recycleOnUnderflow = val;
		}

		public function get recycle() : Boolean {
			return recycleOnOverflow && recycleOnUnderflow;
		}
		public function get value():Number{
			return innerValue;
		}

		public function add(val : Number) : Number {
			var nx : Number = innerValue + val;
			return setTo(nx);
		}

		public function subtract(val : Number) : Number {
			var nx : Number = innerValue - val;
			return setTo(nx);
		}

		public function subtractFrom(val : Number) : Number {
			return (val - innerValue);
		}

		public function multiply(val : Number) : Number {
			var nx : Number = innerValue * val;
			return setTo(nx);		
		}

		public function divide(val : Number) : Number {
			var nx : Number = innerValue / val;
			return setTo(nx);		
		}

		public function setTo(nxVal : Number) : Number {
		//	trace("setTo " + nxVal + " [" + this.min + " " + this.max + "]");
			if(nxVal == innerValue) {
				//NO change in nxValue
				return innerValue;
			}else {
				//potential change in nxValue ////////

				if(minI) {
				//	trace("A");
					if (nxVal <= this.min) {
						if(recycleOnUnderflow) {
						//trace("recycling" + (this.min - nxVal));
							nxVal = this.max - ( this.min- nxVal);
						}else {
							nxVal = this.min;
						}
					} else {
						//okay
					}
				} else {
					//trace("B");
					if (nxVal < min) {
						if(recycleOnUnderflow) {
						//	trace("recycling" + (this.min - nxVal));
							nxVal = this.max - ( this.min- nxVal);
						}else {
							nxVal = this.min;
						}
					} else {
						//okay
					}
				}
				if (maxI) {
					//	trace("C");
					if (max <= nxVal) {
						if(recycleOnOverflow) {
							//	trace("recycling" +(nxVal - this.max));
							nxVal = this.min + (nxVal - this.max);
						}else {
							nxVal = this.max;
						}
					} else {
						//okay
					}
				} else {
				//	trace("D");
					if (max < nxVal) {
						if(recycleOnOverflow) {
							nxVal = this.min + (nxVal - this.max);
						}else {
							nxVal = this.max;
						}
					} else {
						//okay
					}
				}
				if(constrain != null){
					nxVal = constrain(nxVal);
				}
			//	trace("nx Val " + nxVal);
				if(nxVal == innerValue) {
					//NO change in nxValue
					return innerValue;
				}else {
					//change in innerValue
					if(willTrigger(DataChangedEvent.DATA_CHANGE)){
						var evt:DataChangedEvent = new DataChangedEvent(DataChangedEvent.DATA_CHANGE);
						evt.oldVal = innerValue;
						evt.currentVal = nxVal;
						dispatchEvent(evt);
					}
					innerValue = nxVal;
					return innerValue;
				}
			}
		};

	override public function toString() : String {
			var res : String = "";
			res = innerValue.toString();
			return res;
		}


	}
}
