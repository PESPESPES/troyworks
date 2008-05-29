package com.troyworks.validators { 
	import util.StringUtil;
	
	/**
	 * @author Troy Gardner
	 */
	public class StringValidator extends Validator {
		public var minLength : Number = null;
		public var maxLength : Number = null;
		public var trim : Boolean = true;
		public var checkNotWhiteSpace : Boolean = true;
	
		public var passedMinLength : Boolean;
		public var passedMaxLength : Boolean;
		public var passedWhiteCaseLength : Boolean;
	
		public function StringValidator(min : Number, max : Number) {
			super();
			minLength = min;
			maxLength = max;
			reset();
		}
		public function reset() : void{
			passedMinLength = true;
			passedMaxLength = true;
			passedWhiteCaseLength = true;
		}
		public function doValidate(str : String) : Boolean{
			reset();
			var fi : String = (trim)? StringUtil.trim(str):str;
			trace(" " +fi  + " " + fi.length);
			var len : Number = fi.length;
			var passed : Boolean = true;
			 //////////// CHECK NOT WHITE SPACE //////
			 if(checkNotWhiteSpace){
				fi = StringUtil.filter(fi, StringUtil.WHITE_SPACE, false);	
				 if(fi.length == 0){
					passed = false;
					trace("failed whitespace");
					passedWhiteCaseLength = false;
				 } 	
			 }
			//////////// CHECK MIN LENGTH ///////////////
			if (minLength != null && len <minLength ){
				passed = false;
				trace("failed min leng");
				passedMinLength = false;
			 }
			 
			//////////// CHECK MAX LENGTH ///////////////
			 if (maxLength != null && len >maxLength ){
				passed = false;
				trace("failed max len");
				passedMaxLength = false;
			 }
	
			return passed;
			 
		}
	}
}