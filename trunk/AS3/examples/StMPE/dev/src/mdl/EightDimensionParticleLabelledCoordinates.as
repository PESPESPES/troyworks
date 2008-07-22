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
	}
}
