package util { 
	 /*
	*
	* @author
	* @version
	import flash.xml.XMLNode;
	*/
	public class Labels
	{
		public static var labelData : Object = new Object ();
		public static var dictionaryNames_array:Array = new Array ();
		public static var missingLabels_array:Array = new Array ();
		public function Labels ()
		{
		}
		///////////////////////////////////////////////
		// Gets the label from the label dictionary
		// from whatever placeholder string is passed in.
		// where "pre {btn_submit} mid {btn_help}" the
		// values marked up by "{" (and including them)
		// are what's stored in the dictionary
		// @ param label_str =the string to parse
		// @ param strip = boolean on to strip "{" if nothing is found
		// @ param lineBreak = replace any '~' with a '\r' character (because databases can't store transmit the \r char"
		// TEST CODE:
		//Labels.setLabelData("Default",{test:"TestF",test1:"Test1F"});
		//
		//trace(Labels.getLabel("{test}")); // returns {!test!}
		//trace(Labels.getLabel("{test}", true)); // returns test
		//trace(Labels.getLabel("pre {test1} mid  {test2} post")); //returns {"pre {!test1!} mid  {!test2!} post"}
		//trace(Labels.getLabel("pre {test1} ~mid  ~{test2} ~post")); //returns {"pre {!test1!} \rmid  \r{!test2!} \rpost"}
		//
		public static function getLabel (label_str:String, strip:Boolean, lineBreak:Boolean):String
		{
			if (label_str == null || label_str == "")
			{
				return "";
			}
			label_str = StringUtil.trim (label_str);
			var s_array:Array = label_str.split ("}");
			var r_array:Array = new Array ();
			if (s_array.length > 1)
			{
				for (var i:Number = 0; i < s_array.length; i ++)
				{
					var t_array:Array = String(s_array [i]).split ("{");
					if (t_array.length > 1)
					{
						r_array.push (t_array [0]);
						//	trace("trying to get lable " + t_array [1]);
						var str:String = Labels.getLabelFromDictionary (t_array [1] , strip);
						if (lineBreak)
						{
							str = StringUtil.replace (str, "~", "\r");
						}
						r_array.push (str);
					} else
					{
						var str:String = t_array [0];
						if (lineBreak)
						{
							str = StringUtil.replace (str, "~", "\r");
						}
						r_array.push (str);
					}
				}
				// trace("getting label " + label_str + " found " + r_array.join(""));
				return r_array.join ("");
			} else
			{
				var str:String   = Labels.getLabelFromDictionary (label_str, strip);
				//trace("asking for label " + label_str + " found " + str);
				if (lineBreak)
				{
					str = StringUtil.replace (str, "~", "\r");
				}
				return str;
			}
		};
		public static function getLabelFromDictionary (pH : String, strip : Boolean) : String
		{
			//for(var i in _global.internalAppRef.label.Data){
			//	trace("labelCheck " + i + " = "  + _global.internalAppRef.label.Data[i]);
			//}
			if (pH == "")
			{
				return "";
			}
			var lbl : String = null;
			for (var i:Number  = 0; i < Labels.dictionaryNames_array.length; i ++)
			{
				var dictionaryName:Number  = Labels.dictionaryNames_array [i];
				// trace(util.Trace.me(Labels.labelData [dictionaryName],"Labels.labelData [dictionaryName]", true));
				lbl = Labels.labelData [dictionaryName][pH];
				if (lbl != null) break;
			}
			//trace("asking for label " + pH + " found " + lbl);
			if (lbl != null)
			{
				//found label in dictionary
				return lbl;
			} else if (strip)
			{
				//use as is
				return pH;
			} else
			{
				// not found
				Labels.missingLabels_array.push ("'" + pH + "'");
				//	trace("missing labels\r" + Labels.missingLabels_array.toString());
				//	return pH;
				return "{!" + pH + "!}";
			}
		};
		public static function setLabelData (dictionaryName:String, dictionary:Array) : void
		{
			if (Labels.labelData == null)
			{
				Labels.labelData = new Object ();
				Labels.dictionaryNames_array = new Array ();
				Labels.missingLabels_array = new Array ();
			}
			var len : Number = Labels.dictionaryNames_array.length;
			while (len --)
			{
				var name:Array = Labels.dictionaryNames_array [len];
				if (name == dictionaryName)
				{
					Labels.dictionaryNames_array.splice (len, 1);
					delete (Labels.labelData [name]);
					break;
				}
			}
			Labels.dictionaryNames_array.push (dictionaryName);
			Labels.labelData [dictionaryName] = dictionary;
		};
		public static function parseLabelData (xml : Object) : void
		{
			if (xml is XMLNode)
			{
				var x : XMLNode = XMLNode (xml);
				var lblraw:String = String (x.firstChild);
				var keyVal : Array = lblraw.split (";");
				var dict : Object = new Object ();
				for (var i:String in keyVal)
				{
					var kv : Array = keyVal [i].split (",");
					var k:String = util.StringUtil.trim(kv [0]);
					var v:Object = kv [1];
					if (k != null)
					{
						dict [k] = v;
					//	trace ("'"+k + "'=='" + dict [k]+"'");
					}
				}
				var dName:String = "DEFAULT";
				Labels.setLabelData(dName, dict);
			}
		}
	}
	
}