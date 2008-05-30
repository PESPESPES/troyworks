package com.troyworks.apps.tester
{
	import flash.events.Event;

	public class TestEvent extends Event
	{
		public static const TESTER_EVENT:String = "TESTER_EVENT";
		public var passedAll:Boolean = false;
		public static const TEST_RESULTS_XML:XML = <testresults/>;
		public var resultsXML:XML = <testresults/>;
		public function TestEvent(msg:String, passedAll:Boolean= false, resultsXML:XML = null){
		  super(msg);
		  this.passedAll = passedAll;
		  this.resultsXML = resultsXML;
		}
	}
}