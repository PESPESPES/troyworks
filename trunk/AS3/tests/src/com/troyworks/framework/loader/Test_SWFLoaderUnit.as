package com.troyworks.framework.loader {
	import com.troyworks.core.events.PlayheadEvent;	
	import com.troyworks.core.chain.UnitOfWork;	

	import flash.events.Event;	

	import com.troyworks.apps.tester.AsynchronousTestSuite;	

	/**
	 * Test_SWFLoaderUnit
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Jun 5, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class Test_SWFLoaderUnit extends AsynchronousTestSuite {
		public function Test_SWFLoaderUnit() {
			super();
		}

		public function setupChain(id : int = 0) : UnitOfWork {
			var chainA : UnitOfWork = new SWFLoaderUnit();
			var chainA1 : SWFLoaderUnit; 
			var chainA2 : SWFLoaderUnit; 
			var chainA3 : SWFLoaderUnit; 
			var chainA4 : TextLoaderUnit; 
			
			trace("setting up Chain " + view);
			switch(id) {
				case 0:
				
					var aA : SWFLoaderUnit = new SWFLoaderUnit(); 
					aA.mediaURL = "image.jpg";
					
					aA.targetClip = view;
					chainA = aA;
					break;
				case 2:
					chainA = UnitOfWork.makeSequentialWorker();
					chainA1 = new SWFLoaderUnit();
					
					chainA1.targetClip = view;
					
					chainA1.mediaURL = "image.jpg";
					chainA2 = new SWFLoaderUnit();
					
					chainA1.targetClip = view;
					chainA2.mediaURL = "TroyWorks-80x80.jpg";
					
					chainA2.targetClip = view;
					chainA.addChild(chainA1);
					chainA.addChild(chainA2);
					break;
				case 3:
					chainA = UnitOfWork.makeParallelWorker();	
					chainA1 = new SWFLoaderUnit();
					chainA1.targetClip = view;
					chainA1.mediaURL = "image.jpg";
					chainA2 = new SWFLoaderUnit();
					
					chainA2.mediaURL = "TroyWorks-80x80.jpg";
					
					chainA2.targetClip = view;
					chainA.addChild(chainA1);
					chainA.addChild(chainA2);
					break;
					
				case 4:
							chainA = UnitOfWork.makeParallelWorker();	
					chainA1 = new SWFLoaderUnit();
					chainA1.targetClip = view;
					chainA1.mediaURL = "image.jpg";
					chainA4 = new TextLoaderUnit();
					
				//	chainA4.mediaURL = "TroyWorks-80x80.jpg";
					
					chainA4.targetClip = view;
					chainA.addChild(chainA1);
					chainA.addChild(chainA4);
					break;
				case 5:
					chainA = UnitOfWork.makeSequentialWorker();
					chainA4 = new EngineLoaderConfigurationLoader();
					chainA4.targetClip = view;
					chainA4.mediaURL = "engines.txt";
					
					chainA.addChild(chainA4);
					break;		
					
			}
			chainA.initStateMachine();
			return chainA;
		}

		public function atest_1() : Number {
			//	var sm:StateMachine = new UnitOfWork("s_root");
			
			//	sm.addEventListener(UnitOfWork.EVT_COMPLETE, rtest_1);

			
			trace("a sTEST1----------------------");
			var chainA : UnitOfWork = setupChain(5);
			chainA.addEventListener(UnitOfWork.EVT_COMPLETE, rtest_1);
			chainA.startWork();
			trace("CREAting chainA  " + chainA);
			
			return 30000;
		}

		public function rtest_1(evt : PlayheadEvent = null) : void {
			trace("HIGHLIGHT result TEST1----------------------" + evt.percentageDone);
			
			dispatchTestComplete();
		}
	}
}