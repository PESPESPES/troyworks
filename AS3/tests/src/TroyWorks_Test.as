package {
	import com.troyworks.apps.tester.SampleTest;	
	
	import flash.display.MovieClip;	

	import com.troyworks.core.chain.Test_PlaceHolderUnitOfWork;	
	import com.troyworks.core.patterns.*
	import com.troyworks.apps.tester.TestEvent;	
	import com.troyworks.apps.tester.AsynchTestRunner;	
	import com.troyworks.apps.tester.SimpleTestRunner;	
	import com.troyworks.logging.SOSLogger;

	import flash.display.Sprite;
	import flash.events.Event;

	import com.troyworks.util.DesignByContract;
	import com.troyworks.tester.Test_AsynchronousTestSuite;
	import com.troyworks.util.Test_DesignByContract;
	import com.troyworks.util.Test_SwitchPerformance;
	import com.troyworks.core.cogs.Test_Fsm;
	import com.troyworks.core.cogs.Test_Hsm;
	import com.troyworks.logging.*;
	import com.troyworks.data.Test_ArrayX;
	import com.troyworks.core.cogs.StateMachine;
	import com.troyworks.framework.loader.Test_SWFLoaderUnit;
	import com.troyworks.util.datetime.*;

	/*************************************************
	 *  This is the 'main' TestRunner extends Sprite so it
	 *  can actually be compiled, and ideally produce useful
	 * visual and xml output.
	 * 
	 * that runs all tests across the com.troyworks.* library
	 */

	public dynamic class TroyWorks_Test extends MovieClip {
		private var eventSprite : Sprite;

		private var testRunner : SimpleTestRunner;
		private var testRunner2 : AsynchTestRunner;
		//public static var trace : Function = TraceAdapter.SOSTracer;
		public var curStatusSize : Number = 10;

		
		public function TroyWorks_Test() {
			super();
			//TraceAdapter.CurrentTracer = TraceAdapter.SOSTracer;
			//StateMachine.DEFAULT_TRACE = TraceAdapter.CurrentTracer;
			trace("TroyWorks_Test()");
			eventSprite = new Sprite();
			addChild(eventSprite);

			
			addEventListener(Event.ENTER_FRAME, onProgress);	

			onProgress(null);
			startSynchronousTests();

			//	startAsynchTests();
		}

		
		public function onProgress(event : Event = null) : void {
			
			eventSprite.graphics.clear();
			
			if(curStatusSize == 10) {
				eventSprite.graphics.beginFill(0x000000);	
			}else {
				eventSprite.graphics.beginFill(0x666666);
			}
			curStatusSize += 5;
			eventSprite.graphics.drawCircle(0, 0, curStatusSize);
			
			//trace("onResize stage.stageWidth " + stage.stageWidth);
			eventSprite.x = stage.stageWidth / 2 - (eventSprite.width / 2);
			eventSprite.y = stage.stageHeight / 2 - (eventSprite.height / 2);
			
			if(stage.stageWidth != 0 && stage.stageHeight != 0  ) {
				removeEventListener(Event.ENTER_FRAME, onProgress);	
			}
		}

		public function startSynchronousTests() : void {
			
			trace("startSynchronousTests");
			try {
				testRunner = new SimpleTestRunner();
				testRunner.view = this;
				testRunner.stage = testRunner.view.stage; 
				
				testRunner.addEventListener(Event.COMPLETE, onSychronousTestComplete);
				testRunner.addEventListener(Event.CHANGE, onProgress);
				///////////////////////////////////////////
				//	testRunner.addTest(Test_ArrayX);
				//testRunner.addTest(Test_DesignByContract);
				//				testRunner.addTest(Test_Fsm);
				//				testRunner.addTest(Test_SOS);
				//		testRunner.addTest(Test_SwitchPerformance);
				//				var nE:Test_NumberExtention = new Test_NumberExtention();
				//testRunner.addTest(SampleTest);
				//testRunner.addTest(Test_Hsm);		
				//testRunner.addTest(Test_AsynchronousTestSuite);
				//testRunner.addTest(Test_Indexer);
				//testRunner.addTest(Test_DirtyCleanMachine);
				testRunner.addTest(Test_TimeQuantity);
				////////RUN TEST //////////////

				if(testRunner.hasTests){
					testRunner.startTest();
				}else{
					onSychronousTestComplete(null);
				}
				
				
			} catch(e : Error) {
				
				trace("ERROR in startSynchronousTests " + e.toString());
				var evt : TestEvent = new TestEvent(Event.COMPLETE, false);
				onAllTestComplete(evt);
			}
		}

		
		public function onSychronousTestComplete(event : TestEvent) : void {
			startAsynchTests();
		}

		public function startAsynchTests() : void {
			
			trace("startAsynchTests");
			try {
				testRunner2 = new AsynchTestRunner();
				testRunner2.view = this;
				testRunner2.stage = testRunner2.view.stage; 
				
				trace("new atestRunner1" + testRunner2);
				testRunner2.addEventListener(Event.COMPLETE, onAllTestComplete);
				testRunner2.addEventListener(Event.CHANGE, onProgress);
				///////////////////////////////////////////
				//testRunner2.addTest(Test_Hsm);
			//	testRunner2.addTest(Test_PlaceHolderUnitOfWork);
			//testRunner2.addTest(SampleTest);
				//	testRunner2.addTest(Test_SWFLoaderUnit);
						
				////////RUN TEST //////////////
				
				trace("running tests");
				testRunner2.initStateMachine();
			} catch(e : Error) {
				
				trace("ERROR in startAsynchTests ");
				
				var evt : TestEvent = new TestEvent(Event.COMPLETE, false);
				onAllTestComplete(evt);
			}
		}

		public function onAllTestComplete(event : TestEvent) : void {
			///////////////////////////////////////

			var clr : Number = 0xff0000;
			var testResults : XML = event.resultsXML;		
			if(testResults == null){
				
				trace("////////// NO TEST RESULTS!!! ///////////////");
				clr = 0x440000;
			}else{		
			trace("//////////// TEST RESULTS///////////////////" + testResults.@passedAll);
			if (testResults.@passedAll == "true") {
				// draw a green circle for passed
				clr = 0x00ff00;
			} else {
				// draw a red circle for failed
				clr = 0xcc0000;
			}
			
			}
			eventSprite.graphics.clear();
			eventSprite.graphics.beginFill(clr);
			eventSprite.graphics.drawCircle(0, 0, curStatusSize);
			trace("stage.wid " + stage.stageWidth + " h: " + stage.stageHeight);
		}
	}
}