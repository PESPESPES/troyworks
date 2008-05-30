package com.troyworks.data.bit { 
	/**
	 * A masked bitflag, has a set of 32 bits that have a mask indicating which of the 32 bits 
	 * are valid or not, for use in comparison.
	 * 
	 * @author Troy Gardner (troy@troyworks.com)
	 */
	public class MaskedBitFlag extends Object {
		protected var __name : String;
		/* mask */
		public var m:uint;
		/* bits */
		public var b:uint;
		
		public function MaskedBitFlag(val : uint = NaN, mask:uint = NaN, name: String = "") {
		//	super(val);
			super();
			b = isNaN(val)? BitFlag.ALLBITSOFF: val;
			m = isNaN(mask)? BitFlag.ALLBITSOFF: mask;
			__name = name;
		}
		public function get name():String{
			return this.__name;
		}
		public function add(mbf:MaskedBitFlag):void{
			m |= mbf.m;
			b |= mbf.b;
		}
		public function toString():String{
			return this.name + super.toString();
		}
	}
}