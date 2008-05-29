﻿/*** Flash CS3: Missing “disabledState” for the SimpleButton class* * @author	Jens Krause [www.websector.de]* @date		08/22/07* @see		http://www.websector.de/blog/2007/08/22/flash-cs3-missing-disabledstate-for-the-simplebutton-class/* */package {	import flash.display.DisplayObject;	import flash.display.SimpleButton;	public class CustomSimpleButton extends SimpleButton 	{		protected var enabledState: DisplayObject;		protected var disabledState: DisplayObject;				/**		 * Constructor of CustomSimpleButton		 * Declares all states including additional states called "enabledState" or "disabledState"		 * 		 * @param  txt	String of its label		 */				public function CustomSimpleButton(txt: String) 		{			//			// states			enabledState = new ButtonDisplayState(txt, ButtonDisplayState.STATE_NORMAL);			disabledState = new ButtonDisplayState(txt, ButtonDisplayState.STATE_DISABLED);						overState = new ButtonDisplayState(txt, ButtonDisplayState.STATE_OVER);			downState = new ButtonDisplayState(txt, ButtonDisplayState.STATE_DOWN);						upState = enabledState;														hitTestState = upState;		}		/**		 * Overides the setter method of its enabled property		 * @param  value	Boolean true or false 		 */		override public function set enabled(value: Boolean):void 		{			super.enabled = value;			// hide or enable mouse events						this.mouseEnabled = enabled;			// With mouseEnabled = false you'll have only one state named "upState".			// Use this state for setting the new states called "enabledState" or "disabledState" ;-)			upState = (enabled) ? enabledState : disabledState;		}		}}