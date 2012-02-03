	/* this mimics the general event model in Actionscript 3.0
* events are immutable, this differs from Mirek's model
* which are generally structs which flash doesn't have 
*/
package com.troyworks.core.cogs;

import flash.events.Event;
import flash.utils.Timer;
import haxe.Timer;

import com.troyworks.core.cogs.CogSignal;
using com.troyworks.core.cogs.CogSignal;

class CogEvent extends Event, implements Dynamic {
	
	public var sig(default, null) 						: CogSignal<Dynamic>;
	public var isHandled 								: Bool;
	public var continuePropogation 						: Bool;

	static public var EVTD_COG_PRIVATE_EVENT 			: String 	= "EVTD_COG_PRIVATE_EVENT";
	static public var EVTD_COG_PROTECTED_EVENT 			: String 	= "EVTD_COG_PROTECTED_EVENT";
	static public var EVTD_COG_PUBLIC_EVENT 			: String 	= "EVTD_COG_PUBLIC_EVENT";
	static public var EVT_INIT 							: CogEvent 	= 
		new CogEvent(EVTD_COG_PROTECTED_EVENT, SigInit());
		
	static public var EVT_EMPTY 						: CogEvent 	= 
		new CogEvent(EVTD_COG_PROTECTED_EVENT, SigEmpty());
	
	private var startTime 										: Float;
	private var endTime 										: Float;
	private var duration 										: Float;
	public  var origEvent 								: Event;
	public  var args 									: Dynamic;
	

	public function new(type : String, signal : CogSignal<Dynamic>, bubbles : Bool = false, cancelable : Bool = false) {
		isHandled 				= false;
		continuePropogation 	= true;
		
		super(type, bubbles, cancelable);
		
		sig = (signal == null) ? CogSignal.SigEmpty() : signal;
	}

	public function start() : Void {
		startTime = haxe.Timer.stamp();
	}

	public function consumed() : Void {
		endTime = haxe.Timer.stamp();
		duration = endTime - startTime;
	}

	public function getProcessedInMS() : Float {
		return duration;
	}
	override public function clone() : Event {
		var ret : CogEvent = new CogEvent(type, sig, bubbles, cancelable);
		ret.args = this.args;
		return ret;
	}

	override public function toString() : String {
		return "CogEvent[" + "type: " + type + "," + sig.toString() + "]";
	}

	///////////////// FACTORY METHODS  /////////////////////////////////
	static public function decorateEventWithOptionalArgs(evt : CogEvent, optionalArgs : Dynamic = null) : Void {
		if(optionalArgs != null)  {
			for (field in Reflect.fields(optionalArgs)) {
				//only works if dynamic class, appends to prototype
				Reflect.setField(evt,field,Reflect.field(optionalArgs,field));
			}

		}
	}

	static public function getPulseEvent(optionalArgs : Dynamic = null) : CogEvent {
		var res : CogEvent = SigPulse().createPrivateEvent();
		decorateEventWithOptionalArgs(res, optionalArgs);
		return res;
	}

	static public function getEnterEvent(optionalArgs : Dynamic = null) : CogEvent {
		var res : CogEvent = SigEntry().createPrivateEvent();
		decorateEventWithOptionalArgs(res, optionalArgs);
		return res;
	}

	static public function getExitEvent(optionalArgs : Dynamic = null) : CogEvent {
		var res : CogEvent = SigExit().createPrivateEvent();
		decorateEventWithOptionalArgs(res, optionalArgs);
		return res;
	}

	static public function getCallbackEvent(optionalArgs : Dynamic = null) : CogEvent {
		var res : CogEvent = SigCallback().createPrivateEvent();
		decorateEventWithOptionalArgs(res, optionalArgs);
		return res;
	}

	static public function fromUserSig<A>(e:CogSignal<A>) : CogEvent {
		return switch (e) {
			default 				: throw "Not a user Signal.";null;
			case SigUser(en,id,ev) 	:
				new CogEvent(Type.enumConstructor(en),e);
		}
	}

}

