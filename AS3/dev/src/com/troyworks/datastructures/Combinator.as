package com.troyworks.datastructures { 
	/**
	 * For 1 to 3 dimensions return the combinations possible
	 * use with the permutator class
	 * 
	 * CODE:
	 * 		var d1:Array = ["A","B","C"];
	 *		var d2:Array = [1,2,3];
			var d3:Array = null;//["x","y","z"];
			var cb = new Combinator(d1, d2, d3);
	* OUTPUT
	*   msg:  0,0 : A + 1
	*   msg:  0,1 : A + 2
	*   msg:  0,2 : A + 3
	*   msg:  1,0 : B + 1
	*   msg:  1,1 : B + 2
	*   msg:  1,2 : B + 3
	*   msg:  2,0 : C + 1
	*   msg:  2,1 : C + 2
	*   msg:  2,2 : C + 3 
	 * 
	 * @author Troy Gardner
	 */
	public class Combinator {
		public var d1 : Array;
		public var d2 : Array;
		public var d3:Array;
		public var possibilities : Array2;
		public function Combinator(d1 : Array, d2 : Array, d3 : Array) {
			possibilities = new Array2();
			for (var i : Number = 0; i < d1.length; i++) {
				var cx = d1[i];
				if(d2 != null){
					for (var j : Number = 0; j < d2.length; j++) {
						var cy = d2[j];
						if(d3 != null){
							for (var k : Number = 0; k < d3.length; k++) {
									var cz = d3[k];
									trace(" "+ i +","+j +","+k + " : " + cx + " + " + cy +" + " + cz);
									possibilities.push(new Array2(cx, cy, cz));
							}
						}else{
								trace(" "+ i +","+j + " : " + cx + " + " + cy);
								possibilities.push(new Array2(cx, cy));
						}				
					}
				}else{
					trace(" i " + i + " cx " + cx);
					possibilities.push(new Array2(cx));
				}
			}
		}
	}
}