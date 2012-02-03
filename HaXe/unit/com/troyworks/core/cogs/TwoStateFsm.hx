package com.troyworks.core.cogs;

import com.sf.error.UnhandledSignalError;
import flash.events.Event;
import com.troyworks.core.cogs.CogEvent;
import com.troyworks.core.cogs.CogSignal;

import  com.sf.log.Logger;using com.sf.log.Logger;
import com.sf.Assert;using com.sf.Assert;
import com.sf.Methods;  using com.sf.Methods;

using Xml;
using Lambda;

class TwoStateFsm extends Fsm {

	public function new(toOff : Bool = false) {
		states = new StateHash();
		var f = 
			function(s:String){
				var f : CogEvent -> Dynamic = Reflect.field(this,s);
				var x = s.createElement();
				f.isNotNull();
				states.set( s , new CacheObject( new Method1(f,s) , x ));
			};
		[ "initial" , "initial_to_OFF", "ON_state", "OFF_state"].iter( f );
		Debug(states).log();
		initState = ((toOff)) ?  asState(initial_to_OFF) : asState(initial);
		super();
		Info("new TwoStateFsm").log();
	}

	////////////////// ACTIONS ///////////////////////
	 
	public function  toggle() : Void {
		var evt : Event = CogEvent.getPulseEvent();
		dispatchEvent(evt);
	}

	 
	public function  requestToggle() : Void {
		var evt : Event = CogEvent.getCallbackEvent();
		dispatchEvent(evt);
	}

	////////////////// ACCESSORS ///////////////////////////
	 
	public function  isOff() : Bool {
		return isInState( OFF_state);
	}

	 
	public function  isOn() : Bool {
		return isInState( ON_state);
	}

	////////////////// STATES /////////////////////////////
	
	public function  initial(event : CogEvent) : Dynamic {
		trace("TwoStateFsm.initialState");
		//tran( OFF_state);
		fsm_hasInited = true;
		return null;
	}

	
	public function  initial_to_OFF(event : CogEvent) : Dynamic {
		//trace("TwoStateFsm.initial_to_OFF");
		tran( OFF_state);
		fsm_hasInited = false;
		//	fsm_inited();
		return null;
	}

	public function ON_state(event : CogEvent) : Dynamic {
		//trace("TwoStateFsm.ON_state " + event);
		var _sw7_ = (event.sig);
			switch(_sw7_) {
				case SigPulse(_):
					requestTran(OFF_state);
				case SigCallback(_):
					requestTran(OFF_state);
				default		: 
			}
		return null;
	}


	public function OFF_state(event : CogEvent) : Dynamic {

		Info("OFF STATE REACHED" + event).log();
		//trace("TwoStateFsm.OFF_state " + event);
		var _sw8_ = (event.sig);
		var s	= 
		switch(_sw8_) {
			case SigPulse(_):
				requestTran(OFF_state);
			case SigCallback(_):
				requestTran(ON_state);
			default : 
			}
		return null;
	}

}

