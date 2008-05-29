package com.troyworks.query { 
	/**
	 * @author Troy Gardner
	 */
	public class NullNumber extends Number {
		public static var NULL_Number:NullNumber = new NullNumber();
	
		public function NullNumber(num : Object) {
			super(num);
		}
	
	}
}