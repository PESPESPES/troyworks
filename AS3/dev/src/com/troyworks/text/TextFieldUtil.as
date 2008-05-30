package com.troyworks.text {
	import flash.text.TextField;
	import flash.text.TextFieldType;	

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
			}
		}
	}
}
