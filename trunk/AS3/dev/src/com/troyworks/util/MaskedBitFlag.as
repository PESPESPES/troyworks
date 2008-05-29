package com.troyworks.util { 
	/**
	 * @author Troy Gardner
	 */
	public class MaskedBitFlag extends Object {
		protected var __name : String;
		/* mask */
		public var m:int;
		/* bits */
		public var b:int;
		
		public function MaskedBitFlag(val : int, mask:int, name : String) {
		//	super(val);
			super();
			b = (val == null)? BitFlag.ALLBITSOFF: val;
			m = (mask == null)? BitFlag.ALLBITSOFF: mask;
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