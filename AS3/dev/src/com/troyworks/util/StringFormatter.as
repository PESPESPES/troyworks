package com.troyworks.util { 

	//---------------------------------------------------------------------------
	/*******************************************************
	*
	*
	* A Utility to format Strings to title case e.g.
	*---------------doEveryword=false -----everyword(default)
	* TITLE CASE => Title case  Title Case
	* title case => Title case  Title Case
	*
	*TODO: add list of strings to omit (e.g. to, a, and).
	*-----------TEST CASES-------------------//
	startTest = function () {
	trace("start Test ");
	_root.pushbutton.SetLabel("running test");
	var testRUns = 10;
	while (testRUns--) {
	var SF = new StringFormatter();
	var testCase1 = "all lower case stuff";
	var testCase2 = "ALL CAPITALS STUFF";
	var testCase3 = "Title Case Stuff";
	//expected responses///////////////
	var sct1 = "All Lower Case Stuff";
	var sct2 = "All Capitals Stuff";
	var sct3 = "Title Case Stuff";
	var sct4 = "All lower case stuff";
	var sct5 = "All capitals stuff";
	var sct6 = "Title case stuff";
	var tr0 = SF.toTitleCase(testCase1);
	var tr1 = SF.toTitleCase(testCase1, true);
	var tr2 = SF.toTitleCase(testCase2, true);
	var tr3 = SF.toTitleCase(testCase3, true);
	var tr4 = SF.toTitleCase(testCase1, false);
	var tr5 = SF.toTitleCase(testCase2, false);
	var tr6 = SF.toTitleCase(testCase3, false);
	trace("'"+tr0+"' passesTest: "+(tr0 == sct1));
	trace("'"+tr1+"' passesTest: "+(tr1 == sct1));
	trace("'"+tr2+"' passesTest: "+(tr2 == sct2));
	trace("'"+tr3+"' passesTest: "+(tr3 == sct3));
	trace("'"+tr4+"' passesTest: "+(tr4 == sct4));
	trace("'"+tr5+"' passesTest: "+(tr5 == sct5));
	trace("'"+tr6+"' passesTest: "+(tr6 == sct6));
	}
	_root.pushbutton.SetLabel("finishing test");
	};
	
	********************************************************/
	public class StringFormatter {
		public var DoEveryWord:Boolean = false;
		public function StringFormatter(DoEveryWord:Boolean){
			this.DoEveryWord = (DoEveryWord == null) ? true : false;
		}
		public function toTitleCase2 (d_str : String, DoEveryWord : Boolean) : String
		{
			var b = (DoEveryWord != null) ? DoEveryWord : this.DoEveryWord;
			return StringFormatter.toTitleCase (d_str, b);
		}
		public static function toTitleCase (d_str : String, DoEveryWord : Boolean) : String
		{
			//	trace(" '"+d_str+"' to titlecase");
			if (DoEveryWord)
			{
				var fields = d_str.split (" ");
				//var res_str = new String("");
				//	trace("found words: "+fields.length);
				for (var i in fields)
				{
					//trace(i+" "+fields[i]);
					//since the split function removes whitespace, we have to add it back
					fields [i] = fields [i].charAt (0).toUpperCase () + fields [i].substr (1).toLowerCase () + ((i == fields.length - 1) ? "" : " ");
				}
				return fields.join ("");
				//return res_str;
	
			} else
			{
				//	trace("doing word");
				return d_str.charAt (0).toUpperCase () + d_str.substr (1).toLowerCase ();
			}
		}
	}
	
}