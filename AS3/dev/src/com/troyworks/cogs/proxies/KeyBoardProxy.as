﻿/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.cogs.proxies {
	import flash.events.KeyboardEvent;
	import flash.events.IEventDispatcher;
	import com.troyworks.ui.KeyCode;
	import com.troyworks.sketch.KeyBoardEvent;
	import com.troyworks.cogs.IStateMachine;
	import com.troyworks.cogs.CogEvent;
	
	public class KeyBoardProxy {
		
		private var _stage:IEventDispatcher;
		private var _sm:IStateMachine;
		
		public function KeyBoardProxy(keyEvtDispatcher:IEventDispatcher, stateMachine:IStateMachine){
			super();
			_stage= keyEvtDispatcher;
			_sm = stateMachine;
		}
		public function enable():void{
			_stage.addEventListener(KeyboardEvent.KEY_DOWN,reportKeyDown);
			_stage.addEventListener(KeyboardEvent.KEY_UP,reportKeyUp);
		}
		public function disable():void{
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN,reportKeyDown);
			_stage.removeEventListener(KeyboardEvent.KEY_UP,reportKeyUp);
		}
		function reportKeyDown(event:KeyboardEvent):void
		{
		
		//	trace("Key Pressed: " + String.fromCharCode(event.charCode) +         " (key code: " + event.keyCode + " character code: "         + event.charCode + ")");
			var evt:KeyBoardEvent = new KeyBoardEvent(CogEvent.EVTD_COG_PUBLIC_EVENT, KeyCode.parse(event.keyCode));
			evt.keyState = KeyBoardEvent.KEY_DOWN;
			_sm.dispatchEvent(evt);
		}

		function reportKeyUp(event:KeyboardEvent):void
		{
		//	trace("Key Released: " + String.fromCharCode(event.charCode) +         " (key code: " + event.keyCode + " character code: " +         event.charCode + ")");

			var evt:KeyBoardEvent = new KeyBoardEvent(CogEvent.EVTD_COG_PUBLIC_EVENT, KeyCode.parse(event.keyCode));
			evt.keyState = KeyBoardEvent.KEY_UP;
			_sm.dispatchEvent(evt);
			
		}
	}
}
