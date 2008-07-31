package com.troyworks.data { 

	/**
	 * For 1 to 3 dimensions return the combinations possible
	 * use in conjunction with the permutator class
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
		public var possibilities : ArrayX;

		public function Combinator(d1 : Array, d2 : Array, d3 : Array = null) {
			possibilities = new ArrayX();
			for (var i : Number = 0;i < d1.length; i++) {
				var cx:Object = d1[i];
				if(d2 != null) {
					for (var j : Number = 0;j < d2.length; j++) {
						var cy:Object = d2[j];
						if(d3 != null) {
							for (var k : Number = 0;k < d3.length; k++) {
								var cz:Object = d3[k];
								trace(" " + i + "," + j + "," + k + " : " + cx + " + " + cy + " + " + cz);
								possibilities.push(new ArrayX(cx, cy, cz));
							}
						}else {
							trace(" " + i + "," + j + " : " + cx + " + " + cy);
							possibilities.push(new ArrayX(cx, cy));
						}				
					}
				}else {
					trace(" i " + i + " cx " + cx);
					possibilities.push(new ArrayX(cx));
				}
			}
		}
	}
}