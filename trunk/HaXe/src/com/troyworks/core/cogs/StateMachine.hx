/**
 * ...
 * @author Default
 * @version 0.1
 */
package com.troyworks.core.cogs;

import haxe.PosInfos;
import haxe.Log;
import com.sf.Option;using com.sf.Option;
import flash.errors.Error;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.events.EventDispatcher;

import com.sf.log.Logger;using com.sf.log.Logger;
import com.sf.error.AbstractMethodError;

using com.sf.Methods;

import com.sf.Assert;
using com.sf.Assert;

import flash.utils.Timer;

import com.troyworks.events.EventAdapter;
import com.troyworks.core.cogs.CogSignal;
using com.troyworks.core.cogs.CogSignal;

import com.sf.Methods; using com.sf.Methods;

using stax.Iterables;

class StateMachine extends EventDispatcher, implements IStateMachine {
	/* creates a log of the last performed execution chain */
	public  var transitionLog 											: Array<Dynamic>;
	public var stateMachine_hasInited(getStateMachine_hasInited, never) : Bool;

	// 
	/**
	 * a way to register statemachine IDs so when multiple of the identical types are on stage
	 * they can be identified.
	 */
	static var IDz 							: Int = 0;
	static var cachedSIG_EXIT 	: CogEvent 	= SigExit().createPrivateEvent();
	static var cachedSIG_INIT 	: CogEvent 	= SigInit().createPrivateEvent();
	static var cachedSIG_ENTRY 	: CogEvent 	= SigInit().createPrivateEvent();
	////////////////////////////////////////////////////////////////
	
	/**
	 * @private
	 * the name for this stateengine (for Debugging purposes)
	 */
	var _smID 							: Int;
	
	public var _smName 					: String;
	public var _smNameID 				: String;
	/* if we are stackable */
	var _parentState 					: IStateMachine;
	var _childState 					: IStateMachine;
	/* function pointer to current front state*/
	private var states 					: StateHash;
		
	//performance metrics
	var profilingOn 					: Bool;
	var evtRequestTime 					: Float;
	var lastTranTime 					: Float;
	var evtque 							: Array<Dynamic>;
	var heartbeat 						: flash.utils.Timer;
	static var heart 					: Timer;
	/* function pointer to initial pseudo state*/
	var initState 						: State;
	/* function pointer to current state*/
	public var currentState 	(get_currentState,set_currentState)	: State;
	private function get_currentState(){
		return currentState;
	}
	private function set_currentState(s){
		Debug(s).log();
		return currentState = s;
	}
	var _pulsecallBackTimer 			: Timer;
	
	
	//public var trace:Option<CogEvent->Dynamic> = emptyTrace;
	////////////////////////////////////////////////////
	public function new() {
		//Todo needs an initialize function.
		states = states == null ? new StateHash() : states;
		_smName = "sm";
		_smNameID = "";
		profilingOn = false;
		evtRequestTime = 0;
		lastTranTime = 0;
		super();
		heartbeat = getHeartBeat();
	}

	static public function getTotalIDz() : UInt {
		return IDz;
	}

	static public function getNextID() : UInt {
		return IDz++;
	}

	public function getParent() : IStateMachine {
		return _parentState;
	}

	public function setParent(parentState : IStateMachine, reciprocalBind : Bool = true) : Void {
		_parentState = parentState;
		if(reciprocalBind && Std.is(parentState, IStackableStateMachine))  {
			//pass false already not to infinite loop
			cast((parentState), IStackableStateMachine).setChild(this, false);
			cast((parentState), IStackableStateMachine).setChild(this, false);
		}
	}

	public function getChild() : IStateMachine {
		return _childState;
	}

	public function setChild(childState : IStateMachine, reciprocalBind : Bool = true) : Void {
		_childState = childState;
		if(reciprocalBind && (Std.is(childState, IStackableStateMachine)))  {
			//pass false already not to infinite loop
			cast((childState), IStackableStateMachine).setParent(this, false);
		}
	}

	public function getStateMachineName() : String {
		return _smName;
	}

	public function setStateMachineName(newName : String) : Void {
		_smName = newName;
		_smNameID = _smName + "#" + _smID;
	}

	public function hasEventsInQue() : Bool {
		var res : Bool = (evtque.length > 0);
		Info("evtque.length " + evtque.length + " " + res).log();
		return res;
	}

	/************************************************
	 * This is a callback for a asynchronous state 
	 * transitions, and queing multiple transition events
	 * **********************************************/
	static public function getHeartBeat() : Timer {
		if(heart == null)  {
			heart = new Timer(0, 0);
			//heart.addEventListener( TimerEvent.TIMER , function(x) { Debug('pulse').log() ; } );
			Debug(heart).log();
			heart.start();
		}
		return heart;
	}

	public function initStateMachine() : Void {
	}

	public function deactivateStateMachine() : Void {
	}

	public function tran(targetState : Dynamic, transOptions : TransitionOptions = null, crossAction : Void -> Void = null,?pos:PosInfos) : Dynamic {
		new AbstractMethodError().log();
		return null;
	}
	public function requestTran(state : Dynamic, transOptions : TransitionOptions = null, crossAction : Void -> Void = null) : Void {
		new AbstractMethodError().log();
		return;
	}
	public function hasCurrentState() : Bool {
		return currentState != null;
	}
	public function isInState(s : Dynamic) : Bool {
		var state = asState(s);
		var res : Bool = state != null && (!compare(currentState,state));
		Info("isInState " + res).log();
		return res;
	}

