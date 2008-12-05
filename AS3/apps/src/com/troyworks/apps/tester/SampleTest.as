package com.troyworks.apps.tester {
	import flash.events.Event;	
	
	/**
	 * SampleTest
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Jul 27, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class SampleTest {
		
		public function test_helloWorld():Boolean{
			
			trace("hello World");
			return true;	
		}
		
		public function atest_1() : Number {
			
			trace("a sTEST1----------------------");
			return 30000;
		}

		public function rtest_1(evt : Event = null) : void {
			
			trace("result ");
		//	trace("HIGHLIGHT result TEST1----------------------" + evt.percentageDone);
			
		//	dispatchTestComplete();
		}
	}
}
