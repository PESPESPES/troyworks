package com.troyworks.autocomplete.ui { 
	import util.StringUtil;
	import com.troyworks.autocomplete.WordMatch;
	/**
	 * @author Troy Gardner
	 * //var _mc = _root.createEmptyMovieClip("ac_tb", 1234);
	ac_tb = new AutoCompleteTextBox();
	ac_tb.setCanvas(_root.input_mc);
	ac_tb.createChildren();
	 */
	import flash.ui.Keyboard;
	import flash.display.MovieClip;
	import flash.text.TextField;
	public class AutoCompleteComboBox extends MovieClip {
		
		public var wm:WordMatch;
		public var canvas:MovieClip;
		public var input_txt:TextField;
		public var shadow_txt:TextField;
		public var _lb:MovieClip;//ListBox
	
		protected var height : Number;
	
		protected var width : Number;
	
		protected var cci : Number;
	
		protected var si : Number;
	
		protected var a : Number;
	
		protected var lword : Object;
	
		protected var b : Number;
		
		public function AutoCompleteComboBox() {
			super();
		}
	
	public function createChildren () : void {
		= this.canvas.createTextField("input_txt = new TextField();
		= this.canvas.createTextField("addChildAt(= this.canvas.createTextField("input_txt, 1);
		= this.canvas.createTextField("input_txt.width = this.width;
		= this.canvas.createTextField("input_txt.height = this.height;
		
		this.input_txt.type = "input";
		this.input_txt.border = true;
			this.input_txt.background = true;
		this.input_txt.backgroundColor = 0xffffff;
		this.input_txt.text = "please enter search term here";
		= this.canvas.createTextField("sshadow_txt = new TextField();
		= this.canvas.createTextField("saddChildAt(= this.canvas.createTextField("sshadow_txt, 0);
		= this.canvas.createTextField("sshadow_txt.width = this.width;
		= this.canvas.createTextField("sshadow_txt.height = this.height;
		
		this._lb = this.canvas.attachMovie("FListBoxSymbol", "_lb", 3);
		//var _array = ["help", "me", "figure"];
		//this._lb.setDataProvider(_array);
		this.input_txt.owner = this;
		this.input_txt.init = false;
		this.input_txt.onKillFocus = function() {
			trace("kill focus----------------------------");
			Keyboard.removeListener(Object(this).owner);
		};
		this.input_txt.onSetFocus = function() {
			trace("onSetFocus------------------------");
			if (!Object(this).init) {
				Object(this).text = "";
				Object(this).init = true;
			}
			Keyboard.addListener(Object(this).owner);
		};
		this.input_txt.onChanged = function () {
			trace(" changed "+Object(this).text);
			Object(this).owner.onChangedPositioner();
		};
		this.onChangedPositioner();
		this._lb.visible = false;
	};
	public function getLabel () : String {
		trace("getLabel");
		return this.input_txt.text;
	};
	public function onKeyDown () : void {
		trace("You pressed a key.");
	};
	public function onKeyUp () : void {
		trace("You released a key.");
		var k = Keyboard.getCode();
		switch (k) {
		case Keyboard.DOWN :
			//move index down
			trace("keydown "+this.cci);
			this._lb.setSelectedIndex(this._lb.getSelectedIndex()+1);
			Selection.setSelection(this.cci, this.cci);
			break;
		case Keyboard.UP :
			//move index up
			trace("keyup"+this.cci);
			this._lb.setSelectedIndex(this._lb.getSelectedIndex()-1);
			Selection.setSelection(this.cci, this.cci);
			break;
		case Keyboard.ENTER :
			//select 
			var a_str:String = this.input_txt.text.substring(0, this.a+1);
			trace("onEnter '"+a_str+"'");
			var _str = "";
			var v_str = this._lb.getValue();
			if (a_str != null && v_str != null) {
				_str = a_str+v_str+" ";
				this.input_txt.text = _str;
				this._lb.visible = false;
				Selection.setSelection(_str.length, _str.length);
			}
			break;
		default :
			this.cci = Selection.getCaretIndex();
			this.si = 0;
			var cText:String = StringUtil.trim(this.lword);
			trace("terms in put '"+cText+"' "+_global.wm);
			wm.reset();
			var res:Array = wm.getMatches(cText);
			//trace((res == null)+" matches exact: "+res[0]+" possible: "+res[1]);
			var em:Boolean = (res[0] != null);
			var pm:Boolean = (res[1] != null);
			if (em && pm) {
				trace(" \t exact matches too");
				var o:Object = res[0];
				var _ary:Array = res[1];
				_ary.unshift(o);
				this._lb.setDataProvider(new Array());
				this._lb.setDataProvider(_ary);
			} else if (pm) {
				trace(" \t possible matches");
				trace("data provider len "+_root.terms_input.dataProvider.items.length);
				var _ary:Array = res[1];
				this._lb.setDataProvider();
				this._lb.setDataProvider(_ary);
			} else if (em) {
				//exact match no need to show.
			} else {
				//no match
			}
			if (em || pm) {
				this._lb.visible = true;
				this._lb.setSelectedIndex(0);
			} else {
				this._lb.visible = false;
			}
			break;
		}
	};
	public function onChangedPositioner () : void {
		this.shadow_txt.text = this.input_txt.text;
		this.shadow_txt.autoSize = true;
		this.shadow_txt.visible = false;
		//_root.cursor.x = _root.input2_txt.x+_root.input2_txt.width-16;
		//_root.cursor.y = _root.input_txt.y+_root.input_txt.height;
		this._lb.x = this.shadow_txt.x+this.shadow_txt.width-4;
		this._lb.y = this.input_txt.y+this.input_txt.height;
		var firstWord:Number = this.input_txt.text.indexOf(" ", 0);
		var lastWord:String = "";
		if (firstWord == -1) {
			var lastWord:String = this.input_txt.text;
			this.a = -1;
			// lastWord.length;
			trace("first Word "+lastWord);
		} else {
			//split last word fragment off.
			this.a = this.input_txt.text.lastIndexOf(" ", this.input_txt.text.length);
			this.b = this.input_txt.text.length;
			//trace("a "+this.a+" b "+this.b);
			var lastWord:String = this.input_txt.text.substring(this.a, this.b);
			trace("last Word "+lastWord);
		}
		this.lword = lastWord;
	};
	public function destroyChildren () : void {
	};
	public function setCanvas (canvas:MovieClip) : void {
		this.canvas = canvas;
		this.width = this.canvas.width;
		this.height = this.canvas.height;
	};
	
		
	}
}