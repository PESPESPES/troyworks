package com.troyworks.core.cogs;

import flash.events.Event;
import flash.utils.Timer;
import haxe.Timer;

import com.sf.event.TypedEvent;
using com.troyworks.core.cogs.CogSignal;
import com.troyworks.core.cogs.CogSignal;

class SignalCarrier{

	static public var EVTD_COG_PRIVATE_EVENT 		: String 		= "EVTD_COG_PRIVATE_EVENT";
	static public var EVTD_COG_PROTECTED_EVENT 		: String 		= "EVTD_COG_PROTECTED_EVENT";
	static public var EVTD_COG_PUBLIC_EVENT 		: String 		= "EVTD_COG_PUBLIC_EVENT";
	static public var EVT_INIT 						: TypedEvent<SignalCarrier> 	= 
		new TypedEvent(EVTD_COG_PROTECTED_EVENT,SigInit().toCarrier());
		
	static public var EVT_EMPTY 					: TypedEvent<SignalCarrier> = 
		new TypedEvent(EVTD_COG_PROTECTED_EVENT, SigEmpty().toCarrier());

	///////////////// FACTORY METHODS  /////////////////////////////////
	static public function decorateEventWithOptionalArgs(evt : TypedEvent<SignalCarrier>, optionalArgs : Dynamic = null) : Void {
		if(optionalArgs != null)  {
			for (field in Reflect.fields(optionalArgs)) {
				//only works if dynamic class, appends to prototype
				Reflect.setField(evt,field,Reflect.field(optionalArgs,field));
			}

		}
	}

	static public function getPulseEvent(optionalArgs : Dynamic = null) : TypedEvent<SignalCarrier> {
		var res : TypedEvent<SignalCarrier> = SigPulse().createPrivateEvent();
		decorateEventWithOptionalArgs(res, optionalArgs);
		return res;
	}

	static public function getEnterEvent(optionalArgs : Dynamic = null) : TypedEvent<SignalCarrier> {
		var res : TypedEvent<SignalCarrier> = SigEntry().createPrivateEvent();
		decorateEventWithOptionalArgs(res, optionalArgs);
		return res;
	}

	static public function getExitEvent(optionalArgs : Dynamic = null) : TypedEvent<SignalCarrier> {
		var res : TypedEvent<SignalCarrier> = SigExit().createPrivateEvent();
		decorateEventWithOptionalArgs(res, optionalArgs);
		return res;
	}

	static public function getCallbackEvent(optionalArgs : Dynamic = null) : TypedEvent<SignalCarrier> {
		var res : TypedEvent<SignalCarrier> = SigCallback().createPrivateEvent();
		decorateEventWithOptionalArgs(res, optionalArgs);
		return res;
	}

	public var sig : CogSignal;
	
	public function new(signal) {
		sig = (signal == null) ? CogSignal.SigEmpty() : signal;
	}
	public function start() : Void {
		_startTime = haxe.Timer.stamp();
	}

	public function consumed() : Void {
		_endTime = haxe.Timer.stamp();
		duration = _endTime - _startTime;
	}

	public function getProcessedInMS() : Float {
		return duration;
	}
	
	public function toTypedEvent(name:String) : TypedEvent<SignalCarrier>{
		return new TypedEvent(name,this);
	}
	public function toString() : String {
		return "TypedEvent<SignalCarrier>." + sig.toString();
	}
	var _startTime 						: Float;
	var _endTime 						: Float;
	var duration 						: Float;
	public var origEvent 				: Event;
	public var args 					: Dynamic;
	var _isHandled 						: Bool;
	var _continuePropogation 			: Bool;
}