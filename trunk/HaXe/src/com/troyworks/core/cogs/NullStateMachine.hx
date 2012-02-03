/**
* ...
* @author Default
* @version 0.1
*/
package com.troyworks.core.cogs;

import flash.events.Event;
import com.sf.Option;using com.sf.Option;

class NullStateMachine implements IStateMachine, implements IFiniteStateMachine, implements IStackableStateMachine {
	public var stateMachine_hasInited(getStateMachine_hasInited, never) : Bool;

	public function new() {
	}

	public function initStateMachine() : Void {
	}

	public function deactivateStateMachine() : Void {
	}

	public function tran(targetState : Option<CogEvent->Dynamic>, transOptions : TransitionOptions = null, crossAction : Void->Void = null) : Dynamic {
		return null;
	}

	public function requestTran(state : Option<CogEvent->Dynamic>, transOptions : TransitionOptions = null, crossAction : Void->Void = null) : Void {
	}

	public function isInState(state : Option<CogEvent->Dynamic>) : Bool {
		return false;
	}

	public function hasEventsInQue() : Bool {
		return false;
	}

	public function getStateMachineName() : String {
		return "";
	}

	public function setStateMachineName(newName : String) : Void {
	}

	public function dispatchEvent(event : Event) : Bool {
		return false;
	}

	public function hasEventListener(type : String) : Bool {
		return false;
	}

	public function willTrigger(type : String) : Bool {
		return false;
	}

	public function removeEventListener(type : String, listener : Dynamic->Void, useCapture : Bool = false) : Void {
	}

	public function addEventListener(type : String, listener : Dynamic->Void, useCapture : Bool = false, priority : Int = 0, useWeakReference : Bool = false) : Void {
	}

	public function getStateMachine_hasInited() : Bool {
		return false;
	}

	public function getParent() : IStateMachine {
		return null;
	}

	public function setParent(parent : IStateMachine, reciprocate : Bool = true) : Void {
	}

	public function getChild() : IStateMachine {
		return null;
	}

	public function setChild(parent : IStateMachine, reciprocate : Bool = true) : Void {
	}

}

