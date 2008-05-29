package com.troyworks.validators { 
	import util.StringUtil;
	
	/**
	 * Validates US phone numbers
	 * e.g ###-###-#### (usa)
	 * 
	 * @author Troy Gardner
	 */
	public class PhoneValidator extends Validator {
		
		
		public function doValidate(str:String) :Boolean{
			var fi:String = StringUtil.filter(str, StringUtil.NUMBERS);
			//returns only numbers, no spaces or -
			if (fi.length != 10) {
				 return false;
			 }
			return true;
		}
	}
}