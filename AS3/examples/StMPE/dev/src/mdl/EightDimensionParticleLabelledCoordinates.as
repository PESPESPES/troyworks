package mdl {
	import mdl.EightDimensionVector;

	/**
	 * EightDimensionParticleLabelledCoordinates
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Jul 20, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class EightDimensionParticleLabelledCoordinates extends EightDimensionVector {
		public var d1Lbl : String;
		public var d2Lbl : String;
		public var d3Lbl : String;
		public var d4Lbl : String;
		public var d5Lbl : String;
		public var d6Lbl : String;
		public var d7Lbl : String;
		public var d8Lbl : String;

		public function EightDimensionParticleLabelledCoordinates(d1 : Number = 0, d2 : Number = 0, d3 : Number = 0, d4 : Number = 0, d5 : Number = 0, d6 : Number = 0, d7 : Number = 0, d8 : Number = 0, name : String = "unnamed") {
			super(d1, d2, d3, d4, d5, d6, d7, d8, name);
		}

		public function deepClone() : EightDimensionParticleLabelledCoordinates {
			var res : EightDimensionParticleLabelledCoordinates = new EightDimensionParticleLabelledCoordinates(d1, d2, d3, d4, d5, d6, d7, d8, name);
			
			res.d1Lbl = String(this.d1Lbl);
			res.d2Lbl = String(this.d2Lbl);
			res.d3Lbl = String(this.d3Lbl);
			res.d4Lbl = String(this.d4Lbl);
			res.d5Lbl = String(this.d5Lbl);
			res.d6Lbl = String(this.d6Lbl);
			res.d7Lbl = String(this.d7Lbl);
			res.d8Lbl = String(this.d8Lbl);
			return res;		
		}
	}
}
