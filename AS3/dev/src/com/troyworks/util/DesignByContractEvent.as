
package com.troyworks.util{
	import flash.events.Event;

	/**
	 * This class is the default/root Error tossed by using
	 * Design By Contract in classes.
	 * 
	 * fatal indicates that the application cannot proceed.
	 * type provides information about the error.
	 * 
	 * @author Troy Gardner
	 */
	public class DesignByContractEvent extends Event {

		public var fatal : Boolean = false;
		public var message:String = "";
		public static  const ASSERT:String = "ASSERT";
		public static  const ASSERT_FAILED:String = "ASSERT_FAILED";
		public static  const REQUIRE:String = "REQUIRE";
		public static  const REQUIRE_FAILED:String = "REQUIRE_FAILED";

		public function DesignByContractEvent(type : String) {
			super(type);
		}
	}
}