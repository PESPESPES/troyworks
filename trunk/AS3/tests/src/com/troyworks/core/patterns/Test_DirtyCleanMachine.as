package com.troyworks.core.patterns {
	import com.troyworks.core.cogs.CogExternalEvent;	
	import com.troyworks.apps.tester.SynchronousTestSuite;


	import flash.utils.getTimer;
	/**
	 * Test_DirtyCleanMachine
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Aug 21, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class Test_DirtyCleanMachine extends SynchronousTestSuite {
		
		protected var fsm:DirtyCleanMachine;
		public function Test_DirtyCleanMachine() {
			super();
		}
		
				/* Make sure that during inital creation, statemachine is inactive */
		/*public function test_constructor():Boolean {
			var res:Boolean=false;
			var fsm:DirtyCleanMachine=new DirtyCleanMachine () ;
			res = (fsm != null && fsm.currentState == null && !fsm.hasInited);
			return res;
		}
		public function test_init():Boolean {
			var res:Boolean=false;
			var fsm:DirtyCleanMachine=new DirtyCleanMachine () ;
			fsm.init();
			res = (fsm.hasInited == true);
			return res;
		}
		public function test_init2():Boolean {
			var res:Boolean=false;
			var fsm:DirtyCleanMachine=new DirtyCleanMachine (true) ;
			fsm.init();
			res = (fsm.hasInited == true && fsm.isInState(fsm.OFF_state));
			return res;
		}
		public function test_isInState():Boolean {
			var res:Boolean=false;
			var fsm:DirtyCleanMachine=new DirtyCleanMachine (true) ;
			fsm.init();
			var test1:Boolean = ( fsm.isInState(fsm.OFF_state));
			var test2:Boolean = (!fsm.isInState(fsm.ON_state));
			res = test1 && test2;
			return res;
		}
		public function test_stateToggleTest():Boolean {
			var res:Boolean=false;
			var fsm:DirtyCleanMachine=new DirtyCleanMachine(true) ;
			trace("CREAting DirtyCleanMachine");
			fsm.init();
			fsm.toggle();
			res = fsm.isInState(fsm.ON_state);
			return res;
		}
	public function test_stateToggleTwiceTest():Boolean {
			var res:Boolean=false;
			var fsm:DirtyCleanMachine=new DirtyCleanMachine(true) ;
			fsm.init();
			fsm.toggle();
			var test1:Boolean =fsm.isInState(fsm.ON_state);
			fsm.toggle();
			var test2:Boolean =fsm.isInState(fsm.OFF_state);
			res = test1 && test2;
			return res;
		}
		
*/
		public function test_stateToggleSpeedTest():Boolean {
				
			var res:Boolean=true;
			fsm=new DirtyCleanMachine() ;
			trace("CREAting DirtyCleanMachine");
			fsm.initStateMachine();
			var tA:int = getTimer();
			var iterations:uint = 1000;
			while(iterations--){
				
				if(fsm.isDIRTY()){
				fsm.fireClean();
				}else{
					
					fsm.fireDirty();
				}
				
			}
			trace("1000 in " + (getTimer() - tA) + " ms");
			return res;
		}
				/*
		public function test_stateToggleTestAsynch():Boolean {
			var res:Boolean=false;
			var fsm:DirtyCleanMachine=new DirtyCleanMachine(true) ;
			trace("CREAting DirtyCleanMachine");
			fsm.init();
			fsm.requestToggle();
			res = fsm.isInState(fsm.OFF_state);
			return res;
		}*/
		public function atest_stateMultipleToggleTestAsynch():Boolean {
			var res:Boolean=false;
			fsm =new DirtyCleanMachine() ;
			
			trace("CREAting DirtyCleanMachine");
			fsm.initStateMachine();
			fsm.addEventListener(CogExternalEvent.CHANGED,onAsynchTestComplete);

			var i:Number = 9;
			while(i--){
				
				if(fsm.isDIRTY()){
				fsm.fireClean();
				}else{
					
					fsm.fireDirty();
				}
				
			}
			res = fsm.isDIRTY();
			return res;
		}
		public function onAsynchTestComplete(event:CogExternalEvent):void{
			if(!fsm.hasEventsInQue()){
				trace("onAsynchTestComplete===================== " );
			fsm.removeEventListener(CogExternalEvent.CHANGED, onAsynchTestComplete);
			}
			
		}
	}
}
