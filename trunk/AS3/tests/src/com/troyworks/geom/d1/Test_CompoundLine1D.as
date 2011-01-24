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

		/*
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
		public function test_slideshowScore():Boolean {
		var res : Boolean = false;
		var show : CompoundLine1D = new CompoundLine1D("SlideShow", 1, 0, 0);
		var slide1 : CompoundLine1D = new CompoundLine1D("Slide1", 1, 0, 0);
			
		////////////////////////////////////////////////////
		//  Create a 3 phase/step 
		//  ....->transitionIn->dwell->transitionOut->...
		// which means 4 points and 3 lines
		//  (A)--line1--(B)--line2--(C)--line3--(D)
		////////////////////////////////////////////////////
		var transLength:Number = 3;
			
		var tranInStart:Point1D = new Point1D("tranInStart", 0);
		var tranInStopMp3Start:Point1D = new Point1D("tranInStopMp3Start", transLength);
		var mp3StopTranOutStart:Point1D = new Point1D("mp3StopTranOutStart", tranInStopMp3Start.position + 10);
		var tranOutStop:Point1D = new Point1D("tranOutStop",mp3StopTranOutStart.position  +transLength);
			
		////// Create 3 1 dimensional lines to represent the transitionin, dwell and out
		var transitionIn:Line1D = new Line1D("slide1.tranIN",2);
		var dwell:Line1D = new Line1D("slide1.dwell",3);
		var transitionOut:Line1D = new Line1D("slide1.tranOUT",2);
			
		/////// SET EACH Line's (shared) end points
		transitionIn.A = tranInStart;
		transitionIn.Z = tranInStopMp3Start;
		dwell.A = tranInStopMp3Start;
		dwell.Z = mp3StopTranOutStart;
		transitionOut.A = mp3StopTranOutStart;
		transitionOut.Z = tranOutStop;
		////// RECALCULATE the line lenghts ////////
		transitionIn.calc();
		dwell.calc();
		transitionOut.calc();
			
		//////add them to the parent "slide" ////
		slide1.addChild(transitionIn);
		slide1.addChild(dwell);
		slide1.addChild(transitionOut);
		////// take a look at how things are.
		trace(slide1);
		///// increase the audio to 20 ////
			
		var newDuration:Number = 20;
		var delta:Number = newDuration -dwell.length;
		dwell.Z.position += delta;
		transitionOut.Z.position += delta;
		//			dwell.length = 30;
			
		//slide1.calc();
		trace("AFTER changing mp3 duration");
		trace(slide1);
			
			
		//	show.addChild(slide1);
		return res;
		}*/
		public function test_slideshowScore2() : Boolean {
			var res : Boolean = false;
			var show : CompoundLine1D = new CompoundLine1D("SlideShow", 1, 0, 0);
			var slide1 : CompoundLine1D = create3PhaseSlide(1, 5, 10);
			var slide2 : CompoundLine1D = create3PhaseSlide(2, 5, 10);
			
			
			show.addChild(slide1);
			show.addChild(slide2);
			trace("BEFORE " + show);
			slide2.shiftBy(slide1.length + 10);
			//	slide2.A.position += slide1.length;
			//show.calc();		
			trace("AFTER " + show);
			
			
			//	show.addChild(slide1);
			return res;
		}

		public function create3PhaseSlide(id : Number = 0, transLength : Number = 3, audioLength : Number = 5) : CompoundLine1D {
			var slide1 : CompoundLine1D = new CompoundLine1D("Slide" + id, 1, 0, 0);
			////////////////////////////////////////////////////
			//  Create a 3 phase/step 
			//  ....->transitionIn->dwell->transitionOut->...
			// which means 4 points and 3 lines
			//  (A)--line1--(B)--line2--(C)--line3--(D)
			////////////////////////////////////////////////////
			var tranInStart : Point1D = new Point1D("tranInStart", 0);
			var tranInStopMp3Start : Point1D = new Point1D("tranInStopMp3Start", transLength);
			var mp3StopTranOutStart : Point1D = new Point1D("mp3StopTranOutStart", tranInStopMp3Start.position + 10);
			var tranOutStop : Point1D = new Point1D("tranOutStop", mp3StopTranOutStart.position + transLength);
			
			////// Create 3 1 dimensional lines to represent the transitionin, dwell and out
			var transitionIn : Line1D = new Line1D("slide" + id + ".tranIN", 2);
			var dwell : Line1D = new Line1D("slide" + id + "dwell", 3);
			var transitionOut : Line1D = new Line1D("slide" + id + "tranOUT", 2);
			
			/////// SET EACH Line's (shared) end points
			transitionIn.A = tranInStart;
			transitionIn.Z = tranInStopMp3Start;
			dwell.A = tranInStopMp3Start;
			dwell.Z = mp3StopTranOutStart;
			transitionOut.A = mp3StopTranOutStart;
			transitionOut.Z = tranOutStop;
			////// RECALCULATE the line lenghts ////////
			transitionIn.calc();
			dwell.calc();
			transitionOut.calc();
			
			//////add them to the parent "slide" ////
			slide1.addChild(transitionIn);
			slide1.addChild(dwell);
			slide1.addChild(transitionOut);
			return slide1;
		}

		public function createDemo() : void {
			var pres : XML = 
		}
	}
}
