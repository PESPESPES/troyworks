package com.troyworks.data {
	import com.troyworks.apps.tester.SynchronousTestSuite;
	import com.troyworks.data.ArrayX;
	import com.troyworks.data.ArrayWeighting;

	/**
	 * @author Troy Gardner
	 */
	/* This is a comprehensive test of possible state transitios and topologies as inspried by sixstatemachine*/
	public class Test_ArrayX extends SynchronousTestSuite {

		public function Test_ArrayX() {
			super();
			trace("new Test_ArrayX");
		//	DesignByContract.initialize(this);
		//	REQUIRE(testWeightedRandom(), "testWeightedRandom");
		//	REQUIRE(testArrayX_concatEmpty(), "testArrayX_concatEmpty");
		//	REQUIRE(testArrayX_concatOne(), "testArrayX_concatOne");
		//	REQUIRE(testArrayX_concatMany(), "testArrayX_concatMany");
		//	REQUIRE(testArrayX_appendArray(), "testArrayX_appendArray");
		//	REQUIRE(testArrayX_unshift(), "testArrayX_unshift");
		//	REQUIRE(testArrayX_push(), "testArrayX_push");
		//	REQUIRE(testArrayX_pop(), "testArrayX_pop");
		//	REQUIRE(testArrayX_shift(), "testArrayX_shift");
		}

		/*****************************************
		 * for a given bunch of elements, e.g. A, B,C
		 * and a given bunch of weightws e. 60, 30, 10
		 * get a random one that matches the approximate
		 * distrubtion of the weights.
		 */
		public function testWeightedRandom() : Boolean {
			var a : ArrayX = new ArrayX("A", "B", "C");
			var wts : Array = new Array(60, 30, 10);
			var weightor : ArrayWeighting = new ArrayWeighting();
			weightor.c = a;
			weightor.setWeights(wts);
			var res : ArrayX = weightor.getWeightedRandom(null, 1000);
			///////////REVIEW HOW WELL THE FUNCTION DID ///////////////
			trace(" res " + res);
			res.sort();
			var stat : Object = new Object();
			for (var i : Number = 0;i < res.length; i++) {
				var ci : String = res[i];
				if(stat[ci] == null) {
					stat[ci] = 1;
				}else {
					stat[ci]++;
				}
			}
			for(var j:String in stat) {
				var cn : Number = stat[j];
				trace(j + " found " + cn + " total of " + res.length + " = " + cn / res.length * 100 + " %");
			}
			return true;
		}

		/*****************************************
		 * for a given bunch of elements, e.g. A, B,C
		 * and a given bunch of weightws e. 60, 30, 10
		 * get a random one that matches the approximate
		 * distrubtion of the weights.
		 */
		public function test_WeightedRandeom() : Boolean {
			var a : ArrayX = new ArrayX("A", "B", "C");
			var wts : ArrayX = new ArrayX(6, 3, 1);
			var W : ArrayX = new ArrayX();

			var sum_of_wts : Number = 0;
			for (var i : Number = 0;i < wts.length; i++) {
				trace("sum of wts1 " + sum_of_wts);

				sum_of_wts = sum_of_wts + wts[i];
				trace("sum of wts2 " + sum_of_wts);
				W[i] = sum_of_wts;
			}
			trace("sum_of_wts " + sum_of_wts + " array:" + W);

			var res : ArrayX = new ArrayX();
			var count : Number = 1000;
		   
			while(res.length < count) {
				var passes : Boolean = false;
				////////////evaluate /////////////
				while(!passes) {
					var R : Number = Math.random() * sum_of_wts;
					//    trace("threshold "+ R + "-----------");
					for(var k : Number = 0;k < W.length; k++) {
						var cr : Number = W[k];
						if (R <= cr) {
							//trace("adding " + a[k]);
							res.push(a[k]);
							passes = true;
							break;
						} else {
							   // 	trace("not adding " + a[k]); 
							}
					}
				}   
			}
			///////////REVIEW HOW WELL THE FUNCTION DID ///////////////
			trace(" res " + res);
			res.sort();
			var stat : Object = new Object();
			for (var l : Number = 0;l < res.length; l++) {
				var ci : String = res[l];
				if(stat[ci] == null) {
					stat[ci] = 1;
				}else {
					stat[ci]++;
				}
			}
			for(var j:String in stat) {
				var cn : Number = stat[j];
				trace(j + " found " + cn + " total of " + res.length + " = " + cn / res.length * 100 + " %");
			}
			return true;
		}

		/*	public function test_2DArray() : Boolean{

		var a : ArrayX = new ArrayX("A","B", "C");
		for(var i in a){
		trace(" k:'" + i + "' = v:'" +  a[i]+"'");
		}
		var a2D : Array2D = new Array2D( [1,2,3],[4,5,6],[7,8,9]);
		//	trace(util.Trace.me(a2D, " 2D array ", true));
		trace(" a2D lenght " + a2D.length + " " + a2D.getItem(2,2) + " " + a2D[2][2]);

		return true;
		}*/

		public function test_ArrayX_filterNone() : Boolean {
			var a1 : ArrayX = new ArrayX("A", "B", "C");
			var f1 : ArrayX = a1.getFilteredSet(null, null, null, null);
			var passFilter : Boolean = (f1.toString() == "A,B,C");
			trace(" passFilterNone " + passFilter);
			trace(" filtered  is " + f1);
			return passFilter;
		}

		public function test_ArrayX_filterOne() : Boolean {
			var a1 : ArrayX = new ArrayX("A", "B", "C");
			var f1 : ArrayX = a1.getFilteredSet(null, null, ["A"]);
			var passFilter : Boolean = (f1.toString() == "B,C");
			trace(" passFilterOne " + passFilter);
			trace(" filtered  is " + f1);
			return passFilter;
		}

		public function test_ArrayX_filterAll() : Boolean {
			var a1 : ArrayX = new ArrayX("A", "B", "C");
			var f1 : ArrayX = a1.getFilteredSet(null, null, ["A", "B", "C"]);
			var passFilter : Boolean = (f1.toString() == "");
			trace(" passFilterAll " + passFilter);
			trace(" filtered not is " + f1);
			return passFilter;
		}

		///////////////////////Filter To ] /////////////////////
		public function test_ArrayX_filterNoneTo() : Boolean {
			var a1 : ArrayX = new ArrayX("A", "B", "C");
			var f1 : ArrayX = a1.getFilteredSet(0, 1, null, null);
			var passFilter : Boolean = (f1.toString() == "A");
			trace(" passFilterNone " + passFilter);
			trace("filtered not is " + f1);
			return passFilter;
		}

		public function test_ArrayX_filterOneTo() : Boolean {
			var a1 : ArrayX = new ArrayX("A", "B", "C");
			var f1 : ArrayX = a1.getFilteredSet(0, 1, null, ["A"]);
			var passFilter : Boolean = (f1.toString() == "A");
			trace(" test_ArrayX_filterOneFrom " + passFilter);
			trace("filtered not is " + f1);
			return passFilter;
		}

		public function test_ArrayX_filterAllTo() : Boolean {
			var a1 : ArrayX = new ArrayX("A", "B", "C");
			var f1 : ArrayX = a1.getFilteredSet(0, 1, ["A", "B", "C"]);
			var passFilter : Boolean = (f1.toString() == "");
			trace(" passFilterAll " + passFilter);
			trace("filtered not is " + f1);
			return true;
		}

		//////////////////////Filter from [---//////////////////////
		public function test_ArrayX_filterNoneFrom() : Boolean {
			var a1 : ArrayX = new ArrayX("A", "B", "C");
			var f1 : ArrayX = a1.getFilteredSet(2, null, null, null);
			var passFilter : Boolean = (f1.toString() == "C");
			trace(" passFilterNone " + passFilter);
			trace("filtered not is " + f1);
			return passFilter;
		}

		public function test_ArrayX_filterOneFrom() : Boolean {
			var a1 : ArrayX = new ArrayX("A", "B", "C");
			var f1 : ArrayX = a1.getFilteredSet(2, null, ["A"]);
			var passFilter : Boolean = (f1.toString() == "C");
			trace(" test_ArrayX_filterOneFrom " + passFilter);
			trace("filtered not is " + f1);
			return passFilter;
		}

		public function test_ArrayX_filterAllFrom() : Boolean {
			var a1 : ArrayX = new ArrayX("A", "B", "C");
			var f1 : ArrayX = a1.getFilteredSet(2, null, ["A", "B", "C"]);
			var passFilter : Boolean = (f1.toString() == "");
			trace(" passFilterAll " + passFilter);
			trace("filtered not is " + f1);
			return passFilter;
		}

		public function test_ArrayX_concatEmpty() : Boolean {
			var a1 : ArrayX = new ArrayX("A", "B", "C");
			var b1 : ArrayX = ArrayX(a1.concat());
			var passFilter : Boolean = (b1.toString() == "A,B,C");
			trace(" pass concat " + passFilter);
			trace("  concat is " + b1);
			return passFilter;
		}

		public function test_ArrayX_concatOne() : Boolean {
			var a1 : ArrayX = new ArrayX("A", "B", "C");
			var b1 : ArrayX = ArrayX(a1.concat("D"));
			var passFilter : Boolean = (b1.toString() == "A,B,C,D");
			trace(" pass concat " + passFilter);
			trace("  concat is " + b1);
			return passFilter;
		}

		public function test_ArrayX_concatMany() : Boolean {
			var a1 : ArrayX = new ArrayX("A", "B", "C");
			var b1 : ArrayX = ArrayX(a1.concat(["D","E","F"]));
			var passFilter : Boolean = (b1.toString() == "A,B,C,D,E,F");
			trace("  pass concat " + passFilter);
			trace("  concat is " + b1);
			return passFilter;
		}

		public function test_ArrayX_appendArray() : Boolean {
			var a1 : ArrayX = new ArrayX("A", "B", "C");
			a1.appendArray(["D","E","F"]);
			var passFilter : Boolean = (a1.toString() == "A,B,C,D,E,F");
			trace("  pass appendArray: " + passFilter);
			trace("  res is " + a1);
			return passFilter;
		}

		public function test_ArrayX_unshift() : Boolean {
			var a1 : ArrayX = new ArrayX("A", "B", "C");
			a1.unshift(0);
			var passFilter : Boolean = (a1.toString() == "0,A,B,C");
			trace("  pass unshift: " + passFilter);
			trace("  res is " + a1);
			return passFilter;
		}	

		public function test_ArrayX_push() : Boolean {
			var a1 : ArrayX = new ArrayX("A", "B", "C");
			var r : Number = a1.push("D", "E");
			var passFilter : Boolean = (a1.toString() == "A,B,C,D,E") && r == 5;
			trace("  pass push: " + passFilter);
			trace("  res is " + a1 + " r " + r);
			return passFilter;
		}	

		public function test_ArrayX_pop() : Boolean {
			var a1 : ArrayX = new ArrayX("A", "B", "C");
			var r : Object = a1.pop();
			var passFilter : Boolean = (a1.toString() == "A,B" && r == "C");
			trace("  pass pop: " + passFilter);
			trace("  res is " + a1 + " returned " + r);
			return passFilter;
		}	

		public function test_ArrayX_shift() : Boolean {
			var a1 : ArrayX = new ArrayX("A", "B", "C");
			var r : Object = a1.shift();
			var passFilter : Boolean = (a1.toString() == "B,C" && r == "A");
			trace("  pass shift: " + passFilter);
			trace("  res is " + a1 + " returned " + r);
			return passFilter;
		}	
	}
}