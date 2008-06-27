package com.troyworks.core.cogs{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.describeType;
	import flash.utils.getTimer;
	import flash.xml.*;
	
	import com.troyworks.core.cogs.*;
	import com.troyworks.util.DesignByContract;
	
	import flash.utils.Dictionary;

	public class Hsm extends StateMachine implements IStateMachine, IFiniteStateMachine, IHeirarchicalStateMachine, IStackableStateMachine {


		/* these are special events that don't need to be tracked for time/undo */
		public static  const EVT_INIT:CogEvent  =  CogEvent.EVT_INIT;
		public static  const EVT_EMPTY:CogEvent =  CogEvent.EVT_EMPTY;
		protected static  const ARG_INIT:Array = [EVT_INIT];
		protected static  const ARG_EMPTY:Array = [EVT_EMPTY];

		public static  const HSM_EVT_EXIT:CogEvent = new CogEvent(CogEvent.EVTD_COG_PRIVATE_EVENT,CogSignal.EXIT);
		public static  const HSM_EVT_ENTRY:CogEvent = new CogEvent(CogEvent.EVTD_COG_PRIVATE_EVENT, CogSignal.ENTRY);
		public static  const HSM_EVT_CALLBACK:CogEvent = new CogEvent(CogEvent.EVTD_COG_PRIVATE_EVENT,  CogSignal.CALLBACK);


		/* creates a log of the last performed execution chain */
		public var transitionLog:Array;




		//////////////// HSM STATE //////////////////////
		protected var _hasInited:Boolean = false;
		/* whether to perform INIT actions from initial state*/
		protected var _initStateDoINIT:Boolean;

		/* the top most active state, the one that gets first dibs on the
		new events */
		protected var _myCurState : Function = null;
		/* source state duration a transition */
		private var mySource:Function;
		//protected var _mySource : Function = null;
		/* target state during a transition */
		private var targetState:Function;

		private var lastState:Function;
		public var myCurStateName : String = "";
		public var mySourceStateName : String = "";

		//////////////// INTERNAL HSM STATE ///////////////////
		protected var hsm_is_Active:Boolean = false;
		protected var _hsm_hasInited:Boolean = false;
		/* function pointer to initial pseudo state*/
		protected var _hsm_initState:Function;
		/* function pointer to current front state*/
		private var _hsm_currentState:Function;
		protected var s_Idx:Object;
		/* transition index  */
		protected var tran_Idx:Object;
		/* whether or not we are in a tranition */
		protected var transLock:Boolean = false;
		

		private  var _callBackTimer:Timer;
		private  var _pulsecallBackTimer:Timer;
		/* a place to store pending transition list */
		protected var pendingTranList:Array;
		//an empty array with nulls as placeholders
		protected var entry : Array = [null, null, null, null, null, null, null, null, null, null, null];
		protected var exitry : Array = [null, null, null, null, null, null, null, null, null, null, null];

		protected var dict : Dictionary;

	
		/* a variable to hold the xml topology, generally this doesn't change for most statemachines at runtime */
		
		public var topology:XML = null;
		public var stateNameIdx:Array;
		
		public var trace:Function = StateMachine.getDefaultTrace();
		

		/**********************************************************************
		 * 
		 * ********************************************************************/
		public function Hsm(initStateNameAct : String =null, smName : String ="Hsm", aInit : Boolean = true):void {
			super();
			trace("HIGHLIGHTB new HSM(" + smName+")");
			
			
			//---- GUARDS ----------------//
			//Setup the Asserts //////////
			DesignByContract.initialize(this);
			var initState:Function;
			var initStateName:String;
			if(initStateNameAct == null){
				initStateName = "s_initial";
				_initStateDoINIT = true;
			}else{
				var ary:Array =    initStateNameAct.split(",");
				initStateName  = String(ary[0]);
				_initStateDoINIT = (ary.length == 1);
			}
	//		trace("attemping to get initStateName " + initStateName);
			initState = this[initStateName];

			REQUIRE(_smName != null,   " hsm %1 requires an a name passed into constructor", _smID);
			REQUIRE(initState != null,  " %1 hsm %2 requires an initial state passed into constructor", _smName, _smID);
			REQUIRE(initState != s_root, "% 1 hsm %2  requires an initial state (not Root_st) passed into constructor", _smName, _smID);

			_hsm_initState = hsm_s_Initial;
			_hsm_currentState = hsm_s_Initial;
			_initState = initState;
			
			mySource = s_root;
			_myCurState = s_root;
			//trace(_smName + ":1 " + getCurrentStateNames(true));

			_smID = StateMachine.getNextID();
			_smName = (smName= null)?"HSM"+_smID:smName;
			evtque = new Array();
			heartbeat = getHeartBeat();
			tran_Idx = new Object();
			/////////////////////////////////
			onConstructed();
		}
		/**********************************
		 * Called after all classes, parent classes have 
		 * set the attributes as necessary
		 * *********************************/
		protected function onConstructed():void {
			if(topology == null){
				discoverTopology(this);
			}else{
				//// CREATE THE NAME to FUNCTION PAIR FOR DEBUGGING / VISUALIZATION
					s_Idx = new Object();
					var o:Object;
					var mn:String;
					for(var i:int = 0; i < stateNameIdx.length; i++){
						mn = stateNameIdx[i];
						o= new Object();
						o.name = mn;
						o.fn = this[mn];
						var xml:XMLNode = new XMLNode(XMLNodeType.ELEMENT_NODE,mn);
						o.xml = xml;
						s_Idx[mn] =o ;						
					}
				
			}

			
			//if(aInit == null && true == INIT_POLICY || aInit == true){
			//init();
			//}
		}
		/******************************************
		* iterates over the state and finds the methods
		* for a given state.
		*
		* if introspective ui is enabled, get the static
		* actions for a particular state, and gets the function
		* name for debugging purposes.
		*
		****************************************/
		protected function discoverTopology(base:Object, cacheResults:Boolean = true):void {
			trace("HSM.discoverTopology with namespace " );
			if(cacheResults && topology != null){
				return;
			}
			s_Idx = new Object();
			var stateNames:Array = new Array();
			//trace("s_idx " + s_Idx);
//			
			var type:XML = describeType(base);
			////use namespace  COG;
			//trace("dtype '" + type.toString() +"'");
			//	trace(" DTYPE \r" +type.toString().split(">").join("").split("<").join(""));
			//if(type == null || type == ""){
			//	return;
			//}
			///////// ADD ROOT /////////////////
			
			/*		var o:Object= new Object();
					o.name = "s_root";
					o.fn = s_root;
					xml = new XMLNode(XMLNodeType.ELEMENT_NODE,"s_root");
					o.xml = xml;
					s_Idx["s_root"] =o ;*/
				////////////////////////////////////
				var o:Object;
			for each (var method:XML in type..method) {
				var mn:String =String(method.@name);
				if (mn.indexOf("hsm_s_") == -1 && mn.indexOf("s_") ==0) {
					o= new Object();
					o.name = mn;
					o.fn = this[mn];
					var xml:XMLNode = new XMLNode(XMLNodeType.ELEMENT_NODE,mn);
					o.xml = xml;
					s_Idx[mn] =o ;
					stateNames.push(mn);
					trace("type  " + mn);
				}
			}
			///////////// BUILD LINKED TREE /////////////////
			for (var i:Object in s_Idx) {
				trace("testing " + i );
				if (i == "s_initial") {
					XMLNode(s_Idx["s_root"].xml).appendChild(s_Idx[i].xml);
				} else if (i != "s_root" ) {
					var parentFunc:Function = s_Idx[i].fn.call(this, EVT_EMPTY);
					var parentName:String = getStateName(parentFunc);
				
					trace(s_Idx[i]  + " -> " + parentName);
					if(parentName == null){
						throw new Error("invalid Statemachine Topology " + i + " has null parent, check return value");
					}
					var kidNode:XMLNode = XMLNode(s_Idx[i].xml);
					XMLNode(s_Idx[parentName].xml).appendChild(kidNode);
				
				}else{
					/// root //
				}
			}
			var sxml:XML = <hsm/>;
			sxml.appendChild(s_Idx["s_root"].xml);
			trace(" RESULT TREE \r" +sxml.toString().split(">").join("").split("<").join(""));
			if(cacheResults){
				topology = sxml;
				stateNameIdx = stateNames;
			}

		}

		public function getStateName(fn:Function):String {
			////use namespace  COG;
			var res:String = null;
			for (var i:String in s_Idx) {
				if (s_Idx[i].fn === fn) {
					res = s_Idx[i].name;
					break;
				}
			}
			return res;

		}
	
		//////////////////// ACCESSORS ////////////////////////////

		override public function get stateMachine_hasInited():Boolean {
			return _hsm_hasInited;
		}
		public function set hsm_currentState(state:Function):void {
			//// GAURDS--------------------------------------------
			if (state == null) {
				// No state transition taken if invalid target state
				return;
			}
			// if we are here we have a valid state to go to.
			var oldState:Function=_hsm_currentState;
			var args:Array;
			var evt:CogEvent;
			//// EXIT CURRENT STATE ---------------------------------
			if (_hsm_currentState != null) {
				_hsm_currentState.call(this,HSM_EVT_EXIT);
				// since we've exited we are no longer in a valid state
				_hsm_currentState=null;
			}
			// No we are betwen state, if necessary fire between state transition events

			//// ENTER NEW STATE --------------------------------------
			state.call(this,HSM_EVT_ENTRY);
			_hsm_currentState=state;
			//_hsm_currentState=hsm_s_Active;
			trace("HSM DEBUG1 ===========");
			trace("Activating " + (hsm_s_Activating == _hsm_currentState));
			trace("Active " + (hsm_s_Active == _hsm_currentState) + " hsm_is_Active: " + hsm_is_Active);
		}
		public function setHSM(state:Function, name:String):void{
			_hsm_currentState=state;
			trace("HSM DEBUG2 ===========");
			trace("Activating " + (hsm_s_Activating == _hsm_currentState));
			trace("Active " + (hsm_s_Active == _hsm_currentState));
		}
		///////////// EXTERNAL STATE ///////////////
		
		protected function get myCurState():Function {
			return _myCurState;
		}
		protected function set myCurState(stateFN : Function):void {
			//var ary : Array = getStateNames(_myCurState,stateFN);
			//trace(_smName +" myCurState **Changed** from "+ _myCurState+":"+ ary[0] + " to " +stateFN +":"+ ary[1] + "     HIGHLIGHTy" );
			_myCurState = stateFN;
		}
		public function get smID():uint {
			return _smID;
		}

		/*function get mySource():Function {
		return _mySource;
		}
		function set mySource(stateFN : Function):void {
		//trace("settingMySource " + !(stateFN ==s_root));
		//public var ary : Array = getStateNames(_mySource,stateFN);
		//trace(_smName +" mySource **Changed** from "+ ary[0] + " to " + ary[1] + "             ");
		_mySource = stateFN;
		}*/
		////////////////// METHODS ////////////////////////////
		
		protected function hsm_isInState(state:Function):Boolean {
			var res:Boolean=(state != null) && (_hsm_currentState === state);
			trace("isInState " + res);
			return res;
			
		}
		public function get hsmIsActive():Boolean{
			
			//var a:String = hsm_s_Active;
			//var b = _hsm_currentState;
			//trace(a + " " + b);
			//hsm_s_Active == _hsm_currentState
			return  hsm_is_Active;
		}
		/***********************************************************
		 * Returns version number of this Statemachine
		 */
		public function getHsmVersion() : String{
			return "Hsm ver 3.0";
		 }
		/***********************************************************
		* returns whether or not a passed in function of a statemachine
		* is the top most state (menaing it handles the events first) before
		* passing onto parents.
		* e.g.  trace("video ready? " + cs.isCurrentState(cs.s10_pausedAtBeginning)); 
		*/
		public function isCurrentState(stateFn : Function) : Boolean
		{
			return (this.myCurState === stateFn);
		}
		
		/****************************************************************
		* returns whether or not the given function state is on the
		* active linked list/stack.
		* e.g.  trace("video active? " + cs.stateIsActive(cs.s1_active));
		*/
		override public function isInState(stateFn : Function) : Boolean
		{	//use namespace  COG;
		//	trace("isInState?");
			var s:Function = this.myCurState;
			do
			{
			//	trace(" isInState? check");
				if (s === stateFn)
				{
			//		trace("isInState TRUE");
					return true;
				}
				s = s.call(this, EVT_EMPTY);
			} while (s != s_root && s != null);
			//			trace(" isInState FALSE");
			
			return false;
		}
		public function hsm_callbackIn(ms:Number = 45):void{
			trace("hsm calling back in ============================");
			var myTimer:Timer = new Timer(ms, 1);
            myTimer.addEventListener("timer", hsm_onCallbackHandler);
            myTimer.start();
		}
		 public function hsm_onCallbackHandler(event:TimerEvent):void {
            trace("hsm hsm_onCallbackHandler: " + event);
			if(_hsm_currentState != null){
				trace("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
		    	_hsm_currentState.call(this,HSM_EVT_CALLBACK);
				trace("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");
			}else {
				trace("cannot call a null _hsm_currentState");
			}
        }
		/*************************************************/
		override public function dispatchEvent(event:Event):Boolean {
			trace(getStateMachineName() + ":Hsm.dispatchEvent");
			if (event is CogEvent) {
				//use namespace  COG;
				//tmp state variables
				var s : Function;
				var sp:Function;
	
				var ce:CogEvent = CogEvent(event);
				/////// LET CHILD DO IT////////////
				if(_childState!= null){
					trace(getStateMachineName() + "handing to child");
				 	_childState.dispatchEvent(ce);
				}
				/////// TRY LOCALLY //////////////
				if(ce.continuePropogation){
					trace(_smName + "." + getStateName(_myCurState) + ":Hsm.dispatchEvent Cog " + event.type);
					if(myCurState != null){
						s = myCurState;
						while (true) {
							mySource = s;
							sp = s.call (this, event);
							if (sp == null) {
								// arrived at target state or root
								//trace("arrived at " + getStateName(mySource));
								break;
							} else if(sp == s_root ){
								//hit root, can't go farther in this class.
								break;
							} else {
								// else haven't arrived at target state yet, keep going
								s = sp;
							}
						}
										
					}else{
						trace("error null state");
					}
				}
				////// HAND TO PARENT ///////////
				return true;
			} else {
			//	trace("dispatchEvent normal " + super.dispatchEvent);
				return super.dispatchEvent.apply(this, arguments);
			}
		}
		/*public function Q_dispatch(e : AEvent) : void{
			REQUIRE(!DesignByContract.appIsHalted, " app is halted");
			REQUIRE(e != null, "Q_dispatch must not have a null event");
			REQUIRE(e.sig != null, "Q_dispatch must not have an event with a valid SIG signature");
			
			if (deferredEvts.length > 0)
			{
				deferredEvts.push(e);
				//trace (util.Trace.me (deferredEvts, " DEFFERED EVENTS ", false));
				 var len : Number = deferredEvts.length;
				for( var i:Number = 0; i < len; i++)
				{
					var ev : AEvent = AEvent (deferredEvts.shift ());
					trace ("XXXXXXXXXXdispatch deferred XXXXXXXXXX " + e.toString ());
					Q_dispatchI (ev);
				}
			}else{
					Q_dispatchI (e);
			}
			
		}*/
		public function callbackIn(ms:Number = 45):void{
			trace("hcalling back in ============================" + ms);
			var _callBackTimer:Timer = new Timer(ms, 1);
            _callBackTimer.addEventListener("timer", onCallbackHandler);
            _callBackTimer.start();
		}
		 public function onCallbackHandler(event:TimerEvent):void {
            trace("onCallbackHandler: " + event);
			if(myCurState != null){
		    	dispatchEvent(CogEvent.getCallbackEvent());
				IEventDispatcher(event.target).removeEventListener("timer", onCallbackHandler);
				trace("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");
			}else {
				trace("cannot call a null onCallbackHandler");
			}
        }
		public function startPulse(ms:Number = 45, repeats:Number = 0):void{
			trace("hcalling back in ============================" + ms);
			if(_pulsecallBackTimer != null && _pulsecallBackTimer.running){
				_pulsecallBackTimer.stop();
			}else{
			_pulsecallBackTimer= new Timer(ms,repeats);
			}
            _pulsecallBackTimer.addEventListener("timer", onPulseCallbackHandler);
            _pulsecallBackTimer.start();
		}
		 public function onPulseCallbackHandler(event:TimerEvent):void {
            //trace("onPulseCallbackHandler: " + event);
			if(myCurState != null){
		    	dispatchEvent(CogEvent.getPulseEvent());
			}else {
				trace("cannot call a null onCallbackHandler");
			}
        }
		public function stopPulse():void{
			_pulsecallBackTimer.stop();
		}

		/************************************************
		 * This is called to activate the statemachine
		 * meaning when it's first constructed it exists in a
		 * unoperational unefined state, calling this init
		 * takes it from the pseduo intial state, to whatever
		 * state that initial state defines int the constructor
		 * **********************************************/
		override public function initStateMachine():void {
			trace("HSM.init()" + _hsm_initState + " " + REQUIRE);
			REQUIRE(this._hsm_initState != null, "_hsm_initState cannot be null, set it in your constructor");
			trace("PRE HSM_EVT_ENTRY HSM_EVT_ENTRYHSM_EVT_ENTRY");
			this._hsm_initState.call(this,HSM_EVT_ENTRY);
			trace("POST HSM_EVT_ENTRY HSM_EVT_ENTRYHSM_EVT_ENTRY");
		}
		override public function deactivateStateMachine():void{
			requestTran(hsm_s_Deactivated);
		}

		public function requestTranNoInit(targetState:Function):void{
			var tOpts:TransitionOptions = new TransitionOptions();
			tOpts.doInitDiscovery = false;
			requestTran(targetState, tOpts);
		}
		/************************************************
		 * This is called to que up an event
		 * as typically the tran() method performs a transition
		 * inside the calling function, and the transition make take
		 *  non-trivial time, meaning after the transition is complete
		 * we are still in the calling method/state, and may get confused about
		 * which state we are actually in.
		 * 
		 * The consequence of this is that state transitions will
		 * take at a minimum of 10ms, due to the resolution of Flash's Timer.
		 * 
		 * **********************************************/		
		override public function requestTran(targetState:Function, transOptions:TransitionOptions = null, crossAction:Function= null):void{
	
			trace("requestTran");
				//use namespace  COG;
			//REQUIRE(targetState != null, "***ERROR*** %1.tran, passed null state function" ,  toStringShort ());
			REQUIRE(targetState != s_root, "cannot transition to root state!");
		//	REQUIRE(targetState is Function, "***ERROR*** %1.QTRAN, passed invalid state function:  %2", toStringShort (),(targetState is Function));

			evtRequestTime = getTimer();	
			var qt:QueuedTransitionRequest = new QueuedTransitionRequest(targetState, transOptions, crossAction);
			evtque.push(qt);
			//if already added won't duplicate
			heartbeat.addEventListener(TimerEvent.TIMER,onTranTimer);
		}
		/******************************************
		* This is the workhorse of the statemachine, processing the
		* transitions between various states to other states. It's command is the state(function)
		* to transition to from the current state(function)
		*
		* it ensure that actions are performed in the right direction, handling parents appropriately
		* generally it's Exit actions, Transition Actions (if any), Enter Actions and then possibly
		* INIT actions. Enter and Exit actions are not allowed to fire off any state transitions of their own
		* but can update state variables (e.g. visibile = true).
		*
		* Transitions (not the exit and enter actions) are supposed to be take zero time, meaning all the work is associated with the Enter and Exit actions
		* and inbetween the Exit and Enter states, when technically it's an undefined state, no work is performed.
		* if you need work performed between states you should introduce a new state, e.g.
		*   - OFF->Dimming Up->OnFull
		*   - SRootped->AnimatedTransitionRootlay->Playing
		*            <-AnimatedTransitionToSRoot<-
		*/
		override public function tran(targetState:Function, transOptions:TransitionOptions = null, crossAction:Function= null):* {
				//use namespace  COG;
			//REQUIRE(targetState != null, "***ERROR*** %1.tran, passed null state function" ,  toStringShort ());
			REQUIRE(targetState != s_root, "cannot transition to root state!");
		//	REQUIRE(targetState is Function, "***ERROR*** %1.QTRAN, passed invalid state function:  %2", toStringShort (),(targetState is Function));
			if(transOptions == null){
				transOptions = TransitionOptions.DEFAULT;
			}
			////////////For Debugging Purposes/////////////////
				transitionLog = new Array();
			var curName:String = getStateName(_myCurState);
			var sourceName:String = getStateName(mySource);
			var requestedName:String = getStateName(targetState);
			trace("HIGHLIGHTB Q_Tran>>>>>>>>>>>>>>>>>>>>>>>>>>>>> " + curName + ".. "+ sourceName+ " to " + requestedName + "");
			var key:String = curName+"->"+requestedName;
	
			///////////////////////////
			//tmp state variables
			var s : Function;
			var t:Function;
			// Capture the target, source and current state for synchronization
			// reason
			var tS : Function = targetState;
			var sS:Function = mySource;
			var cS:Function = _myCurState;
			// target parent and source parent state
			var tp : Function;
			var sp :Function;

			var lca : uint;
			var cont : uint;
			var e : uint = 0;
			var f : uint = 0;
			// reset the action lists
			var preExit:Array = new Array();
			entry = new Array();
			exitry = new Array();
			var postEnter:Array = new Array();
			/////////////////////////////////////////////////////////////////
			//
			// PHASE1: UNWIND From currentState to the source of the transition
			// 
			/////////////////////////////////////////////////////////////////
			if(sS != cS){
			trace("UNWINDING-----------------" + getStateName(cS) + "  sS"+ getStateName(sS) );
			s = cS;
			while (true) {
				sp = s.call (this, EVT_EMPTY);
				trace(" - sp " + getStateName(sp) + " s " +getStateName(s));
				if (sp == null) {
					// arrived at target state or root
					trace(" arrived at root");
					break;
				}else if(sp == sS){	
					// else haven't arrived at source state yet, keep going
					trace("arrived unwinding " + getStateName(s));
					preExit.push(s);
				//	f= 1;
					break;
				} else {
					// else haven't arrived at source state yet, keep going
					trace(" unwinding " + getStateName(s));
					preExit.push(s);
				//	f= 1;
					s = sp;
				}
			}
			}
			trace("preExit " + preExit.length);
			//targetState is parent and it's already active.
			var tIsPA : Boolean = false;
			var skipPrune:Boolean = false;
			var reentrant:Boolean = false;
			var LCA:Function = null;

			//Store this for posterity/history/undo
			lastState = _myCurState;
			if (transOptions.useCachedRouting && tran_Idx[key] != null) {
				//Found an existing routing
				trace("existing routing");
				var routing:Array = tran_Idx[key];
				entry = routing[0];
				exitry = routing[1];
			} else {
				//discover route
				trace("discovering routing ");
				///////////////////////////////////////////////////////////////////
				//
				// ROUTE   , find the path from the source
				// of the transition to the target state
				// start recording transition chain, if not a dynamic
				// 
				////////////////////////////////////////////////////////////////////
				trace("ROUTING----------");
				if (sS == tS) {
					////////////////////////////////////////////////////////////
					//  Self Transitions, no extended discovery needed.
					// Fig 4.7(a) 
					////////////////////////////////////////////////////////////
					 trace ("(a) - self transition");
					entry [e++] = tS;
					exitry [f++] = sS;
					skipPrune = true;
					reentrant = true;
	
				} else {
					trace ("source != target");
					//target's parent state
					tp = tS.call (this, EVT_EMPTY);
					//source's parent state
					sp  = sS.call (this, EVT_EMPTY);
					//if (cS == sS) {
					//	trace("single level");
						////////////////////////////////////////////////////////////
						//  Single Level Transitions, no extended discovery needed.
						////////////////////////////////////////////////////////////
						if (sS == tp) {
							// CHILD
							trace ("*Fig 4.7 (b)* -  transition to first child - ENTER only" );
					//		if(tS != cS){
								entry [e++] = tS;
						//	}else {
						//		trace(" already active");
								//reentrant = true;
								//return;
								//break;
				//	}
							
						} else if (sp == tp) {
							// SIBLING
							trace ("*Fig 4.7 (c) (sp == tp)* -  transition to sibling via parent EXIT and ENTER chain ");
							entry [e++] = tS;
							exitry [f++] = sS;
						} else if (sp == tS) {
							// PARENT
							trace ("*Fig 4.7 (d)* -  transition to first parent EXIT only");
							exitry [f++] = sS;
							tIsPA = true;
						
					} else {
						//////////////////////////////////////////////////////////////
						// Multi Level Transitions, extended discovery needed
						/////////////////////////////////////////////////////////////
						trace("multi level");
						//trace ("*Fig 4.7 (e),(f), (g), (h) (sp.. == tp..)* -  transition to sibling(s) EXIT and ENTER chain  ");
						//ENTER LIST from target
						for (s = tS; s != null && s!= s_root; s = s.call (this, EVT_EMPTY)) {
							//trace ("checking enter list from targets's parent"  + s.call (this, TRACE_EVT));
							if (s == sS ) {
								//found it, target is GRANDCHILD
								trace ("e 4.7 (e)  found LCA! " + e);
								LCA = s;
								break;
							} else {
								// add to entry list keep going,
								entry [e++] = s;
							}
						}
						entry.reverse();
						if(LCA == null){
							LCA = entry[0];
						}
						//EXIT LIST from source
						for (s = sS; s != null && s!= s_root; s = s.call (this, EVT_EMPTY)) {
							//trace ("checking exit list from activestate/source " + s.call (this, TRACE_EVT));
							if (s == tS || s == LCA) {
								//found it, target is GRANDPARENT
								trace ("x 4.7 (h) found LCA ! " + f);
								break;
							} else {
								// add to exit list keep going,
								exitry [f++] = s;
							}
						}
						//
						trace("\r\r");
						traceEnterExitList(f, e, "after normal routing");
						trace("\r\r");
						//PRUNE LIST for any unecessary LCA/root state's
						if (e > 0 && f > 0) {
							//if we are here we didn't find the LCA *Fig 4.7 (g)
							trace ("----performing LCA extended discovery pruning---------");
							var ee : uint = e;
							var ff : uint = f;
							while (entry [( -- ee )] == exitry [( -- ff)]) {
								e --;
								f --;
								//trace ("discarding " + entry [(e )].call (this, TRACE_EVT) + " " + exitry [(f )].call (this, TRACE_EVT));
							}
						}

						trace("\r\r");
						traceEnterExitList(f, e, "after LCA discovery");
						trace("\r\r");
					}
				}
				if(exitry.length == 0){
					reentrant = true;
				}
				////////////////////////////////////////////////////////////////////
				//
				// ROUTE B, find path from target state to topmost init,
				//
				////////////////////////////////////////////////////////////////////
				if(transOptions.doInitDiscovery){
					trace("INIT ROUTING----------------");
					if ( ! tIsPA) {
						s = tS;
						tp = s.call (this, EVT_EMPTY);
						while (true) {
							t = s.call (this, EVT_INIT);
							if (t == tp || t== s_root) {
								//reached destination, no init state to process
								break;
							} else {
								trace("  init " + getStateName(s) +" ++> " + getStateName(t));
		
								//found a new state to enter, add to list and keep climbing
								postEnter.unshift(t);
								tp = s;
								s = t;
							}
						}
					}
					postEnter.reverse(); //for multi level init
				}else{
					trace("SKIP INIT ROUTING");
				}
				//CAPTURE List and save it for later
				tran_Idx[key] = [entry.concat(),exitry.concat()];
			}
			///////////////////////////////////////////////////////////////////
			// MERGE the preExit and postEnter lists
			//////////////////////////////////////////////////////////////////
		//	trace("\r\r");

			exitry = preExit.concat(exitry);
			entry = entry.concat(postEnter);
			trace("MERGED ");
			traceEnterExitList(f, e, "after MERGE discovery");
			//trace("\r\r");


			////////////////////////////////////////////////////////////////////
			// 
			//  DONE FINDING ROUTE, perform actual transition, process events
			//
			/////////////////////////////////////////////////////////////////////
			/* now we have the list of operations for this transition  proceed through the chain and exit each one
			* [0] child
			* [1] parent
			* [2] grandparent
			*/

			ASSERT(transLock == false, "Error in HSM Illegal Transition detected in "+toStringShort ()+"Q_TRAN, cannot perform another Q_TRAN inside EXIT_EVT or ENTER_EVT (use INIT_EVT instead) ");
			transLock = true;
			trace(_smName + " TRANSITIONING===================");
			var i:uint;
			var finalState:Function;
		
			var msg:String;
			var handled:Object = null;
			if (f > 0 || preExit.length >0) {
				for (i = 0; i < exitry.length; i ++) {
					s = exitry [i];
					/* retrace exit path in reverse order */
					msg = "EXITING " +getStateName(s);
					trace(msg);
					handled = s.call(this, CogEvent.getExitEvent());
					if(handled == null){
						transitionLog.push(msg + " HANDLED");
					}else{
						transitionLog.push(msg + " NOT HANDLED");
					}
					finalState = s.call(this, EVT_EMPTY);
				}
			}
			/*
			*  Perform any between state 'cross' transitions, these should be synchronous, else one should
			* use a dedicated state to represent.
			* TODO: Not implemented yet.
			*/
			if(crossAction != null){
				crossAction();
			}
			/* now we are in the LCA of source__ and target, proceed through the chain and enter each one  in
			* [0] target
			* [1] target's parent
			* [2] targets's grandparent
			*/
			if (e > 0|| postEnter.length >0) {
				/* retrace entry path in reverse order */
				for (i = 0; i < entry.length; i ++) {
					s = entry [i];
					

					if(! isInState(s) || reentrant){
						// if we are going from a child to an already active parent //
					msg = "ENTERING " +getStateName(s);
					trace(msg);

					handled = s.call(this, CogEvent.getEnterEvent());
					if(handled == null){
						transitionLog.push(msg + " HANDLED");
					}else{
						transitionLog.push(msg + " NOT HANDLED");
					}
					}

					finalState = s;
				}
				
			}
			transLock = false;
			////////////////////////////////////////////////////////////////////////////
			//
			//  FINISHED with the transition, set the current state to the last entered
			//  and proceed to notify the world
			//
			/////////////////////////////////////////////////////////////////////////////
			if(finalState != null){
				myCurState = finalState;
				onInternalStateChanged();
			}else{
				trace("WARNING, no statetransition performed");
			}
			///// Check if there are additional transitions to peform, that might have 
			// been generated in the process of this last transition.
			//if(!pendingTranList.length > 0){
			//	transitionCallBackTimer.start();				
			//}
			return handled;
		}
		/******************************************************************
		* A utility method for getting possible actions/Events associated with this state
		* used in testing and introspected User interfaces,
		*
		* which is called at the end of any state transition, This also fires off the statechanged
		* event to other interested parties who might be intereseted in updating, e.g. the User Interface
		*/
		protected function onInternalStateChanged():void {
			trace(" NEW STATE " + getStateName(myCurState));
			mySource  = myCurState; //reset it incase no events were fired.
			// FINISHED - notify the rest of the world of the state change, if there is anybody there
			if(hsmIsActive ){
				if ( hasEventListener(CogExternalEvent.CHANGED )) {

					var cogE:CogExternalEvent=new CogExternalEvent(CogExternalEvent.CHANGED,lastState,myCurState);
									trace("  onInternalStateChanged.notificatifying" + cogE);
					dispatchEvent(cogE);
				}else {
						trace("  no listeners " );
				}
			}else{
									trace("  hsm not fully initialized yet");
			}
		}
		public function traceEnterExitList(x : Number, e : Number, str : String):void {
			var i:uint;
			var s:Function;
			var res:Array = new Array();

			res.push("traceEnterExitList\\ ------ x " + x + " e " + e + "  " + str);
			res.push("[[Exit Chain is ]]" + x);
			for (i = 0; i < exitry.length; i ++) {
				s = exitry [i];
				res.push("  " + i + " " + getStateName(s));

			}
			res.push("[[[Enter Chain is]] " + e);
			for (i = 0; i < entry.length; i ++) {
				s = entry [i];
				res.push("  " + i + " " + getStateName(s));

			}
			res.push("traceEnterExitList//");
			trace(res.join("\r"));
		}
		override public function toString():String {
			//trace("hsm.toString()");
			var a:Array = new Array ();
			a.push("Hsm." + _smName + _smID + "." + myCurStateName);
			return a.join("\r");
		}
		public function toStringShort(stateName : String= null):String {
			var res : String = _smName + _smID + "." + ((stateName == null)?myCurStateName:stateName);
			//trace("toStringShort " + res);
			return res;
		}
		////////////////// HSM STATES /////////////////////////////
		/* the default very first pseudostate called when the machine
		* is turned on via the init() call */
		protected function hsm_s_Initial(event:CogEvent):void {
			trace("hsm_s_Initial" + event.sig);
			if (event.type ==CogEvent.EVTD_COG_PRIVATE_EVENT) {
				switch (event.sig) {
					case SIG_ENTRY :
						hsm_callbackIn(1);
					break;
					case SIG_CALLBACK:
						hsm_currentState = hsm_s_HasntActivated;
						break;
				}
			}
		}

		protected function hsm_s_HasntActivated(event:CogEvent):void {
			trace("hsm_s_HasntActivated" + event.sig);
			if (event.type ==CogEvent.EVTD_COG_PRIVATE_EVENT) {

				switch (event.sig) {
					case SIG_ENTRY :
					trace("hsm_s_HasntActivated-");
						hsm_callbackIn(1);
						trace("hsm_s_HasntActivated--");
					break;
					case SIG_CALLBACK:
						hsm_currentState = hsm_s_Activating;
						break;
				}
			}

		}
		protected function hsm_s_Activating(event:CogEvent):void {
			trace("hsm_s_Activating" + event.sig);
			if (event.type ==CogEvent.EVTD_COG_PRIVATE_EVENT) {

				switch (event.sig) {
					case SIG_ENTRY :
						hsm_callbackIn(1);
					break;
					case SIG_CALLBACK:
						///////////// TRANSITION TO SUB CLASS  /////////////
					/*	if(_initUseHistory){
							if(_initStateDoINIT){
								// from history, but perform init past
								_myCurState = _initState.call (this, EVT_EMPTY);
								//ReEnter state (but no enter actions have been performed)
								tran( _initState);
							}else{
								//from history, no init past
								myCurState = _initState;
								onInternalStateChanged();
							}
						}else{*/
							var tOpts:TransitionOptions = new TransitionOptions();
							tOpts.doInitDiscovery = _initStateDoINIT;
							tran(_initState, tOpts );
						
						//After child state has entered initial state, turn this into
						// active and allow public acceptance of events
						hsm_currentState = hsm_s_Active;
						//setHSM(hsm_s_Active, "hsm_s_Active");
						break;
				}
			}

		}
		/* State where the subclasses are actually 
		* able to process events 
		*/
		protected function hsm_s_Active(event:CogEvent):void {
				//use namespace  COG;
			if (event.type ==CogEvent.EVTD_COG_PRIVATE_EVENT) {
				trace("hsm_s_Active" + event.sig);
				switch (event.sig) {
						case SIG_ENTRY:
							trace("HIGHLIGHT1 !!!!!!!!!!!!!!!!!!!! HSM now ACTIVE !!!!!!!!!!!!!!!!!!!!!!!!!");
							hsm_is_Active = true;
							dispatchEvent(new CogExternalEvent(CogExternalEvent.INIT));
							//First event propogated to the external world
							onInternalStateChanged();
							//dispatchEvent( new CogEvent(CogEvent.EVTD_COG_PUBLIC_EVENT, 
							//var cogE:CogExternalEvent=new CogExternalEvent(CogExternalEvent.,lastState,myCurState);
							//dispatchEvent(cogE);
						break;
						case SIG_EXIT:
						 
						break;
				}
			}else{
				trace("HIGHLIGHT1 "+ toStringShort () + ".Q_dispatch "+  event);
				REQUIRE(event != null, "Q_dispatchI must not have a null event");
				REQUIRE(event.sig != null, "Q_dispatchI must not have an event with a valid SIG signature");
				////////////////////////////////////
				// responsible for firing an Event through the active state list/stack
				// until it hits a loop, or the event is consumed (the state returns null)
				 var s : Function = myCurState;
				 var t : Function;
				do
				{
				//	trace("DISPATCH 111111111111" + mySource.call (this, TRACE_EVT));
					t = s.call(this,event);
					REQUIRE( t != myCurState, _smName + _smID +" statemachine, hit infinite state loop!, state(event) should return null or another state");
					s = t;
					//trace("DISPATCH 22222" + mySource.call (this, TRACE_EVT));
				} while (t !=s_root && t != null );
				trace("HIGHLIGHT0 Q_dispatchEND ");
			}
		}
		//============== TRANSITION BLOCK ============================//
		protected function hsm_s_ActiveInTransition(event:CogEvent):void {
			trace("hsm_s_ActiveInTransition" + event.sig);
			if (event.type ==CogEvent.EVTD_COG_PRIVATE_EVENT) {

				switch (event.sig) {
					case SIG_ENTRY :
						hsm_currentState = hsm_s_Activating;
						break;
				}
			}
		}
		protected function hsm_s_Deactivating(event:CogEvent):void {
			trace("hsm_s_Deactivating" + event.sig);
			if (event.type ==CogEvent.EVTD_COG_PRIVATE_EVENT) {

				switch (event.sig) {
					case SIG_ENTRY :
						hsm_currentState = hsm_s_Deactivated;
						break;
					case SIG_EXIT:
					
					break;
				}
			}
		}
		protected function hsm_s_Deactivated(event:CogEvent):void {
			trace("hsm_s_Deactivated" + event.sig);
			if (event.type ==CogEvent.EVTD_COG_PRIVATE_EVENT) {

				switch (event.sig) {
					case SIG_ENTRY :
						hsm_is_Active = false;
						break;
				}
			}
		}
		/////////////////////// INHERITABLE STATES ////////////////////////////////////////////////////////
		/*...........Root State, that underlies everythign......................................................*/
		 public function s_root(event:CogEvent):Function {
			//trace("s_root()----");
			//onFunctionEnter("s_root", e, []);
			//__cStateOpts = emptyArray;
			//trace (_smName + _smID + __cStateName +".RootState(" + e.toString () + ")");
			return null;
		}
	}

}