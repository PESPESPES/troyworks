package com.troyworks.core.cogs {
	import com.troyworks.apps.tester.TestEvent;	
	import com.troyworks.apps.tester.TestSuite;	
	import com.troyworks.util.DesignByContract;
	import com.troyworks.util.DesignByContractEvent;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;

	import flash.utils.getTimer;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.events.Event;

	import com.troyworks.logging.TraceAdapter;

	import com.troyworks.core.cogs.NameSpaceTest;
	import flash.utils.Timer;
	import flash.utils.describeType;
    import flash.events.TimerEvent;


	/* This is a comprehensive test of possible state transitios and topologies as inspried by EightStateMachine*/
	public class Test_Hsm extends TestSuite
	{
		protected var GearBox:EightStateMachine;
		protected var myTimer:Timer;
		protected var trace:Function = TraceAdapter.TraceToSOS;
		protected var cogHasInited:Boolean = false;
		protected var timeOutInMS:Number = 200;
		public var timeOutTmer:Timer;

		public function Test_Hsm(){
			super();
//			timeOutTmer= new Timer(timeOutInMS, 1);
 //           timeOutTmer.addEventListener("timer", onTimeOutCallback);
		}
		
	/*	public function test_constructor():Boolean {
			var res:Boolean=false;
			//////////////////////////////////
					var iObj:IntrospectableObj = new IntrospectableObj();
		//	var desc:XML = describeType( iObj);
				//// TRY using 
			//		use namespace COG;
				//iObj.s_introspectable();
		//iObj.COG::["s_introspectable"]();
			///////////////////////////////////
			var GearBox:EightStateMachine=new EightStateMachine () ;
//			var GearBox:NameSpaceTest = new NameSpaceTest();
			//var hsm:Hsm = new Hsm();
			var desc:XML = flash.utils.describeType( GearBox);
			//			var desc:XML = flash.utils.describeType( hsm);
			trace(" RESULT TREE \r" +desc.toString().split(">").join("").split("<").join(""));
			res = (GearBox != null && (GearBox.s_initial_isInState) && !GearBox.hsm_hasInited);
			return res;
		}/**/
		
		//////////// SYNCHRONOUS TESTS /////////////////
		public function test_equal():Boolean{
			return test_equal == test_equal;
		}
		public function test_equal2():Boolean{
			return test_equal === test_equal;
		}
		public function test_equal3():Boolean{
			var fn:Function = test_equal;
			return fn == test_equal;
		}
		public function getEightStateMachine(initListener:Function, defaultState:String = null):EightStateMachine{
			
			
			StateMachine.DEFAULT_TRACE = trace;
			cogHasInited = false;
			var GearBox:EightStateMachine =new EightStateMachine (defaultState) ;
			GearBox.addEventListener(CogExternalEvent.CHANGED,initListener);
			currentResultsFunction = initListener;
			GearBox.initStateMachine();
			return GearBox;
		}
		///////////////////////////////////////////////////////////////////
		// TRANSITION TO HISTORY TESTS
		// transition to history means that no enter events up to that will be performed
		//-------------- s_0 history test --------------------------------------------
		public function atest_0_history_s_0():Number {
			GearBox = getEightStateMachine(rtest_0_history_s_0, "s_0,noINIT") ;	
			return defaultTimeOutInMS;
		}
		public function rtest_0_history_s_0(event:* = null):void{
			trace(GearBox +  "HIGHLIGHTO rtest_0_history_s_0 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			var inited:Boolean = (GearBox.hsmIsActive && GearBox.s_0_isCurrent);
			trace("GearBox.transitionLog " + GearBox.transitionLog);
			var rightPath:Boolean = "ENTERING s_0 HANDLED" == GearBox.transitionLog.toString();
			trace("Test t1: " + inited + "  t2: " + rightPath);
			if(inited && rightPath){
				cogHasInited = true;
				var evt:TestEvent = new TestEvent(Event.COMPLETE,true);
				trace(GearBox + " HIGHLIGHTG rtest_0_history_s_0  PASSED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				dispatchEvent(evt);
			}else{
				trace(GearBox + " ERROR atest_0_history_s0!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			}
		} 
		//-------------- s_1 history test --------------------------------------------

		public function atest_0_history_s_1():Number {
			GearBox = getEightStateMachine(rtest_0_history_s_1, "s_1,noINIT") ;
			return defaultTimeOutInMS;
		}
		public function rtest_0_history_s_1(event:* = null):void{
			trace(GearBox +  "HIGHLIGHTO atest_0_history_s_1 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			var inited:Boolean = (GearBox.hsmIsActive && GearBox.s_1_isCurrent);
			trace("GearBox.transitionLog " + GearBox.transitionLog);
			var rightPath:Boolean = "ENTERING s_0 HANDLED,ENTERING s_1 HANDLED" == GearBox.transitionLog.toString();
			trace("Test t1: " + inited + "  t2: " + rightPath);
			if(inited && rightPath){
				cogHasInited = true;
				var evt:TestEvent = new TestEvent(Event.COMPLETE,true);
				trace(GearBox + " HIGHLIGHTG atest_0_history_s_1  PASSED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				dispatchEvent(evt);
			}else{
				trace(GearBox + " ERROR atest_0_history_s_1!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			}
		} 
		//-------------- s_11 history test --------------------------------------------

		public function atest_0_history_s_11():Number {
			GearBox = getEightStateMachine(rtest_0_history_s_11, "s_11,noINIT") ;	
			return defaultTimeOutInMS;
		}
		public function rtest_0_history_s_11(event:* = null):void{
			trace(GearBox +  "HIGHLIGHTO atest_0_history_s_11 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			var inited:Boolean = (GearBox.hsmIsActive && GearBox.s_11_isCurrent);
			trace("GearBox.transitionLog " + GearBox.transitionLog);
			var rightPath:Boolean = "ENTERING s_0 HANDLED,ENTERING s_1 HANDLED,ENTERING s_11 HANDLED" == GearBox.transitionLog.toString();
			trace("Test t1: " + inited + "  t2: " + rightPath);
			if(inited && rightPath){
				cogHasInited = true;
				var evt:TestEvent = new TestEvent(Event.COMPLETE,true);
				trace(GearBox + " HIGHLIGHTG atest_0_history_s_11  PASSED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				dispatchEvent(evt);
			}else{
				trace(GearBox + " ERROR atest_0_history_s_11!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			}
		} 	
		//-------------- s_2 history test --------------------------------------------

		public function atest_0_history_s_2():Number {
			GearBox = getEightStateMachine(rtest_0_history_s_2, "s_2,noINIT") ;	
						return defaultTimeOutInMS;

		}
		public function rtest_0_history_s_2(event:* = null):void{
			trace(GearBox +  "HIGHLIGHTO atest_0_history_s_2 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			var inited:Boolean = (GearBox.hsmIsActive && GearBox.s_2_isCurrent);
			trace("GearBox.transitionLog " + GearBox.transitionLog);
			var rightPath:Boolean = "ENTERING s_0 HANDLED,ENTERING s_2 HANDLED" == GearBox.transitionLog.toString();
			trace("Test t1: " + inited + "  t2: " + rightPath);
			if(inited && rightPath){
				cogHasInited = true;
				var evt:TestEvent = new TestEvent(Event.COMPLETE,true);
				trace(GearBox + " HIGHLIGHTG atest_0_history_s_2  PASSED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				dispatchEvent(evt);
			}else{
				trace(GearBox + " ERROR atest_0_history_s_2!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			}
		} 	
				//-------------- s_21 history test --------------------------------------------

		public function atest_0_history_s_21():Number {
			GearBox = getEightStateMachine(rtest_0_history_s_21, "s_21,noINIT") ;	
						return defaultTimeOutInMS;

		}
		public function rtest_0_history_s_21(event:* = null):void{
			trace(GearBox +  "HIGHLIGHTO atest_0_history_s_21 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			var inited:Boolean = (GearBox.hsmIsActive && GearBox.s_21_isCurrent);
			trace("GearBox.transitionLog " + GearBox.transitionLog);
			var rightPath:Boolean = "ENTERING s_0 HANDLED,ENTERING s_2 HANDLED,ENTERING s_21 HANDLED" == GearBox.transitionLog.toString();
			trace("Test t1: " + inited + "  t2: " + rightPath);
			if(inited && rightPath){
				cogHasInited = true;
				var evt:TestEvent = new TestEvent(Event.COMPLETE,true);
				trace(GearBox + " HIGHLIGHTG atest_0_history_s_21  PASSED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				dispatchEvent(evt);
			}else{
				trace(GearBox + " ERROR atest_0_history_s_21!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			}
		} 	
				//-------------- s_211 history test --------------------------------------------

		public function atest_0_history_s_211():Number {
			GearBox = getEightStateMachine(rtest_0_history_s_211, "s_211,noINIT") ;	
						return defaultTimeOutInMS;

		}
		public function rtest_0_history_s_211(event:* = null):void{
			trace(GearBox +  "HIGHLIGHTO atest_0_history_s_211 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			var inited:Boolean = (GearBox.hsmIsActive && GearBox.s_211_isCurrent);
			trace("GearBox.transitionLog " + GearBox.transitionLog);
			var rightPath:Boolean = "ENTERING s_0 HANDLED,ENTERING s_2 HANDLED,ENTERING s_21 HANDLED,ENTERING s_211 HANDLED" == GearBox.transitionLog.toString();
			trace("Test t1: " + inited + "  t2: " + rightPath);
			if(inited && rightPath){
				cogHasInited = true;
				var evt:TestEvent = new TestEvent(Event.COMPLETE,true);
				trace(GearBox + " HIGHLIGHTG atest_0_history_s_211  PASSED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				dispatchEvent(evt);
			}else{
				trace(GearBox + " ERROR atest_0_history_s_211!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			}
		} 	
		/////////////////////////////////// INIT TESTS//////////////////////////////////////////////////////
		//----------------- init chain 1 (from root to final)------------------------------------
		public function atest_1_init():Number {
			GearBox = getEightStateMachine(rtest_init) ;	
			return defaultTimeOutInMS;
		}
		public function rtest_init(event:* = null):void{
			trace(GearBox +  "HIGHLIGHTO rtest_init !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			trace("Test " + GearBox.hsmIsActive + "  " + GearBox.s_11_isCurrent);
			var inited:Boolean = (GearBox.hsmIsActive && GearBox.s_11_isCurrent);
			trace("GearBox.transitionLog " + GearBox.transitionLog);
			var rightPath:Boolean ="ENTERING s_initial NOT HANDLED,ENTERING s_0 HANDLED,ENTERING s_1 HANDLED,ENTERING s_11 HANDLED"== GearBox.transitionLog.toString();
			trace("Test t1: " + inited + "  t2: " + rightPath);
			if(inited && rightPath){
				cogHasInited = true;
				var evt:TestEvent = new TestEvent(Event.COMPLETE,true);
				trace(GearBox + " HIGHLIGHTG rtest_init  PASSED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				dispatchEvent(evt);
			}else{
				trace(GearBox + " ERROR rtest_init!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			}
		} 		
			//----------------- init chain 2 (from root via s_2 as )------------------------------------
		public function atest_1b_init_s2():Number {
				GearBox = getEightStateMachine(rtest_init_s2, "s_2") ;	
							return defaultTimeOutInMS;

		}
		public function rtest_init_s2(event:* = null):void{
			var inited:Boolean = (GearBox.hsmIsActive && GearBox.s_211 && !cogHasInited);
			trace("GearBox.transitionLog " + GearBox.transitionLog);
			var rightPath:Boolean = "ENTERING s_0 HANDLED,ENTERING s_2 HANDLED,ENTERING s_21 HANDLED,ENTERING s_211 HANDLED"== GearBox.transitionLog.toString();
			trace("Test t1: " + inited + "  t2: " +rightPath);
			if(inited && rightPath){
				var evt:TestEvent = new TestEvent(Event.COMPLETE,true);
				trace(GearBox + " HIGHLIGHTG rtest_init_s2  PASSED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				dispatchEvent(evt);
			}else{
				trace(GearBox + " ERROR rtest_init_s2!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			}
		} 		
			
		public function atest_2_SELF(): Number {
			trace(GearBox + "HIGHLIGHT atest_2_SELF \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\" );
			GearBox = getEightStateMachine(rtest_2_SELF) ;	
			return defaultTimeOutInMS;
		}
		public function rtest_2_SELF(event:* = null):void{
			trace(GearBox + "HIGHLIGHT rtest_2_SELF !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" + event);
		
			var inited:Boolean = (GearBox.hsmIsActive && GearBox.s_11_isCurrent && !cogHasInited);
			var reachedState:Boolean = (GearBox.hsmIsActive && GearBox.s_1_isInState);
			trace("GearBox.transitionLog " + GearBox.transitionLog);
			var rightPath:Boolean = "EXITING s_11 HANDLED,ENTERING s_11 HANDLED"== GearBox.transitionLog.toString();
			trace("Test t1: " + inited + "  t2: " + reachedState);
			if(inited){
				cogHasInited = true;
				trace("attempting to FireSELF");
				GearBox.fire_SELF();
			}else if(reachedState && rightPath){
				var evt:TestEvent = new TestEvent(Event.COMPLETE,true);
				trace(GearBox + " HIGHLIGHTG rtest_2_SELF  PASSED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				dispatchEvent(evt);
			}else{
				trace(GearBox + " ERROR rtest_2_SELF!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			}
		}
		public function atest_2_SELF2(): Number {
			trace(GearBox + "HIGHLIGHT atest_2_SELF2 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\" );
			GearBox = getEightStateMachine(rtest_2_SELF2) ;	
			return defaultTimeOutInMS;
		}
		public function rtest_2_SELF2(event:* = null):void{
			trace(GearBox + "HIGHLIGHT rtest_2_SELF2 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" + event);
		
			var inited:Boolean = (GearBox.hsmIsActive && GearBox.s_11_isCurrent && !cogHasInited);
			var reachedState:Boolean = (GearBox.hsmIsActive && GearBox.s_1_isInState);
			trace("GearBox.transitionLog " + GearBox.transitionLog);
			var rightPath:Boolean = "EXITING s_11 HANDLED,EXITING s_1 HANDLED,ENTERING s_1 HANDLED"== GearBox.transitionLog.toString();
			trace("Test t1: " + inited + "  t2: " + reachedState);
			if(inited){
				cogHasInited = true;
				trace("attempting to FireSELF2");
				GearBox.fire_SELF2();
			}else if(reachedState && rightPath){
				var evt:TestEvent = new TestEvent(Event.COMPLETE,true);
				trace(GearBox + " HIGHLIGHTG rtest_2_SELF2  PASSED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				dispatchEvent(evt);
			}else{
				trace(GearBox + " ERROR rtest_2_SELF2!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			}
		}


		public function atest_3_PARENT(): Number {
			GearBox = getEightStateMachine(rtest_3_PARENT) ;	
			return defaultTimeOutInMS;
		}
		public function rtest_3_PARENT(event:* = null):void{
			trace(GearBox + "HIGHLIGHT rtest_2_PARENT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		
			var inited:Boolean = (GearBox.hsmIsActive && GearBox.s_11_isCurrent && !cogHasInited);
			var reachedState:Boolean = (GearBox.hsmIsActive && GearBox.s_1_isCurrent);
			var rightPath:Boolean = "EXITING s_11 HANDLED"== GearBox.transitionLog.toString();
			trace("GearBox.transitionLog " + GearBox.transitionLog);
			trace("Test t1: " + inited + "  t2: " + reachedState);
			if(inited){
				cogHasInited = true;
				GearBox.fire_PARENT();
			}else if(reachedState && rightPath){
				var evt:TestEvent = new TestEvent(Event.COMPLETE,true);
				trace(GearBox + " HIGHLIGHTG rtest_2_PARENT! PASSED !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				dispatchEvent(evt);
			}else{
				trace(GearBox + " ERROR rtest_2_PARENT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			}
		}
		public function atest_3_PARENT2(): Number {
			GearBox = getEightStateMachine(rtest_3_PARENT2, "s_1,noINIT") ;	
			return defaultTimeOutInMS;
		}
		public function rtest_3_PARENT2(event:* = null):void{
			trace(GearBox + "HIGHLIGHT rtest_2_PARENT2!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		
			var inited:Boolean = (GearBox.hsmIsActive && GearBox.s_1_isCurrent && !cogHasInited);
			trace("active " + GearBox.hsmIsActive + " current "  + " " + GearBox.s_1_isCurrent + " cogHasInited "  + cogHasInited);
			var reachedState:Boolean = (GearBox.hsmIsActive && GearBox.s_0_isCurrent);
			var rightPath:Boolean = "EXITING s_1 HANDLED"== GearBox.transitionLog.toString();
			trace("GearBox.transitionLog " + GearBox.transitionLog);
			trace("Test inited: " + inited + "  reached: " + reachedState);
			if(inited){
				cogHasInited = true;
				GearBox.fire_PARENT();
			}else if(reachedState && rightPath){
				var evt:TestEvent = new TestEvent(Event.COMPLETE,true);
				trace(GearBox + " HIGHLIGHTG rtest_2_PARENT2! PASSED !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				dispatchEvent(evt);
			}else{
				trace(GearBox + " ERROR rtest_2_PARENT2!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			}
		}
		
		public function atest_3_GRANDPARENT(): Number {
			GearBox = getEightStateMachine(rtest_3_GRANDPARENT) ;	
			return defaultTimeOutInMS;
		}
		public function rtest_3_GRANDPARENT(event:* = null):void{
			trace(GearBox + "HIGHLIGHT rtest_3_GRANDPARENT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		
			var inited:Boolean = (GearBox.hsmIsActive && GearBox.s_11_isCurrent && !cogHasInited);
			var reachedState:Boolean = (GearBox.hsmIsActive && GearBox.s_0_isCurrent);
			var rightPath:Boolean = "EXITING s_11 HANDLED,EXITING s_1 HANDLED"== GearBox.transitionLog.toString();
			trace("GearBox.transitionLog " + GearBox.transitionLog);
			trace("Test t1: " + inited + "  t2: " + reachedState);
			if(inited){
				cogHasInited = true;
				GearBox.fire_GRANDPARENT();
			}else if(reachedState && rightPath){
				var evt:TestEvent = new TestEvent(Event.COMPLETE,true);
				trace(GearBox + " HIGHLIGHTG rtest_3_GRANDPARENT! PASSED !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				dispatchEvent(evt);
			}else{
				trace(GearBox + " ERROR rtest_3_GRANDPARENT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			}
		}
		/////////////////////////////////////////////////////////////////////////////////
		//                                  CHILD STATE TETS 
		////////////////////////////////////////////////////////////////////////////////////////
		public function atest_4_CHILD_INACTIVE(): Number {
			GearBox = getEightStateMachine(rtest_4_CHILD_INACTIVE) ;	
			return defaultTimeOutInMS;
		}
		public function rtest_4_CHILD_INACTIVE(event:* = null):void{
			trace(GearBox + "HIGHLIGHT rtest_4_CHILD_INACTIVE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		
			var inited:Boolean = (GearBox.hsmIsActive && GearBox.s_11_isCurrent && !cogHasInited);
			var reachedState:Boolean = (GearBox.hsmIsActive && GearBox.s_111_isCurrent);
			var rightPath:Boolean = "ENTERING s_111 NOT HANDLED"== GearBox.transitionLog.toString();
			trace("GearBox.transitionLog " + GearBox.transitionLog);
			trace("Test t1: " + inited + "  t2: " + reachedState);
			if(inited){
				cogHasInited = true;
				GearBox.fire_CHILD_INACTIVE();
			}else if(reachedState && rightPath){
				var evt:TestEvent = new TestEvent(Event.COMPLETE,true);
				trace(GearBox + " HIGHLIGHTG rtest_4_CHILD_INACTIVE! PASSED !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				dispatchEvent(evt);
			}else{
				trace(GearBox + " ERROR rtest_4_CHILD_INACTIVE TIMEOUT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				var evt2:TestEvent = new TestEvent(Event.COMPLETE,false);
				dispatchEvent(evt2);

			}
		}
		public function atest_4_CHILD_ACTIVE(): Number {
			GearBox = getEightStateMachine(rtest_4_CHILD_ACTIVE,"s_1,noInit") ;	
			return defaultTimeOutInMS;
		}
		public function rtest_4_CHILD_ACTIVE(event:* = null):void{
			trace(GearBox + "HIGHLIGHT rtest_4_CHILD_ACTIVE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		
			var inited:Boolean = (GearBox.hsmIsActive && GearBox.s_1_isCurrent && !cogHasInited);
			var reachedState:Boolean = (GearBox.hsmIsActive && GearBox.s_11_isCurrent);
			var rightPath:Boolean = "ENTERING s_11 HANDLED"== GearBox.transitionLog.toString();
			trace("GearBox.transitionLog " + GearBox.transitionLog);
			trace("Test t1: " + inited + "  t2: " + reachedState);
			if(inited){
				cogHasInited = true;
				GearBox.fire_CHILD_ACTIVE();
			}else if(reachedState && rightPath){
				var evt:TestEvent = new TestEvent(Event.COMPLETE,true);
				trace(GearBox + " HIGHLIGHTG rtest_4_CHILD_ACTIVE! PASSED !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				dispatchEvent(evt);
			}else{
				trace(GearBox + " ERROR rtest_4_CHILD_ACTIVE TIMEOUT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				var evt2:TestEvent = new TestEvent(Event.COMPLETE,false);
				dispatchEvent(evt2);

			}
		}
		/////////////////////////////////////////////////////////////////////////////////
		//                                  GRANDCHILD STATE TESTS
		////////////////////////////////////////////////////////////////////////////////////////
		public function atest_5_GRANDCHILD_INACTIVE(): Number {
			GearBox = getEightStateMachine(rtest_5_GRANDCHILD_INACTIVE,"s_0,noInit") ;	
			return defaultTimeOutInMS;
		}
		public function rtest_5_GRANDCHILD_INACTIVE(event:* = null):void{
			trace(GearBox + "HIGHLIGHT rtest_5_GRANDCHILD_INACTIVE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		
			var inited:Boolean = (GearBox.hsmIsActive && GearBox.s_0_isCurrent && !cogHasInited);
			var reachedState:Boolean = (GearBox.hsmIsActive && GearBox.s_211_isCurrent);
			var rightPath:Boolean = "ENTERING s_2 HANDLED,ENTERING s_21 HANDLED,ENTERING s_211 HANDLED"== GearBox.transitionLog.toString();
			trace("GearBox.transitionLog " + GearBox.transitionLog);
			trace("Test t1: " + inited + "  t2: " + reachedState);
			if(inited){
				cogHasInited = true;
				GearBox.fire_GRANDCHILD_INACTIVE();
			}else if(reachedState && rightPath){
				var evt:TestEvent = new TestEvent(Event.COMPLETE,true);
				trace(GearBox + " HIGHLIGHTG rtest_5_GRANDCHILD_INACTIVE! PASSED !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				dispatchEvent(evt);
			}else{
				trace(GearBox + " ERROR rtest_5_GRANDCHILD_INACTIVE TIMEOUT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				var evt2:TestEvent = new TestEvent(Event.COMPLETE,false);
				dispatchEvent(evt2);

			}
		}
		public function atest_5_GRANDCHILD_INACTIVE2(): Number {
			GearBox = getEightStateMachine(rtest_5_atest_5_GRANDCHILD_INACTIVE2) ;	
			return defaultTimeOutInMS;
		}
		public function rtest_5_atest_5_GRANDCHILD_INACTIVE2(event:* = null):void{
			trace(GearBox + "HIGHLIGHT rtest_5_atest_5_GRANDCHILD_INACTIVE2!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		
			var inited:Boolean = (GearBox.hsmIsActive && GearBox.s_11_isCurrent && !cogHasInited);
			var reachedState:Boolean = (GearBox.hsmIsActive && GearBox.s_211_isCurrent);
			var rightPath:Boolean = "EXITING s_11 HANDLED,EXITING s_1 HANDLED,ENTERING s_2 HANDLED,ENTERING s_21 HANDLED,ENTERING s_211 HANDLED"== GearBox.transitionLog.toString();
			trace("GearBox.transitionLog " + GearBox.transitionLog);
			trace("Test t1: " + inited + "  t2: " + reachedState);
			if(inited){
				cogHasInited = true;
				GearBox.fire_GRANDCHILD_INACTIVE2();
			}else if(reachedState && rightPath){
				var evt:TestEvent = new TestEvent(Event.COMPLETE,true);
				trace(GearBox + " HIGHLIGHTG rtest_5_atest_5_GRANDCHILD_INACTIVE2! PASSED !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				dispatchEvent(evt);
			}else{
				trace(GearBox + " ERROR rtest_5_atest_5_GRANDCHILD_INACTIVE2 TIMEOUT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				var evt2:TestEvent = new TestEvent(Event.COMPLETE,false);
				dispatchEvent(evt2);

			}
		}
		public function atest_5_GRANDCHILD_ACTIVE(): Number {
			GearBox = getEightStateMachine(rtest_5_atest_5_GRANDCHILD_ACTIVE) ;	
			return defaultTimeOutInMS;
		}
		public function rtest_5_atest_5_GRANDCHILD_ACTIVE(event:* = null):void{
			trace(GearBox + "HIGHLIGHT rtest_5_atest_5_GRANDCHILD_ACTIVE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		
			var inited:Boolean = (GearBox.hsmIsActive && GearBox.s_11_isCurrent && !cogHasInited);
			var reachedState:Boolean = (GearBox.hsmIsActive && GearBox.s_111_isCurrent);
			var rightPath:Boolean = "EXITING s_11 HANDLED,EXITING s_1 HANDLED,ENTERING s_1 HANDLED,ENTERING s_11 HANDLED,ENTERING s_111 NOT HANDLED"== GearBox.transitionLog.toString();
			trace("GearBox.transitionLog " + GearBox.transitionLog);
			trace("Test t1: " + inited + "  t2: " + reachedState);
			if(inited){
				cogHasInited = true;
				GearBox.fire_GRANDCHILD_ACTIVE();
			}else if(reachedState && rightPath){
				var evt:TestEvent = new TestEvent(Event.COMPLETE,true);
				trace(GearBox + " HIGHLIGHTG rtest_5_atest_5_GRANDCHILD_ACTIVE! PASSED !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				dispatchEvent(evt);
			}else{
				trace(GearBox + " ERROR rtest_5_atest_5_GRANDCHILD_ACTIVE TIMEOUT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				var evt2:TestEvent = new TestEvent(Event.COMPLETE,false);
				dispatchEvent(evt2);

			}
		}
		/////////////////////////////////////////////////////////////////////////////////
		//                                  GRANDCHILD STATE TESTS
		////////////////////////////////////////////////////////////////////////////////////////
		public function atest_6_SIBLING(): Number {
			GearBox = getEightStateMachine(rtest_6_SIBLING,"s_1,noInit") ;	
			return defaultTimeOutInMS;
		}
		public function rtest_6_SIBLING(event:* = null):void{
			trace(GearBox + "HIGHLIGHT rtest_6_SIBLING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		
			var inited:Boolean = (GearBox.hsmIsActive && GearBox.s_1_isCurrent && !cogHasInited);
			var reachedState:Boolean = (GearBox.hsmIsActive && GearBox.s_2_isCurrent);
			var rightPath:Boolean = "EXITING s_1 HANDLED,ENTERING s_2 HANDLED"== GearBox.transitionLog.toString();
			trace("GearBox.transitionLog " + GearBox.transitionLog);
			trace("Test t1: " + inited + "  t2: " + reachedState);
			if(inited){
				cogHasInited = true;
				GearBox.fire_SIBLING();
			}else if(reachedState && rightPath){
				var evt:TestEvent = new TestEvent(Event.COMPLETE,true);
				trace(GearBox + " HIGHLIGHTG rtest_6_SIBLING! PASSED !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				dispatchEvent(evt);
			}else{
				trace(GearBox + " ERROR rtest_6_SIBLING TIMEOUT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				var evt2:TestEvent = new TestEvent(Event.COMPLETE,false);
				dispatchEvent(evt2);

			}
		}
		public function atest_6_SIBLING2(): Number {
			GearBox = getEightStateMachine(rtest_6_SIBLING2) ;	
			return defaultTimeOutInMS;
		}
		public function rtest_6_SIBLING2(event:* = null):void{
			trace(GearBox + "HIGHLIGHT rtest_6_SIBLING2!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		
			var inited:Boolean = (GearBox.hsmIsActive && GearBox.s_11_isCurrent && !cogHasInited);
			var reachedState:Boolean = (GearBox.hsmIsActive && GearBox.s_2_isCurrent);
			var rightPath:Boolean = "EXITING s_11 HANDLED,EXITING s_1 HANDLED,ENTERING s_2 HANDLED"== GearBox.transitionLog.toString();
			trace("GearBox.transitionLog " + GearBox.transitionLog);
			trace("Test t1: " + inited + "  t2: " + reachedState);
			if(inited){
				cogHasInited = true;
				GearBox.fire_SIBLING();
			}else if(reachedState && rightPath){
				var evt:TestEvent = new TestEvent(Event.COMPLETE,true);
				trace(GearBox + " HIGHLIGHTG rtest_6_SIBLING2! PASSED !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				dispatchEvent(evt);
			}else{
				trace(GearBox + " ERROR rtest_6_SIBLING2 TIMEOUT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				var evt2:TestEvent = new TestEvent(Event.COMPLETE,false);
				dispatchEvent(evt2);

			}
		}
		
		public function atest_6_UNCLE(): Number {
			GearBox = getEightStateMachine(rtest_6_UNCLE) ;	
			return defaultTimeOutInMS;
		}
		public function rtest_6_UNCLE(event:* = null):void{
			trace(GearBox + "HIGHLIGHT rtest_6_UNCLE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		
			var inited:Boolean = (GearBox.hsmIsActive && GearBox.s_11_isCurrent && !cogHasInited);
			var reachedState:Boolean = (GearBox.hsmIsActive && GearBox.s_2_isCurrent);
			var rightPath:Boolean = "EXITING s_11 HANDLED,EXITING s_1 HANDLED,ENTERING s_2 HANDLED"== GearBox.transitionLog.toString();
			trace("GearBox.transitionLog " + GearBox.transitionLog);
			trace("Test t1: " + inited + "  t2: " + reachedState);
			if(inited){
				cogHasInited = true;
				GearBox.fire_SIBLING();
			}else if(reachedState && rightPath){
				var evt:TestEvent = new TestEvent(Event.COMPLETE,true);
				trace(GearBox + " HIGHLIGHTG rtest_6_UNCLE! PASSED !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				dispatchEvent(evt);
			}else{
				trace(GearBox + " ERROR rtest_6_UNCLE TIMEOUT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				var evt2:TestEvent = new TestEvent(Event.COMPLETE,false);
				dispatchEvent(evt2);

			}
		}
		public function atest_6_UNCLE2(): Number {
			GearBox = getEightStateMachine(rtest_6_UNCLE2,"s_111") ;	
			return defaultTimeOutInMS;
		}
		public function rtest_6_UNCLE2(event:* = null):void{
			trace(GearBox + "HIGHLIGHT rtest_6_UNCLE2!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		
			var inited:Boolean = (GearBox.hsmIsActive && GearBox.s_111_isCurrent && !cogHasInited);
			var reachedState:Boolean = (GearBox.hsmIsActive && GearBox.s_2_isCurrent);
			var rightPath:Boolean = "EXITING s_111 NOT HANDLED,EXITING s_11 HANDLED,EXITING s_1 HANDLED,ENTERING s_2 HANDLED"== GearBox.transitionLog.toString();
			trace("GearBox.transitionLog " + GearBox.transitionLog);
			trace("Test t1: " + inited + "  t2: " + reachedState);
			if(inited){
				cogHasInited = true;
				GearBox.fire_SIBLING();
			}else if(reachedState && rightPath){
				var evt:TestEvent = new TestEvent(Event.COMPLETE,true);
				trace(GearBox + " HIGHLIGHTG rtest_6_UNCLE2! PASSED !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				dispatchEvent(evt);
			}else{
				trace(GearBox + " ERROR rtest_6_UNCLE2 TIMEOUT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				var evt2:TestEvent = new TestEvent(Event.COMPLETE,false);
				dispatchEvent(evt2);

			}
		}
		public function atest_7_NEPHEW(): Number {
			GearBox = getEightStateMachine(rtest_7_NEPHEW,"s_1,noInit") ;	
			return defaultTimeOutInMS;
		}
		public function rtest_7_NEPHEW(event:* = null):void{
			trace(GearBox + "HIGHLIGHT rtest_7_NEPHEW!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		
			var inited:Boolean = (GearBox.hsmIsActive && GearBox.s_1_isCurrent && !cogHasInited);
			var reachedState:Boolean = (GearBox.hsmIsActive && GearBox.s_21_isCurrent);
			var rightPath:Boolean = "EXITING s_1 HANDLED,ENTERING s_2 HANDLED,ENTERING s_21 HANDLED"== GearBox.transitionLog.toString();
			trace("GearBox.transitionLog " + GearBox.transitionLog);
			trace("Test t1: " + inited + "  t2: " + reachedState);
			if(inited){
				cogHasInited = true;
				GearBox.fire_NEPHEW();
			}else if(reachedState && rightPath){
				var evt:TestEvent = new TestEvent(Event.COMPLETE,true);
				trace(GearBox + " HIGHLIGHTG rtest_7_NEPHEW! PASSED !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				dispatchEvent(evt);
			}else{
				trace(GearBox + " ERROR rtest_7_NEPHEW TIMEOUT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				var evt2:TestEvent = new TestEvent(Event.COMPLETE,false);
				dispatchEvent(evt2);

			}
		}
		public function atest_8_FIRSTCOUSIN(): Number {
			GearBox = getEightStateMachine(rtest_8_FIRSTCOUSIN) ;	
			return defaultTimeOutInMS;
		}
		public function rtest_8_FIRSTCOUSIN(event:* = null):void{
			trace(GearBox + "HIGHLIGHT rtest_8_FIRSTCOUSIN!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		
			var inited:Boolean = (GearBox.hsmIsActive && GearBox.s_11_isCurrent && !cogHasInited);
			var reachedState:Boolean = (GearBox.hsmIsActive && GearBox.s_211_isCurrent);
			var rightPath:Boolean = "EXITING s_11 HANDLED,EXITING s_1 HANDLED,ENTERING s_2 HANDLED,ENTERING s_21 HANDLED,ENTERING s_211 HANDLED"== GearBox.transitionLog.toString();
			trace("GearBox.transitionLog " + GearBox.transitionLog);
			trace("Test t1: " + inited + "  t2: " + reachedState);
			if(inited){
				cogHasInited = true;
				GearBox.fire_FIRST_COUSIN_REMOVED();
			}else if(reachedState && rightPath){
				var evt:TestEvent = new TestEvent(Event.COMPLETE,true);
				trace(GearBox + " HIGHLIGHTG rtest_8_FIRSTCOUSIN! PASSED !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				dispatchEvent(evt);
			}else{
				trace(GearBox + " ERROR rtest_8_FIRSTCOUSIN TIMEOUT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				var evt2:TestEvent = new TestEvent(Event.COMPLETE,false);
				dispatchEvent(evt2);

			}
		}
		public function atest_8_FIRSTCOUSIN2(): Number {
			GearBox = getEightStateMachine(rtest_8_FIRSTCOUSIN2, "s_111,noInit") ;	
			return defaultTimeOutInMS;
		}
		public function rtest_8_FIRSTCOUSIN2(event:* = null):void{
			trace(GearBox + "HIGHLIGHT rtest_8_FIRSTCOUSIN2!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		
			var inited:Boolean = (GearBox.hsmIsActive && GearBox.s_111_isCurrent && !cogHasInited);
			var reachedState:Boolean = (GearBox.hsmIsActive && GearBox.s_211_isCurrent);
			var rightPath:Boolean = "EXITING s_111 NOT HANDLED,EXITING s_11 HANDLED,EXITING s_1 HANDLED,ENTERING s_2 HANDLED,ENTERING s_21 HANDLED,ENTERING s_211 HANDLED"== GearBox.transitionLog.toString();
			trace("GearBox.transitionLog " + GearBox.transitionLog);
			trace("Test t1: " + inited + "  t2: " + reachedState);
			if(inited){
				cogHasInited = true;
				GearBox.fire_FIRST_COUSIN_REMOVED(); //s_211
			}else if(reachedState && rightPath){
				var evt:TestEvent = new TestEvent(Event.COMPLETE,true);
				trace(GearBox + " HIGHLIGHTG rtest_8_FIRSTCOUSIN2! PASSED !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				dispatchEvent(evt);
			}else{
				trace(GearBox + " ERROR rtest_8_FIRSTCOUSIN2 TIMEOUT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				var evt2:TestEvent = new TestEvent(Event.COMPLETE,false);
				dispatchEvent(evt2);

			}
		}	
		public function atest_9_MIRRORDEPTH_OTHER_STACK(): Number {
			GearBox = getEightStateMachine(rtest_9_MIRRORDEPTH_OTHER_STACK, "s_211,noInit") ;	
			return defaultTimeOutInMS;
		}
		public function rtest_9_MIRRORDEPTH_OTHER_STACK(event:* = null):void{
			trace(GearBox + "HIGHLIGHT rtest_9_MIRRORDEPTH_OTHER_STACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		
			var inited:Boolean = (GearBox.hsmIsActive && GearBox.s_211_isCurrent && !cogHasInited);
			var reachedState:Boolean = (GearBox.hsmIsActive && GearBox.s_111_isCurrent);
			var rightPath:Boolean = "EXITING s_211 HANDLED,EXITING s_21 HANDLED,EXITING s_2 HANDLED,ENTERING s_1 HANDLED,ENTERING s_11 HANDLED,ENTERING s_111 NOT HANDLED"== GearBox.transitionLog.toString();
			trace("GearBox.transitionLog " + GearBox.transitionLog);
			trace("Test t1: " + inited + "  t2: " + reachedState);
			if(inited){
				cogHasInited = true;
				GearBox.fire_MIRRORDEPTH_ON_OTHER_STACK(); //s_111
			}else if(reachedState && rightPath){
				var evt:TestEvent = new TestEvent(Event.COMPLETE,true);
				trace(GearBox + " HIGHLIGHTG rtest_9_MIRRORDEPTH_OTHER_STACK! PASSED !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				dispatchEvent(evt);
			}else{
				trace(GearBox + " ERROR rtest_9_MIRRORDEPTH_OTHER_STACK TIMEOUT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				var evt2:TestEvent = new TestEvent(Event.COMPLETE,false);
				dispatchEvent(evt2);

			}
		}
	}
}