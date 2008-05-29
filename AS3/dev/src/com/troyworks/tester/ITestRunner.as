package  { 
	/**
	 * @author Troy Gardner
	 */
	interface com.troyworks.tester.ITestRunner {
		public function startTest():void;
		public function onTestFinished():Boolean;
	}
}