package com.troyworks.text {
	import flash.display.DisplayObjectContainer;
	import flash.text.AntiAliasType;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;		

	/**
	 * A simple utility when working with a collection of textfields
	 *  that allow view/edit states
	 * @author Troy Gardner
	 */
	public class TextFieldUtil {
		public static function turnEditable(aryOfTextFields : Array) : void {
			var i : int = 0;
			var n : int = aryOfTextFields.length;
			var txt : TextField;
			for(;i < n;++i) {
				txt = aryOfTextFields[i] as TextField;
				txt.type = TextFieldType.INPUT;
				txt.embedFonts = true;
				txt.border = true;
				txt.background = true;
				txt.selectable = true;
			//	txt.tabEnabled = true;
						
					//view.cert_mc.student_txt.tabIndex = ti++;
			}
		}

		public static function turnViewable(aryOfTextFields : Array) : void {
			var i : int = 0;
			var n : int = aryOfTextFields.length;
			var txt : TextField;
			for(;i < n;++i) {
				txt = aryOfTextFields[i] as TextField;
				txt.type = TextFieldType.DYNAMIC;
				txt.border = false;
				txt.background = false;
				txt.selectable = false;
				txt.setSelection(-1, -1);
			//	txt.tabEnabled = false;
			}
		}

		public static function getChildren(parent : XML) : XML {
			trace("getChildren " + parent);
			var body : XML = <span></span>;
			//new XML();
			var children : XMLList = parent.children();
			
			for each(var child in children) {
				trace("adding child " + child.toString());
				body.appendChild(child);
			}
			trace("returning  " + body);
			return body;
		}

		
		// Takes a TextField on the Timeline and swaps it out with an
		// identical Script based TextField.  Becuase a Timeline based
		// textField has many restrictions:
		// - it cannot have it's name modified (useful for some form processing)
		// - it cannot access runtime loaded embedded fonts 
		// used like
		// EXAMPLE: 1
		//   fillinblank_txt = TextFieldUtil.swapWithClone(fillinblank_txt);
		//NOTE that this works but won't replace the local reference
		// EXAMPLE: 2 
		// TextFieldUtil.swapWithClone(fillinblank_txt);
		public static function  swapWithClone(txt : TextField, embed : Boolean = true, CSSMode : Boolean = false) : TextField {
			trace("swapWithClone..............." + txt.name);
			var par : DisplayObjectContainer = txt.parent;

			var tf : TextField = new TextField();
			if(CSSMode) {
				var ss : StyleSheet = new StyleSheet();
				ss = TextFormatUtil.getTextFormatAsCSS(txt);
				trace("ss.fontSize" + ss.getStyle("p").fontSize);
				var tff : TextFormat = txt.defaultTextFormat;
				tff.size = ss.getStyle("p").fontSize;
				tff.font = tff.font;
				tf.defaultTextFormat = tff;
				tf.styleSheet = ss;
			}else{
				trace("using textFormat " + txt.defaultTextFormat);
				tf.defaultTextFormat = txt.defaultTextFormat;
			}
			trace("txt.type " + txt.type);
			tf.type = "input";
			//txt.type;
			tf.multiline = txt.multiline;
			//tf.numLines = txt.numLines;
			tf.autoSize = txt.autoSize;
			tf.background = txt.background;
			tf.border = txt.border;
			tf.borderColor = txt.borderColor;
			//tf.bottomScrollV = txt.bottomScrollV;
			tf.condenseWhite = txt.condenseWhite;
			tf.displayAsPassword = txt.displayAsPassword;
			tf.gridFitType = txt.gridFitType;
			tf.maxChars = txt.maxChars;
			//	tf.maxScrollH = txt.maxScrollH;
			//	tf.maxScrollV = txt.maxScrollV;

			tf.width = txt.width;
			tf.height = txt.height;
			tf.x = txt.x;
			tf.y = txt.y;
			//	tf.border = true; 
			if(embed) {
				tf.embedFonts = true;
				tf.antiAliasType = AntiAliasType.ADVANCED;
				//tf.rotation = 15;
			//	txt.visible = false;
			}
			
  
			
			if(CSSMode) {
				tf.selectable = true;
				tf.multiline = true;
				tf.wordWrap = false;
				tf.condenseWhite = false;
				trace("swapClip htmlText " + txt.htmlText);
				var html : String = "<p>" + txt.text + "</p>";
				tf.htmlText = html;
			}else {
				tf.selectable = txt.selectable;
				tf.multiline = txt.multiline;
				tf.wordWrap = txt.wordWrap;
				tf.condenseWhite = txt.condenseWhite;
				tf.htmlText = txt.htmlText;
			}
			tf.name = txt.name + "";
			tf.filters = txt.filters;
	      
			//	        par
			par.addChildAt(tf, par.getChildIndex(txt));
			par.removeChild(txt);
			return tf;
		}
	}
}
