package com.troyworks.query { 
	/**
	 * @author Troy Gardner
	 */
	public class AnyString extends String {
		public static var ANY_String:AnyString = new AnyString("*:String");
		public function AnyString(string : String) {
			super(string);
		}
	
	}
}