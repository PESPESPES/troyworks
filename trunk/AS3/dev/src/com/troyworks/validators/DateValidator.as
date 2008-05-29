package com.troyworks.validators { 
	
	/**
	 * @author Troy Gardner
	 */
	public class DateValidator extends Validator {
		public var minDate : Date = null;
		public var maxDate : Date = null;
		public var checkIsNotToday : Boolean = false;
	
		public var passedIsNotNullDate : Boolean;
		public var passedMinDate : Boolean;
		public var passedMaxDate : Boolean;
		public var passedIsNotToday : Boolean;
	
		public function DateValidator(min : Date, max : Date) {
			super();
			minDate = min;
			maxDate = max;
			reset();
		}
		public function reset() : void{
			passedIsNotNullDate = true;
			passedMinDate = true;
			passedMaxDate = true;
			passedIsNotToday = true;
		}
		public function doValidate(val : Date) : Boolean{
			reset();
			trace(" " +val);
			var passed : Boolean = true;
			 //////////// CHECK NOT WHITE SPACE //////
			 if(val == null){
				passed = false;
				trace("failed null");
				passedIsNotNullDate = false;
			 }
			//////////// CHECK MIN LENGTH ///////////////
			if (minDate != null && val.getTime() <minDate.getTime() ){
				passed = false;
				trace("failed min leng");
				passedMinDate = false;
			 }
			 
			//////////// CHECK MAX LENGTH ///////////////
			 if (maxDate != null&& val.getTime() >maxDate.getTime() ){
				passed = false;
				trace("failed max len");
				passedMaxDate = false;
			 }
	
			return passed;
			 
		}
	}
}