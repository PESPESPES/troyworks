package  { 
	class com.troyworks.ui.EditableTextField extends TextField
	import flash.text.TextField;
	import flash.text.TextFormat;
	{
		public var history : Array;
		public var historyIdx : Number;
		public var onKilledFocusCallback : Function;
		public var rawText : String;
		public var defaultEditMode : String;
		public var curstate : String;
		public var laststate : String;
		public var textMode : String;
		public var tmpText : String;
		public var oldStyleSheet:Object;
		public var styleSheet:Object;
		public var oldBackgroundColor:Number;
		public var oldBackground:Boolean;
		public var owner:Object;
		public var hasBeenEdited:Boolean;
		public static var RB1 : String = '<FONT FACE="Myriad Pro" SIZE="25" COLOR="#FFFFFF">·</FONT>';
		public static var RB2 : String = '<FONT FACE="Myriad Pro" SIZE="25" COLOR="#FFFFFF">··</FONT>';
		public static var RB3 : String = '<FONT FACE="Myriad Pro" SIZE="25" COLOR="#FFFFFF">···</FONT>';
		public static var PB1 : String = '·';
		public static var PB2 : String = '··';
		public static var PB3 : String = '···';
		public function EditableTextField ()
		{
		}
		public static function initialize (txt : TextField) : void {
			//trace("initializing textfield");
			var t:EditableTextField = new EditableTextField ();
			txt.switchToMode = t.switchToMode;
			txt.setFocusHandler = t.setFocusHandler;
			txt.onKillFocusHandler = t.onKillFocusHandler;
			txt.onChangedHandler = t.onChangedHandler;
			//txt.goBackwardsInHistory = t.goBackwardsInHistory;
			//txt.goForwardInHistory = t.goForwardInHistory;
			txt.setUserInteraction = t.setUserInteraction;
			txt.enterWSYWIG_Edit = t.enterWSYWIG_Edit;
			txt.stripImageTag = t.stripImageTag;
			txt.stripImageTag2 = t.stripImageTag2;
			txt.restoreImageTags = t.restoreImageTags;
			txt.restoreImageTags2 = t.restoreImageTags2;
			txt.enterCodeEdit = t.enterCodeEdit;
			txt.leaveWSYWIG_Edit = t.leaveWSYWIG_Edit;
			txt.WSYWIG_to_View = t.WSYWIG_to_View;
			txt.leaveCode_Edit = t.leaveCode_Edit;
			txt.enterView = t.enterView;
			txt.leaveView = t.leaveView;
			txt.history = new Array ();
			txt.historyIdx = 0;
			txt.curstate = Application.getInstance ().currentEditViewMode.toUpperCase ();
			//"VIEW";
			txt.laststate = "";
			txt.tmpText = "";
			txt.hasBeenEdited = true;
			txt.defaultEditMode = "WSYWIG_EDIT";
			txt.curstate = "VIEW";
			txt.detectCSS = t.detectCSS;
			txt.convertCSStoTextFormat = t.convertCSStoTextFormat;
		}
		public function switchToMode (mode : String) : void {
			//		if(this.oldStyleSheet == null){
			//			this.oldStyleSheet = this.styleSheet;
			//		}
			//this.html = false;
			//trace("htmlOFF htmlText " + this.htmlText  + "  text " + this.text);
			//this.html = true;
			//trace(this.curstate + " A htmlText " + this.htmlText );
			mode = (mode == null) ? MDLClient.getInstance ().currentEditViewMode.toUpperCase () : mode.toUpperCase ();
			//trace ("com.troyworks.ui.EditableTextField.STATECHANGE " + this.curstate + "-->" + mode );
			if (mode == "EDIT")
			{
				mode = this.defaultEditMode;
			}
			switch (this.curstate)
			{
				case "WSYWIG_EDIT" :
				switch (mode)
				{
					case "PREVIEW" :
					case "VIEW" :
					this.WSYWIG_to_View ();
					break;
					case "WSYWIG_EDIT" :
					//ignore
					this.leaveWSYWIG_Edit ();
					this.enterWSYWIG_Edit ();
					break;
					case "CODE_EDIT" :
					this.leaveCode_Edit ();
					this.enterWSYWIG_Edit ();
					break;
				}
				break;
				case "CODE_EDIT" :
				switch (mode)
				{
					case "PREVIEW" :
					case "VIEW" :
					this.leaveCode_Edit ();
					this.enterView ();
					break;
					case "WSYWIG_EDIT" :
					this.leaveCode_Edit ();
					this.enterWSYWIG_Edit ();
					break;
					case "CODE_EDIT" :
					//ignore
					break;
				}
				break;
				case "VIEW" :
				switch (mode)
				{
					case "PREVIEW" :
					case "VIEW" :
					//ignore
					break;
					case "WSYWIG_EDIT" :
					this.leaveView ();
					this.enterWSYWIG_Edit ();
					break;
					case "CODE_EDIT" :
					this.leaveView ();
					this.enterCodeEdit ();
					break;
				}
				break;
			}
			//	trace(this.curstate + " B htmlText " + this.htmlText );
			this.laststate = this.curstate;
			this.curstate = mode;
		}
		public function setUserInteraction (turnOn : Boolean) : void {
			if (turnOn)
			{
				this.border = true;
				this.selectable = true;
				this.onSetFocus = this.setFocusHandler;
				this.onKillFocus = this.onKillFocusHandler;
				this.onChanged = this.onChangedHandler;
				this.onKillFocusHandler ();
			} else
			{
				this.selectable = false;
				this.border = false;
				this.onSetFocus = null;
				this.onKillFocus = null;
				this.onChanged = null;
			}
		}
		///////////////////////////
		// utility to determine the correct way to deal
		// with translating from CSS to the TextFormat
		// as if repeatedly done it introduces
		public function detectCSS () : void {
			if (this.htmlText.indexOf ('<p class=') > - 1)
			{
				//trace ("in CSS mode!!!!!");
				this.textMode = "CSS";
			} else
			{
				//trace ("in TextFormat mode!!!!!");
				this.textMode = "TextFormat";
			}
		}
		///////////////////////////////////////
		// convert <p class="B-Head">...</p> like tags
		// to <Font size=25, etc) that flash
		// uses for rich formatting.
		public function convertCSStoTextFormat () : void {
			/////////////////////////////////////////////////
			// (1) step one strip images out as CSS and images
			// causes issues with parsing, e.g. any font tags
			// around the image will end up as size=2, so typing
			// during editing will end up causing ultrasmall text
			//
			this.tmpText = this.htmlText + "";
			this.stripImageTag2 ();
			/////////////////////////////////////////////////////
			// (2) now that images are stripped
			// reparse the text as html (settin html = true in case coming from edit code mode).
			this.html = true;
			//this causes the htmlText to be reparsed
			this.htmlText = this.tmpText + "";
			//	trace ("\r\r 1.Reparse " + this.htmlText);
			// e.g. htmlText = <p class="B-HeadTitle">Formatting Styles: </p><p class="B-HeadTitle"></p>
			//save the reparsed text for the converstion to editable
			this.tmpText = this.htmlText + "";
			/////////////////////////////////////////
			// (3) make the field editable, this requires
			// a) changing the type to input
			// b) removing the stylesheet (as Flash prohibits changing CSS styled text)
			/////////////////////////////////////////
			//	trace("_AAhtml " + this.tmpText);
			if (this.styleSheet != null)
			{
				this.oldStyleSheet = this.styleSheet;
				//	trace("_AChtml " + this.htmlText);
				////////////////////////////////////////////////////////
				//this allows the text field to be reedited but costs the htmlText to be reparsed
				// which is causing extra tags to be inserted e.g.
				// <FONT SIZE="25" COLOR="#FFFFFF"></FONT>
				// if there is no tags with styles (e..g textformats, plain HTML P, FONT tags etc) and will cause an error
				this.styleSheet = null;
				//should be something like if coming from html the first time
				//NORMAL: <P ALIGN="LEFT"><FONT FACE="Myriad Pro" SIZE="40" COLOR="#9BDAFD">Formatting Styles: </FONT></P><P ALIGN="LEFT"><FONT FACE="Myriad Pro" SIZE="40" COLOR="#9BDAFD"></FONT></P>
				//the second time:
				//ERRROR: <P ALIGN="LEFT"><FONT FACE="Myriad Pro" SIZE="40" COLOR="#9BDAFD">Formatting Styles: <FONT SIZE="25" COLOR="#FFFFFF"></FONT></FONT></P><P ALIGN="LEFT"><FONT FACE="Myriad Pro" SIZE="25" COLOR="#FFFFFF"></FONT></P>
				//ERROR2: if there are textformat tags it tends to cause breaks in the editing? (is caused by textfields on stage having leading)
				//ERROR3?: if the textfield on stage is a single line it will cause issues with the end of the where some extra <p> </p> like tag is inserted
				// and this can't be see in the code (some DOM object).
				//         oddly setting multiline=true doens't fix the problem.
				// CSS loaded might be a cause? Xnope
				// Embedded fonts? Not
				//e.g.
				//<TEXTFORMAT LEADING="2"><P ALIGN="LEFT"><FONT FACE="Myriad Pro" SIZE="45" COLOR="#9BDAFD"><B>New England: Commerce and Religion</B></FONT></P></TEXTFORMAT>
				trace ("\r\r 2.Made CSS Editable  '" + this.htmlText + "'");
			}
		}
		////////////////////////////////////////
		public function enterWSYWIG_Edit () : void {
			//trace ("enterWSYWIG_Edit------------------------------------------");
			this.setUserInteraction (true);
			this.detectCSS ();
			switch (this.textMode)
			{
				case "CSS" :
				{
					this.convertCSStoTextFormat ();
				}
				break;
				case "TextFormat" :
				{
					///get the text prior to
					this.tmpText = this.htmlText + "";
					this.stripImageTag2 ();
					// forces a reparse (eg.img tags get wrapped with font size=2 tags, so text should be gotten prior)
					this.styleSheet = null;
					this.html = true;
					//this causes the htmlText to be reparsed
					this.htmlText = this.tmpText + "";
					//leave the HTML text as it is.
					//	trace ("\r\r 2.Made TextFormat Editable  " + this.htmlText);
	
				}
				break;
			}
			this.type = "input";
			//	trace("this should be input? " + this.type + " style? " + this.styleSheet );
	
		}
		//////////////////////////////////////////////////////////////////////////////////////////////////
		// This section deals with converting image bullets for view mode into text bullets for edit mode
		// the rule is text bullets should be wrapped in a font tag, e,g. <p>*</p> needs to be <p><font>*</font></p>
		// to work correctly. By default a bullet by itself won't have font tags and may introduce undesired default
		// font tags which have screwy settings (e.g. color = black, size =2), but during import most bullets have text
		// associated with them and if the font tags are there they may nest incoorectly e.g. <fontbullet>*<fonttext>text</fonttext></fontbullet>
		//
		// TODO automatically detect whether a particular bullet needs font tags inserted or not.
		public function stripImageTag () : void {
			//trace ("prestrip \r\r" + this.tmpText);
			var ary = this.tmpText.split ('<IMG SRC="BulletLevel2Graphic">');
			var stripped = ary.join (EditableTextField.RB3);
			ary = stripped.split ('<IMG SRC="BulletLS2">');
			stripped = ary.join (EditableTextField.RB2);
			ary = stripped.split ('<IMG SRC="BulletGraphic">');
			stripped = ary.join (EditableTextField.RB1);
			//	trace ("stripped of IMG tags-----------\r\r" + stripped + "\r\r");
			this.tmpText = stripped;
		}
		public function stripImageTag2 () : void {
			//	trace ("prestrip \r\r" + this.tmpText);
			var ary = this.tmpText.split ('<IMG SRC="BulletLevel2Graphic">');
			var stripped = ary.join (EditableTextField.PB3);
			ary = stripped.split ('<IMG SRC="BulletLS2">');
			stripped = ary.join (EditableTextField.PB2);
			ary = stripped.split ('<IMG SRC="BulletGraphic">');
			stripped = ary.join (EditableTextField.PB1);
			//		trace ("stripped of IMG tags-----------\r\r" + stripped + "\r\r");
			this.tmpText = stripped;
		}
		public function restoreImageTags () : void {
			var ary = this.tmpText.split (EditableTextField.RB3);
			var stripped = ary.join ('<IMG SRC="BulletLevel2Graphic">');
			ary = stripped.split (EditableTextField.RB2);
			stripped = ary.join ('<IMG SRC="BulletLS2">');
			ary = stripped.split (EditableTextField.RB1);
			stripped = ary.join ('<IMG SRC="BulletGraphic">');
			//	trace ("restored txt \r\r" + stripped);
			this.tmpText = stripped;
		}
		public function restoreImageTags2 () : void {
			var ary = this.tmpText.split (EditableTextField.PB3);
			var stripped = ary.join ('<IMG SRC="BulletLevel2Graphic">');
			ary = stripped.split (EditableTextField.PB2);
			stripped = ary.join ('<IMG SRC="BulletLS2">');
			ary = stripped.split (EditableTextField.PB1);
			stripped = ary.join ('<IMG SRC="BulletGraphic">');
			//		trace ("restored txt \r\r" + stripped);
			this.tmpText = stripped;
		}
		public function leaveWSYWIG_Edit () : void {
			//trace ("preRestored -----------------------------\r\r'" + this.htmlText + "'");
			if (this.htmlText != null && this.htmlText != "")
			{
				//var stripped = ary.join("·.");
				this.tmpText = this.htmlText + "";
				this.restoreImageTags2 ();
				this.styleSheet = undefined;
				this.html = true;
				this.htmlText = this.tmpText + "";
				//trace ("reparsed " + this.htmlText);
	
			} else
			{
				//do nothing
	
			}
			////////////////////////////
			//trace (" after reset  \r\r" + this.htmlText);
	
		}
		public function WSYWIG_to_View () : void {
			//this.leaveWSYWIG_Edit ();
			//this.enterView ();
			this.setUserInteraction (false);
			this.type = "dynamic";
			//trace ("WSYWIG_to_View preRestored -----------------------------\r\r'" + this.htmlText + "'");
			if (this.htmlText != null && this.htmlText != "")
			{
				//var stripped = ary.join("·.");
				this.tmpText = this.htmlText + "";
				this.restoreImageTags2 ();
				//	trace ("restored images \r\r" + this.tmpText);
				this.html = true;
				///////////////////////////////////////
				// there has to be a stylesheet for the rep
				// to interpret the img tags without introducing
				// extra fonts tags that get reinjected
				// into the edit mode
				this.styleSheet = this.oldStyleSheet;
				//reparses the string->html
				this.htmlText = this.tmpText + "";
				//	trace ("reparsed \r\r" + this.htmlText);
	
			} else
			{
				//do nothing
	
			}
			////////////////////////////
			//trace (" after reset  \r\r" + this.htmlText);
		}
		public function enterCodeEdit () : void {
			this.setUserInteraction (true);
			if (this.styleSheet != null)
			{
				this.oldStyleSheet = this.styleSheet;
				this.styleSheet = undefined;
			}
			this.type = "input";
			//trace("e this.type AFTER:"+this.type);
			this.text = this.htmlText + "";
			this.html = false;
			this.oldBackgroundColor = this.backgroundColor;
			this.backgroundColor = 0xffffff;
			this.oldBackground = this.background;
			this.background = true;
			//		this.htmlText = this.text+"";
	
		}
		public function leaveCode_Edit () : void {
			this.tmpText = this.text + "";
			this.backgroundColor = this.oldBackgroundColor;
			this.background = this.oldBackground;
			//	//trace("leaveCode_Edit " + this.tmpText);
			//	//trace("leaveCode_Edit htmlText "+this.htmlText+"  \rtext "+this.text);
	
		}
		public function enterView () : void {
			this.setUserInteraction (false);
			if (false)
			{
				this.detectCSS ();
				switch (this.textMode)
				{
					case "CSS" :
					if (this.oldStyleSheet != null)
					{
						//trace ("setting stylesheet to old one");
						//trace ("htmlOn htmlText \r\r " + this.htmlText + "  \rtext " + this.text);
						this.styleSheet = undefined;
						//trace ("clearedStyle htmlText \r\r" + this.htmlText + "  \rtext " + this.text);
						this.styleSheet = this.oldStyleSheet;
						this.html = true;
						this.htmlText = this.tmpText + "";
					} else if (this.styleSheet != null)
					{
						//trace ("current stylesheet found");
						//		this.styleSheet = this.styleSheet;
						this.html = true;
						this.htmlText = this.tmpText + "";
					} else
					{
						//trace ("WARNING NO STYLE SHEET ASSOCIATED!");
						this.html = true;
						this.htmlText = this.tmpText + "";
					}
					break;
					case "TextFormat" :
					//trace ("None CSS!");
					this.html = true;
					this.htmlText = this.tmpText + "";
					break;
				}
			}
			this.type = "dynamic";
			this.tmpText = null;
			//trace("e this.type AFTER:"+this.type);
			//this.text = this.htmlText+"";
			//		this.htmlText = this.text+"";
	
		}
		public function leaveView () : void {
			this.tmpText = this.text + "";
			//		//trace("leaveView " + this.tmpText);
			//		//trace("leaveView htmlText "+this.htmlText+" \r text "+this.text);
			//
		}
		/////////////////////////////////////////////
		public function setFocusHandler () : void {
			//trace("setFocusHandler ");
			this.borderColor = 0xffffff;
			this.background = true;
			this.backgroundColor = 0x666666;
			this.owner.currentField = this;
			//trace("after Set Focus " + this.type + " style " + this.styleSheet + " \r"+ this.htmlText);
	
		}
		public function onKillFocusHandler (newFocus : Object) : void {
			//trace("onKillFocusHandler ");
			this.borderColor = 0xcccccc;
			this.background = false;
			this.backgroundColor = 0x333333;
			this.onKilledFocusCallback ();
		}
		function onChangedHandler () : void {
			this.hasBeenEdited = true;
			//trace("onChangedHandler: going to unsaved mode");
			trace (" changed " + "\r" + this.text + "\r\r" + this.htmlText);
			this.history.push (this.text);
			this.historyIdx = this.history.length - 2;
			for (public var i in this.history)
			{
				if (i == this.historyIdx)
				{
					//trace("**history "+i+" = "+this.history[i]);
	
				} else
				{
					//trace("history "+i+" = "+this.history[i]);
	
				}
			}
		}
		function goBackwardsInHistory () : void {
			//trace("goBackwardsInHistory"+this.historyIdx);
			//TODO range check
			if (this.historyIdx > - 1)
			{
				//trace("going back to "+(this.historyIdx-1));
				//trace(this.history[this.historyIdx-c1]);
				this.text = this.history [this.historyIdx];
				this.historyIdx --;
			} else
			{
				//trace("can't go back");
	
			}
		}
		function goForwardInHistory () : void {
			//trace("goForwardInHistory"+this.historyIdx);
			//TODO range check
			if (this.historyIdx < this.history.length - 1)
			{
				//trace("going forward");
				this.text = this.history [ ++ this.historyIdx];
			} else
			{
				//trace("cant' go forward");
	
			}
		}
	}
	
}