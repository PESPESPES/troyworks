
package com.troyworks.tester{
	import flash.xml.XMLDocument;
	import flash.events.EventDispatcher;
	import flash.utils.describeType;
	import com.troyworks.tester.SynchronousTestSuite;
	import com.troyworks.tester.TestEvent;
	import flash.events.TextEvent;
	import flash.events.Event;
	/********************************************
	 * This is passed a worklist of tests and outputs the results in a synchrounous fashion
	 * for asynchrous tests use the statemachine version.
	 * 
	 * This is generally used for testing low level features such as Fsm, Hsfm, DesignByContract
	 * and the other TestRunners should be used/extended over using this as this class
	 * can't handle asynchronous tests.
	 * 
	 *********************************************/
	public class SimpleTestRunner extends EventDispatcher {
		protected var tests:Array;
		public var results:XML = <testResults/>;
		public var passedAll:Boolean = true;
		public var passedN:Number = 0;
		public var totalN:Number = 0;

		public function SimpleTestRunner() {
			super();
			tests = new Array();
		}
		public function addTest(c:Class):void {
			trace("addingTest " + c + " " + typeof(c));
			tests.push(c);
		}
		public function startTest():XML {
			var results:XML = <testRunnerResults/>;
			var passedAll:Boolean = true;
			var passedN:Number = 0;
			var totalN:Number = 0;

			for (var i:int=0; i < tests.length; i++) {
				var passed:Boolean = runTestsOnClass(tests[i], results);
				if (!passed) {
					passedAll = false;
				} else {
					passedN++;
				}
				totalN++;
			}
			results.@passedAll = passedAll;
			results.@perc = passedN + "/"+totalN;
			trace("results:\r" + results.toXMLString());
			var evt:TestEvent = new TestEvent(Event.COMPLETE, passedAll, results);
			dispatchEvent(Event(evt));
			return results;
		}
		/////////////////////////////TESTS BEGIN //////////////////////////////////////////
		public static function getTestList(aClass:Class):Array{
			var typeDesc : XML = describeType(aClass);
			var typeN:String = typeDesc.type.@name;
			var methodList:XMLList = typeDesc.factory.method;
			var item:XML;
			var sn:String;
			///////////// NOW ITERATE OVER THE FUNCTIONS FIGURE OUT WHICH ARE TESTS ///////////////
			// if the method has the name 'test_' in it then execute it
			var tests:Array = new Array();
			for (var i:int = 0; i < methodList.length(); i++) {
				item = methodList[i];
				sn = String(item.@name);

				if (sn.indexOf("test_") == 0 || sn.indexOf("atest_") == 0) {
					tests.push(sn);
				}
			}
			/////////////// SORT THEM AS THEY MAY BE OUT OF ORDER ///////////////////////
			tests.sort();
			trace("running functions\r "+ tests.join("\r"));
			return tests;
		}
		public function runTestsOnClass( aClass:Class, totalResults:XML):Boolean {
			trace("running Tests\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\");
			var inst:Object =  new aClass();
			var results:XML = <testResults/>;
			var passedAll:Boolean = true;
			var passedN:Number = 0;
			var totalN:Number = 0;
			var sn:String;
			var tests:Array = SimpleTestRunner.getTestList(aClass);
			
			for (var j:int = 0; j < tests.length; j++) {
				sn = tests[j];
					trace("METHOD " + sn + "()----------------------------------" );//item.toXMLString() +" \r");
					var passedThis:Boolean = false;
					try{
					  passedThis= inst[sn]();
					}catch(err:Error){
						trace("error " +err);
						passedThis = false;
					}
					
					var a:XML = <method/>;
					a.@name =sn;
					a.@passed = passedThis;
					results.appendChild(a);
					if (!passedThis) {
						passedAll = false;
					} else {
						passedN++;
					}
					totalN++;
					/////////////////////////////////////
					var evt:TestEvent = new TestEvent(Event.CHANGE, passedAll, results);
					dispatchEvent(Event(evt));	
					/////////////////////////////////////
			}
			results.@passedAll = passedAll;
			results.@perc = passedN + "/"+totalN;
			if (totalResults !== null) {
				totalResults.appendChild(results);
			}
		
			return passedAll;
		}
	}
}