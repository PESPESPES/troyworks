package com.troyworks.geom.d1 {
	import com.troyworks.geom.d1.LineQuery;	
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
	public class Test_CompoundLine1D extends SynchronousTestSuite {
		public function Test_CompoundLine1D() {
			super();
		}

		public function test_setEmpty() : Boolean {
			var res : Boolean = false;
			var ln : CompoundLine1D = new CompoundLine1D("Song", 1, 0, 10);
			res = ASSERT(ln.length == 10, "Line has wrong length"); 
			return res;
		}
		public function test_setAdd() : Boolean {
			var res : Boolean = false;
			var ln : CompoundLine1D = new CompoundLine1D("Song", 1, 0, 0);
			trace("ln "+ ln);
			res = ASSERT(ln.length == 0, "Line has wrong length"); 
			return res;
		}
		public function test_setAdd1() : Boolean {
			var res : Boolean = false;
			var ln : CompoundLine1D = new CompoundLine1D("Song", 1, 0, 0);
			var ln1:Line1D = new Line1D("note1",2, 0, 5);
			var ln2:Line1D = new Line1D("note2",2, 5, 5);
			ln.addChild(ln1);
			ln.addChild(ln2);
			trace("ln " + ln);
			res = ASSERT(ln.length == 10, "Line has wrong length"); 
			return res;
		}
		public function test_setQuery1() : Boolean {
			var res : Boolean = false;
			var ln : CompoundLine1D = new CompoundLine1D("Song", 1, 0, 0);
			var ln1:Line1D = new Line1D("note1",2, 0, 5, NaN);
			var ln2:Line1D = new Line1D("note2",2, 5, NaN, 5 );
			var ln3:Line1D = new Line1D("note2",2, 4, NaN, 4);
			ln.addChild(ln1);
			ln.addChild(ln2);
			ln.addChild(ln3);
			trace("starting Query1");
			var startingBetween:LineQuery = new LineQuery(-1, NaN,4);
			startingBetween.name = "startingBetween-1And4";
			startingBetween.minRelationToMin = LineQuery.GREATER_THAN_OR_EQUAL_TO;
			startingBetween.minRelationToMax = LineQuery.LESS_THAN_OR_EQUAL_TO;
			var ary:Array = ln.getClips(startingBetween);
			res = ASSERT(ary.length == 2, "Line has wrong length");
			trace("clips between -1 and 4 ==" + ary.length + " \r results:\r" + ary.join(","));
	
			var endingBetween:LineQuery = new LineQuery(-1,NaN, 4);
			startingBetween.name = "endingBetween-1And4";
			endingBetween.maxRelationToMax = LineQuery.LESS_THAN_OR_EQUAL_TO;
	
			
			var ary2:Array = ln.getClips(endingBetween);
					trace("clips between 0 and 7 ==" + ary2.length + " \r results:\r" + ary2.join(",")); 
			res = ASSERT(ary2.length == 2, "Line has wrong length"); 
			return res;
		}
	}
}
