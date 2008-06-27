package com.troyworks.core.chain {
	import com.troyworks.core.events.PlayheadEvent;	
	
	import flash.events.Event;	
	
	import com.troyworks.apps.tester.AsynchronousTestSuite;	


	/**
	 * Test_PlaceHolderUnitOfWork
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Jun 5, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class Test_PlaceHolderUnitOfWork extends AsynchronousTestSuite
	 {
		public function Test_PlaceHolderUnitOfWork() {
			super();
		}

		public function setupChain(id : int = 0) : UnitOfWork {
			var chainA : UnitOfWork = new PlaceHolderUnitOfWork();
			var chainA1 : UnitOfWork; 
			var chainA2 : UnitOfWork; 
			var chainA3 : UnitOfWork; 
			var chainA4 : UnitOfWork; 
			switch(id) {
				case 0:
				chainA = new PlaceHolderUnitOfWork();
					break;
				case 2:
					chainA = UnitOfWork.makeSequentialWorker();
					chainA1 = new PlaceHolderUnitOfWork();
					chainA2 = new PlaceHolderUnitOfWork();
					chainA.addChild(chainA1);
					chainA.addChild(chainA2);
					break;
				case 3:
					chainA = UnitOfWork.makeParallelWorker();	
					chainA1 = new PlaceHolderUnitOfWork();
					chainA2 = new PlaceHolderUnitOfWork();
					chainA.addChild(chainA1);
					chainA.addChild(chainA2);
					break;	
			}
			chainA.initStateMachine();
			return chainA;
		}
		public function atest_1():Number{
		//	var sm:StateMachine = new UnitOfWork("s_root");
			
		//	sm.addEventListener(UnitOfWork.EVT_COMPLETE, rtest_1);

			
			trace("a sTEST1----------------------");
			var chainA : UnitOfWork = setupChain(0);
			chainA.addEventListener(UnitOfWork.EVT_COMPLETE, rtest_1);
			chainA.startWork();
			trace("CREAting chainA  " + chainA);
			
			return 30000;
		}
		
		public function rtest_1(evt : PlayheadEvent = null) : void {
			trace("HIGHLIGHT result TEST1----------------------" + evt.percentageDone);
			
			dispatchTestComplete();
			
		}
	/*
		public function atest_2():Number{
		//	var sm:StateMachine = new UnitOfWork("s_root");
			
		//	sm.addEventListener(UnitOfWork.EVT_COMPLETE, rtest_1);

			
			trace("a sTEST1----------------------");
			var chainA : UnitOfWork = setupChain(2);
			chainA.addEventListener(UnitOfWork.EVT_COMPLETE, rtest_2);
			chainA.startWork();
			trace("CREAting chainA  " + chainA);
			
			return 30000;
		}
		
		public function rtest_2(evt : Event= null) : void {
			trace("HIGHLIGHT result TEST1----------------------");
			
			dispatchTestComplete();
			
		}*/
		/*
		public function atest_3():Number{
		//	var sm:StateMachine = new UnitOfWork("s_root");
			
		//	sm.addEventListener(UnitOfWork.EVT_COMPLETE, rtest_1);

			
			trace("a sTEST1----------------------");
			var chainA : UnitOfWork = setupChain(3);
			chainA.addEventListener(UnitOfWork.EVT_COMPLETE, rtest_3);
			chainA.startWork();
			trace("CREAting chainA  " + chainA);
			
			return 30000;
		}
		
		public function rtest_3(evt : Event= null) : void {
			trace("HIGHLIGHT result TEST1----------------------");
			
			dispatchTestComplete();
			
		}*/
		
	}
}
