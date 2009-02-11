/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.dayinlife {
	
	import com.troyworks.util.DesignByContract;
	import com.troyworks.util.DesignByContractEvent;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.events.Event;
	import com.troyworks.apps.tester.AsynchronousTestSuite;
	import com.troyworks.apps.tester.TestSuite;
    import com.troyworks.apps.tester.TestEvent;
	import com.troyworks.logging.TraceAdapter;
	import com.troyworks.core.cogs.*;
	import com.troyworks.core.persistance.IntrospectableObj;
	import com.troyworks.core.cogs.NameSpaceTest;
	import flash.utils.Timer;
	import flash.utils.describeType;
    import flash.events.TimerEvent;
	
	public class Test_DayInLife extends TestSuite {
		protected var myTimer:Timer;
		protected var trace:Function = TraceAdapter.TraceToSOS;
		protected var cogHasInited:Boolean = false;
		protected var timeOutInMS:Number = 200;
		public var timeOutTmer:Timer;
		
		public var DIL:DayInLife;
		public function Test_DayInLife() {
			super();
		}
		public function getDayInLifeMachine(initListener:Function, defaultState:String = null):DayInLife{
			
			
			Hsm.DEFAULT_TRACE = trace;
			cogHasInited = false;
			DIL =new DayInLife (defaultState) ;
			DIL.addEventListener(CogExternalEvent.CHANGED,initListener);
			currentResultsFunction = initListener;
			DIL.initStateMachine();
			return DIL;
		}
		public function atest_goHome():Object{
			//transition immediately
			//return tran(s_ON);
			DIL = getDayInLifeMachine(rtest_goHome);
			DIL.goHome();
			currentResultsFunction = rtest_goHome;
			return 1000;
		//return true;
		}
		public function rtest_goHome(event:* = null):void{
			trace("HIGHLIGHTO rtest_goHome !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			var inited:Boolean = (DIL.hsmIsActive && DIL.isAtHome());
			trace("GearBox.transitionLog " + DIL.transitionLog);
			var rightPath:Boolean = "ENTERING s_initial NOT HANDLED,ENTERING s_dayTime HANDLED,ENTERING s_atHome HANDLED" == DIL.transitionLog.toString();
			trace("Test t1: " + inited + "  t2: " + rightPath);
			if(inited && rightPath){
				cogHasInited = true;
				var evt:TestEvent = new TestEvent(Event.COMPLETE,true);
				trace(DIL + " HIGHLIGHTG rtest_goHome  PASSED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				dispatchEvent(evt);
			}else{
				trace(DIL + " ERROR rtest_goHome!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			}
		} 
		public function atest_goToWork():Object{
			trace("HIGHLIGHTO atest_goToWork !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			DIL = getDayInLifeMachine(rtest_gotoWork);
			
				return 1000;
		}
		public function rtest_gotoWork(event:* = null):void{
			trace("HIGHLIGHTO rtest_gotoWork !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			var inited:Boolean = (DIL.hsmIsActive && DIL.isAtHome());
			
			if(inited){
				DIL.goToWork();
			}
			trace("GearBox.transitionLog " + DIL.transitionLog);
			var rightPath:Boolean = "ENTERING s_initial NOT HANDLED,ENTERING s_dayTime HANDLED,ENTERING s_atWork HANDLED" == DIL.transitionLog.toString();
			trace("Test t1: " + inited + "  t2: " + rightPath);
			if(inited && rightPath){
				cogHasInited = true;
				var evt:TestEvent = new TestEvent(Event.COMPLETE,true);
				trace(DIL + " HIGHLIGHTG rtest_gotoWork  PASSED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				dispatchEvent(evt);
			}else{
				trace(DIL + " ERROR rtest_gotoWork!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			}
		} 
	}
	
}
