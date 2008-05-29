package com.troyworks.tester{
	import flash.events.EventDispatcher;
	import com.troyworks.util.DesignByContract;
	import com.troyworks.util.DesignByContractEvent;
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
	public class SynchronousTestSuite extends TestSuite {
		public function SynchronousTestSuite() {
			super();
		}

		/*public function trace(msg:String):void{
		   
		}*/

	}
}