package com.troyworks.validators { 
	import util.StringUtil;
	
	/**
	 * @author Troy Gardner
	 */
	public class EmailValidator extends Validator {
		
		public var passedSimpleEmail:Boolean;
		public function EmailValidator() {
			super();
			
		}
		public function reset():void{
			passedSimpleEmail = true;
		}
		public function doValidate(str : String) : Boolean{
			 reset();
			var passed:Boolean = true;
			var abc:Array=		 str.split("@");
			var bc:Array = abc[1].split(".");
			var AA:String = StringUtil.filter(abc[0], StringUtil.WHITE_SPACE, false);
			var BB:String = StringUtil.filter(bc[0], StringUtil.WHITE_SPACE, false);
			var CC:String = StringUtil.filter(bc[1], StringUtil.WHITE_SPACE, false);
		//	trace("HIGHLIGHT  AA " + AA + " BB " + BB + " CC" +CC);
	 
	 		if(AA.length < 1 || BB == null || BB.length < 1 || CC == null || CC.length <1 || CC.length > 4){
	 		//	trace("ERROR didn't pass");
	 			passed = false;
	 			passedSimpleEmail = false;
	 		}
	
	
			 return passed;
			 
		}
	}
}