package {
	import com.troyworks.logging.SOSLogger;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.troyworks.util.DesignByContract;
	import com.troyworks.tester.SimpleTestRunner;
	import com.troyworks.tester.Test_AsynchronousTestSuite;
	import com.troyworks.util.Test_DesignByContract;
	import com.troyworks.util.Test_SwitchPerformance;
	import com.troyworks.util.traceTest;
	import com.troyworks.cogs.Test_Fsm;
	import com.troyworks.cogs.Test_Hsm;
	import com.troyworks.cogs.*;
	import com.troyworks.text.*;
	import com.troyworks.tester.AsynchronousTestSuite;
	import com.troyworks.tester.AsynchTestRunner;
	import com.troyworks.tester.TestEvent;
	import com.troyworks.logging.*;
	import com.troyworks.datastructures.Test_ArrayX;

	/*************************************************
	 *  This is the 'main' TestRunner extends Sprite so it
	 *  can actually be compiled, and ideally produce useful
	 * visual and xml output.
	 * 
	 * that runs all tests across the com.troyworks.* library
	 */

	public dynamic class TroyWorks_Test extends Sprite
	{
		private var eventSprite:Sprite;
		private var sos:SOS;
		
		private var testRunner:SimpleTestRunner;
		private var testRunner2:AsynchTestRunner;
		public static var trace:Function;
		public var curStatusSize:Number = 10;
		

		public function TroyWorks_Test() {
			trace = TraceAdapter.TraceToSOS;
			eventSprite = new Sprite();
			addChild(eventSprite);
			eventSprite.graphics.beginFill(0x000000);
			eventSprite.graphics.drawCircle(0, 0, curStatusSize);
			eventSprite.x = stage.stageWidth / 2;
			eventSprite.y = stage.stageHeight / 2;	
			/*sos = new SOS();
			sos.connect();
			
			sos.showMessage("TroyWorks_Test","!!!!!!!!!!!!!!!!!!!!!!!hello from TroyWorks_Test!!!!!!!!!!!!!!!!!!!!");
			sos.showMessage("TroyWorks_Test", "A = A \r B = B \r C = C");
			//sos.createDialog("Hello popup");
			sos.clearConsole();
			TraceAdapter.setTraceOutputToSOS();
			this.trace("HIGHLIGHT sos this.trace");
			TraceAdapter.setTraceOutputToFlashTrace();
			this.trace("NORMAL this.trace");
			trace = TraceAdapter.getNormalTracer();
			trace("trace()");
			trace = TraceAdapter.TraceToSOS;
			trace("trace2()");
			
			var log:ILogger = new SOSLogger("TroyWorks_Test");
			log.fatal("fatal message");
			log.fatal("fatal message with folded a\rb\rc");
			log.debug("debug message");
			log.error("error message");
			log.info("info message");
			//log.severe("severe message");
			
			
		//	this.trace("normal");*/
		
			startSynchronousTests();
		}
		public function startSynchronousTests():void{
			try {
				testRunner = new SimpleTestRunner();
				testRunner.addEventListener(Event.COMPLETE, onSychronousTestComplete);
				testRunner.addEventListener(Event.CHANGE, onProgress);
				///////////////////////////////////////////
			//	testRunner.addTest(Test_ArrayX);
				//testRunner.addTest(Test_DesignByContract);
//				testRunner.addTest(Test_Fsm);
//				testRunner.addTest(Test_SOS);
		//		testRunner.addTest(Test_SwitchPerformance);
//				var nE:Test_NumberExtention = new Test_NumberExtention();

				//testRunner.addTest(Test_Hsm);		
				//testRunner.addTest(Test_AsynchronousTestSuite);
				//testRunner.addTest(Test_Indexer);
				////////RUN TEST //////////////
				testRunner.startTest();

			} catch(e:Error) {
				var evt:TestEvent = new TestEvent(Event.COMPLETE, false);
				onAllTestComplete(evt);
			}

		}
		public function onProgress(event:TestEvent):void{
			eventSprite.graphics.beginFill(0x666666);
			curStatusSize +=5;
			eventSprite.graphics.drawCircle(0, 0, curStatusSize);

		}
		public function onSychronousTestComplete(event:TestEvent):void{
			startAsynchTests();
		}
		public function startAsynchTests():void{
			try {
				testRunner2 = new AsynchTestRunner();
				testRunner2.addEventListener(Event.COMPLETE, onAllTestComplete);
				testRunner2.addEventListener(Event.CHANGE, onProgress);
				///////////////////////////////////////////
				testRunner2.addTest(Test_Hsm);		
				////////RUN TEST //////////////
				testRunner2.init();

			} catch(e:Error) {
				var evt:TestEvent = new TestEvent(Event.COMPLETE, false);
				onAllTestComplete(evt);
			}

		}
		public function onAllTestComplete(event:TestEvent):void{
			///////////////////////////////////////
			eventSprite.graphics.clear();
			var clr:Number = 0xff0000;
			var testResults:XML = event.resultsXML;		
			trace("//////////// TEST RESULTS///////////////////" + testResults.@passedAll);
			if (testResults.@passedAll== "true") {
				// draw a green circle for passed
				clr = 0x00ff00;
			} else {
				// draw a red circle for failed
				clr = 0xcc0000;
			}
			eventSprite.graphics.beginFill(clr);
			eventSprite.graphics.drawCircle(0, 0, curStatusSize);
			trace("stage.wid " + stage.stageWidth + " h: " + stage.stageHeight);
			eventSprite.x = stage.stageWidth / 2;
			eventSprite.y = stage.stageHeight / 2;	
		}
	}
}