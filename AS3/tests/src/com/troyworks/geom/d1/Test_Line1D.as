package com.troyworks.geom.d1 {
	import com.troyworks.apps.tester.SynchronousTestSuite;

	/**
	 * Test_Line1D
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Nov 16, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class Test_Line1D extends SynchronousTestSuite {
		public function Test_Line1D() {
			super();
		}

		public function test_setEmpty() : Boolean {
			var res : Boolean = false;
			var ln : Line1D = new Line1D(null, 1, 0, 10);
			res = ASSERT(ln.length == 10, "Line has wrong length"); 
			return res;
		}
	}
}
