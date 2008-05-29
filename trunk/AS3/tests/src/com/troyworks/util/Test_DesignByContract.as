package com.troyworks.util{


	import com.troyworks.util.DesignByContract;
	import com.troyworks.util.DesignByContractEvent;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import com.troyworks.tester.TestSuite;

	/**
	 * This is somewhat of an odd duck, bootstrapping wise 
	 * it's testing using itself.
	 * 
	 * @author Troy Gardner
	 */
	public dynamic class Test_DesignByContract extends TestSuite
	{


		public function Test_DesignByContract() {
			super();
		}

		public function test_Constructor():Boolean {
			var res : Boolean = false;
			var dbc : DesignByContract = new DesignByContract();
			return (dbc != null);
		}
		public function test_notificationonAssertFailed():Boolean {
			//trace("attempting to add the event listerner to " + onAssertFailed);
			var res : Boolean = false;
			assertRes = "MM";
			onAssertFailed(null);
			res = (assertRes == "MM")?true:false;
			trace("assertRes " + res);
			return res;
		}
		public function test_notificationonAssertFailed2():Boolean {
			var res : Boolean = false;
			assertRes = "MM";
			var dbcE:DesignByContractEvent = new DesignByContractEvent(DesignByContract.EVTD_ASSERT_FAILED);
			dbcE.message = DesignByContractEvent.ASSERT_FAILED;
			dbcE.fatal = true;
			onAssertFailed(dbcE);
			res = (assertRes == DesignByContractEvent.ASSERT_FAILED)?true:false;
			trace("assertRes " + res);
			return res;
		}
		public function test_AssertNotification():Boolean {
			////////////////// SETUP ///////////////////////
			var res : Boolean = false;
			var dbc : DesignByContract = new DesignByContract();
			assertRes = "";
			trace("attempting to add the event listerner to " + onAssertFailed);
			dbc.addEventListener(DesignByContractEvent.ASSERT_FAILED, onAssertFailed);
			////////////////// RUN ///////////////////////
			//create dummy event and broadcast it
			var dbcE:DesignByContractEvent = new DesignByContractEvent(DesignByContractEvent.ASSERT_FAILED);
			dbcE.message = "Test Failed";
			dbcE.fatal = true;
			trace("dispatchingEvent");
			dbc.dispatchEvent(dbcE);
			trace("assertRes22 " + assertRes);
			/////////////////////// GRADE //////////////////////////////
			res = (assertRes  ==  "Test Failed")? true:false;
			assertRes = null;
			return res;

		}
		public function test_RequireNotification():Boolean {
			////////////////// SETUP ///////////////////////
			var res : Boolean = false;
			var dbc : DesignByContract = new DesignByContract();
			assertRes = "";
			trace("attempting to add the event listerner to " + onAssertFailed);
			dbc.addEventListener(DesignByContractEvent.REQUIRE_FAILED, onAssertFailed);
			////////////////// RUN ///////////////////////
			//create dummy event and broadcast it
			var dbcE:DesignByContractEvent = new DesignByContractEvent(DesignByContractEvent.REQUIRE_FAILED);
			dbcE.message = "Test Failed";
			dbcE.fatal = true;
			trace("dispatchingEvent");
			dbc.dispatchEvent(dbcE);
			trace("assertRes22 " + assertRes);
			/////////////////////// GRADE //////////////////////////////
			res = (assertRes  ==  "Test Failed")? true:false;
			assertRes = null;
			return res;

		}
		public function test_REQUIRE():Boolean {
			var res : Boolean = false;
			lastEvent = null;
			DesignByContract.REQUIRE(false, "test of REQUIRE", false);
			trace("lastEvent " + lastEvent);
			res = (lastEvent.type == DesignByContractEvent.REQUIRE_FAILED);
			return res;

		}
		public function test_ASSERT():Boolean {
			var res : Boolean = false;
			lastEvent = null;
			DesignByContract.ASSERT(false, "test of ASSERT", false);
			trace("lastEvent " + lastEvent);
			res = (lastEvent.type == DesignByContractEvent.ASSERT_FAILED);
			return res;

		}
		public function test_MyREQUIRE():Boolean {
			var res : Boolean = false;
			lastEvent = null;
			REQUIRE(false, "test of My REQUIRE", false);
			trace("lastEvent " + lastEvent);
			res = (lastEvent.type == DesignByContractEvent.REQUIRE_FAILED);

			return res;

		}
		public function test_MyASSERT():Boolean {
			var res : Boolean = false;
			lastEvent = null;

			ASSERT(false, "test of My ASSERT", false);
			trace("lastEvent " + lastEvent);
			res = (lastEvent.type == DesignByContractEvent.ASSERT_FAILED);

			return res;
		}


	}
}