package com.troyworks.data { 
	/**
	 * This is a utility class to work with a given array, primarily 
	 * to weight getting a random item, e.g. in games make some characters/rewards 
	 * appear more often than others.
	 * 
	 * This is a bin/quantized approach, the  values can be whatever to whatever.
	 * 
	 * 
	 * A useful approach is setting the weights via an equasion (e.g. an easing equasion)
	 * with the number of entries as samples
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
	 * //B found 331 total of 1000 = 33.1 % (desired 30%)
	 * //C found 78 total of 1000 = 7.8 %  (desired 10%)
	 * @author Troy Gardner
	 */
	public class ArrayWeighting extends Object {
		// Collection 
		public var c : Array;
		public var sum_of_wts : Number = 0;
		// Weights
		protected var W : Array;
	
		public function ArrayWeighting() {
			super();
		}
		public function setWeights(wts : Array) : void{
			W = new Array();
			sum_of_wts = 0;
			for (var i : Number = 0; i < wts.length; i++) {
				trace("sum of wts1 " + sum_of_wts);
				sum_of_wts = sum_of_wts +  wts[i];
				trace("sum of wts2 " + sum_of_wts);
				W[i] = sum_of_wts;
			}
			trace("sum_of_wts " + sum_of_wts + "  array:" + W);
		}
		/*****************************************
		 * for a given bunch of elements, e.g. A, B,C
		 * and a given bunch of weightws e. 60, 30, 10
		 * get a random one that matches the approximate
		 * distrubtion of the weights.
		 */
		public function getWeightedRandom(source : Array, quantity : Number = 1) : ArrayX{
	
			var a : Array = (source == null)?c:source;
			var res : ArrayX = new ArrayX();
	
			while(res.length < quantity){
				var passes : Boolean = false;		
			    ////////////evaluate /////////////
			    while(!passes){
					var R : Number = Math.random()* sum_of_wts;
					//    trace("threshold "+ R + "-----------");
					for(var i:int = 0; i< W.length; i++){
						var cr:Number = W[i];
					        if (R <= cr){
							trace("adding " + a[i]);
							res.push(a[i]);
							passes = true;
	
							break;
					        } else {
							trace("not adding " + a[i]); 
					        }
	        	 		}
		        }
			}
			return res;   
		}
	
	}
}