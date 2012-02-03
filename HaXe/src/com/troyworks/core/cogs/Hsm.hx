package com.troyworks.core.cogs;

import Xml;
using Xml;

//using Type;
import haxe.PosInfos;
import haxe.Timer;

import flash.errors.Error;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Dictionary;

import com.sf.Assert;using com.sf.Assert;


import com.sf.log.Logger;
using com.sf.log.Logger;

import com.sf.Option;
using com.sf.Option;

using com.sf.Functions;
import com.sf.Util;using com.sf.Util;

import com.troyworks.core.cogs.CogSignal;
using com.troyworks.core.cogs.CogSignal;

using com.troyworks.core.cogs.Hsm;
import com.sf.Option;using com.sf.Option;

import com.sf.Methods;using com.sf.Methods;

import com.troyworks.core.cogs.StateMachine;
import com.sf.Methods; using com.sf.Methods;

import stax.Iterables; using stax.Iterables;

class Hsm extends StateMachine, implements IStateMachine, implements IFiniteStateMachine, implements IHeirarchicalStateMachine, implements IStackableStateMachine {

	public static function withError(b:Bool,error:Dynamic){
		if(!b){
			throw error;
		};
	}
	public 	var s_root : State;

	private var hsm_currentState(default,default) 					: State;

	public  var smID(default, null)	 				: Int;
	public  var hsmIsActive(default, null) 			: Bool;

	/* these are special events that don't need to be tracked for time/undo */
	static public  var EVT_INIT 					: CogEvent 			= CogEvent.EVT_INIT;
	static public  var EVT_EMPTY 					: CogEvent 			= CogEvent.EVT_EMPTY;

	static var ARG_INIT 							: Array<Dynamic> 	= [EVT_INIT];
	static var ARG_EMPTY 							: Array<Dynamic> 	= [EVT_EMPTY];
	static public  var HSM_EVT_EXIT 				: CogEvent 			= new CogEvent(CogEvent.EVTD_COG_PRIVATE_EVENT, CogSignal.SigExit());

	static public  var HSM_EVT_ENTRY 				: CogEvent 			= new CogEvent(CogEvent.EVTD_COG_PRIVATE_EVENT, CogSignal.SigEntry());

	static public  var HSM_EVT_CALLBACK 			: CogEvent 			= new CogEvent(CogEvent.EVTD_COG_PRIVATE_EVENT, CogSignal.SigCallback());


	//////////////// HSM STATE //////////////////////
	private var _hasInited 							: Bool;
	/* whether to perform INIT actions from initial state*/
	private var _initStateDoINIT 					: Bool;
	/* the top most active state, the one that gets first dibs on the
	new events */
	
	/* source state duration a transition */
	private var mySource 							: State;
	
	/* target state during a transition */
	private var targetState 						: State;
	private var lastState 							: State;

	//////////////// INTERNAL HSM STATE ///////////////////
	private var _hsm_hasInited 						: Bool;
	/* function pointer to initial pseudo state*/
	private var _hsm_initState 						: State;
	
	/* transition index  */
	private var tran_Idx 							: Hash<Array<Dynamic>>;
	/* whether or not we are in a tranition */
	private var transLock 							: Bool;
	private var _callBackTimer 						: Timer;
	/* a place to store pending transition list */
	private var pendingTranList 					: Array<State>;
	//an empty array with nulls as placeholders
	private var entry 								: Array<State>;
	private var exitry 								: Array<State>;

	//TODO would a hash do?
	//private var dict : Dictionary;
	/* a variable to hold the xml topology, generally this doesn't change for most statemachines at runtime */
	public  var topology 							: Xml;
	public  var stateNameIdx 						: Array<Dynamic>;
	
