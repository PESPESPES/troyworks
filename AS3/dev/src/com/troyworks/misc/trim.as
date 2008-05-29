package  { 
	//removes the leading and trailing space of the string.
	
	_global.Trim = function (str1) {
		public var char_array = new Array();
		//find first character
		public var firstChar = 0;
		public var str = null;
		if( typeof(str1) =="string"){
			//trace( "is string");
			str = str1;
		}else {
			//trace ("inst");
			str = new String(str1);
		}
		//trace("len " + str.length + " " + str1.length );
	
		public var lastChar = str.length;
		for (public var j=0; j<str.length; j++) {
			// A useful character is anything over 32 (space, tab,
			// new line, etc are all below).
			if (str.charCodeAt(j)>32) {
				//trace("first char "+j);
				firstChar = j;
				break;
			}
		}
		//find last character
		for (var j=str.length; j>=0; j--) {
			// A useful character is anything over 32 (space, tab,
			// new line, etc are all below).
			if (str.charCodeAt(j)>32) {
				lastChar = j+1;
				break;
			}
		}
		//	trace(firstChar+" "+lastChar);
		var rs = str.substring(firstChar, lastChar);
		return rs;
	};
	
	String.prototype.Trim = function() {
		this = Trim(this);
	};
	/////////////////////////////////
	//
	//for(var i:Number = 0; i < 256; i++){
	//	var c = String.fromCharCode(i);
	//	_global.trimAlphaNumericOnly(c);
	//}
	_global.trimAlphaNumericOnly = function(str1) {
		var char_array = new Array();
		//find first character
		var firstChar = 0;
		var str = null;
		if (typeof (str1) == "string") {
			//trace( "is string");
			str = str1;
		} else {
			//trace ("inst");
			str = new String(str1);
		}
		//trace("len " + str.length + " " + str1.length );
		for (var j = 0; j<str.length; j++) {
			// A useful character is anything over 32 (space, tab,
			// new line, etc are all below).
	
			public var sc = str.charCodeAt(j);
			public var c =  str.charAt(j);
			public var addc = false;
			if (48<=sc && sc<=57) {
				//numbers
				addc = true;
			} else if (65<=sc && sc<=90) {
				//caps
				addc = true;
			} else if (97<=sc && sc<=122) {
				//lower case
				addc = true;
			}
			if (addc) {
				//trace("adding "+c);
				char_array.push(c);
			} else {
				//trace("NOT adding "+c);
			}
		}
		return char_array.join();
	};
	
}