package util { 
	public class DataValidation
	{
		/* does basic email validation, note doesn't check for top level domain validity
		*  as those might change.
		* EXAMPLE
		* var ary = new Array();
		ary.push("troy");
		ary.push("troy@test.com");
		ary.push("troy@test");
		ary.push("troy@test.com.com");
		ary.push("123troy@test.com.com");
	
		for(var i in ary){
		trace(ary[i]  + " " + DataValidation.isEmail(ary[i]));
		}
		//OUTPUTS
		123troy@test.com.com true
		troy@test.com.com true
		troy@test false
		troy@test.com true
		troy false
		*/
		public static function isEmail (inputValue : String) : Boolean
		{
			var parts : Array = inputValue.split ("@");
			if (parts.length != 2)
			{
				// 1 and only 1 @
				return false;
			}
			var user : String = parts [0];
			var domain : String = parts [1];
			/////////validate user////////////////
			if (user.length == 0)
			{
				return false;
			} if (user.indexOf (".") == 0)
			{
				return false;
			} if (domain.indexOf (".") == - 1)
			{
				return false;
			} if (inputValue.indexOf ("..") != - 1 || inputValue.indexOf ("@.") != - 1 || inputValue.indexOf (".@") != - 1)
			{
				return false;
			}
			/////////validate domain/////////////
			var domainParts : Array = domain.split (".");
			var countryCode = domainParts [domainParts.length - 1];
			//not just domainParts[1], because emails can be bob@mrq.gouv.qc.ca
			if (countryCode.length < 2)
			{
				return false;
			}
			//var okChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.@-+_";
			// ref : http://www.remote.org/jochen/mail/info/chars.html
			var onlyOKs = StringUtil.filter (inputValue, StringUtil.EMAIL);
			if (onlyOKs != inputValue)
			{
				return false;
			} else
			{
				// no errors found, address is OK
				return true;
			}
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
			var fil = StringUtil.filter (inputValue, StringUtil.FLOAT_NUM);
			var rst = ! isNaN (Number (fil));
			//trace(val + "isNumber " + rst);
			return rst;
		};
	}
	
}