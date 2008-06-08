package com.troyworks.tester {
	import com.troyworks.apps.tester.AsynchronousTestSuite;	
	import com.troyworks.apps.tester.SynchronousTestSuite;	

	public class Test_AsynchronousTestSuite extends SynchronousTestSuite
	{	protected var fsm:AsynchronousTestSuite;
		public function Test_AsynchronousTestSuite():void{		
			super();
		}
		
		/* Make sure that during inital creation, statemachine is inactive */
		/*public function test_constructor():Boolean {
			var res:Boolean=false;
			var fsm:AsynchronousTestSuite=new AsynchronousTestSuite () ;
			trace( fsm.currentState  + " " + fsm.hasInited());
			res = (fsm != null && fsm.currentState == null && !fsm.hasInited());
			return res;
		}
		public function test_init():Boolean {
			var res:Boolean=false;
			fsm =new AsynchronousTestSuite () ;
			fsm.init();
			res = (fsm != null && fsm.hasCompletedAllTests);
			return res;
		}
		public function test_init2():Boolean {
			var res:Boolean=false;
			res = (fsm != null && fsm.hasCompletedAllTests);
			return res;
		}
		public function test_oneTest():Boolean {
			var res:Boolean=false;
			fsm =new AsynchronousTestSuite () ;
			fsm.addTest("DummyTest");
			fsm.init();
			res = (fsm != null && fsm.hasCompletedAllTests);
			return res;
		}
		public function test_twoTest():Boolean {
			var res:Boolean=false;
			fsm =new AsynchronousTestSuite () ;
			fsm.addTest("DummyTest");
			fsm.addTest("DummyTest2");
			fsm.init();
			res = (fsm != null && fsm.hasCompletedAllTests);
			return res;
		}*/

	/*	public function test_init3():Boolean {
			var res:Boolean=false;
			fsm =new AsynchronousTestSuite () ;
			fsm.addTest("DummyTest");
			fsm.addTest("DummyTest2");
			fsm.addTest("DummyTest3");
			fsm.init();
			res = (fsm != null && fsm.hasCompletedAllTests);
			return res;
		}*/
	}
}