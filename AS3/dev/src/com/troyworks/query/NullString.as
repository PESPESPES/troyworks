package com.troyworks.query { 
	/**
	 * @author Troy Gardner
	 */
	public class NullString extends String {
		public static var NULL_STRING:NullString = new NullString("NULL");
		
		protected function NullString(string : String) {
			super(string);
		}
	
	}
}