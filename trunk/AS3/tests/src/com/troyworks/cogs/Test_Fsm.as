package com.troyworks.cogs{
	import com.troyworks.util.DesignByContract;
	import com.troyworks.util.DesignByContractEvent;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import com.troyworks.tester.SynchronousTestSuite;
	import flash.utils.getTimer;
	import com.troyworks.cogs.CogExternalEvent;

	public class Test_Fsm extends SynchronousTestSuite {
		protected var fsm:TwoStateFsm;
		public function Test_Fsm():void {
			super();
		}
		/* Make sure that during inital creation, statemachine is inactive */
		/*public function test_constructor():Boolean {
			var res:Boolean=false;
			var fsm:TwoStateFsm=new TwoStateFsm () ;
			res = (fsm != null && fsm.currentState == null && !fsm.hasInited);
			return res;
		}
		public function test_init():Boolean {
			var res:Boolean=false;
			var fsm:TwoStateFsm=new TwoStateFsm () ;
			fsm.init();
			res = (fsm.hasInited == true);
			return res;
		}
		public function test_init2():Boolean {
			var res:Boolean=false;
			var fsm:TwoStateFsm=new TwoStateFsm (true) ;
			fsm.init();
			res = (fsm.hasInited == true && fsm.isInState(fsm.OFF_state));
			return res;
		}
		public function test_isInState():Boolean {
			var res:Boolean=false;
			var fsm:TwoStateFsm=new TwoStateFsm (true) ;
			fsm.init();
			var test1:Boolean = ( fsm.isInState(fsm.OFF_state));
			var test2:Boolean = (!fsm.isInState(fsm.ON_state));
			res = test1 && test2;
			return res;
		}
		public function test_stateToggleTest():Boolean {
			var res:Boolean=false;
			var fsm:TwoStateFsm=new TwoStateFsm(true) ;
			trace("CREAting TwoStateFsm");
			fsm.init();
			fsm.toggle();
			res = fsm.isInState(fsm.ON_state);
			return res;
		}
	public function test_stateToggleTwiceTest():Boolean {
			var res:Boolean=false;
			var fsm:TwoStateFsm=new TwoStateFsm(true) ;
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
			var fsm:TwoStateFsm=new TwoStateFsm(true) ;
			fsm.init();
			var tA:int = getTimer();
			var iterations:uint = 1000;
			while(iterations--){
				fsm.toggle();
			}
			trace("1000 in " + (getTimer() - tA) + " ms");
			return res;
		}
				/*
		public function test_stateToggleTestAsynch():Boolean {
			var res:Boolean=false;
			var fsm:TwoStateFsm=new TwoStateFsm(true) ;
			trace("CREAting TwoStateFsm");
			fsm.init();
			fsm.requestToggle();
			res = fsm.isInState(fsm.OFF_state);
			return res;
		}*/
		public function test_stateMultipleToggleTestAsynch():Boolean {
			var res:Boolean=false;
			fsm =new TwoStateFsm(true) ;
			
			trace("CREAting TwoStateFsm");
			fsm.init();
			fsm.addEventListener(CogExternalEvent.CHANGED,onAsynchTestComplete);

			var i:Number = 9;
			while(i--){
				fsm.requestToggle();
			}
			res = fsm.isOff();
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