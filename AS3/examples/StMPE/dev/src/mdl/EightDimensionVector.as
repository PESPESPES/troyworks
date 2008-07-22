package mdl {

	/**
	 * @author Troy Gardner
	 */
	public class EightDimensionVector {
		public var d1 : Number;
		public var d2 : Number;
		public var d3 : Number;
		public var d4 : Number;
		public var d5 : Number;
		public var d6 : Number;
		public var d7 : Number;
		public var d8 : Number;

		public var name : String;

		public function EightDimensionVector(d1 : Number = 0,d2 : Number = 0,d3 : Number = 0,d4 : Number = 0,d5 : Number = 0,d6 : Number = 0,d7 : Number = 0,d8 : Number = 0, name : String = "unnamed") : void {
			this.d1 = d1;
			this.d2 = d2;
			this.d3 = d3;
			this.d4 = d4;
			this.d5 = d5;
			this.d6 = d6;
			this.d7 = d7;
			this.d8 = d8;
			this.name = name;
		}
		public function length():Number{
			return getDotProductFromVector(this);
		}
		public function getDotProductFromVector(v : EightDimensionVector, traceOn : Boolean = true) : Number {
			if(v == null) {
				throw new Error("dot product vector cannot be null");
			}
			var res : Number = (d1 * v.d1) + (d2 * v.d2) + (d3 * v.d3) + (d4 * v.d4) + (d5 * v.d5) + (d6 * v.d6) + (d7 * v.d7) + (d8 * v.d8);
			/*dot.v
			0 0
			-1 1
			0 0
			1 0
			0 0
			0 0
			0 0
			0 0*/
			if(traceOn) {
				trace(name + ".getDotProductFrom(" + v.name + ")");
				trace(d1 + " " + v.d1);
				trace(d2 + " " + v.d2);
				trace(d3 + " " + v.d3);
				trace(d4 + " " + v.d4);
				trace(d5 + " " + v.d5);
				trace(d6 + " " + v.d6);
				trace(d7 + " " + v.d7);
				trace(d8 + " " + v.d8);
				trace(" res:::::::::::::: " + res);
			}
			return res;
		}

		public function limit() : void {
			this.d1 = Math.max(Math.min(d1, 1), -1);
			this.d2 = Math.max(Math.min(d2, 1), -1);
			this.d3 = Math.max(Math.min(d3, 1), -1);
			this.d4 = Math.max(Math.min(d4, 1), -1);
			this.d5 = Math.max(Math.min(d5, 1), -1);
			this.d6 = Math.max(Math.min(d6, 1), -1);
			this.d7 = Math.max(Math.min(d7, 1), -1);
			this.d8 = Math.max(Math.min(d8, 1), -1);
		}
		public function multiply(val:Number):void{
			this.d1 *=val;
			this.d2 *=val;
			this.d3 *=val;
			this.d4 *=val;
			this.d5 *=val;
			this.d6 *=val;
			this.d7 *=val;
			this.d8 *=val;
		}

		public function getNormalized() : EightDimensionVector {
			var dotSelf : Number = this.getDotProductFromVector(this, false);
			//trace("dotSelf " + dotSelf);
			var g1 : EightDimensionVector = new EightDimensionVector();
			g1.name = name;
			if(dotSelf == 0) {
				trace("ERROR zero length");
				return null;
			}
			//	trace("dotSelf " + dotSelf);
			var sqrtG : Number = Math.sqrt(dotSelf);
//			trace("sqrtG " + sqrtG);
			/*			g1.d1 = Math.max(-1, Math.min(1, d1 / sqrtG));
			g1.d2 = Math.max(-1, Math.min(1, d2 / sqrtG));
			g1.d3 = Math.max(-1, Math.min(1, d3 / sqrtG));
			g1.d4 = Math.max(-1, Math.min(1, d4 / sqrtG));
			g1.d5 = Math.max(-1, Math.min(1, d5 / sqrtG));
			g1.d6 = Math.max(-1, Math.min(1, d6 / sqrtG));
			g1.d7 = Math.max(-1, Math.min(1, d7 / sqrtG));
			g1.d8 = Math.max(-1, Math.min(1, d8 / sqrtG));
			 */		
			g1.d1 = d1 / sqrtG;
			g1.d2 = d2 / sqrtG;
			g1.d3 = d3 / sqrtG;
			g1.d4 = d4 / sqrtG;
			g1.d5 = d5 / sqrtG;
			g1.d6 = d6 / sqrtG;
			g1.d7 = d7 / sqrtG;
			g1.d8 = d8 / sqrtG;
			return g1;
		}
		public function clone():EightDimensionVector{
			var res:EightDimensionVector = new EightDimensionVector();
				res.d1 = Number(d1);
			res.d2 = Number(d2);
			res.d3 = Number(d3);
			res.d4 = Number(d4);
			res.d5 = Number(d5);
			res.d6 = Number(d6);
			res.d7 = Number(d7);
			res.d8 = Number(d8);
			res.name = String(name);
			return res;
			
		}
		public function toString() : String {
			var ary : Array = [d1,d2,d3,d4,d5,d6,d7,d8];
			var res : String = "[" + ary.join(",") + "]";
			return res; 
		}
	}
}
