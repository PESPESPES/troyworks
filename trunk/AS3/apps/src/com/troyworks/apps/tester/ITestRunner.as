package  com.troyworks.apps.tester{ 
	/**
	 * @author Troy Gardner
	 */
	interface ITestRunner {
		function startTest():void;
		function onTestFinished():Boolean;
	}
}