package com.troyworks.apps.tester {
	import flash.display.Sprite;	
	import flash.display.Stage;	

	import com.troyworks.core.cogs.CogSignal;
	import com.troyworks.core.cogs.Fsm;
	import com.troyworks.core.cogs.CogEvent;

	import flash.events.EventDispatcher;

	import com.troyworks.util.DesignByContract;
	import com.troyworks.util.DesignByContractEvent;
	import com.troyworks.apps.tester.TestTask;

	import flash.utils.describeType;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	import com.troyworks.logging.TraceAdapter;

	/***************************************
	 * This is a lightweight class automates testing of methods (generaly
	 * each an synchronous testcase). Each class is a suite of tests to run.
	 * 
	 * methods should be named 'test_XXXX():Boolean'
	 * methods should setup and cleanup afterthemselves. 
	 * 
	 * EXAMPLE
	 * 
	 * public function test_REQUIRE() : Boolean{
	var res : Boolean = false;
	DesignByContract.REQUIRE(false, "test of REQUIRE", false);
	return res;
	
	}
	 */
	public class AsynchTestRunner extends Fsm {

		/* these are mixed in */
		public var assertRes : String;
		public var lastEvent : DesignByContractEvent;
		public var allTests : Array;
		public var testsLeft : Array;
		public var curTest : TestTask;
		//
		public var passedN : Number = 0;
		public var totalN : Number = 0;
		public var passedAll : Boolean;
		public var results : XML;
		public var timeOutInMS : Number = 200;
		public var timeOutTmer : Timer;

		public static const TIMEOUT : CogSignal = CogSignal.CALLBACK;
		public var haltOnErrors : Boolean = true;

		public var stage : Stage;
		public var view : Sprite;

		public function AsynchTestRunner() {
			super("s_initial", "AsynchTestRunner", false);
			
			trace = TraceAdapter.CurrentTracer;
			trace("new AsynchronousTestSuite");
			DesignByContract.initialize(this);
			DesignByContract.HALT_ON_ERRORS = false;
			allTests = new Array();
			testsLeft = new Array();
			_initState = s_initial;
			timeOutTmer = new Timer(timeOutInMS, 1);
			timeOutTmer.repeatCount = 1;
			timeOutTmer.addEventListener("timer", onTimeOutCallback);
		}

		
		
		public function setTimeOut(ms : Number = 45) : void {
			trace("setTimeOutIn " + ms + " ============================");
			
			if(ms > 0) {
				timeOutTmer.delay = ms;
			}else{
			}
			timeOutTmer.start();
		}

		public function onTimeOutCallback(event : TimerEvent) : void {
			trace("onTimeOutCallback: " + event);
			if(_currentState != null) {
				_currentState.call(this, new CogEvent("TIMEOUT", TIMEOUT));
				trace("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");
			}else {
				trace("cannot call a null currentState");
			}
		}

		public function onAssertFailed(e : DesignByContractEvent) : void {
			//Insert a breakpoint here.
			//trace("!!!!!!!!!!!!!!!!!!!!!!!!! DesignByContract"+ID+" ERROR !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\r" + util.Trace.me(e, e.message) + " fatal?: "+ e.fatal);
			if (e != null) {
				trace("!!!!!!!!!!!!!!!!!!!!!!!!! TestSuite.DesignByContract ASSERT ERROR !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\r" + e.message + " fatal?: " + e.fatal);
				assertRes = e.message;
			} else {
				trace("!!!!!!!!!!!!!!!!!!!!!!!!! TestSuite.DesignByContract  ASSERT  ERROR !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\r");
			}
			lastEvent = e;
		}

		/////////////////////////////TESTS BEGIN //////////////////////////////////////////
		public static function getTestList(aClass : Class, view : Sprite = null, stage : Stage = null) : Array {
			var typeDesc : XML = describeType(aClass);
			var typeN : String = typeDesc.type.@name;
			var methodList : XMLList = typeDesc.factory.method;
			var item : XML;
			var sn : String;
			///////////// NOW ITERATE OVER THE FUNCTIONS FIGURE OUT WHICH ARE TESTS ///////////////
			// if the method has the name 'test_' in it then execute it
			var tests : Array = new Array();
			for (var i : int = 0;i < methodList.length(); i++) {
				item = methodList[i];
				sn = String(item.@name);

				if (sn.indexOf("test_") == 0 || sn.indexOf("atest_") == 0) {
				  
					var tt : TestTask = new TestTask(aClass, sn);
					
					tt.view = view;
					
					tt.stage = stage;
					tests.push(tt);
					trace("discovered Test " + tt);
				}
			}
			/////////////// SORT THEM AS THEY MAY BE OUT OF ORDER ///////////////////////
			tests.sortOn("methodName");
			trace("running functions\r " + tests.join("\r"));
			return tests;
		}

		public function addTest(test : Object) : void {
			if(test is Class) {
				trace("test is a class");
				var newTests : Array = getTestList(Class(test));
				allTests = allTests.concat(newTests);
			}else {
				allTests.push(test);
			}
		}

		/////////////////////// ACCESSORS //////////////////////////////////
		public function get hasCompletedAllTests() : Boolean {
			return _currentState == s_allTestsComplete;
		}

		/*.................................................................*/
		public function s_initial(e : CogEvent) : void {
			trace("s_initial " + e);
			switch (e.sig) {
				
				case SIG_ENTRY :
					//case SIG_INIT:
					trace("*****************************************");
					trace("*       STARTING " + allTests.length + " ATESTS               *");
					trace("*****************************************");
					testsLeft = allTests.concat();
					results = <testResults/>;
					passedAll = true;
					if(testsLeft.length == 0) {
						
						results.@passedAll = true;
						results.@perc = "0/0";
						requestTran(s_allTestsComplete);
					}else {
						requestTran(s_gettingNextTest);
					}
					return;
				//case SIG_ENTRY :
	
				//	return;
				case SIG_EXIT :
					return;
			}			
		}

		/*.................................................................*/
		public function s_gettingNextTest(e : CogEvent) : void {
			trace("s_gettingNextTest " + e);
			switch (e.sig) {
				case SIG_ENTRY :
					curTest = TestTask(testsLeft.shift());
					trace("\\\\\\\\\\\\\\\\\\\\\\\\ currentTest is " + curTest);
					requestTran(s_settingUpTest);
					return;
				case SIG_EXIT :
					return;
			}			
		}

		/*.................................................................*/
		public function s_settingUpTest(e : CogEvent) : void {
			trace("s_settingUpTest " + e);
			switch (e.sig) {
				case SIG_ENTRY :
					requestTran(s_testSetup);
					return;
				case SIG_EXIT :
					return;
			}	
		}

		/*.................................................................*/
		public function s_testSetup(e : CogEvent) : void {
			trace("s_testSetup " + e);
			switch (e.sig) {
				case SIG_ENTRY :
					requestTran(s_runningTest);
					return;
				case SIG_EXIT :
					return;
			}	
		}

		/*.................................................................*/
		public function s_runningTest(e : CogEvent) : void {
			trace("s_runningTest " + e);
			switch (e.sig) {
				case SIG_ENTRY :
					curTest.view = view;
					curTest.stage = stage;
					if(curTest.asynch) {
						trace("================================================");
						trace("running aTest------------- " + curTest);
						var timeOutIn : Number = Number(curTest.runTest(onAsynchTestComplete));
						trace("TimeOUT in " + timeOutIn);
						if(timeOutIn > -1) {
							setTimeOut(timeOutIn);
						}
					}else {
						trace("================================================");
						trace("running test------------- " + curTest);
						curTest.runTest();
						requestTran(s_resultsGotten);
						var tevt : TestEvent = new TestEvent(Event.CHANGE, passedAll, results);
						dispatchEvent(Event(tevt));	
					}
					return;
				case TIMEOUT:
					trace("================================================");
					trace("ERROR test timed out");
					//				    	requestTran(s_resultsGotten);
					trace("curTest " + curTest);
					trace("curTest.suite " + curTest.suite);
					if(haltOnErrors) {
						trace("^^^^^^^^^ HALTING ON ERROR LOOK ABOVE ME FOR DETAILS ^^^^^^^^^^^");
						var a : XML = <method/>;
						a.@name = curTest.methodName;
						a.@passed = "false";
						a.appendChild(<error msg="TIMEOUT"/>);
						results.appendChild(a);
						requestTran(s_allTestsComplete);
					}else {
						if(curTest.suite != null && curTest.suite.currentResultsFunction != null) {
							trace("curTest.currentResultsFunction " + curTest.suite.currentResultsFunction);
							curTest.suite.currentResultsFunction.call(new TestEvent(Event.CLOSE));
						}						
					}
					var ttevt : TestEvent = new TestEvent(Event.CHANGE, passedAll, results);
					dispatchEvent(Event(ttevt));	
					return;
				case SIG_EXIT :
					return;
			}	
		}

		public function onAsynchTestComplete(event : TestEvent) : void {
			trace("----------------------------------------------------");
			trace("AynchTestRunner.onAsynchTestComplete");
			timeOutTmer.stop();
			var a : XML = <method/>;
			a.@name = curTest.methodName;
			a.@passed = event.passedAll;
			if(event.passedAll) {
				passedN++;
			}else {
				passedAll = false;
			}
			totalN++;
			if(event.resultsXML != null) {
				a.appendChild(event.resultsXML);
			}
			results.appendChild(a);
			results.@passedAll = passedAll;
			results.@perc = passedN + "/" + totalN;
			requestTran(s_testRan);
		}

		/*.................................................................*/
		public function s_testRan(e : CogEvent) : void {
			trace("s_testRan " + e);
			switch (e.sig) {
				case SIG_ENTRY :
					requestTran(s_gettingResults);
					return;
				case SIG_EXIT :
					return;
			}	
		}

		/*.................................................................*/
		public function s_gettingResults(e : CogEvent) : void {
			trace("s_gettingResults " + e);
			switch (e.sig) {
				case SIG_ENTRY :
					requestTran(s_resultsGotten);
					return;
				case SIG_EXIT :
					return;
			}	
		}

		/*.................................................................*/
		public function s_resultsGotten(e : CogEvent) : void {
			trace("s_resultsGotten " + e);
			switch (e.sig) {
				case SIG_ENTRY :
					requestTran(s_cleaningUp);
					return;
				case SIG_EXIT :
					return;
			}	
		}

		/*.................................................................*/
		public function s_cleaningUp(e : CogEvent) : void {
			trace("s_cleaningUp " + e);
			switch (e.sig) {
				case SIG_ENTRY :
					requestTran(s_cleanedUp);
					return;
				case SIG_EXIT :
					return;
			}	
		}

		/*.................................................................*/
		public function s_cleanedUp(e : CogEvent) : void {
			trace("s_cleanedUp " + e);
			switch (e.sig) {
				case SIG_ENTRY :
					if(testsLeft.length == 0) {
						requestTran(s_allTestsComplete);
					}else {
						requestTran(s_gettingNextTest);
					}
					return;
				case SIG_EXIT :
					return;
			}	
		}

		/*.................................................................*/
		public function s_allTestsComplete(e : CogEvent) : void {
			trace("s_allTestsComplete " + e);
			switch (e.sig) {
				case SIG_ENTRY :
					trace("*****************************************");
					trace("*       ALL ATESTS COMPLETE              *");
					trace("*****************************************");
					trace(results.toXMLString());
					var evt : TestEvent = new TestEvent(Event.COMPLETE, passedAll, results);
					dispatchEvent(Event(evt));					
					return;
				case SIG_EXIT :
					return;
			}	
		}
	}
}
