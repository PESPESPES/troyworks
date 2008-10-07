package com.troyworks.text {
	import flash.text.TextField;	
	import flash.text.TextFormat;	
	import flash.text.StyleSheet;	

	/**
	 * TextFormatUtil
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Sep 20, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class TextFormatUtil {
		public function TextFormatUtil() {
		}

		public static function getTextFormatAsCSS(txt : TextField, cssTag:String = "p", appendToCSS:StyleSheet = null) : StyleSheet {
			var res : StyleSheet = (appendToCSS == null)?new StyleSheet(): appendToCSS;
			
			var dft : TextFormat = txt.defaultTextFormat;
			var p : Object = new Object();
			
			
			p.color = "#"+dft.color.toString(16);
			trace("dft.color = " + dft.color + " " + p.color);   
			//0x000000 to //#000000
			//p.display

			p.fontFamily = dft.font;
			trace(" dft.size " + dft.size);
			p.fontSize = dft.size;
			p.fontStyle = (dft.italic) ? "italic" : "normal";
			p.fontWeight = (dft.bold) ? "bold" : "normal";
		
			var kn : Number = Number(getValueOfAttribute(txt.htmlText, 'KERNING="'));
			
			p.kearning = (kn==1 || dft.kerning) ? 'true' : 'false';
			trace(" dft.kerning " + dft.kerning + " " + kn +" > " + p.kearning );	  
			//truefalse
			p.leading = dft.leading;
			var ls : Number = Number(getValueOfAttribute(txt.htmlText, 'LETTERSPACING="'));
			
		
			p.letterSpacing = (!isNaN(ls))?ls:dft.letterSpacing;
				trace(" dft.letterSpacing " + dft.letterSpacing + " " + ls+" > " + p.letterSpacing );
			p.marginLeft = dft.leftMargin;
			p.marginRight = dft.rightMargin;
			p.textAlign = dft.align; 
			//left, center.right, justify
			p.textDecoration = (dft.underline) ? "underline" : "none";
			p.textIndent = dft.indent;
			res.setStyle(cssTag, p);
			return res;
		}

		public static function getValueOfAttribute(str : String, key : String) : Object {
			var res : Object = null; 
			var a : int = 0;
			var b : int = 0;
			a = str.indexOf(key);
			if(a > -1) {
				b = str.indexOf('"', a + key.length);
				res = str.substring(a + key.length, b);
				trace(key + " parsing '" + res + "'");
			}
		
			return res;
		}
	}
}

