/**
 * ...
 * @author Default
 * @version 0.1
 */

package com.troyworks.core.cogs {
	import com.troyworks.events.EventAdapter;	

	import flash.utils.getTimer;	
	import flash.events.TimerEvent;	
	import flash.utils.Timer;	
	import flash.events.EventDispatcher;	

	public class StateMachine extends EventDispatcher implements IStateMachine {
		public static  const SIG_EMPTY : CogSignal = CogSignal.EMPTY;
		public static  const SIG_INIT : CogSignal = CogSignal.INIT;
		public static  const SIG_ENTRY : CogSignal = CogSignal.ENTRY;
		public static  const SIG_EXIT : CogSignal = CogSignal.EXIT;
		public static  const SIG_TRACE : CogSignal = CogSignal.TRACE;
		public static  const SIG_PULSE : CogSignal = CogSignal.PULSE;
		public static  const SIG_CALLBACK : CogSignal = CogSignal.CALLBACK;
		public static  const SIG_GETOPTS : CogSignal = CogSignal.GETOPTS;
		public static  const SIG_TERMINATE : CogSignal = CogSignal.TERMINATE;
		public static  const SIG_STATE_CHANGED : CogSignal = CogSignal.STATE_CHANGED;
		// a way to register statemachine IDs so when multiple of the identical types are on stage
		// they can be identified.
		private static var IDz : uint = 0;
		////////////////////////////////////////////////////////////////
		//the name for this stateengine (for Debugging purposes)
		protected var _smID : uint;
		public var _smName : String = "sm";		
		public var _smNameID:String = "";
		/* if we are stackable */
		protected var _parentState : IStateMachine;
		protected var _childState : IStateMachine;

		// REQUIRED by DesignByContract, used for the ASSERTs
		public var ASSERT : Function;
		public var REQUIRE : Function;
		//////////// LOGGING /////////////////////
		public static var DEFAULT_TRACE : Function;
		//performance metrics
		protected var profilingOn : Boolean = false;
		protected var evtRequestTime : Number = 0;
		protected var lastTranTime : Number = 0;

		protected var evtque : Array;
		protected var heartbeat : Timer;
		private static var _heart : Timer;

		/* function pointer to initial pseudo state*/
		protected var _initState : Function;
		/* function pointer to current state*/
		protected var _currentState : Function;
		protected static var cachedSIG_EXIT : CogEvent = SIG_EXIT.createPrivateEvent();
		protected static var cachedSIG_INIT : CogEvent = SIG_INIT.createPrivateEvent();
		protected static var cachedSIG_ENTRY : CogEvent = SIG_ENTRY.createPrivateEvent();
		private  var _pulsecallBackTimer : Timer;

		//public var trace:Function = emptyTrace;
		////////////////////////////////////////////////////
		public function StateMachine() {
			super();
			heartbeat = getHeartBeat();
		}

		public static function getTotalIDz() : uint {
			return IDz;
		}

		public static function getNextID() : uint {
			return IDz++;
		}

		public static function emptyTrace(... rest) : void {
		}

		public static function getDefaultTrace() : Function {
			trace("getDefaultTrace " + DEFAULT_TRACE);
			return (DEFAULT_TRACE == null) ? trace : DEFAULT_TRACE;
		}

		public 	function getParent() : IStateMachine {
			return _parentState;
		}

		public function setParent(parentState : IStateMachine, reciprocalBind : Boolean = true) : void {
			_parentState = parentState;	
			if(reciprocalBind && parentState is IStackableStateMachine) {
				//pass false already not to infinite loop
				IStackableStateMachine(parentState).setChild(this, false);
			}
		}

		public 	function getChild() : IStateMachine {
			return _childState;
		}

		public function setChild(childState : IStateMachine, reciprocalBind : Boolean = true) : void {
			_childState = childState;
			if(reciprocalBind && (childState is IStackableStateMachine)) {
				//pass false already not to infinite loop
				IStackableStateMachine(childState).setParent(this, false);
			}
		}

		public function getStateMachineName() : String {
			return _smName;
		}

		public function setStateMachineName(newName : String) : void {
			_smName = newName;
			_smNameID = _smName + "#" + _smID;
		}

		public function hasEventsInQue() : Boolean {
			var res : Boolean = (evtque.length > 0);
			trace("evtque.length " + evtque.length + " " + res);
			return res;
		}

		/************************************************
		 * This is a callback for a asynchronous state 
		 * transitions, and queing multiple transition events
		 * **********************************************/
		public static function getHeartBeat() : Timer {
			if(_heart == null) {
				_heart = new Timer(0, 0);
				_heart.start();
			}
			return _heart;
		}

		public function initStateMachine() : void {
		}

		public function deactivateStateMachine() : void {
		}

		public function tran(targetState : Function, transOptions : TransitionOptions = null, crossAction : Function = null) : * {
			throw new Error("StateMachine.tran cannot be called directly, use a valid subclass");
			return null;
		}

		public function requestTran(state : Function, transOptions : TransitionOptions = null, crossAction : Function = null) : void {
			throw new Error("StateMachine.requestTran cannot be called directly, use a valid subclass");
			return null;
		}

		
		public function hasCurrentState() : Boolean {
			return _currentState != null;
		}

		public function isInState(state : Function) : Boolean {
			var res : Boolean = state != null && _currentState === state;
			//	trace("isInState " + res);
			return res;
		}

		public function createSignalDispatcher(sig : CogSignal) : EventAdapter {
			//essentially 	dispatchEvent(sig.createPrivateEvent()); when the event
			// this translator is listenign to is hit	
			var evtl : EventAdapter = new EventAdapter();
			evtl.initAsRedispatcher(this, null, sig.createPrivateEvent);
			return evtl;
		}

		
		public function get stateMachine_hasInited() : Boolean {
			return false;
		}

		/*************************************************
		 *  This is called by the heart beat to fire off
		 *  queued transitions
		 *************************************************/
		protected function onTranTimer(event : TimerEvent) : void {
			try {
				if(profilingOn) {
					var now : Number = getTimer();
					var dur : Number = now - evtRequestTime;
					var ld : Number = now - lastTranTime;
				//trace("onTranTimer " + dur + " " + ld);
				}
				var qt : QueuedTransitionRequest = evtque.shift();
				tran(qt.trg, qt.opts, qt.crossAction);
				if(evtque.length == 0) {
					heartbeat.removeEventListener(TimerEvent.TIMER, onTranTimer);
				}
			}catch (e : Error) {
				heartbeat.removeEventListener(TimerEvent.TIMER, onTranTimer);
				throw e;
			}
		}

		public function startPulse(ms : Number = 45, repeats : Number = 0) : void {
			//trace"hcalling back in ============================" + ms);
			trace(_smName + "#" + _smID + ".startPulse " + ms);
			
			if(_pulsecallBackTimer == null) {
				_pulsecallBackTimer = new Timer(ms, repeats);
				_pulsecallBackTimer.addEventListener("timer", onPulseCallbackHandler);
			} 
			if( _pulsecallBackTimer.running) {
				_pulsecallBackTimer.stop();
			}
			_pulsecallBackTimer.start();
		}	

		public function onPulseCallbackHandler(event : TimerEvent) : void {
			//trace("onPulseCallbackHandler: " + event);
			if(_currentState != null) {
				dispatchEvent(CogEvent.getPulseEvent());
			}else {
				trace(_smName + "#" + _smID + ".onPulseCallbackHandler cannot call a null state ");
			}
		}

		public function stopPulse() : void {
			trace(_smName + "#" + _smID + ".stopPulse ");
			
			_pulsecallBackTimer.stop();
		}

		///////////////
		override public function toString() : String {
			//trace("hsm.toString()");
			var a : Array = new Array();
			a.push("sm." + _smName+ "#" + _smID + ".");
			return a.join("\r");
		}
	}
}
