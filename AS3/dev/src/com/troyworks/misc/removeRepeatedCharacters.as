package  { 
	 /* > st = getTimer ();
	import flash.utils.getTimer;
	> s = removeRepeatedChars (s, 2);
	> trace ('1: ' + (getTimer () - st));
	>> st = getTimer ();
	> s = removeRepeatedChars2 (s, 2);
	> trace ('2: ' + (getTimer () - st));
	*/
	 function removeRepeatedChars2 (str, amount_num)
	{
		public var new_str = str;
		public var counter_num = 0;
		while (counter_num < new_str.length)
		{
			var c = new_str.charAt (counter_num ++);
			var joinOn_str = "";
			var charCount_num = amount_num;
			while (charCount_num --)
			{
				joinOn_str += c;
			};
			new_str = new_str.split (joinOn_str + c + c).join (joinOn_str).split (joinOn_str + c).join (joinOn_str);
		};
		return new_str;
	};
	//doesn't do numbers or www.
	function removeRepeatedChars (s, maxRepetition)
	{
		public var s = s.split ('');
		public var c = 1;
		for (public var i = 1, len = s.length + 1; i < len; i ++)
		{
			if (s [i] == s [i - 1] and s [i].toUpperCase () != "W" and isNaN (Number (s [i])))
			{
				c ++;
	
			}else
			{
				if (c > maxRepetition)
				{
					var r = c - maxRepetition;
					s.splice (i - r, r);
					i -= r;
					len -= r;
	
				} c = 1;
	
			}
		} return s.join ('');
	
	}
	//Here's a function I created and use extensively
	//that will allow for a single char or a string portion delete or exchange.
	//To delete, just use "" as the theNewSegment:
	/*TEST CODE
	* myString = "Hello, this is me saying saying hello to you";
	// // deletes duplicate word in this case.
	myString = string_exchange(myString, "saying saying", "saying"); //
	
	}
	// RESULT: myString = "Hello, this is me saying hello to you"; Sincerel
	
	* /
	function string_exchange (theString, theSegment, theNewSegment)
	{
	// the addition of "" is done to make sure if a movie path
	// is passed, it is treated as a string and not an object or _target
	theString = "" + theString;
	var theNewString = "";
	theArray = new Array ();
	theArray = theString.split (theSegment);
	for (i = 0; i < theArray.length; i ++)
	{
	if (i == 0)
	{
	theNewString += theArray [i];
	
	} else
	{
	theNewString += theNewSegment + theArray [i];
	
	}
	} return theNewString;
	
	}
	
	
}