	/**********************************************************************
	 * 
	 * ********************************************************************/
	public function new(initStateNameAct : String = null, smName : String = "Hsm", aInit : Bool = true) {
		super();
		s_root 						= Method1.toMethod( function(x:CogEvent){ return null;} , "s_root");
		_smNameID					= smName;
		_hasInited 					= false;
		
		hsmIsActive 				= false;
		_hsm_hasInited 				= false;
		transLock 					= false;
		//TODO does this optimisation hold for haxe?
		entry 						= [null, null, null, null, null, null, null, null, null, null, null];
		exitry 						= [null, null, null, null, null, null, null, null, null, null, null];
		topology 					= null;
		

		Debug(("Construct HSM(" + smName + ")")).log();
		
		var initState 		: State;
		var initStateName 	: String;

		if(initStateNameAct == null)  {
			initStateName = "s_initial";
			_initStateDoINIT = true;
		}else  {
			var ary : Array<Dynamic> = initStateNameAct.split(",");
			initStateName = Std.string(ary[0]);
			_initStateDoINIT = (ary.length == 1);
		}
		Debug(initStateName).log();

		var init_function 	= Reflect.field(this,initStateName);
		Assert.isNotNull(init_function);
		initState 			= Method1.toMethod(init_function,initStateName);

		_smID 				= StateMachine.getNextID();

		if( smName == null ){
			Error(_smID + "Statemachine requires a name").log();	
		}
		if( initState.equals(s_root) ){
			Error([initState,s_root,"should not be the same function"].join(" ")).log();
		}

		hsm_currentState 	= _hsm_initState 		= hsm_s_Initial.toMethod("hsm_s_Initial");
		

		this.initState		= initState;
		mySource = currentState	= s_root;
		 		

		
		smName				= (smName == null) ? "HSM" + _smID : smName;
		evtque 				= new Array<Dynamic>();
		heartbeat 			= StateMachine.getHeartBeat();
		tran_Idx 			= new Hash();
		/////////////////////////////////
		onConstructed();
		if(aInit)  {
			Debug("AUTOINIT").log();
			initStateMachine();
		}
	}

