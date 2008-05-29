package com.troyworks.hsmf { 
	 /*
	* This is a heirarchical statemachine inspired by Miro Samek's Quantum Statemachine Framework
	* that uses functions for the states, and pointers for the statetransitions and heirarchy,
	* 
	* A statemachine controls the valid behavior over time. Think of a person, who has different 'states' like awake, and asleep. 
	* Heirarchical states are elaborations on those states, an awake person might be happy, sad, moving etc. 
	* 
	* it's designed to be subclassed for real use (see the HsmfTest for an example).
	*  It extends MovieClip so state like behavior can be added to existing movie clips
	*  and components simply.
	*
	* The state heirarchy is determined by the function's return value (it's parent state, or in this case a function pointer)
	* The active state heirarchy is essentially a linked list built at compile time, determined by the return function inside a state.
	*
	* [+] advangates
	*  - speedy runtime execution, and memory useage (compared to where everystate is an object, on the heap)
	*  - easy to code
	*  - about as simple and compact codewise and as possible (vrs. engineering or statediagrams or State as Class versions
	*  - maintains fast coding (autocomplete, less pollution of the filesystem where each state is a as file
	*  - using functions keeps overall description of a statemachine and refactoring
	* [-] disadvantages
	*  - allows for developers to create invalid statemachines (have to pay attention or validate);
	* [-/+]
	*   - statemachine graph is compiled at runtime, and isn't quite fluid to change by default ( there are ways to create lookup tables),
	*      but is easier on memory
	*
	* advantages over Miro's Actionscript version (available off of www.flashsim.com)
	*  - many bug fixes
	*  - has pulse and callback events built in (less overhead managemet)
	*  - using classes for signals and events allows for richer semantics
	*     both for the parser and for run time
	*       - signals carry no state, they only type/identify/tag a signal
	*       - events  should be of only one state (a snapshot)
	*  - adds events to state changes, so other machines can be notified, synchrnonized 
	*  - utility methods to determine the active state.
	*  - extends the MovieClip class to allow tighter coupling of UI components with their corresponding movieclips, as it is used frequently.
	*
	*Events always propogate like this:
	*   source(EVT) ->should update curState
	* DEBUGGING
	*   (1) For the entire Statemachine In the constructor turn tracesOn = true;
	*   (2) in the particcular state/function, pass in Number.MAX in the onFunctionEnter args
	*   -- unable the Q_TRAN, and disptatch to set boundaries on calls.
	* Usage:
	* ////////////// in constructor:////////////////////////////
	*  		super ();
	        Q_INIT (s0_waitingOnOnLoad); //initial state you want
		 	hsmName = "SRM_P";  // some descriptive name for this for trace outputs.
	        init(); //trigger the waiting state, start processing events. 
	 * 
	///////////create function for  states://///////////////
	function s1_active (e : AEvent) : Function
	{
	this.onFunctionEnter ("s1_active-", e, []);
	switch (e)
	{
	case ENTRY_EVT :
	{
	 //NOTE NO StateChanges/Q_TRANS IN HERE, use INIT_EVT instead.
	
	return null;
	}
	case EXIT_EVT :
	{
	return null;
	}
	case INIT_EVT :
	{
	if (this.autoPlay)
	{
	trace ("******AUTOPLAY****** ");
	this.Q_TRAN (s11_playing);
	} else
	{
	trace ("*****awaiting key stroke*******");
	this.Q_INIT (this.s10_pausedAtBeginning);
	}
	return null;
	}
	}
	return top;
	}
	
	
	*/
	import com.troyworks.events.TEventDispatcher;
	import com.troyworks.framework.ApplicationContext;
	import com.troyworks.datastructures.Array2;
	import com.troyworks.util.DesignByContract;
	import com.troyworks.events.TProxy;
	import com.troyworks.util.DesignByContractError;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.display.MovieClip;
	import flash.utils.setInterval;
	public class Hsmf extends MovieClip {
		public static var Q_EMPTY_SIG : Signal = new Signal (0, "EMPTY");
		public static var Q_INIT_SIG : Signal = new Signal (1, "INIT");
		public static var Q_ENTRY_SIG : Signal = new Signal (2, "ENTRY");
		public static var Q_EXIT_SIG : Signal = new Signal (4, "EXIT");
		public static var Q_TRACE_SIG : Signal = new Signal (8, "TRACE");
		public static var Q_PULSE_SIG : Signal = new Signal (16, "PULSE");
		public static var Q_CALLBACK_SIG : Signal = new Signal (32, "CALLBACK");
		public static var Q_GETOPTS_SIG : Signal = new Signal (64, "GETOPTS");
		public static var Q_TERMINATE_SIG : Signal = new Signal (128, "TERMINATE");
		public static var Q_STATE_CHANGED_SIG : Signal = new Signal (256, "STATE_CHANGED_EVT");
	
		public static var USER_SIG : Signal = new Signal (Signal.SignalUserIDz, "USER");
		/////////////////////////HSMF EVENTS ///////////////////////////////////////////////////
		//These Signals/events are used system wide and don't change, and don't carry any arguments
		// so they can be static
		public static var EMPTY_EVT : AEvent = new AEvent (Q_EMPTY_SIG);
		public static var INIT_EVT : AEvent = new AEvent (Q_INIT_SIG);
		public static var ENTRY_EVT : AEvent = new AEvent (Q_ENTRY_SIG);
		public static var EXIT_EVT : AEvent = new AEvent (Q_EXIT_SIG);
		public static var TRACE_EVT : AEvent = new AEvent (Q_TRACE_SIG);
		public static var PULSE_EVT : AEvent = new AEvent (Q_PULSE_SIG);
		public static var CALLBACK_EVT : AEvent = new AEvent (Q_CALLBACK_SIG);
		public static var GETOPTS_EVT : AEvent = new AEvent (Q_GETOPTS_SIG);
		public static var TERMINATE_EVT : AEvent = new AEvent (Q_TERMINATE_SIG);
		public static var STATE_CHANGED_EVT : AEvent = new AEvent (Q_STATE_CHANGED_SIG);
	
		
		/* the active state */
		protected var _myCurState : Function = null;
		/* source state duration a transition */
		protected var _mySource : Function = null;
		protected var myInitialSource : Function = null;
	
		protected var __tmpState : Function = null;
		
		//the last state we were in (during a QTran)
		public var lastState : Function;
		// a placeholder for states, typically used in generic (e.g. preloader) states
		// as the next state to go to afterwards.
		protected var utilState : Function;
		//an empty array with nulls as placeholders
		protected var entry : Array = [null, null, null, null, null, null, null, null, null, null, null];
		protected var exitry : Array = [null, null, null, null, null, null, null, null, null, null, null];
		public var __cStateName : String = null;
		public var __cStateOpts : Array2 = null;
		public var stateOpts : Array2 = null;
		// the list of options for the current valid state heirachy/stack;
		public var stackOpts : Array2 = null;
		// deferred EVENTS;
		public var deferredEvts : Array = new Array();
		//necessary for the complier
		public static var evtd : TEventDispatcher;
	
		// TEventDispatcher mixin interface
		public var $tevD:TEventDispatcher;
		public var addEventListener : Function;
		public var dispatchEvent : Function;
		public var removeEventListener : Function;
		public static var EVTD_INT_STATE_CHANGED : String = "EVT_INT_STATE_CHANGED";
		// REQUIRED by DesignByContract
		public var ASSERT : Function;
		public var REQUIRE : Function;
		
		////////////////////////////////////////////////////////////////
		//the namve for this stateengine (for Debugging purposes)
		public var hsmName : String = "HsmfE";
	
		public var myCurStateName : String = "";
		public var mySourceStateName : String = "";
		public var myTopStateName : String = "";
		
		//store this only on traces to help when tracing out statetransitions and other active states,
		// this.traceN will change and not be the active or this statenamed state.
		public var __traceN : String = "";
	//	public var _mc : MovieClip;
		//helps ensure that 2 transitions aren't called inside each other (helps debugging invalid statemachines)
		public var transLock : Boolean = false;
		// a placeholder for the setInterval used in the pulse activities
		public var pulseIntV : Number = - 1;
		// a way to register statemachine IDs so when multiple of the identical types are on stage
		// they can be identified.
		public static var IDz : Number = 0;
		// whether or not to show the traces on this particular statemachine.
		public var tracesOn : Boolean = false;
		public var hsmID : Number = null;
		public var log : Function = null;
		public static var INIT_NOT_INITED : Number = -1;
		public static var INIT_INITIALIZING : Number = 0;
		public static var INIT_HAS_INITED : Number = 1;
		public var hasInited : Number = INIT_NOT_INITED;
		public static var INIT_POLICY : Boolean = false;
		public static var emptyArray:Array2 = new Array2();
		////////////////////////////////////////////////////
		// The constructor. The only argument that is passed in
		// is the default function to use if the default top state isn't
		// provided.
		public function Hsmf(initState : Function, hsmfName : String, aInit : Boolean)
		{
			super ();
			///add in the mixins for ASSERT and REQUIRE
			DesignByContract.initialize(this);
			// add in the mixin support for add/remove events
			TEventDispatcher.initialize(this);
			
			//scanFunctions(this);
			trace(hsmName + ":1 " + getCurrentStateNames(true));
	
			hsmID = Hsmf.IDz ++;
			hsmName = (hsmfName != null)? hsmfName: "UnamedHsmf";
			REQUIRE(hsmfName != null,  name+ " Hsmf "+hsmID+" requires an a name passed into constructor" + util.Trace.me(this, "class", true));
			REQUIRE(initState != null,  hsmName+ " Hsmf "+hsmID+" requires an initial state passed into constructor");
			REQUIRE(initState != s_top, hsmName+ " Hsmf "+hsmID+" requires an initial state (not top_st) passed into constructor");
	
			trace("\r"+hsmName+":Hsmf("+initState+")_________________________________________________");
		//	trace(hsmName + ":2 " + getCurrentStateNames(true));
			
			/////// Troywork Framework related ////////////
		//	log = ApplicationContext.getInstance().getLoggerRef();
		//	trace("init. setting myCurState to top ");
			myCurState = s_top;
		//	trace("init. setting mySource to initState ");
		//	trace("init. making sure it's not top " + !(initState ==s_top));
			myInitialSource = initState;
			mySource = initState;
		//	trace("DEBUG: myCurState " + s_top +" mySource " +mySource);
			trace(hsmName + ":init3 " + getCurrentStateNames(true));
			trace(hsmName +" Hsfm()......................................................\r");
			if(aInit == null && true == INIT_POLICY || aInit == true){
				init();
			}
		}
	
		public function get myCurState():Function{
			return _myCurState;
		}
	
		function set myCurState(stateFN : Function):void{
			public var ary : Array = getStateNames(_myCurState,stateFN);
			trace(hsmName +" myCurState **Changed** from "+ _myCurState+":"+ ary[0] + " to " +stateFN +":"+ ary[1] + "     HIGHLIGHTy" );
			_myCurState = stateFN;
			_mySource = stateFN;
		}
	
		function get mySource():Function{
			return _mySource;
		}
	
		function set mySource(stateFN : Function):void{
			//trace("settingMySource " + !(stateFN ==s_top));
			public var ary : Array = getStateNames(_mySource,stateFN);
			trace(hsmName +" mySource **Changed** from "+ ary[0] + " to " + ary[1] + "             ");
			_mySource = stateFN;
		}
		
		///////////////////////////////////////////////////////
		// the call to initialize this statemachine
		// similar to turning on a VCR, the statemachine should be unresponsive to any
		// button presses/events prior to turning it 'on' via this init call.
		// it can have an optional event to pass to the default start state
		// possibly as a configuration flag.
		function init(e : AEvent) : void
		{
			
			REQUIRE(hasInited == INIT_NOT_INITED, toStringShort()+"HSM.init() must be not initalized");
			hasInited = INIT_INITIALIZING;
	
			trace (toStringShort()+ ".init()________________________________________________________________HIGHLIGHT4 ");
			/* HSM not executed */
			trace(" AAAAAAAAAAAA "+ getCurrentStateNames());
		
			REQUIRE(myCurState ==s_top, toStringShort()+"HSM not executed - inital state must be s_top");
			REQUIRE(mySource != null, toStringShort()+"HSM not executed - inital desired state cannot be null..pass in the value in the Hsmf constructor");
			REQUIRE(mySource != s_top, toStringShort()+"HSM not executed - inital desired state cannot be null..pass in the value in the Hsmf constructor");
			deferredEvts = new Array ();
			/*we are about to dereference mySource, save it in a temporary*/
			public var orig : Function = mySource;
			/* take top-most initial tran. */
			e =(e== null)?INIT_EVT:e;
			trace("processing first PSEUDOSTATE   11111111111111");
			// in the s_top, this will change the myCurState to s_initial via the required Q_INIT
			orig.call(this,e);
			trace("processed first PSEUDOSTATE   2222222");
			 //now in the initial state
			//var names = getStateNames(orig, myCurState, myCurState (EMPTY_EVT));
			trace(" BBBBBBBBBB "+ getCurrentStateNames());
	
			onInternalStateChanged ();
			hasInited = INIT_HAS_INITED;
			///////////////pr
			if(myCurState != myInitialSource){
				deferredEvts.push(INIT_EVT);
				createTimedCallBack(createCallback(EMPTY_EVT), 0);
			}
			trace ( hsmName + ".init().....................................................HIGHLIGHT3");
			
		}
		/****************************************************
		 * if fired requires a tranistion
		*/
		function Q_INIT(targ_state : Function) : void {
			trace("Q_INITTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");
			trace(getCurrentStateNames(true));
			trace (toStringShort () + ".Q_INIT ->" + getStateName(targ_state));
			REQUIRE (targ_state != null  , "*** Error ***  Q_tranInit INIT_EVT handling, initial transition must not be null");
			if(myInitialSource != mySource){
			//	ASSERT (mySource ==  targ_state.call(this, EMPTY_EVT) , "*** Error ***  Q_tranInit INIT_EVT handling, initial transition must go *one* level deep, or be self");
			}
			targ_state.call(this, ENTRY_EVT);
			myCurState = targ_state;
	//		myCurState.call(this, INIT_EVT);
		}
		/***********************************************************
		 * Returns version number of this Statemachine
		 */
		public function Q_getVersion() : String{
			return "Hsmf ver 1.0";
		 }
		/***********************************************************
		* returns whether or not a passed in function of a statemachine
		* is the top most state (menaing it handles the events first) before
		* passing onto parents.
		* e.g.  trace("video ready? " + cs.isTopMostState(cs.s10_pausedAtBeginning)); 
		*/
		public function isTopMostState(stateFn : Function) : Boolean
		{
			return (this.myCurState === stateFn);
		}
		
		/****************************************************************
		* returns whether or not the given function state is on the
		* active linked list/stack.
		* e.g.  trace("video active? " + cs.stateIsActive(cs.s1_active));
		*/
		public function isInState(stateFn : Function) : Boolean
		{
		//	trace("isInState?");
			public var tmpSource:Function = this.myCurState;
			do
			{
			//	trace(" isInState? check");
				if (tmpSource === stateFn)
				{
			//		trace("isInState TRUE");
					return true;
				}
				tmpSource = tmpSource (TRACE_EVT);
			} while (tmpSource != null);
			//			trace(" isInState FALSE");
			
			return false;
		}
		/**********************************************************
		 * retrieves the top most state.
		 */
		function getState() : Function
		{
			return myCurState;
		}
		//////////////////////////////////////////////////////
		// attempts to reparent or set the parent of a given
		// statemachine, typically used for switching skins.
		//function setMC(mc:MovieClip):void{
		//trace(super.name + "setting MovieClip to " + mc.name);
		//super = mc;
		//this._mc = mc;
		//trace("after set MovieClip " + super);
		//}
		
		/****************************************************************
		* Acts like a Delegate.create, to the central Q_dispatch
		* but with a specific event.
		* typically used in pulse activities e.g.
		* CODE:
			 case ENTRY_EVT :
			{
			this.playIntV = setInterval (this.createCallback (INCREMENT_PLAYHEAD_EVT) , 1000 / 24 );
			return null;
			}
			case EXIT_EVT :
			{
			clearInterval (this.playIntV );
			return null;
			}
		*/
		/***********************************************************
		 * creates a callback to this particular event, this is useful for when
		 * you have buttons or tween that when fired or finished need to generate 
		 * an event and be dispatched into the statemachine,
		 * the callback is quicker than doing onRelease= function(){ Q_dispatch(new Event(SomeSIG))[
		 * but is roughtly similar.
		 * 
		 * ignoreCallbackParams is useful for when you are using things like Tweens whose callbacks
		 * send the calling function, displacing the event.
		 */
		public function createCallback(e : AEvent, ignoreCallBackParams : Boolean) : Function
		{
			trace ("111111111111111111111111111111111111111111111");
			trace ("111111111111111111111111111111111111111111111");
			trace ("111111111111111111111111111111111111111111111");
			trace ("111111111111111111 " + hsmName + ".createCallback222111111111111111111111111111");
			trace ("11111111111111111111111 Q_dispatch " + this.Q_dispatch + " 1111111111111111111111");
			trace(" for Event: " +e);
			trace ("111111111111111111111111111111111111111111111");
			REQUIRE(e != null, toStringShort () + ":ERROR couldn't create callback, event cannot be null");
			TProxy.currentUserName = toStringShort();
			//TProxy.DEBUG_TRACES_ON = true;
			TProxy.IgnoreCallbackParams = (ignoreCallBackParams == true || ignoreCallBackParams == null);
			public var proxy : Function = TProxy.create(this, this.Q_dispatch, e);
		//	TProxy.DEBUG_TRACES_ON = false;
			TProxy.IgnoreCallbackParams = false;
			return proxy;
		}
		/*********************************************************************
		 * Given the above createCallback, create a one time event that 
		 * performs the callback, if no time is given defaults to the 
		 * 1/24 of a second (typical frame rates);
		 * CODE
		 */
		public function createTimedCallBack( callback : Function, time : Number) : Object{
			time=  (time== null)? 1000/24:time;
			trace(toStringShort () + ":Hsmf.createTimedCallBack "+ callback + " " +time);
			public var o : Object = new Object();
			o.fn = callback;
			o.intV = null;
			o.cancel = function():void{
				clearInterval( Object(this).intV);
			};
			o.timedCallback = function():void{
				trace("TimedCallback FIRING----------------------  " + Object(this).intV);
				clearInterval( Object(this).intV);
				Object(this).fn();
			
			};
			o.intV = setInterval(o, "timedCallback", time);
			return Object;
		}
		
		/*********************************************************************
		 * creates a one-time callback of the CALLBACK_EVT, at the given time (in ms)
		 * this differs from PULSE_EVT which are designed to be continue to repeat.
		 * if no time is provided it defaults to 1/24 of a second (e.g. a frame);
		 * CODE
		 * case ENTRY_EVT:{
		 *  callbackIn();
		 *  break;
		 * }
		 * case CALLBACK_EVT:{
		 * }
		 */
		public function callbackIn(time : Number) : void{
			trace(toStringShort () + ":Hsmf.callbackIn("+ time);
			var fn : Function = createCallback(CALLBACK_EVT);
			createTimedCallBack(fn, time);
		}
		/****************************************************
		 * Determine if this class is already generating pulses
		 * 
		 */
		public function pulseHasStarted() : Boolean{
			return pulseIntV > -1;
		}
		/*****************************************************
		 *  Creates a pulse for the state to handle,
		 *  typically used in checking progress in loading
		 *  or triggering animations
		 *  use stopPulse(); at any time to graphics.clear it out.
		 *  returns the id of the pulse;
		 */
		public function startPulse(timeInMS : Number) : Number
		{
			timeInMS = (timeInMS == null)? 1000/24:timeInMS ;
			REQUIRE(pulseIntV == -1,"ERROR startPulse already started! "+pulseIntV + " " + toStringShort ());
			pulseIntV = setInterval (createCallback (PULSE_EVT) , timeInMS);
			trace(toStringShort () + ":Hsmf.startedPulse++++++++++++++++++++++ HIGHLIGHTG " + pulseIntV);
			return Number(pulseIntV);
		}
		/********************
		 * Stops the pulse event, created by the startPulse()
		 * returns the id of the pulse or -1 if it's invalid.
		 */
		public function stopPulse() : Number
		{
			trace(toStringShort ()  + ":Hsmf.stopPulse------------------- " + pulseIntV + typeof(pulseIntV));
			if (pulseIntV != -1)
			{
				public var p : Number = pulseIntV;
				clearInterval (pulseIntV );
				pulseIntV = -1;
				return p;
			} else
			{
				trace ("WARNING, " + toStringShort () + " pulse stopped when there wasn't any active!");
				return -1;
			}
		}
		public function Q_dispatch(e : AEvent) : void{
			REQUIRE(!DesignByContract.appIsHalted, " app is halted");
			REQUIRE(e != null, "Q_dispatch must not have a null event");
			REQUIRE(e.sig != null, "Q_dispatch must not have an event with a valid SIG signature");
			
			if (deferredEvts.length > 0)
			{
				deferredEvts.push(e);
				trace (util.Trace.me (deferredEvts, " DEFFERED EVENTS ", false));
				public var len : Number = deferredEvts.length;
				for(public var i:Number = 0; i < len; i++)
				{
					var ev : AEvent = AEvent (deferredEvts.shift ());
					trace ("XXXXXXXXXXdispatch deferred XXXXXXXXXX " + e.toString ());
					Q_dispatchI (ev);
				}
			}else{
					Q_dispatchI (e);
			}
			
		}
		public function Q_dispatchI(e : AEvent) : void{
			trace("HIGHLIGHT1 "+ toStringShort () + ".Q_dispatch "+  util.Trace.me(e, e.sig.name));
			REQUIRE(e != null, "Q_dispatchI must not have a null event");
			REQUIRE(e.sig != null, "Q_dispatchI must not have an event with a valid SIG signature");
			if(hasInited == INIT_HAS_INITED){
				////////////////////////////////////
				// responsible for firing an Event through the active state list/stack
				// until it hits a loop, or the event is consumed (the state returns null)
				
				//trace(toStringShort ()+ ".Q_dispatchACTIVE "+ util.Trace.me(e, "EVT "));
				//	trace (hsmName + ".dispatch " + e + " " + util.Trace.me(arguments, "args ", true));
				//util.Trace.me (e, "evt", false));
				public var tmpSrc : Function = myCurState;
				//		var l_state = null;
				do
				{
				//	trace("DISPATCH 111111111111" + mySource.call (this, TRACE_EVT));
					//Causes an infinite loop in flash player 8
					//ORIG:	mySource = mySource (e);
					var nxt : Function = Function(tmpSrc.call(this,e));
					tmpSrc = nxt;
					//trace("DISPATCH 22222" + mySource.call (this, TRACE_EVT));
					REQUIRE( tmpSrc != myCurState, hsmName + hsmID +" statemachine, hit infinite state loop!, state(event) should return null or another state");
				} while (tmpSrc != null);
	
			}else{
				/////// for when the statemachine is initializing or not initialized
				public var s : String = null;
				if(hasInited == INIT_NOT_INITED){
					s = toStringShort () + ".Q_dispatchINACTIVE "+ util.Trace.me(e, "EVT IGNORED, Statemachine not active, set Q_INIT(your firststate) and try  init() first", true);
				}else if(hasInited == INIT_INITIALIZING){
					s = toStringShort () + ".Q_dispatchINACTIVE "+ util.Trace.me(e, "EVT IGNORED, Statemachine cannot dispatch events until initialized, set Q_INIT(your firststate) and try  init() first", true);	
				}
				REQUIRE(false, s);
			}
			trace("HIGHLIGHT0 Q_dispatchEND ");
		
		}
		//converts from eventdispather to local events
		function dispatchED(e : AEvent) : void
		{
			trace (hsmName + hsmID  + ".dispatchED " + e.toString ());
			//util.Trace.me (e, "evt", false));
			Q_dispatch (e);
		}
		//called on a state recieving an event to setup the name, and available options as well
		// as trace to the output
		function Q_dispatchDeferredEvents() : void
		{
		}
		function onFunctionEnter(stateName : String, e : AEvent, stateOpts : Array, traceOpts : Number) : void
		{
			//trace ("Hsmf.onFunctionEnterAA" + stateName + "(" + e.toString () + ")");
	
			if (e == TRACE_EVT)
			{
				//store this only on traces to help when tracing out statetransitions and other active states,
				// traceN will change and not be the active state.
				__traceN = toStringShort(stateName);
				if (tracesOn)
				 {
					trace ("TRACE: "+__traceN +"("+e.sig.name+ ")----------------------------------------------");
				}
				return;
			} else if (e != EMPTY_EVT && e != GETOPTS_EVT && tracesOn || traceOpts == Number.MAX_VALUE)
			{
				trace (stateName + "(" + e.toString () + ")");
			}
			__cStateName = stateName; //NOT toStringShort(stateName);
		//	trace(hsmName+"."+ __cStateName+ "onFunctionEnter  " + stateOpts);
			var a:Array2;
			if(!(stateOpts is Array2)){
				a = new Array2();
				if(stateOpts != null && stateOpts.length >0){
				a.appendArray(stateOpts);
				}
				
			}else{
				a = Array2(stateOpts);
			}
			__cStateOpts = (a == null) ? emptyArray : a;
		}
		/******************************************************************
		* A utility method for getting possible actions/Events associated with this state
		* used in testing and introspected User interfaces,
		*
		* which is called at the end of any state transition, This also fires off the statechanged
		* event to other interested parties who might be intereseted in updating, e.g. the User Interface
		*/
		function onInternalStateChanged() : void {
			//		_global.outText ("onInternalStateChanged(" + getTimer () + ")-------------------");
			var tmp_sOpts : Array2 = new Array2 ();
			var tmp_stkOpts : Array2 = new Array2 ();
			var tmp = myCurState;
			var c : Number = 0;
			var s : Function = myCurState;
			//trace (c ++ + "A getting options for " + __cStateName + " are " + __cStateOpts);
			//sOpts = sOpts.concat (__cStateOpts);
			do
			{
				s = Function (s.call (this, GETOPTS_EVT));
			//	trace ("  -" +(c ++) + " options for " + __cStateName + " are " + __cStateOpts);
				if(__cStateOpts != null && __cStateOpts.length > 0){
				//	trace("adding to the collection -----------------");
				//	trace("sktOPts1 " + tmp_stkOpts + " " + __cStateOpts);
					tmp_stkOpts = tmp_stkOpts.concat (__cStateOpts);
					tmp_sOpts.push (
					{
						name : __cStateName , opts : __cStateOpts.concat ()
					});
				}
			} while (s != null);
			//
			//myCurState = tmp;
			myCurState.call (this, EMPTY_EVT);
		  //  trace("finished getting options " + util.Trace.me(tmp_sOpts, "CUR STATE OPTIONS", true));
		  // trace("finished getting options " + util.Trace.me(tmp_stkOpts, "ALL STATE OPTIONS", true));
			stateOpts = tmp_sOpts;
			stackOpts = tmp_stkOpts;
			//trace(hsmName + hsmID +"-------------------------------dispatching state change events =-====================");
			trace ( toStringShort() +" statechanged to: " + __cStateName  + "     ");
			dispatchEvent (
			{
				type : Hsmf.EVTD_INT_STATE_CHANGED, target : this, state : myCurState, stackOpts : stackOpts
			});
		
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
		*   - Stopped->AnimatedTransitionToPlay->Playing
		*            <-AnimatedTransitionToStop<-
		*/
		function Q_TRAN(targ : Function) : void
		{
			REQUIRE(targ != null, "***ERROR*** " + toStringShort () +".QTRAN, passed null state function" );
			REQUIRE(targ is Function, "***ERROR*** " + toStringShort () +".QTRAN, passed invalid state function:  " + (targ is Function));
			////////////For Debugging Purposes/////////////////
			mySource.call (this, TRACE_EVT);
			var an : String = __traceN;
			targ.call (this, TRACE_EVT);
			var bn : String = __traceN;
			trace ("Q_Tran>>>>>>>>>>>>>>>>>>>>>>>>>>>>> \r\t" + an + " to \r\t" + bn + "");
			var names : Array = getStateNames(mySource, myCurState, s_top);
			trace(" CCCCCCCCCCCC00 _source: " + names[0] + " myCurState: " +names[1] + " top: " + names[2]);
			
			///////////////////////////
			//s= state
			var s : Function;
			//t = state
			var t : Function;
			var lca : Number;
			var cont : Number;
			var e : Number = 0;
			var f : Number = 0;
			lastState = mySource;
			//target is parent and it's already active.
			var tIsPA : Boolean = false;
			// assume entry to target
			if (mySource == targ)
			{
		//		trace ("(a) - self transition");
				/* Fig 4.7(a) */
				/* source == target (transition to self) */
				entry [e ++] = targ;
				exitry [f ++] = mySource;
				/* exit source */
			} else
			{
		//		trace ("source != target");
				// JMK myCurState = targ;
				//target's parent state
				public var tp : Function = Function (targ.call (this, EMPTY_EVT));
				//sources parent state
				public var sp : Function = Function (mySource (EMPTY_EVT));
				public var lcaEn : Boolean = false;
				public var lcaEx : Boolean = false;
				//Single Level Transitions, no extended discovery needed.
				if (mySource == tp && myCurState == mySource)
				{
		//			trace ("*Fig 4.7 (b)* -  transition to first child - ENTER" );
					entry [e ++] = targ;
				} else if (sp == tp&& myCurState == mySource)
				{
		//			trace ("*Fig 4.7 (c) (sp == tp)* -  transition to sibling via parent EXIT and ENTER chain ");
					entry [e ++] = targ;
					exitry [f ++] = mySource;
				} else if (sp == targ&& myCurState == mySource)
				{
		//			trace ("*Fig 4.7 (d)* -  transition to first parent EXIT");
					exitry [f ++] = mySource;
					tIsPA = true;
				} else
				{
		//			trace ("*Fig 4.7 (e),(f), (g), (h) (sp.. == tp..)* -  transition to sibling(s) EXIT and ENTER chain  ");
					//ENTER LIST from target
					for (s = targ; s != null; s = Function (s.call (this, EMPTY_EVT)))
					{
						//trace ("checking enter list from targets's parent"  + s.call (this, TRACE_EVT));
						if (s == mySource )
						{
		//					trace ("e 4.7 (e)  found LCA! " + e);
							lcaEn = true;
							break;
						} else if (s == s_top)
						{
							break;
						}
		//				trace ("adding entry to list" + s.call (this, TRACE_EVT));
						entry [e ++] = s;
					}
					//EXIT LIST get exitter list from source
					for (s = myCurState; s != null; s = Function (s.call (this, EMPTY_EVT)))
					{
		//				trace ("checking exit list from activestate/source " + s.call (this, TRACE_EVT));
						if (s == targ )
						{
		//					trace ("x 4.7 (h) found LCA ! " + f);
							lcaEx = true;
							break;
						} else if (s == s_top)
						{
							break;
						}
		//				trace ("adding to exit list " + s.call (this, TRACE_EVT));
						exitry [f ++] = s;
					}
		//			trace ("\r\r");
		//			traceEnterExitList (f, e, "after normal routing");
		//			trace ("\r\r");
					if ((e > 0 && f > 0)) //&& ( ! lcaEn && ! lcaEx)
					{
						//if we are here we didn't find the LCA *Fig 4.7 (g)
						//	trace ("----performing LCA extended discovery pruning---------");
						var ee : Number = e;
						var ff : Number = f;
						while (entry [( -- ee )] == exitry [( -- ff)])
						{
							e --;
							f --;
							//		trace ("discarding " + entry [(e )].call (this, TRACE_EVT) + " " + exitry [(f )].call (this, TRACE_EVT));
						}
					}
		//			trace ("\r\r");
		//			traceEnterExitList (f, e, "after LCA discovery");
		//			trace ("\r\r");
				}
			}
			/* now we have the list of operations for this transition  proceed through the chain and exit each one
			* [0] child
			* [1] parent
			* [2] grandparent
			*/
			ASSERT(transLock == false, "Error in HSM Illegal Transition detected in "+toStringShort ()+"Q_TRAN, cannot perform another Q_TRAN inside EXIT_EVT or ENTER_EVT (use INIT_EVT instead) ");
			transLock = true;
			if (f > 0)
			{
				while ((s = Function (exitry [ -- f ])) != null)
				{
					//	trace ("Exiting " + s.call (this, TRACE_EVT))
					/* retrace exot
					* path in reverse order */
					//_global.outText ("preExit4");
					s.call (this, EXIT_EVT);
					//_global.outText ("postExit4");
					/* enter */
				}
			}
			/* now we are in the LCA of source__ and target, proceed through the chain and enter each one  in
			* [0] target
			* [1] target's parent
			* [2] targets's grandparent
			*/
			if (e > 0)
			{
				while ((s = Function (entry [ -- e])) != null)
				{
					/* retrace entry path in reverse order */
					//_global.outText ("preEnter4");
					s.call (this, ENTRY_EVT);
					//_global.outText ("postEnter4");
					/* enter */
				}
			}
			transLock = false;
			//Once we've reached this point we've already entered the target state specified by the
			//transition , but may have substate transitions to attend to, not specified by the
			// requested transition, this should not be more than one level deep.
			// currentState == result  and null = consumed the event
			//
			myCurState = targ;
	
			/*------------- PROCESS THE INIT_EVT --------------*/
			onInternalStateChanged ();
	
			if ( ! tIsPA)
			{
			
				/* process the init event */
				//Q_tranInit();
		
				//this will fire off a Q_TRAN inside the targ, which will update the 
				// myCurState
				// or return null if handled.
				public var res = myCurState.call (this, INIT_EVT);
	
		 		if(res == null){
				//	trace(" INIT EVENT CONSUMED");
					if (myCurState === targ)
					{
						//returned itself so no INIT_EVT handler, or at least no state transition performed
					//	trace("Kept Same state");
					}
				}else{
					//returned another state of some sort.
					if (myCurState === targ)
					{
					//	trace (toStringShort ()+ " ERROR IN STATEMACHINE, INIT_EVT kept same state without consuming" + res);
					} else
					{
						myCurState.call (this, TRACE_EVT);
						var an2 = __traceN;
						targ.call (this, TRACE_EVT);
						var bn2 = __traceN;
						trace (toStringShort ()+"Q_Tran.INIT Has Another StateTransition >>>>>>>>>>>>>>>>>>>>>>>>>>>>> \r\t" + an2 + " to \r\t" + bn2 + "");
						// initial transition must go one level deep, so the empty event will return the parent which should equal the original state 
						ASSERT (targ == myCurState (EMPTY_EVT) , "3 Error in Q_TRAN " + hsmName + " " + __cStateName + ", initial transition must go one level deep");
					}				
				}
			} else
			{
				//parent state is already active no need to reinitialize, but we do need to reactivate ti.
				targ.call (this, EMPTY_EVT);
				//	onInternalStateChanged (targ);
	
			}
			Q_dispatchDeferredEvents ();
		}
		//protected function Q_tranInit(){
	
		//}
		public function traceEnterExitList(x : Number, e : Number, str : String) : void {
			trace ("traceEnterExitList\\ ------ x " + x + " e " + e + "  " + str);
			trace ("[[Exit Chain is ]]" + x);
			for (var i = 0; i < x; i ++)
			{
				public var eb = exitry [i];
				if (eb == null)
				{
					break;
				}
				//trace ("  " + i + " ");
				eb.call (this, TRACE_EVT);
			}
			trace ("[[[Enter Chain is]] " + e);
			for (var i = 0; i < e; i ++)
			{
				public var eb = entry [i];
				if (eb == null)
				{
					break;
				}
				//trace ("  " + i + " ");
				eb.call (this, TRACE_EVT);
			}
			trace ("traceEnterExitList//");
		}
		public function toString() : String
		{
		//	trace("hsm.toString()");
			var a = new Array ();
			a.push ("Hsmf." + hsmName + hsmID + "." + __cStateName);
			return a.join ("\r");
		}
		public function toStringShort(stateName : String) : String
		{
			var res : String = hsmName + hsmID + "." + ((stateName == null)?__cStateName:stateName);
			//trace("toStringShort " + res);
			return res;
		}
		/*******************************************
		 * this function is useful for setting breakpoints 
		 * when an assert or require fails.
		 */
		public function onAssertFailed(evt : DesignByContractError) : void{
			trace("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX HSM ERROR " +toStringShort() + "  XXXXXXXXXXXXXXXXXX " + util.Trace.me(evt));
	
			if(evt.fatal){
		//	 throw new Error(evt.msg);
			}
		}
		/*******************************************
		 * a utility method that takes up to 3 states
		 * and gets the names for them. Useful for debugging and logging
		 */
		public function getStateNames(from : Function, to : Function, top : Function) : Array{
		//	trace("??????????????????????????????????????????????????????????????");
		//	trace("getStateNames from:" + from + " to:" + to  + " top:" + top);
				if(top == null){
				return [getStateName(from), getStateName(to)];
				}else {
				return [getStateName(from), getStateName(to), getStateName(top)];
				}
		
		}
		public function getStateName(fn : Function) : String{
			var res : String;
			__traceN = null;
			{
				fn.call(this, TRACE_EVT);
				res = __traceN;
			// get the source state name
			}
			__traceN = null;
		//	trace("getStateName " + fn +":" +res);
			return res;
	    }
		public function getCurrentStateNames(showTop : Boolean) : String{
		//	trace("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
		//	trace("getCurrentStateNames("+ showTop + ")" + mySource + " " + myCurState + " " + s_top);
			//get current state name
			myCurStateName = getStateName(myCurState);
			// get the source state name
			mySourceStateName = getStateName(mySource);
			//show the top
				if(showTop == null || showTop == false){
				return hsmName + ":  +   source:'" + mySourceStateName + "'  myCurState:'" +myCurStateName+"'";
				}else {
				myTopStateName = getStateName(s_top);
				return hsmName + ":  +   source:'" + mySourceStateName + "'  myCurState:'" +myCurStateName+ "'  top:'" + myTopStateName+"'";
				}
		//		trace("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");	
		}
	
		/*...........Top Most Root State......................................................*/
		function s_top(e : AEvent) : Function
		{
			//trace("s_top()----");
			//onFunctionEnter("s_top", e, []);
			__traceN = "s_top";
			__cStateName = "s_top";
			__cStateOpts = emptyArray;
			//trace (hsmName + hsmID + __cStateName +".topState(" + e.toString () + ")");
			return null;
		}
		//	function hsmf_null (e : AEvent) : Function
		//	{
		//		return new Function();
		//	}
	
	}
	
}