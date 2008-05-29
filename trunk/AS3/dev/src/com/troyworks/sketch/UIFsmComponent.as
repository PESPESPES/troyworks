package com.troyworks.sketch
{
		import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import flash.display.MovieClip;
	import com.troyworks.cogs.*;
	
	public dynamic class UIFsmComponent extends MovieClip implements IStateMachine
	{
			public static  const SIG_EMPTY : CogSignal =  CogSignal.EMPTY;
		public static  const SIG_INIT : CogSignal =   CogSignal.INIT;
		public static  const SIG_ENTRY : CogSignal =    CogSignal.ENTRY;
		public static  const SIG_EXIT : CogSignal =   CogSignal.EXIT;
		public static  const SIG_TRACE : CogSignal =   CogSignal.TRACE;
		public static  const SIG_PULSE : CogSignal =   CogSignal.PULSE;
		public static  const SIG_CALLBACK : CogSignal =   CogSignal.CALLBACK;
		public static  const SIG_GETOPTS : CogSignal =  CogSignal.GETOPTS;
		public static  const SIG_TERMINATE : CogSignal =   CogSignal.TERMINATE;
		public static  const SIG_STATE_CHANGED : CogSignal =   CogSignal.STATE_CHANGED;
		
		/* function pointer to initial pseudo state*/
		protected var _initState:Function;
		/* function pointer to current state*/
		private var _currentState:Function;
		private var _hasInited:Boolean = false;

		protected var heartbeat:Timer;
		private static var _heart:Timer;
		protected var oldState:Function;
		private var nextState:Function;

		
		protected var evtque:Array;
		//performance metrics
		private var profilingOn:Boolean = false;
		private var evtRequestTime:Number = 0;
		private var lastTranTime:Number = 0;
		
		public var smName:String = "UI_FSM";
		
		public function UIFsmComponent() {
			super();
			evtque = new Array();
			heartbeat = Fsm.getHeartBeat();
		}
		/************************************************
		 * This is a callback for a asynchronous state 
		 * transitions, and queing multiple transition events
		 * **********************************************/
		public static function getHeartBeat():Timer{
			if(_heart == null){
				_heart = new Timer(0,0);
				_heart.start();
			}
			return _heart;
		}
		override public function dispatchEvent(event:Event):Boolean {
			if (event is CogEvent) {
				if(_currentState != null){
					_currentState.call(this,event);
				}else{
					trace("error null state");
				}
				return true;

			} else {
				return super.dispatchEvent.apply(this,arguments);
			}
		}

		//////////////////// STATE MACHINE ////////////////////////////////////
		/************************************************
		 * This is called to activate the statemachine
		 * meaning when it's first constructed it exists in a
		 * unoperational unefined state, calling this init
		 * takes it from the pseduo intial state, to whatever
		 * state that initial state defines int the constructor
		 * **********************************************/
		public function init():void {
			//Take initial transition
			trace("Fsm.init" + CogEvent.EVT_INIT);
			_initState.call(this,CogEvent.EVT_INIT);
			_hasInited = true;
		}
		protected function tran(target:Function):void {
			currentState=target;
		}
		/***************************************************
		 *  Request transitions is the 'clean' but slower
		 *  way of making state changes, asynchronously
		 *  
		 * passing in the desired state will be queued up,
		 * and the transition taken when next called by the
		 * heartbeat timer. This ensures that the calling function
		 * doesn't directly change states inside it's function
		 * and then still have remaining actions
		 * 
		 * e.g. 
		 * PROBLEM CASE
		 * function s_oldStateChange():void{
		 *  //gets some state vars
		 *   currentState = newState;
		 *  // Do something else;
		 *   // we are still in oldState but the machine
		 *   // thinks we are in newState, this is particularly problematic
		 *   // when there are many nested state machines 
		 * }
		 * 
		 * The solution is to requestTran, and have a event listener
		 * for the state change.
		 * 
		 * ***********************************************/
		public function requestTran(state:Function):void{
			trace("requestTran");
			evtRequestTime = getTimer();
			
			evtque.push(state);
			//if(!heartbeat.running){
			// flash will not add duplicate event listeners, it's faster to keep the
			// timer running rather than stopping and starting it. Since there is only one
			// shared across all state machines this is low impact.
				heartbeat.addEventListener(TimerEvent.TIMER,onTranTimer);
				//heartbeat.start();
			//}
			
		}
		/*************************************************
		 *  This is called by the heart beat to fire off
		 *  queued transitions
		 *************************************************/
		protected function onTranTimer(event:TimerEvent):void{
			if(profilingOn){
			var now:Number = getTimer();
			var dur:Number = now  - evtRequestTime;
			var ld:Number = now - lastTranTime;
			trace("onTranTimer " + dur + " " + ld);
			}
			currentState = evtque.shift();
			if(evtque.length == 0){
				heartbeat.removeEventListener(TimerEvent.TIMER,onTranTimer);
			}
		}

		//////////////////// ACCESSORS ////////////////////////////
		public function hasInited():Boolean{
			return _hasInited;
		}
		protected function fsm_inited():void{
			_hasInited = true;
		}
		public function isInState(state:Function):Boolean {
			var res:Boolean=state != null && _currentState === state;
			trace("isInState " + res);
			return res;
		}
		public function get currentState():Function {
			return _currentState;
		}
		public function hasEventsInQue():Boolean{
			var res:Boolean = (evtque.length > 0);
			trace("evtque.length " + evtque.length + " " + res);
			return res;
		}
		
	
				/************************************************
		* this is called so that whoever changes the state, from wherever
		* has the appropriate Enter and Exit actions called
		* Old State isn't invalidated until it's been exited
		* New State isn't current until it's been entered 
		* So
		* 1) exit old state
		* 2) invalidate currentstate
		* 3) enter new state
		* 4) set currentState to newState
		*  dispatch CogExternalEvent.CHANGED event.
		 * 
		 * NOTE: the calling function (if the same state) will still
		 * be on the stack, this is 
		*/

		public function set currentState(state:Function):void {
			//// GAURDS--------------------------------------------
			if (state == null) {
				// No state transition taken if invalid target state
				return;
			}
			lastTranTime = getTimer();
			// if we are here we have a valid state to go to.
			nextState = state;
			oldState=_currentState;
			//// EXIT CURRENT STATE ---------------------------------
			var evt:CogEvent;
			//trace("EXIT_FsmCurrentState ");
			if (_currentState != null) {
				evt = CogEvent.getExitEvent();
				if(profilingOn)evt.start();
				_currentState.call(this,evt);
				if(profilingOn)evt.consumed();
				_currentState=null;
			}
			// Now we are between states, if necessary fire between state transition events
			// enter the new state immediately (still in the calling class enclosure)
			//trace("ENTER_FsmNewState");
			//// ENTER NEW STATE --------------------------------------
			evt = CogEvent.getEnterEvent();
			if(profilingOn)evt.start();
			nextState.call(this,evt);
			if(profilingOn)evt.consumed();
			_currentState=nextState;
			nextState = null;
			// FINISHED - notify the rest of the world of the state change, if there is anybody there
			if (hasEventListener(CogExternalEvent.CHANGED)) {
				var cogE:CogExternalEvent=new CogExternalEvent(CogExternalEvent.CHANGED,oldState,_currentState);
				dispatchEvent(cogE);
			}
		}
	}
}