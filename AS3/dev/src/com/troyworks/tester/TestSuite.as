/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.tester {
	import com.troyworks.cogs.Fsm;
	import com.troyworks.cogs.CogEvent;
	import flash.events.EventDispatcher;
	import com.troyworks.util.DesignByContract;
	import com.troyworks.util.DesignByContractEvent;

	public class TestSuite extends EventDispatcher{
		public var currentResultsFunction:Function;
		
			/* these are mixed in */
		public var REQUIRE:Function;
		public var ASSERT:Function;
		public var assertRes:String;
		public var lastEvent:DesignByContractEvent;
		public var defaultTimeOutInMS:Number = 2000;
		
		public function TestSuite() {
			DesignByContract.initialize(this);
			DesignByContract.HALT_ON_ERRORS = false;
		}
		public function onAssertFailed(e : DesignByContractEvent):void {
			//Insert a breakpoint here.
			//trace("!!!!!!!!!!!!!!!!!!!!!!!!! DesignByContract"+ID+" ERROR !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\r" + util.Trace.me(e, e.message) + " fatal?: "+ e.fatal);
			if (e != null) {
				trace("!!!!!!!!!!!!!!!!!!!!!!!!! TestSuite.DesignByContract ASSERT ERROR !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\r" + e.message + " fatal?: "+ e.fatal);
				assertRes = e.message;
			} else {
				trace("!!!!!!!!!!!!!!!!!!!!!!!!! TestSuite.DesignByContract  ASSERT  ERROR !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\r");

			}
			lastEvent = e;

		}
	}
	
}
