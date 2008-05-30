package com.troyworks.data.validators {
	import com.troyworks.util.StringUtil; 

	/**
	 * @author Troy Gardner
	 */
	public class StringValidator extends Validator {
		public var minLength : Number = NaN;
		public var maxLength : Number = NaN;
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
		override public function reset() : void{
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
			if (!isNaN(minLength) && len <minLength ){
				passed = false;
				trace("failed min leng");
				passedMinLength = false;
			 }
			 
			//////////// CHECK MAX LENGTH ///////////////
			 if (!isNaN(maxLength) && len >maxLength ){
				passed = false;
				trace("failed max len");
				passedMaxLength = false;
			 }
	
			return passed;
			 
		}
			///////////////////////////////////////////////////
		// a utility to parse numbers input as strings
		// won't handle percentages
		////////////
		/*EXAMPLE
		var ary = new Array();
		ary.push("troy");
		ary.push("1.0");
		ary.push("1231");
		ary.push("-1");
		ary.push("-1.0");
		for (var i in ary) {
		trace(ary[i]+" "+DataValidation.isNumber(ary[i]));
		}
		OUTPUTS-1.0 true
		-1 true
		1231 true
		1.0 true
		troy false*/
		public static function isNumber (inputValue : Object) : Object {
			var fil:String = StringUtil.filter (inputValue, StringUtil.FLOAT_NUM);
			var res:Boolean = ! isNaN (Number (fil));
			//trace(val + "isNumber " + res);
			return res;
		};
	}
}