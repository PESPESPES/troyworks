﻿/*** Flash CS3: Missing “disabledState” for the SimpleButton class* * @author	Jens Krause [www.websector.de]* @date		08/22/07* @see		http://www.websector.de/blog/2007/08/22/flash-cs3-missing-disabledstate-for-the-simplebutton-class/* */package {	import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.display.Sprite;	import flash.text.TextField;	import flash.text.TextFieldAutoSize;	import flash.text.TextFormat;		class ButtonDisplayState extends Sprite 	{		public static var STATE_NORMAL: uint = 0;		public static var STATE_OVER: uint = 1;		public static var STATE_DOWN: uint = 2;		public static var STATE_DISABLED: uint = 3;		/**		 * Constructor of ButtonDisplayState		 * Adds a background image and a label		 * 		 * @param  txt		String of its label		 * @param  stateID	Identifier of its state		 */	    	public function ButtonDisplayState(txt: String, stateID:uint) 		{						var bgImage: BitmapData;			//			// Using bitmaps located in the library for background.			// Note: Flash IDE creates associated classes for these bitmaps called "BGNormal", etc.			// Check the "Automatically declare stage instances" box in the publish settings ;-)			switch (stateID)			{				case STATE_NORMAL:					bgImage = new BGNormal(108, 37);				break;				case STATE_OVER:				case STATE_DOWN:					bgImage = new BGOver(108, 37);				break;								case STATE_DISABLED:					bgImage = new BGDisabled(108, 37);				break;				default:					bgImage = new BGNormal(108, 37);							}						//			// add bitmap			var bg: Bitmap = new Bitmap(bgImage);			this.addChild(bg);						//			// and add a label as well			var format: TextFormat = new TextFormat();			format.font = "Arial";			format.color = 0xFFFFFF;			format.size = 15;                        var label: TextField = new TextField();            label.autoSize = TextFieldAutoSize.CENTER;			label.defaultTextFormat = format;            label.text = txt;            label.x = 0;            label.y = 5;            label.width = bg.width;	                        this.addChild(label);							}	}}