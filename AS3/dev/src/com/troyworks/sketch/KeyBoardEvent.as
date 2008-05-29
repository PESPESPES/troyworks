/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.sketch {
	import com.troyworks.cogs.CogEvent;
	import com.troyworks.cogs.CogSignal;
	public class KeyBoardEvent extends CogEvent{
		public static const KEY_DOWN:int = 0;
		public static const KEY_UP:int = 1;
		public var keyState:int = KEY_DOWN;
		public function KeyBoardEvent(type:String, signal:CogSignal, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, signal, bubbles, cancelable);

		}
	}
	
}
