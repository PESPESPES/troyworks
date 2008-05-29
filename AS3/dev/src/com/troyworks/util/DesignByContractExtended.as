package com.troyworks.util
{
	public class DesignByContractExtended extends DesignByContract
	{
		public static  const IS_EQUAL_BYSTRING : String = "=string=";
		public static  const IS_EQUAL : String = "==";
		public static  const IS_EQUAL_TOREF : String = "===";
		public static  const IS_NOT_EQUAL : String = "!=";
		public static  const IS_LESS_THAN : String = "<";
		public static  const IS_LESS_THAN_OR_EQUAL : String = "<=";
		public static  const IS_GREATER_THAN_OR_EQUAL : String = ">=";
		public static  const IS_GREATER_THAN : String = ">";
		public static  const ADDED_TO_SELF_EQUALS : String = "+=";
		public static  const SUBTRACTED_FROM_SELF_EQUALS : String = "-=";
		public static  const DIVIDED_BY_SELF_EQUALS : String = "/=";
		public static  const MULTIPLIED_BY_SELF_EQUALS : String = "*=";
		
		public function DesignByContractExtended(){
			super();
		}
		
		public static function ASSERT_TEST(a : Object, test : String, b : Object, aDescription : String, bDescription : String, failedMessage : String):String {
			var res : Array = new Array();
			res.push("'");
			res.push((aDescription == null)?a.toString():aDescription);
			trace("A:\r'" + a.toString() +"' \r" + test+" \r" +"B:\r'"+ b.toString()+"'");
			res.push("' " + test + " '");
			res.push((bDescriptionXXX == null)?b.toString():aDescription);
			res.push("'");
			var passes : Boolean = false;
			switch (test) {
				case IS_EQUAL_BYSTRING :
					var ass : String = String(a);
					var bs : String = String(b);
					//trace("    A B:");
					var len : Number = Math.max( ass.length, bs.length);
					for (var i : Number = 0; i <len; i++) {
						var ac : String = (i >= ass.length)?'null':ass.charAt(i);
						var bc : String = (i>= bs.length)?'null':bs.charAt(i);
						var tc : Boolean = (ass.charAt(i) == bs.charAt(i));
						var tcf : String = (tc)? "true" :" *** FALSE *** ";
						//trace(" " + i + "= "+ ac + " " + bc + " equals? " + tcf);
					}
//trace("    A B.");
					passes = ( ass == bs);
					break;
				case IS_EQUAL :
					passes = (a == b);
					break;
				case IS_EQUAL_TOREF :
					passes = (a === b);
					break;
				case IS_NOT_EQUAL :
					passes = (a != b);
					break;
				case IS_LESS_THAN :
					passes = (a < b);
					break;
				case IS_LESS_THAN_OR_EQUAL :
					passes = (a <= b);
					break;
				case IS_GREATER_THAN :
					passes = (a > b);
					break;
				case IS_GREATER_THAN_OR_EQUAL :
					passes = (a >= b);
					break;
					/*case ADDED_TO_SELF_EQUALS:
					passes = (a += b);
					break;
					case SUBTRACTED_FROM_SELF_EQUALS:
					passes = (a -= b);
					break;
					case DIVIDED_BY_SELF_EQUALS:
					passes = (a /= b);
					break;
					case MULTIPLIED_BY_SELF_EQUALS:
					passes = (a *= b);
					break;
					*/
			}
			res.push(" passes? " + ((passes)?"TRUE":"FALSE"));
			if (!passes) {
				res.push("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
				res.push(failedMessage);
				res.push("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
				var err:DesignByContractEvent = new DesignByContractEvent(failedMessage);
				DesignByContract.getInstance().onAssertFailed(err);

			}
			trace("ASSERT_TEST " + res.join(""));
			return res.join("");
		}
	}
}