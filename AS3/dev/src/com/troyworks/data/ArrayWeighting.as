package com.troyworks.data { 

	/**
	 * This is a utility class to work with a given array, primarily 
	 * to weight getting a random item, e.g. in games make some characters/rewards 
	 * appear more often than others.
	 * 
	 * It also offers some utilities to adjust the values of weights. 
	 * 
	 * The metaphor is that the array passed in is a type of particle.
	 * Each position in the array is a bin the values can be whatever.
	 * e.g.
	 * 
	 * 0= "A"
	 * 1= "B"
	 * 2 ="C"
	 * 
	 * A second array is created to act as the distribution for those values. They can be whatever
	 * numeric value, the function will normalize the range prior .
	 * 
	 * 
	 * The weightings act like a valve/gate, controls how frequently one of the particles are emitted.
	 * Like an stereo equalizer, the valves can be animated, over the progression of the application
	 * to create different effects.
	 * 
	 * A useful approach is setting the weights via an equasion (e.g. an easing equasion)
	 *
	 * This beats the RandomizedPlayList approach for many things, as frequently we want to 
	 * have some things more frequent than others, rather than just purely something we can't
	 * predict. 
	 *
	 *
	 *  
	 *  
	 * EXAMPLE
	 * 		var a : ArrayX = new ArrayX("A","B", "C");
	var wts : Array = new Array(60, 30, 10);
	var weightor:ArrayWeighting = new ArrayWeighting();
	weightor.c = a;
	weightor.setWeights(wts);
	var res:ArrayX = weightor.getWeightedRandom(null, 1000);
	// NOTE percentages are approximate, there is some random variation.		 
	//A found 591 total of 1000 = 59.1 % (desired 60%)
	 * 		//B found 331 total of 1000 = 33.1 % (desired 30%)
	 * 		//C found 78 total of 1000 = 7.8 %  (desired 10%)
	 * @author Troy Gardner
	 */
	public class ArrayWeighting extends Object {
		// Collection 
		public var c : Array;
		public var sum_of_wts : Number = 0;
		// Weights
		protected var W : Array;

		protected var wts : Array;

		public var allowImmediateRepeats : Boolean = false;
		protected var lastR : Number = 0;

		
		public function ArrayWeighting() {
			super();
		}

		public function set array(ary : Array) : void {
			c = ary;
		}

		public function get array() : Array {
			return c;
		}

		public function getWeights() : Array {
			return wts;	
		}

		public function setWeights(wts : Array) : void {
			
			this.wts = wts;
			W = new Array();
			sum_of_wts = 0;
			for (var i : Number = 0;i < wts.length; i++) {
				trace("sum of wts1 " + sum_of_wts);
				sum_of_wts = sum_of_wts + wts[i];
				trace("sum of wts2 " + sum_of_wts);
				W[i] = sum_of_wts;
			}
		//	trace("sum_of_wts " + sum_of_wts + "  array:" + W);
		}

		public function multiplyWeightsBy(val : Number = 1, startIdx : Number = 0, upperIdx : Number = NaN) : void {
			var i : int = startIdx;
			var n : int = isNaN(upperIdx) ? wts.length : upperIdx;
				
			for (;i < n; ++i) {
				wts[i] *= val;
			}
				
			setWeights(wts);
		}

		public function divideWeightsBy(val : Number = 1, startIdx : Number = 0, upperIdx : Number = NaN) : void {
			var i : int = startIdx;
			var n : int = isNaN(upperIdx) ? wts.length : upperIdx;
				
			for (;i < n; ++i) {
				wts[i] /= val;
			}
				
			setWeights(wts);
		}

		public function addToWeights(val : Number = 1, startIdx : Number = 0, upperIdx : Number = NaN) : void {
			var i : int = startIdx;
			var n : int = isNaN(upperIdx) ? wts.length : upperIdx;
				
			for (;i < n; ++i) {
				wts[i] += val;
			}
				
			setWeights(wts);
		}

		public function subtractFromWeights(val : Number = 1, startIdx : Number = 0, upperIdx : Number = NaN) : void {
			var i : int = startIdx;
			var n : int = isNaN(upperIdx) ? wts.length : upperIdx;
				
			for (;i < n; ++i) {
				wts[i] -= val;
			}
				
			setWeights(wts);
		}

		
		
		
		/*****************************************
		 * for a given bunch of elements, e.g. A, B,C
		 * and a given bunch of weightws e. 60, 30, 10
		 * get a random one that matches the approximate
		 * distrubtion of the weights.
		 */
		public function getWeightedRandom(overrideSource : Array = null, quantityToGenerate : Number = 1) : ArrayX {
	
			var a : Array = (overrideSource == null) ? c : overrideSource;
			var res : ArrayX = new ArrayX();
			var i : int = 0;
			var n : int = W.length; 
			while(res.length < quantityToGenerate) {
				var passes : Boolean = false;		
				////////////evaluate /////////////
				while(!passes) {
					var R : Number = Math.random() * sum_of_wts;
					// trace("threshold "+ R + "-----------");
					//for(var i : int = 0;i < W.length; i++) {
					i = 0;
					for (;i < n; ++i) {
						var cr : Number = W[i];
						if (R <= cr) {
							
							if(!allowImmediateRepeats && (lastR == R)) {
							//	trace("skipping repeat");
							} else {
								//	trace("adding " + a[i]);
								res.push(a[i]);
								lastR = R;
								passes = true;
								break;
							}
						} else {
						//	trace("not adding " + a[i]); 
						}
					}
				}
			}
			return res;   
		}

		public function toString(sample : Boolean = true) : String {
			var res : Array = new Array();
				
			res.push("ArrayWeighting: items " + c.length + " wts " + wts.length);
			var i : int = 0;
			var n : int = (sample) ? 5 : c.length;
				
			for (;i < n; ++i) {
				res.push("\r " + c[i] + " wt: " + wts[i]);
			}
			return res.join("\r");			
		}
	}
}