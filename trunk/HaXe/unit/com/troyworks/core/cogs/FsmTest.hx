package com.troyworks.core.cogs;

import com.sf.Assert;
using com.sf.Assert;

import haxe.Timer;
import flash.events.EventDispatcher;

class FsmTest{

	var fsm : TwoStateFsm;
	
	public function  new() {
	
	}

	/* Make sure that during inital creation, statemachine is inactive */
	/*
	@Test
	public function  test_constructor(){
		var fsm:TwoStateFsm=new TwoStateFsm () ;
				fsm.isNotNull();
				fsm.currentState.isNull();
				fsm.stateMachine_hasInited.isFalse();
	}
	
	@Test
	public function  test_init() {
	var fsm:TwoStateFsm=new TwoStateFsm () ;
		
		fsm.stateMachine_hasInited.isTrue();
	}
	
	@TestDebug 
	public function  test_init2()  {
		var fsm:TwoStateFsm=new TwoStateFsm (true) ;
		
		fsm.stateMachine_hasInited.isTrue();
		fsm.isInState(fsm.OFF_state).isTrue();
	}
	
	@Test 
	public function  test_isInState()  {
	var res =false;
	var fsm:TwoStateFsm=new TwoStateFsm (true) ;
	fsm.initStateMachine();
	var test1  = ( fsm.isInState(fsm.OFF_state));
	var test2  = (!fsm.isInState(fsm.ON_state));
	res = test1 && test2;
	return res;
	}

	@Test 
	public function  test_stateToggleTest()  {
	var res =false;
	var fsm:TwoStateFsm=new TwoStateFsm(true) ;
	trace("CREAting TwoStateFsm");
	fsm.init();
	fsm.toggle();
	res = fsm.isInState(fsm.ON_state);
	return res;
	}
	@Test 
	public function  test_stateToggleTwiceTest()  {
	var res =false;
	var fsm:TwoStateFsm=new TwoStateFsm(true) ;
	fsm.init();
	fsm.toggle();
	var test1  =fsm.isInState(fsm.ON_state);
	fsm.toggle();
	var test2  =fsm.isInState(fsm.OFF_state);
	res = test1 && test2;
	return res;
	}
	
*/
	@Test
	public function  test_stateToggleSpeedTest() : Bool {
		var res : Bool = true;
		var fsm : TwoStateFsm = new TwoStateFsm(true);
		fsm.initStateMachine();
		var tA : Float = Timer.stamp();
		var iterations : Int = 1000;
		while(iterations-- != 0) {
			fsm.toggle();
		}

		trace("1000 in " + (Timer.stamp() - tA) + " ms");
		return res;
	}

	/*
	@Test 
	public function  test_stateToggleTestAsynch()  {
	var res =false;
	var fsm:TwoStateFsm=new TwoStateFsm(true) ;
	trace("CREAting TwoStateFsm");
	fsm.init();
	fsm.requestToggle();
	res = fsm.isInState(fsm.OFF_state);
	return res;
	}
	*/
	@Test 
	public function  test_stateMultipleToggleTestAsynch() : Bool {
		var res : Bool = false;
		fsm = new TwoStateFsm(true);
		trace("CREAting TwoStateFsm");
		fsm.initStateMachine();
		fsm.addEventListener(CogExternalEvent.CHANGED, onAsynchTestComplete);
		var i : Int = 9;
		while(i-- != 0) {
			fsm.requestToggle();
		}

		res = fsm.isOff();
		return res;
	}

	public function  onAsynchTestComplete(event : CogExternalEvent) : Void {
		if(!fsm.hasEventsInQue())  {
			trace("onAsynchTestComplete===================== ");
			fsm.removeEventListener(CogExternalEvent.CHANGED, onAsynchTestComplete);
		}
	}		
}

