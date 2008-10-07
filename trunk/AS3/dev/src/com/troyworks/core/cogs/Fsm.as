package com.troyworks.core.cogs{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	
	import com.troyworks.core.cogs.IFiniteStateMachine;
	/* 
	* This is a flat state machine engine for Actionscript 3.0
	* inspired by Miro Samek's
	* Practical State Machine 's in C and C++ ISBN 1-57820-110-1, page 70
	* 
	* Some advantages:
	* - it has a small memory footprint,
	* - fast excution time (both in dispatch and statechanges, actually it can't really get faster)
	* - supports behavioral interitance.
	* - succinct/easy to modify state topologies subclasses
	* 
	* But has some features that Samek's doesn't have, 
	* - that supports exit and enter actions
	* - compatibility with Flash's EventModel and signature
	* - external events telling when states have changed
	* - ability to determine if a machine is in a given state (highly useful for when
	* multiple states machines are running in parrallel synchronizing actions)
	*
	* While sharing the same Event interface as it's parent EventDispatcher
	* it shortcuts on CogEvents as in general there should only be one interested 
	* party. This allows us to get a speedy, 1000 statetransitions in 7-9 ms(with time logging), making it
	* suitable for particle effects, Boids or other creatures, brains. For comparison.
	
	*  For asynchronous, queued or 'clean' state changes the delay between changing states might be 2-65ms
	* depending on the frame rate of the flash player, and other processes in memory
	*
	* To synchronize orthagonal regions) use the FsmE class (which is slower 
	* at 30ms for 1000 transitions, but allows more than one interested party
	* to listen to the Exit and Enter events. 
	*
	* In general use of statemachines with subclasses may experience exceptions
	* should be caught in a try/catch block as the events and then
	* modelled as a Fault state in the state machine topology can interrupt the statemachine
	* and result in invalid operation. 
	EXAMPLE
	package com.troyworks.core.cogs{
	import flash.events.Event;
	import com.troyworks.core.cogs.CogEvent;
	import com.troyworks.core.cogs.CogSignal;
	public class TwoStateFsm extends Fsm {
	public var hasInited:Boolean=false;
	public function TwoStateFsm(toOff:Boolean = false) {
	super();
	_initState=(toOff)?initial_to_OFF: initial;
	trace("new TwoStateFsm");
	
	}
	////////////////// ACTIONS ///////////////////////
	public function toggle():void{
	var evt:Event = CogEvent.getPulseEvent();
	dispatchEvent(evt);
	}
	////////////////// STATES /////////////////////////////
	public function initial(event:CogEvent):void {
	trace("TwoStateFsm.initialState");
	currentState=OFF_state;
	hasInited=true;
	}
	public function initial_to_OFF(event:CogEvent):void {
	trace("TwoStateFsm.initial_to_OFF");
	currentState=OFF_state;
	hasInited=true;
	}
	
	public function ON_state(event:CogEvent):void {
	trace("TwoStateFsm.ON_state " + event);
	switch(event.sig){
	case CogSignal.Q_PULSE_SIG:
	currentState = OFF_state;
	break;
	}
	
	}
	public function OFF_state(event:CogEvent):void {
	trace("TwoStateFsm.OFF_state " + event);
	switch(event.sig){
	case CogSignal.Q_PULSE_SIG:
	currentState = ON_state;
	break;
	}
	}
	
	}
	}
	*
	*/
	public class Fsm extends StateMachine implements IStateMachine, IFiniteStateMachine, IStackableStateMachine {

		

		protected var fsm_hasInited:Boolean = false;


		protected var oldState:Function;
		private var nextState:Function;

		
		public var trace:Function = StateMachine.getDefaultTrace();


		

		public function Fsm(initStateNameAct : String =null, smName:String = "FSM", aInit : Boolean = true ) {
			super();
			_smID = StateMachine.getNextID();
			_smName = (smName == null)?("FSM"+_smID):(smName);
			evtque = new Array();
			
			if(initStateNameAct != null){
				_initState = this[initStateNameAct];
			}
			if(aInit){
				initStateMachine();
			}
			//trace(_smName+ ":" + _initState + " " + initStateNameAct);
		}
	
		override public function dispatchEvent(event:Event):Boolean {
			//trace(getStateMachineName() + ":FSM.dispatchEvent");
			if (event is CogEvent) {
				var ce:CogEvent = CogEvent(event);
				/////// LET CHILD DO IT////////////
				if(_childState!= null && ce.continuePropogation){
					//trace(getStateMachineName() + "handing to child");
				 	_childState.dispatchEvent(ce);
				}
				/////// TRY LOCALLY //////////////
				if(ce.continuePropogation){
					if( _currentState != null){
						//trace(getStateMachineName() + "trying locally");
						_currentState.call(this,ce);
					}else{
						trace("error null state");
					}
				}else{
					//trace("  Handled event");
				}
				////// HAND TO PARENT ///////////
				
			//	if(ce.continuePropogation && _parentState!= null){
					//_parentState.dispatchEvent(ce);
			//		trace(getStateMachineName() + "handing to Parent");
			//	}
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
		override public function initStateMachine():void {
			//Take initial transition
			//trace("Fsm.init" + CogEvent.EVT_INIT);
			//_initState.call(this,CogEvent.EVT_INIT);
			//_initState.call(this, SIG_ENTRY.createPrivateEvent());
			tran(_initState);
			if(_childState!= null){
				//trace("handing to child");
				 _childState.initStateMachine();
			}
			///for asynch should callback with this.
			fsm_hasInited = true;
		}
		override public function	deactivateStateMachine():void{
			requestTran(s_stateMachineDeactivated);
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
		 * WARNING: this isn't 'safe', the calling function (if the same state) will still
		 * be on the stack once this completes, so care needs to be taken that no
		 * actions are past that.
		 * 
		 * tranFast is a non-profiling transition, with cached events.
		*/
		public function tranFast(targetState:Function, transOptions:TransitionOptions = null, crossAction:Function= null):* {
			//trace("tran " +targetState);
			//// GAURDS--------------------------------------------
			if (targetState == null) {
				// No state transition taken if invalid target state
				return;
			}
			
			// if we are here we have a valid state to go to.
			///////////////// ROUTE TRANSITION //////////////////////////
			//var initList:Array = new Array();
			var res:Object;
			
			///////////////// PERFORM TRANSTION /////////////////////////
			//takeSnapShot of current State() in case of rollback.
			oldState=_currentState;
			nextState = targetState;
			//// EXIT CURRENT STATE ---------------------------------
			var evt:CogEvent;
			//trace("EXIT_FsmCurrentState ");
			if (_currentState != null) {		
				_currentState.call(this,cachedEXIT_EVT);
				_currentState=null;
			}
			// Now we are between states, if necessary fire between state transition events
			/////CROSS LCA----------------------------------------
			if(crossAction != null){
				crossAction();
			}
			// enter the new state immediately (still in the calling class enclosure)
			//trace("ENTER_FsmNewState");
			//// ENTER NEW STATE --------------------------------------
			//trace("nextState " + nextState + " " + evt);
			res = nextState.call(this,cachedENTRY_EVT);
			_currentState=nextState;
			nextState = null;
			// FINISHED - notify the rest of the world of the state change, if there is anybody there
			if (hasEventListener(CogExternalEvent.CHANGED)) {
				var cogE:CogExternalEvent=new CogExternalEvent(CogExternalEvent.CHANGED,oldState,_currentState);
				cogE.result = res;
				dispatchEvent(cogE);
			}
			return res;
		}
		override public function tran(targetState:Function, transOptions:TransitionOptions = null, crossAction:Function= null):* {
			//trace("tran " +targetState);
			//// GAURDS--------------------------------------------
			if (targetState == null) {
				// No state transition taken if invalid target state
				return;
			}
			lastTranTime = getTimer();
			// if we are here we have a valid state to go to.
			///////////////// ROUTE TRANSITION //////////////////////////
			//var initList:Array = new Array();
			var res:Object;
			
			///////////////// PERFORM TRANSTION /////////////////////////
			//takeSnapShot of current State() in case of rollback.
			oldState=_currentState;
			nextState = targetState;
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
			/////CROSS LCA----------------------------------------
			if(crossAction != null){
				crossAction();
			}
			// enter the new state immediately (still in the calling class enclosure)
			//trace("ENTER_FsmNewState");
			//// ENTER NEW STATE --------------------------------------
			evt = CogEvent.getEnterEvent();
			if(profilingOn)evt.start();
			//trace("nextState " + nextState + " " + evt);
			res = nextState.call(this,evt);
			if(profilingOn)evt.consumed();
			_currentState=nextState;
			nextState = null;
			// FINISHED - notify the rest of the world of the state change, if there is anybody there
			if (hasEventListener(CogExternalEvent.CHANGED)) {
				var cogE:CogExternalEvent=new CogExternalEvent(CogExternalEvent.CHANGED,oldState,_currentState);
				cogE.result = res;
				dispatchEvent(cogE);
			}
			return res;
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
		override public function requestTran(targetState:Function, transOptions:TransitionOptions = null, crossAction:Function= null):void{
			//trace("requestTran");
			evtRequestTime = getTimer();
			var qt:QueuedTransitionRequest = new QueuedTransitionRequest(targetState, transOptions, crossAction);
			evtque.push(qt);
			//if(!heartbeat.running){
			// flash will not add duplicate event listeners, it's faster to keep the
			// timer running rather than stopping and starting it. Since there is only one
			// shared across all state machines this is low impact.
				heartbeat.addEventListener(TimerEvent.TIMER,onTranTimer);
				//heartbeat.start();
			//}
			
		}
		///// ACCESSORS ////////////////////////////
		override public function get stateMachine_hasInited():Boolean{
			return fsm_hasInited;
		}
	
		///////////////////////STATES //////////////////////////
		public function s_stateMachineDeactivated():void{
			fsm_hasInited = false;
		}


	}
}