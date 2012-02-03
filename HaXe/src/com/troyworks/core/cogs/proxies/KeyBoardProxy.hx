/**
* Translates Keyboard events into CogEvents for use in state transitions
* @author Default
* @version 0.1
*/
package com.troyworks.core.cogs.proxies;

import com.troyworks.core.cogs.IStateMachine;
import flash.events.KeyboardEvent;
import flash.events.IEventDispatcher;

class KeyBoardProxy {

	var _stage : IEventDispatcher;
	var _sm : IStateMachine;
	public function new(keyEvtDispatcher : IEventDispatcher, stateMachine : IStateMachine) {
		super();
		_stage = keyEvtDispatcher;
		_sm = stateMachine;
	}

	public function enable() : Void {
		_stage.addEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
		_stage.addEventListener(KeyboardEvent.KEY_UP, reportKeyUp);
	}

	public function disable() : Void {
		_stage.removeEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
		_stage.removeEventListener(KeyboardEvent.KEY_UP, reportKeyUp);
	}

	public function reportKeyDown(event : KeyboardEvent) : Void {
		trace("Key Pressed: " + String.fromCharCode(event.charCode) + " (key code: " + event.keyCode + " character code: " + event.charCode + ")");
		//	var evt:KeyBoardEvent = new KeyBoardEvent(CogEvent.Eventttt_COG_PUBLIC_EVENT, KeyCode.parse(event.keyCode));
		//	evt.keyState = KeyBoardEvent.KEY_DOWN;
		//	_sm.dispatchEvent(evt);
	}

	public function reportKeyUp(event : KeyboardEvent) : Void {
		trace("Key Released: " + String.fromCharCode(event.charCode) + " (key code: " + event.keyCode + " character code: " + event.charCode + ")");
		//	var evt:KeyBoardEvent = new KeyBoardEvent(CogEveEventntntnt_COG_PUBLIC_EVENT, KeyCode.parse(event.keyCode));
		//	evt.keyState = KeyBoardEvent.KEY_UP;
		//	_sm.dispatchEvent(evt);
	}

}