	public function createSignalDispatcher(sig : CogSignal<Dynamic>) : EventAdapter {
		//essentially 	dispatchEvent(sig.createPrivateEvent()); when the event
		// this translator is listenign to is hit
		return EventAdapters.adaptMethod( sig.createPrivateEvent.toMethod("createPrivateEvent") );
	}

	public function getStateMachine_hasInited() : Bool {
		return false;
	}

	/*************************************************
	 *  This is called by the heart beat to fire off
	 *  queued transitions
	 *************************************************/
	function onTranTimer(event : TimerEvent) : Void {
		Debug(event).log();
		try {
			if(profilingOn)  {
				var now : Float = haxe.Timer.stamp();
				var dur : Float = now - evtRequestTime;
				var ld : Float = now - lastTranTime;
				Debug("onTranTimer " + dur + " " + ld).log();
			}
			var qt : QueuedTransitionRequest = evtque.shift();
			tran(qt.trg, qt.opts, qt.crossAction);
			if(evtque.length == 0)  {
				heartbeat.removeEventListener(TimerEvent.TIMER, onTranTimer);
			}
		}
		catch(e : Error) {
			heartbeat.removeEventListener(TimerEvent.TIMER, onTranTimer);
			throw e;
		}

	}

	public function startPulse(ms : Int = 45, repeats : Int = 0) : Void {
		Info("hcalling back in ============================" + ms).log();
		Info(_smName + "#" + _smID + ".startPulse " + ms).log();
		if(_pulsecallBackTimer == null)  {
			_pulsecallBackTimer = new flash.utils.Timer(ms, repeats);
			_pulsecallBackTimer.addEventListener("timer", onPulseCallbackHandler);
		}
		if(_pulsecallBackTimer.running)  {
			_pulsecallBackTimer.stop();
		}
		_pulsecallBackTimer.start();
	}

	public function onPulseCallbackHandler(event : TimerEvent) : Void {
		Info(trace("onPulseCallbackHandler: " + event)).log();
		if(currentState != null)  {
			dispatchEvent(CogEvent.getPulseEvent());
		}

		else  {
			Info(_smName + "#" + _smID + ".onPulseCallbackHandler cannot call a null state ").log();
		}

	}

	public function stopPulse() : Void {
		Info(_smName + "#" + _smID + ".stopPulse ").log();
		if(_pulsecallBackTimer!=null)  {
			_pulsecallBackTimer.stop();
		}
	}

	///////////////
	override public function toString() : String {
		var a : Array<Dynamic> = new Array<Dynamic>();
		a.push("sm." + _smName + "#" + _smID + ".");
		return a.join("");
	}

	/**
	* Returns whether the state is valid.
	* @param s 		A State
	* @return 		A Bool
	*/ 
	public function sOk(s:State):Bool{
		return (s != null) && !s.isEmpty();
	}
	/** 
	* Returns whether a function is valid.
	* @param f    	A function
	* @return 		A Bool
	*/
	public function fOk(f:CogEvent->Dynamic):Bool{
		return f != null;
	}
	/**
	* Lookup a state in the cache.
	* @param 	s 		State to lookup.
	* @return 			a CacheObject or null if the state is null;
	*/
	public function sLookup(s:State){
		if ( s == null ) return null;
		return states.get(s.name);
	}
	/**
	* Assure that the input returns a State by wrapping functions. It assumes the input is either a State or a CogEvent -> Dynamic
	* @param	c 		Either a Method or a State.
	* @return 			A State or null if the input is null.
	*/
	public  function asState(c:Dynamic,name = null):State{
		return if ( Std.is(c,Method) ){
			c;
		}else{
			var s = states.find( function(x) return Reflect.compareMethods(x.method.fn,c) );
			switch (s) {
				case Some(v) 	: v.method;
				default 		: null;
			}
		}
	}
	/**
	* General function / method dispatch.
	* @param	e 		Either a Method or a State;
	* @param    v 		The parameter to send to the function / method.
	* @param    pos 	the position where the call came from.
	* @return 			The results of the operation.
	*/
	public function execute(e:Dynamic,v:Dynamic,?pos:PosInfos):Dynamic{
		e.isNotNull();
		v.isNotNull();

		Debug([e,v,pos]).log();
		var o = null;
		try{ 
			o = if (e == null){
				null;
			}else if (Std.is(e,Method)){
				var m = cast(e);
				m.execute(v);
			}else if( Reflect.isFunction(e) ){
				var f : CogEvent -> Dynamic = cast e;
				f(v);
			}else{
				Error("Execute Failed").log();null;
			}
		}catch(e:Dynamic){
			Error(e).log();		
		}
		return asState(o);
	}
	/**
	* Comparison function for functions / Methods. If one is a function and the other is a Method, compares their wrapped functions.
	* @param 	a 		Either a function or a Method.
	* @param	b 		Either a function or a Method.
	*/
	public function compare(a:Dynamic,b:Dynamic):Bool{

		var l 	= asState(a);
		var r 	= asState(b);
		if(l == null || r == null){
			return false;
		}
		return l.equals(b);
	}
	
}

