package  com.troyworks.util{ 
	/*******************************
	 * A collection of string/text related utilities
	 * to help remove characters, useful
	 * for simple things like validation
	 * text manipulation
	 *  
	 * revised for AS3.0
	 * 
	 * */
	public class StringUtil
	{
		public static const NUMBERS : String = '0123456789';
		public static const FLOAT_NUM:String = NUMBERS + '.-';
		public static const CAP_LETTERS : String = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
		public static const LOW_LETTERS : String = 'abcdefghijklmnopqrstuvwxyz';
		public static const LETTERS : String = StringUtil.CAP_LETTERS + StringUtil.LOW_LETTERS ;
		public static const ALPHA_NUM : String = StringUtil.CAP_LETTERS + StringUtil.LOW_LETTERS + StringUtil.NUMBERS;
		public static const BASIC_MATH_ADD_SUBTRACT:String = "+-";
		public static const BASIC_MATH_DIVIDE_MULTIPLY:String = "*/";
		public static const KEY_SPACE : String = ' ';
		public static const WHITE_SPACE:String =' \r\t\n';
		public static const EMAIL : String = StringUtil.ALPHA_NUM + '.@-+_';
		/************************************************************
		* Removes the leading and trailing whitespace
		* e.g. util.StringUtil.trim(' something '); //outputs 'something'*/
		public static function trim (str1 : String = null) : String
		{
			if (str1 == null)
			{
				return null;
			}
			var s : String = String (str1);
			//trace("len " + str.length + " " + str1.length );
			//firstCharacter
			var A : Number = 0;
			//lastCharacter
			var B : Number = s.length;
			//find first character
			for (var j : Number = 0; j < s.length; j ++)
			{
				// A useful character is anything over 32 (space, tab,
				// new line, etc are all below).
				var cc:Number = s.charCodeAt (j);
				//			trace("Testing char "+j + " == " + s.charAt(j) + ": " + s.charCodeAt(j));
				if ( cc> 32 && cc!= 160)
				{
				//	trace("first char "+j + " == " + s.charAt(j) + ": " + s.charCodeAt(j));
					A = j;
					break;
				} else if (j == s.length - 1)
				{
					//string is blank
					return '';
				}
			}
			//find last character
			for (var k : Number = s.length; k >= 0; k --)
			{
				// A useful character is anything over 32 (space, tab,
				// new line, etc are all below).
					var ccc:Number = s.charCodeAt (k);
				if (ccc > 32 && ccc!= 160)
				{
					B = k + 1;
					break;
				}
			}
			var rs : String = s.substring (A, B);
			//trace(str1 + " Trimmed to " + rs);
			return rs;
		}
		/*******************************************
		 * returns the first index of a character that is in the filterList
		 */
		public static function indexOf(input : Object, filter : String = "", filterIsWhiteList : Boolean = true):Number{
			if (input == null)
			{
				return NaN;
			}
			var str : String = String (input);
			
			filterIsWhiteList = (filterIsWhiteList) ?true : false;
			//---perform filter-----//
			for (var i : Number = 0; i < str.length; i ++)
			{
				var cc:String = str.charAt (i);
				var fc:Boolean = (filter.indexOf (cc) != - 1);
				if ((fc && filterIsWhiteList) || ( ! fc && ! filterIsWhiteList))
				{
					trace("StringUtil.indexOf = " + i);
					return i;
				}
			}
			return -1;
	
		}
		public static function lastIndexOf(input : Object = null, filter : String = "", filterIsWhiteList : Boolean = true):Number{
			if (input == null)
			{
				return NaN;
			}
			var str : String = String (input);
			filterIsWhiteList = (filterIsWhiteList) ?true : false;
			//---perform filter-----//
			for (var j : Number = str.length; j >= 0; j --)
			{
				var cc:String = str.charAt (j);
				var fc:Boolean = (filter.indexOf (cc) != - 1);
				if ((fc && filterIsWhiteList) || ( ! fc && ! filterIsWhiteList))
				{
					return j;
				}
			}
			return -1;
		}
		
		//////////////////////////////////////////////////////////////////
		// removes all non-alphanumeric characters from the input based on
		// the characters in the filter string. Can operate in either in pass
		// the filter characters (e.g. abbc[b] -> bb) or filterOut (e.g. abbc[!b] -> ac)
		//
		// and returns the filtered string
		//**warning** can be slow if both strings are large
		// @ input: item to filter which will be cast to String (toString()) if not already one
		// @ filter:String, list of characters to either pass or filter out. For convenience you can use
		//           the ones on the static .
		//	StringUtil.NUMBERS
		//  StringUtil.FLOAT_NUM
		//  StringUtil.CAP_LETTERS
		//  StringUtil.LOW_LETTERS
		//  StringUtil.LETTERS
		//  StringUtil.ALPHA_NUM
		//  StringUtil.KEY_SPACE
		// @ pass:Boolean, mode to pass or filter out.
		//and returns the filtered string
		/* EXAMPLE
		trace("'"+StringUtil.filter('  trim me 1!', StringUtil.LETTERS )+"'"); //'trimme'
		trace("'"+StringUtil.filter('  trim me 1!', StringUtil.LETTERS + " " )+"'"); //'  trim me '
		trace("'"+StringUtil.filter('  trim me 1!', StringUtil.LETTERS + " ", false )+"'"); //'1!'
		* */
		public static function filter (input : Object = null, filter : String = "", filterIsWhiteList : Boolean = true) : String
		{
			if (input == null)
			{
				return null;
			}
			var char_array:Array = new Array ();
			var str : String = String (input);
			filterIsWhiteList = (filterIsWhiteList) ?true : false;
			//---perform filter-----//
			for (var i : Number = 0; i < str.length; i ++)
			{
				var cc:String = str.charAt (i);
				var fc:Boolean = (filter.indexOf (cc) != - 1);
				if ((fc && filterIsWhiteList) || ( ! fc && ! filterIsWhiteList))
				{
					char_array.push (cc);
				}
			}
			return char_array.join ('');
		};
		//////////////////////////////////////////////////////////////////////////////
		// Determines if a field has no characters or only white space input into it
		// or fails to meet a minimum number of characters
		/*	trace("'"+StringUtil.isEmpty('  trim me 1!')+"'");
		//'false!'
		trace("'"+StringUtil.isEmpty('  ')+"'");
		//'true'
		trace("'"+StringUtil.isEmpty('AAA!')+"'");
		//'false'
		//looking for a minimum of 5 characters
		trace("'"+StringUtil.isEmpty('AAA!', 5)+"'");
		//'true'
		trace("'"+StringUtil.isEmpty(null)+"'");
		//'true'
		trace("'"+StringUtil.isEmpty(undefined)+"'");
		//'true'*/
		public static function isEmpty (input : Object = null , min_chars : * = undefined) : Boolean
		{
			if (input == null)
			{
				return true;
			} else
			{
				var str : String = StringUtil.trim (String (input));
				if (str == '')
				{
					return true;
				} else if (min_chars == undefined && str.length < min_chars)
				{
					return true;
				} else
				{
					return false;
				}
			}
		}
				//parsing variables by type - valtozok ertelmezese tipus szerint
		public static function getBoolean(att:String,def:Boolean):Boolean {
			if(def!=undefined && att==null) {
				return def;
			}
			if(att=="true") return true;
			else return false;
		}
		public static function getNumber(att:String,def:Number):Number {
			if(def!=undefined && att==null) {
				return def;
			}
			return Number(att);
		}
		public static function getString(att:String,def:String) :String{
			if(def!=undefined && att==null) {
				return def;
			}
			return String(att);
		}
	
	}
	
}