	/**********************************
	 * Called after all classes, parent classes have 
	 * set the attributes as necessary
	 * *********************************/
	function onConstructed() : Void {
		Debug("Construct").log();
		if(topology == null)  {
			discoverTopology(this);
		}else  {
			//// CREATE THE NAME to FUNCTION PAIR FOR DEBUGGING / VISUALIZATION

			var o 	: CacheObject;
			var mn 	: String;
			var i 	 : Int = 0;

			while(i < stateNameIdx.length) {
				mn = stateNameIdx[i];

				var fn : CogEvent -> Dynamic = Reflect.field(this,mn);
				var m 	: State = new Method1( fn , mn);
				

				states.set(mn, new CacheObject( m  , mn.createElement() ));
				i++;
			}
		}
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
	function discoverTopology(base : Dynamic, cacheResults : Bool = true) : Void {
		//Debug(("HSM.discoverTopology with namespace!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ")).log();
		
		if(cacheResults && (topology != null))  {
			return; 
		}
		
	
		var stateNames : Array<Dynamic> = new Array<Dynamic>();
		
		for (mn in Type.getInstanceFields(Type.getClass(this))) {
			//Debug((" checking method " + mn)).log();

			if((mn.indexOf("hsm_s_") == -1) && (mn.indexOf("s_") == 0) ) {

				Debug(mn + " " + Reflect.field(this,mn)).log();
				var x: Dynamic = Reflect.field(this,mn);

				if( Std.is(x,Method) ) {
					var m = cast(x,Method<Dynamic,Dynamic,Dynamic>);
					states.set(m.name, new CacheObject(cast m, mn.createElement()));
				}else{
					var fn : CogEvent -> Dynamic = cast x;
					Assert.isNotNull(fn);
					if( !Reflect.isFunction(fn) ) Error(fn).log() ;
					var m 	: State = new Method1( fn , mn);
					
					states.set(mn, new CacheObject( m , mn.createElement() ));
				}

				//Debug(("type  " + mn)).log();
			}
		}
		Debug(states).log();
		Debug("Build Link Tree").log();
		///////////// BUILD LINKED TREE /////////////////
		for (key in states.keys()) {
			Debug(("testing " + key)).log();
			if(key == "s_initial")  {
				states.get("s_root").xml.addChild(states.get(key).xml);
			}else if(key != "s_root")  {
				var cached 									= states.get(key);
				

				var gtParentFunc 							= cached.method;
				Debug(states.get(key) + " -> " + gtParentFunc).log();
				

				var parentFunc 	= gtParentFunc == null ? null :  this.execute(gtParentFunc,EVT_EMPTY) ;
					
				Debug(parentFunc).log();
				
					if(parentFunc == null)  {
						Error("invalid Statemachine Topology " + key + " " + states.get(key) + " has null parent, check return value").log();
					}
					var p_state 							= parentFunc == null ? null : states.get( parentFunc.name );

					var kidNode  = cached.xml;
					states.get(parentFunc.name).xml.addChild(kidNode);
				
			}else  {
				/// root //
			}

		}
		Debug("Create Cache").log();
		var sxml  = Xml.createDocument();

		//new flash.xml.XML("<hsm/>");
		Debug(states).log();

		var root = states.get(s_root.name);
		Assert.isNotNull(root);

		sxml.addChild(states.get(s_root.name).xml);
		Debug(sxml).log();
		//Debug((" RESULT TREE \r" + sxml.toString().split(">").join("").split("<").join(""))).log();
		if(cacheResults)  {
			topology = sxml;
			stateNameIdx = stateNames;
		}
	}

	public function getStateName(fn : State) : String {
		////use namespace  COG;
		var res = null;
		for (key in states.keys()) {
			var s = states.get(key);
			if( Reflect.compareMethods(s.method, fn ))  {
				if( fn != null ){
					res = s.method.name;
					break;
				}else{
					Error("Null StateCache Encountered" + fn );
				}
			}
		}
		return res;
	}

	//////////////////// ACCESSORS ////////////////////////////
	override public function getStateMachine_hasInited() : Bool {
		return _hsm_hasInited;
	}

	public function set_hsm_currentState(state : State) : State {
		Assert.isNotNull(state);
		Debug(state).log();
		var oldState 	: State = hsm_currentState;
		var args 		: Array<Dynamic>;
		var evt 		: CogEvent;
		//// EXIT CURRENT STATE ---------------------------------
		if(sOk(hsm_currentState))  {
			this.execute(hsm_currentState,HSM_EVT_EXIT);
			// since we've exited we are no longer in a valid state
			hsm_currentState = null;
		}
		this.execute(state,HSM_EVT_ENTRY);
		hsm_currentState = state;
		return state;
	}

	public function setHSM(state : State, name : String) : Void {
		Debug(state).log();
		hsm_currentState = state;
	}

	///////////// EXTERNAL STATE ///////////////
	function getMyCurState() : State {
		return currentState;
	}

	function setMyCurState(stateFN : State) : State {
		if(stateFN == null){ Error("Null"); }
		//var ary : Array = getStateNames(_currentState,stateFN);
		//Debug((_smName +" currentState **Changed** from "+ _currentState+":"+ ary[0] + " to " +stateFN +":"+ ary[1] + "     HIGHLIGHTy" )).log();
		currentState = stateFN;
		return stateFN;
	}

	public function getSmID() : Int {
		return _smID;
	}

	////////////////// METHODS ////////////////////////////
	function hsm_isInState(state : State) : Bool {
		var res : Bool = compare(state,hsm_currentState);
		Debug(("isInState " + res)).log();
		return res;
	}

	/***********************************************************
	 * Returns version number of this Statemachine
	 */
	public function getHsmVersion() : String {
		return "Hsm ver 3.0";
	}

	/***********************************************************
	 * returns whether or not a passed in function of a statemachine
	 * is the top most state (menaing it handles the events first) before
	 * passing onto parents.
	 * e.g.  Debug(("video ready? " + cs.isCurrentState(cs.s10_pausedAtBeginning))).log(); 
	 */
	public function isCurrentState(stateFn : Dynamic) : Bool {
		var st = asState(stateFn);
		return this.compare(this.currentState,st);
	}

	/****************************************************************
	 * returns whether or not the given function state is on the
	 * active linked list/stack.
	 * e.g.  Debug(("video active? " + cs.stateIsActive(cs.s1_active))).log();
	 */
	override public function isInState(st : Dynamic) : Bool {
		var state = asState(st);
		
		Debug([state,this.currentState]).log();
		var s : Dynamic = this.currentState;
		if(!sOk(s)){
			return false;
		}
		var f = null;

		do{
			Assert.isNotNull(s);
			Debug(s);
			
			Debug(s);
			if( compare(s,state) ){
				return true;
			}
			s =  execute( s , EVT_EMPTY ) ;
		}while( ((s != null) && (!compare(s,s_root)) ));

		return false;
	}

	/*hsm_callbackIn is needed to get around the single thread reenter a state issue we are supposed to have left issue.  this when off caused some nasty bugs that are hard to track down. e.g. you write a good statemachine, looks good then when running it starts doing wierd things during transitions that execute other transitions.
	*/
	public function hsm_callbackIn(ms : Int = 45) : Void {
		Debug(ms).log();
		//	var myTimer : Timer = new Timer(ms, 1);
		//	myTimer.addEventListener("timer", hsm_onCallbackHandler);
		//	myTimer.start();
		haxe.Timer.delay(hsm_onCallbackHandler, ms);
	}

	public function hsm_onCallbackHandler() : Void {
		
		if(sOk(hsm_currentState)){
			Debug(hsm_currentState).log();
			this.execute(hsm_currentState,HSM_EVT_CALLBACK);
		}
		
	}

	/*************************************************/
	override public function dispatchEvent(event : Event) : Bool {
		Debug((_smNameID + ":Hsm.dispatchEvent")).log();
		if(Std.is(event, CogEvent))  {
			//use namespace  COG;
			//tmp state variables
			var s 	: State;
			var sp 	: State;
			var ce 	: CogEvent = cast((event), CogEvent);

			/////// LET CHILD DO IT////////////
			if(_childState != null)  {
				Debug("handing to child").log();
				_childState.dispatchEvent(ce);
			}
			if(ce.continuePropogation)  {
				Debug("Continue Propogation").log();
				//trace_smName + "." + getStateName(_currentState) + ":Hsm.dispatchEvent Cog " + event.type);
				if(sOk(currentState))  {
					s = currentState;
					while(true) {
						mySource = s;
						sp =  this.execute(s,ce) ;
						if (!sOk(sp) || compare(sp,s_root)) {
							Debug(mySource).log();
							break;
						}else {
							// else haven't arrived at target state yet, keep going
							s = sp;
						}

					}

				}else  {
					Warning("Null State").log();
				}

			}
			return true;
		}else {
			Debug("dispatchEvent normal " + event ).log();
			return super.dispatchEvent(event);
		}

	}
	public function callbackIn(ms : Int = 45) : Void {
		Debug(ms).log();
		//var _callBackTimer : Timer = new Timer(ms, 1);
		//_callBackTimer.addEventListener("timer", onCallbackHandler);
		//_callBackTimer.start();
		//TODO callback doesn't need event parameter
		Timer.delay(callback(onCallbackHandler,null), ms);
	}

	public function onCallbackHandler(event : TimerEvent = null) : Void {
		Debug(event).log();
		if(!sOk(currentState))  {
			dispatchEvent(CogEvent.getCallbackEvent());
			//IEventDispatcher(event.target).removeEventListener("timer", onCallbackHandler);
			//trace"BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");
		}else  {
			Error(_smNameID + " HSM.onCallbackHandler cannot call a null state ").log();
		}

	}

	/************************************************
	 * This is called to activate the statemachine
	 * meaning when it's first constructed it exists in a
	 * unoperational unefined state, calling this init
	 * takes it from the pseduo intial state, to whatever
	 * state that initial state defines int the constructor
	 * **********************************************/
	override public function initStateMachine() : Void {
		Debug(_hsm_initState ).log();
		(this._hsm_initState != null).withError(["_hsm_initState cannot be null, set it in your constructor"]);
		//trace"PRE HSM_EVT_ENTRY HSM_EVT_ENTRYHSM_EVT_ENTRY");
		this.execute(_hsm_initState,HSM_EVT_ENTRY);
		//trace"POST HSM_EVT_ENTRY HSM_EVT_ENTRYHSM_EVT_ENTRY");
	}

	override public function deactivateStateMachine() : Void {
		requestTran(hsm_s_Deactivated);
	}

	public function requestTranNoInit(tS : Dynamic ) : Void {
		var targetState = asState(tS);
		Debug(targetState).log();
		var tOpts : TransitionOptions = new TransitionOptions();
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
	override public function requestTran(t : Dynamic, transOptions : TransitionOptions = null, crossAction : Void -> Void = null) : Void {
		Debug(t).log();
		var targetState = asState(t);
		//use namespace  COG;
		//(targetState != null).withError(["***ERROR*** %1.tran, passed null state function" ,  toStringShort ()]);
		(!compare(targetState,s_root)).withError(["cannot transition to root state!"]);
		//	(targetState is State).withError(["***ERROR*** %1.QTRAN, passed invalid state function:  %2", toStringShort (),(targetState is Function)]);
		evtRequestTime = Timer.stamp();
		var qt : QueuedTransitionRequest = new QueuedTransitionRequest(targetState, transOptions, crossAction);
		evtque.push(qt);
		//if already added won't duplicate
		heartbeat.addEventListener(TimerEvent.TIMER, onTranTimer);
	}

	/******************************************
	 * This is the workhorse of the statemachine, processing the
	 * transitions between various states to other states. It's command is the state(function)
	 * to transition to from the current state(function)
	 *
	 * it ensure that actions are performed in the right direction, handling parents appropriately
	 * generally it's Exit actions, Transition Actions (if any), Enter Actions and then possibly
	 * INIT actions. Enter and Exit actions are not allowed to fire off any state transitions of their own
	 * but can update state variables (e.g. visible = true).
	 *
	 * Transitions (not the exit and enter actions) are supposed to be take zero time, meaning all the work is associated with the Enter and Exit actions
	 * and inbetween the Exit and Enter states, when technically it's an undefined state, no work is performed.
	 * if you need work performed between states you should introduce a new state, e.g.
	 *   - OFF->Dimming Up->OnFull
	 *   - Stopped->AnimatedTransitionPlay->Playing
	 *            <-AnimatedTransitionToStop<-
	 */
	override public function tran(t: Dynamic, transOptions : TransitionOptions = null, crossAction : Void->Void = null,?pos:PosInfos) : Dynamic {

		Assert.isNotNull(t);
		var tgt = asState( t );

		Debug(["Transition Called:",tgt,pos.toString(),transOptions ].join("")).log();

		if(compare(s_root,tgt)){
			Error("Cannot transition to root state").log();
		}

		transOptions = (transOptions == null)  ?  TransitionOptions.DEFAULT : transOptions;
		transOptions.isNotNull();

		Assert.isNotNull(currentState);
		Assert.isNotNull(mySource);
		Assert.isNotNull(tgt.name);

		transitionLog 							= [];
		var curName 		: String 			= currentState.name;
		var sourceName 		: String 			= mySource.name;
		var requestedName 	: String 			= tgt.name;

		Debug([ "machine :" , _smNameID,"::",currentState.name, mySource.name,"-->", tgt.name].join(" ")).log();

		var key 			: String 	= curName + "->" + requestedName;
		///////////////////////////
		//tmp state variables
		var s 				: State    	= null;
		var t 				: State  	= null;
		// Capture the target, source and current state for synchronization
		// reason
		var tS 				: State = tgt;
		var sS 				: State = mySource;
		var cS 				: State = currentState;

		Debug([tS,sS]).log();

		Assert.isNotNull(currentState);
		Assert.isNotNull(sS);
		Assert.isNotNull(cS);

		// target parent and source parent state
		var raw 			: Dynamic;
		var fn 				: CogEvent -> Dynamic;

		var tp 				: State = null;
		var sp 				: State = null;
		var lca 			: Int;
		var cont 			: Int;
		var e : Int 						= 0;
		var f : Int 						= 0;
		// reset the action lists
		var preExit 		: Array<State> 	= [];
		entry 								= [];
		exitry 								= [];
		var postEnter 		: Array<State>	= [];
		Debug(["Start","current",cS,"source",sS,"target",tS]).log();

		if(!compare(sS,cS))  {
			Debug(["Unwind",cS,sS]).log();
			s = cS;
			Assert.isNotNull(s);
			while(true) {
				sp =  this.execute( s , EVT_EMPTY ) ;
				if(!sOk(sp)){
					break;
				}else if(compare(sp,sS))  {
					// else haven't arrived at source state yet, keep going
					//trace"arrived unwinding " + getStateName(s));
					preExit.push(s);
					//	f= 1;
					break;
				}else  {
					// else haven't arrived at source state yet, keep going
					//trace" unwinding " + getStateName(s));
					preExit.push(s);
					//	f= 1;
					s = sp;
				}

			}
		}
		Debug(preExit).log();
		var tIsPA 		: Bool = false;
		var skipPrune 	: Bool = false;
		var reentrant 	: Bool = false;
		var LCA 		: State = null;

		//Store this for posterity/history/undo
		lastState = currentState;

		transOptions.isNotNull();
		if(transOptions.useCachedRouting && tran_Idx.exists(key))  {
			//Found an existing routing
			//trace"existing routing");
			var routing = tran_Idx.get(key);
			entry 		= routing[0];
			exitry 		= routing[1];
		}

		else  {
			Debug("Route Discovery").log();
			///////////////////////////////////////////////////////////////////
			//
			// ROUTE   , find the path from the source
			// of the transition to the target state
			// start recording transition chain, if not a dynamic
			//
			////////////////////////////////////////////////////////////////////
			Assert.isNotNull(sS);
			Assert.isNotNull(tS);

			if(compare(sS,tS))  {
				try{
					Debug("Self Transition: " + tS).log();
					entry[e++] = tS;
					exitry[f++] = sS;
					skipPrune = true;
					reentrant = true;
				}catch(e:Dynamic){
					Error(e).log();
				}
			}else  {

				Debug(["Not Self",tS,sS].join(" ")).log();

				tp =  this.execute(tS,EVT_EMPTY);				
				sp =  this.execute(sS,EVT_EMPTY) ;

				Debug([sp,tp]).log();


				if(compare(sS,tp) )  {
					Debug("Child " + tS).log();
					entry[e++] = tS;
				}else if(compare(sp,tp) )  	{
					Debug("Sibling").log();
					entry[e++] = tS;
					exitry[f++] = sS;
				}else if(compare(sp,tS))  {
					Debug("Parent").log();
					exitry[f++] = sS;
					tIsPA = true;
				}else  {
					Debug("MultiLevel").log();

					try{
						s = tS;
						Assert.isNotNull(s);

						while(!compare(s,s_root)) {
							Debug(s).log();
							//trace ("checking enter list from targets's parent"  + s.call (this, TRACE_EVT));
							if (sOk(s)){
								if(compare(s,sS))  {
									Debug("GRANDCHILD").log();
									//trace"e 4.7 (e)  found LCA! " + e);
									LCA = s;
									break;
								}else {									
									Warning("Entry Push " + s + " " + s_root + " ? "  + compare(s,s_root)).log();
									entry[e++] = s;	
								}
								s =  this.execute(s,EVT_EMPTY) ;
							}
						}
					}catch(e:Dynamic){
						Error(e).log();
					}
					
					entry.reverse();
					if(LCA == null)  {
						LCA = entry[0];
					}
					Debug("Entry " + entry + " LCA : " + LCA ).log();
					s = sS;

					try{
						while(sOk(s) && !compare(s,s_root)) {
							//trace ("checking exit list from activestate/source " + s.call (this, TRACE_EVT));
							if(compare(s,tS) || compare(s,LCA))  {
								Debug("GRANDPARENT").log();
								//trace"x 4.7 (h) found LCA ! " + f);
								break;
							}else if(!s.isEmpty()) {
								// add to exit list keep going,
								exitry[f++] = s;
							}else if(s.isEmpty()){
								break;
							}
							s =  this.execute(s,EVT_EMPTY) ;
						}
					}catch(e:Dynamic){
						Error(e).log();
					}

					Debug("Exitry" + exitry).log();

					Debug("Prune " + e + " " + f).log();
					try{
						if(e > 0 && f > 0)  {
							//if we are here we didn't find the LCA *Fig 4.7 (g)
							//trace"----performing LCA extended discovery pruning---------");
							var ee : Int = e;
							var ff : Int = f;
							while( compare( entry[(--ee)] , exitry[(--ff)] ) ) {
								e--;
								f--;
								Debug("discarding " + entry[e] + " " + exitry [f] ).log();
							}

						}
					}catch(e:Dynamic){
						Error(e).log();
					}
					Debug("Done MultiLevel" + e + " " + f).log();
				}

			}

			if(exitry.length == 0)  {
				reentrant = true;
			}

			if(transOptions.doInitDiscovery)  {
				Debug("Init Routing: " + !tIsPA).log();
				//traceace("INIT ROUTING----------------");
				if(!tIsPA)  {
					s = tS;
					tp =  this.execute(s,EVT_EMPTY) ;
					
					while(sOk(s)) {
						t =  this.execute(s,EVT_INIT);
						Debug("Route " + s + "->" + t).log();
						if(!sOk(t) && !this.compare(s,hsm_s_Deactivated))  {
							 Error("error in statemachine topology, EVT_INIT " + s.name + " returned null").log();
						}
						else if(compare(t,tp) || compare(t,s_root))  {
							//reached destination, no init state to process
							break;
						}else {
							postEnter.unshift(t);
							tp = s;
							s = t;
						}

					}

				}
				Debug(postEnter).log();
				postEnter.reverse();
				//for multi level init
			}
			else  {
				Debug(("SKIP INIT ROUTING")).log();
			}

			//CAPTURE List and save it for later
			Assert.isNotNull(tran_Idx);
			tran_Idx.set(key, [entry.copy(), exitry.copy()]);
		}

		///////////////////////////////////////////////////////////////////
		// MERGE the preExit and postEnter lists
		//////////////////////////////////////////////////////////////////
		
		exitry 	= preExit.concat(exitry);
		entry 	= entry.concat(postEnter);
		
		Debug(["MERGED",exitry, entry]).log();
		//Debug(("\r\r")).log();
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

		if(transLock == true){
			Error(["Error in HSM Illegal Transition detected in " + toStringShort() + "Cannnot perform another SigExit(_) or ENTER_EVT use SigInit(_) instead."]).log();
		}
		transLock = true;

		Debug("Begin Transition").log();
		var i : Int;
		var finalState : State = null;
		var msg 	: String;
		var handled : State = null;
		if(f > 0 || preExit.length > 0)  {
			Debug("Exiting").log();
			try{
				i = 0;
				while(i < exitry.length) {
					Assert.isType( exitry[i] , State );
					s = exitry[i];
					
					Assert.isNotNull(s);
					/* retrace exit path in reverse order */
					msg = "EXITING " + s.name;

					Debug(msg).log();

					handled =  this.execute(s,CogEvent.getExitEvent()) ;
					
					Debug( msg + " After").log();

					if(!sOk(handled) )  {
						transitionLog.push(msg + " HANDLED");
					}else  {
						transitionLog.push(msg + " NOT HANDLED");
					}
					finalState =  this.execute(s,EVT_EMPTY) ;
					i++;
				}
			}catch(e:Dynamic){
				Error(e).log();
			}
		}
		if(crossAction != null)  {
			crossAction();
		}
		if(e > 0 || postEnter.length > 0)  {
			Debug("Entering").log();
			/* retrace entry path in reverse order */
			i = 0;
			while(i < entry.length) {
				s = entry[i];
				Assert.isNotNull(s);
				if(!isInState(s) || reentrant)  {
					// if we are going from a child to an already active parent //
					msg = "ENTERING " + s.name;
					Debug(msg).log();
					//tracemsg);
					handled =  this.execute(s,CogEvent.getEnterEvent()) ;
					if(!sOk(handled))  {
						transitionLog.push(msg + " HANDLED");
					}else  {
						transitionLog.push(msg + " NOT HANDLED");
					}

				}
				finalState = s;
				i++;
			}
		}
		transLock = false;
		Debug("Transitions Complete").log();
		
		////////////////////////////////////////////////////////////////////////////
		//
		//  FINISHED with the transition, set the current state to the last entered
		//  and proceed to notify the world
		//
		////////////////////////////////////////////////////////////////////////////

		if (sOk(finalState)){
		
			currentState = finalState;
			dispatchEvent(SigGetOpts().createPrivateEvent());
			onInternalStateChanged();
		}else{
			Error(("WARNING, no statetransition performed")).log();
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
	function onInternalStateChanged() : Void {
		Debug((_smNameID + " NEW STATE " + currentState.name + "active? " + hsmIsActive)).log();
		mySource = currentState;
		//reset it incase no events were fired.
		// FINISHED - notify the rest of the world of the state change, if there is anybody there
		if(hsmIsActive)  {
			if(hasEventListener(CogExternalEvent.CHANGED))  {
				var cogE : CogExternalEvent = new CogExternalEvent(CogExternalEvent.CHANGED, lastState, currentState);
				Debug(("  onInternalStateChanged.notificatifying" + cogE)).log();
				dispatchEvent(cogE);
			}else  {
				Debug(("  no listeners ")).log();
			}

		}

		else  {
			Debug(("  hsm not fully initialized yet")).log();
		}

	}

	override public function toString() : String {
		//Debug(("hsm.toString()")).log();
		var a : Array<Dynamic> = new Array<Dynamic>();
		a.push("Hsm." + _smName + _smID + "." + currentState.name);
		return a.join("
");
	}

	public function toStringShort(stateName : String = null) : String {
		var res : String = _smName + "#" + _smID + "." + (((stateName == null)) ? currentState.name : stateName);
		//Debug(("toStringShort " + res)).log();
		return res;
	}

	////////////////// HSM STATES /////////////////////////////
	/* the default very first pseudostate called when the machine
	 * is turned on via the init() call */
	function hsm_s_Initial(event : CogEvent) : Dynamic {
		Debug(event).log();
		if(event.type == CogEvent.EVTD_COG_PRIVATE_EVENT)  {
			var _sw0_ = (event.sig);
			switch(_sw0_) {
			case SigEntry(_):
				hsm_callbackIn(1);
			case SigCallback(_):
				set_hsm_currentState(hsm_s_HasntActivated.toMethod("hsm_s_HasntActivated"));
			default 	:
			}
		}
		return null;
	}

	function hsm_s_HasntActivated(event : CogEvent) : Dynamic {
		Assert.isNotNull(event);
		Debug(event).log();
		if(event.type == CogEvent.EVTD_COG_PRIVATE_EVENT)  {
			var _sw1_ = (event.sig);
			switch(_sw1_) {
			case SigEntry(_):
				Debug(("hsm_s_HasntActivated-")).log();
				hsm_callbackIn(1);
				Debug(("hsm_s_HasntActivated--")).log();
			case SigCallback(_):
				set_hsm_currentState( hsm_s_Activating.toMethod("hsm_s_Activating") );
			default 			:
			}
		}
	}

	function hsm_s_Activating(event : CogEvent) : Dynamic {
		Debug(event).log();
	
		if(event.type == CogEvent.EVTD_COG_PRIVATE_EVENT)  {
			var _sw2_ = (event.sig);
			switch(_sw2_) {
			case SigEntry(_) 	:
				hsm_callbackIn(1);
			case SigCallback(_):
				///////////// TRANSITION TO SUB CLASS  /////////////
				var tOpts : TransitionOptions = new TransitionOptions();

				tOpts.doInitDiscovery = _initStateDoINIT;
				tran(initState, tOpts);

				//After child state has entered initial state, turn this into
				// active and allow public acceptance of events
				var m = hsm_s_Active.toMethod("hsm_s_Active");
				set_hsm_currentState(m);
				setHSM(m, "hsm_s_Active");
			default :
			}
		}
	}

	/* State where the subclasses are actually 
	 * able to process events 
	 */
	function hsm_s_Active(event : CogEvent) : Dynamic {
		Debug(event).log();
		//use namespace  COG;
		if(event.type == CogEvent.EVTD_COG_PRIVATE_EVENT)  {
			Debug(event.sig).log();
			var _sw3_ = (event.sig);
			switch(_sw3_) {
			case SigEntry(_):
				Debug("HSM now ACTIVE").log();
				hsmIsActive = true;
				dispatchEvent(new CogExternalEvent(CogExternalEvent.INIT));
				//First event propogated to the external world
				onInternalStateChanged();
				//dispatchEvent( new CogEvent(CogEvent.EVTD_COG_PUBLIC_EVENT,
				//var cogE:CogExternalEvent=new CogExternalEvent(CogExternalEvent.,lastState,currentState);
				//dispatchEvent(cogE);
			default:
			}
		}else  {
			Debug(("HIGHLIGHT1 " + toStringShort() + ".dispatchEvent " + event)).log();
			(event != null).withError(["dispatchEventI must not have a null event"]);
			(event.sig != null).withError(["dispatchEventI must not have an event with a valid SIG signature"]);
			////////////////////////////////////
			// responsible for firing an Event through the active state list/stack
			// until it hits a loop, or the event is consumed (the state returns null)
			var s : State = currentState;
			var t : State;
			do {
				//	Debug(("DISPATCH 111111111111" + mySource.call (this, TRACE_EVT))).log();
				t =  this.execute(s,event);
				(t != currentState).withError([_smName + _smID + " statemachine, hit infinite state loop!, state(event) should return null or another state"]);
				s = t;
				//Debug(("DISPATCH 22222" + mySource.call (this, TRACE_EVT))).log();
			}while(!compare(t,s_root) && !sOk(t) );
			
			Debug(("HIGHLIGHT0 dispatchEventEND ")).log();
		}
		return null;
	}

	//============== TRANSITION BLOCK ============================//
	function hsm_s_ActiveInTransition(event : CogEvent) {
		Debug(("hsm_s_ActiveInTransition" + event.sig)).log();
		if(event.type == CogEvent.EVTD_COG_PRIVATE_EVENT)  {
			var _sw4_ = (event.sig);
			switch(_sw4_) {
			case SigEntry(_):
				set_hsm_currentState(hsm_s_Activating.toMethod("hsm_s_Activating"));
			default 		:
			}
		}
		return null;
	}

	function hsm_s_Deactivating(event : CogEvent) : Dynamic {
		Debug(("hsm_s_Deactivating" + event.sig)).log();
		if(event.type == CogEvent.EVTD_COG_PRIVATE_EVENT)  {
			var _sw5_ = (event.sig);
			switch(_sw5_) {
			case SigEntry(_):
				set_hsm_currentState( hsm_s_Deactivated.toMethod("hsm_s_Deactivating") );
			default :
			}
		}
		return null;
	}

	function hsm_s_Deactivated(event : CogEvent) : Dynamic {
		Debug(("hsm_s_Deactivated" + event.sig)).log();
		if(event.type == CogEvent.EVTD_COG_PRIVATE_EVENT)  {
			var _sw6_ = (event.sig);
			switch(_sw6_) {
			case SigInit(_), SigEntry(_):
				hsmIsActive = false;
				dispatchEvent(new CogExternalEvent(CogExternalEvent.CHANGED));
			default 	:
			}
		}
		return null;
	}

	/////////////////////// INHERITABLE STATES ////////////////////////////////////////////////////////
	/*...........Root State, that underlies everythign......................................................*/
	public function s_initial(e:CogEvent) : Dynamic{
		return null;
	}
}