package com.troyworks.templateengine { 
	import util.StringUtil;
	import com.troyworks.framework.BaseStatefulObject;
	import com.troyworks.data.ArrayX;
	/**
	 * @author Troy Gardner
	 */
	public class TemplateManager extends BaseStatefulObject{
	
		protected var labelIdx : Object;
		protected var labelDict:ArrayX;
		protected var missingLabels_array : ArrayX;
		public static var STARTCHAR:String = "{";
		public static var ENDCHAR:String = "}";
		public static var LINEBREAK_CHAR:String = "~";
		public function TemplateManager() {
			
		}
		///////////////////////////////////////////////
		// Gets the label from the label dictionary
		// from whatever placeholder string is passed in.
		// where "pre {btn_submit} mid {btn_help}" the 
		// values marked up by "{" (and including them)
		// are what's stored in the dictionary
		// @ param label_str =the string to parse
		// @ param strip = boolean on to strip "{" if nothing is found (for laternatl naves
		// @ param lineBreak = replace any '~' with a '\r' character (because databases can't store transmit the \r char"
		// TEST CODE:																
		//trace(getLabel("{test}")); // returns {!test!}
		//trace(getLabel("{test}", true)); // returns test
		//trace(getLabel("pre {test1} mid  {test2} post")); //returns {"pre {!test1!} mid  {!test2!} post"}
		//trace(getLabel("pre {test1} ~mid  ~{test2} ~post")); //returns {"pre {!test1!} \rmid  \r{!test2!} \rpost"}
		//
		public function getLabel(label_str : String, strip : Boolean, lineBreak : Boolean) : String {
			if (label_str == null || label_str == "") {
					return "";
			}
			label_str = StringUtil.trim(label_str);
			var s_array = label_str.split(ENDCHAR);
			var r_array = new Array();
			if (s_array.length>1) {
					for (var i = 0; i<s_array.length; i++) {
						var t_array = s_array[i].split(STARTCHAR);
					if (t_array.length>1) {
							r_array.push(t_array[0]);
						//trace("trying to get lable");
							var str = getLabelFromDictionary(t_array[1], strip);
						if (lineBreak) {
								str = replaceCharacters(str, LINEBREAK_CHAR, "\r");
						}
							r_array.push(str);
					} else {
							var str = t_array[0];
					    if (lineBreak) {
								str = replaceCharacters(str, LINEBREAK_CHAR, "\r");
						}
							r_array.push(str);
					}
				}
				// trace("getting label " + label_str + " found " + r_array.join(""));
					return r_array.join("");
			} else {
					var str = getLabelFromDictionary(label_str, strip);
				//trace("asking for label " + label_str + " found " + str);
				if (lineBreak) {
						str = replaceCharacters(str,LINEBREAK_CHAR, "\r");
				}
					return str;
			}
		};
		public function getLabelFromDictionary(pH : String, strip : Boolean) : String {
			//for(var i in internalAppRef.label.Data){
			//	trace("labelCheck " + i + " = "  + internalAppRef.label.Data[i]);
			//}
			if (pH == "") {
				return "";
			}
			var lbl:String = null;
			for(var i = 0; i < labelDict.length; i++){
				var dictionaryName = labelDict[i];
				lbl = labelIdx[dictionaryName][pH];
				if(lbl != null)
				   break;
			}
			//trace("asking for label " + pH + " found " + lbl);
			if (lbl != null) {
				//found label in dictionary
				return lbl;
			} else if (strip) {
				//use as is
				return pH;
			} else {
				// not found
			//	missingLabels_array.push("'"+pH+ "'");
			//	trace("missing labels\r" + missingLabels_array.toString());
			//	return pH;
				return "{!"+pH+"!}";
			}
		};
		public function setLabelData(dictionaryName : String, dictionary : Object) : void {
			if(labelIdx == null){
				labelIdx = new Object();
				labelDict = new ArrayX();
			}
			///////////// remove the dictionary if it's already there ///////////
			var len = labelDict.length;
			while(len--){
				var name = labelDict[len];
				if(name == dictionaryName){
					labelDict.splice(len,1);
					delete(labelIdx[name]);
					break;
				}
			}
			labelDict.push(dictionaryName);
			labelIdx[dictionaryName] = dictionary;
			missingLabels_array = new ArrayX();
		};
		/* Test Cases
		var s0 = "This ~is My First ~Test ~~ as you Know";
		var s1 = "This is My First Test as you Know";
		var s2 = "This is My First Test as you Know~";
		var s3 = "~This is My First Test as you Know";
		
		var s = replaceCharacters(s3, "~", "+r");
		trace(s);
		*/
		public function replaceCharacters(label_str:String, charToFind:String, charToReplaceWith:String) : String {
			var s_array:Array = label_str.split(charToFind);
			var r_array:Array = new Array();
			if (s_array.length>1) {
					for (var i = 0; i<s_array.length; i++) {
						r_array.push(s_array[i]);
					if (i<s_array.length-1) {
							r_array.push(charToReplaceWith);
					}
				}
				// trace("getting label " + label_str + " found " + r_array.join(""));
					return r_array.join("");
			} else {
					return label_str;
			}
		};
	
		public function replaceLabels(moddata:Object, useNameIfNotFound:Boolean, useDetailNameIfNotFound:Boolean) : String {
			moddata.LABEL = getLabel(moddata.LABEL, useNameIfNotFound);
			var _array = moddata.ITEMS;
			for (var i = 0; i<_array.length; i++) {
				_array[i].LABEL = getLabel(_array[i].LABEL, useDetailNameIfNotFound);
				_array[i].data = _array[i].RETURNPARAM;
			}
			moddata.data = new Object();
			moddata.data.cbdata = _array;
			moddata.data.lbdata = _array;
			return moddata;
		};	
	}
	
	
}