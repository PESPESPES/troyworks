package com.troyworks.core.cogs;

import flash.events.Event;
import com.sf.Option;using com.sf.Option;

import com.troyworks.core.cogs.StateMachine;

class CogExternalEvent extends Event {

	static public var INIT 		: String = "COG_INIT";
	static public var CHANGED : String = "COG_STATE_CHANGED";
	
	public var result 				: Dynamic;
	public function new(type : String, oldState : State = null, newState : Dynamic  = null, bubbles : Bool = false, cancelable : Bool = false) {
		super(type, bubbles, cancelable);
		_oldVal = oldState;
		_newVal = newState;
	}

	override public function clone() : Event {
		//TODO super replaced with value on this ok?
		var ret : CogExternalEvent = new CogExternalEvent(type, _oldVal, _newVal, bubbles, cancelable);
		ret.result = result;
		return ret;
	}

	override public function toString() : String {
		return "CogExternalEvent." + type;
	}

	var _oldVal 							: State;
	var _newVal 							: State;
}

