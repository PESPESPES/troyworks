package com.troyworks.data.query { 

	/**
	 * @author Troy Gardner
	 */
	public class NullNumber extends Number {
		public static var NULL_Number:NullNumber = new NullNumber();
	
		public function NullNumber(num : Object = NaN) {
			super(num);
		}
	
	}
}