package com.troyworks.geom.d1 {
	import com.troyworks.apps.tester.SynchronousTestSuite;

	/**
	 * TestPoint1D
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Nov 16, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class Test_Point1D extends SynchronousTestSuite {
		var pn : Point1D;
		var pv : Point1D;
		var p3 : Point1D;
		var p4 : Point1D;

		public function Test_Point1D() {
			super();
		}

		public function test_clone() : Boolean {
			var res : Boolean = false;
			pn = new Point1D("TEST", 34);
			trace(pn);
	
			pv = pn.clone();
			trace(pv);
			res = ASSERT(pv.name == pn.name, "point clone doens't match names");
			if(res) {
				res = ASSERT(pv.position == pn.position, "point clone doens't match value"); 
			}
			return res;
		}

		public function test_add() : Boolean {
			var res : Boolean = false;
			test_clone();
			
			p3 = pv.add(pn);
			trace(p3);
			res = ASSERT((p3.position == (pv.position + pn.position)), "point add doens't match expected value"); 
			return res;
		}

		public function test_subtract() : Boolean {
			var res : Boolean = false;
			test_clone();
	
			p4 = pv.subtract(pn);
			trace(p4);
			res = ASSERT((p4.position == (pv.position - pn.position)), "point subtract doens't match expected value"); 
			return res;
		}
	}
}
