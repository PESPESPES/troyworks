package mdl{

	/**
	 * @author Troy Gardner
	 */
	public class Dimension {
		public static  const d1UV : EightDimensionVector = new EightDimensionVector(1, 0, 0, 0, 0, 0, 0, 0, "d1UV");
		public static const d2UV : EightDimensionVector = new EightDimensionVector(0, 1, 0, 0, 0, 0, 0, 0, "d2UV");
		public static const d3UV : EightDimensionVector = new EightDimensionVector(0, 0, 1, 0, 0, 0, 0, 0, "d3UV");
		public static const d4UV : EightDimensionVector = new EightDimensionVector(0, 0, 0, 1, 0, 0, 0, 0, "d4UV");
		public static const d5UV : EightDimensionVector = new EightDimensionVector(0, 0, 0, 0, 1, 0, 0, 0, "d5UV");
		public static const d6UV : EightDimensionVector = new EightDimensionVector(0, 0, 0, 0, 0, 1, 0, 0, "d6UV");
		public static const d7UV : EightDimensionVector = new EightDimensionVector(0, 0, 0, 0, 0, 0, 1, 0, "d7UV");
		public static const d8UV : EightDimensionVector = new EightDimensionVector(0, 0, 0, 0, 0, 0, 0, 1, "d8UV");
		
		public static const D1 : Dimension = new Dimension(1, d1UV);
		public static const D2 : Dimension = new Dimension(2, d2UV);
		public static const D3 : Dimension = new Dimension(3, d3UV);
		public static const D4 : Dimension = new Dimension(4, d4UV);
		public static const D5 : Dimension = new Dimension(5, d5UV);
		public static const D6 : Dimension = new Dimension(6, d6UV);
		public static const D7 : Dimension = new Dimension(7, d7UV);
		public static const D8 : Dimension = new Dimension(8, d8UV);

		//which dimension (by number as an ID)
		private var d : int;
		//unit vector 
		public var uv : EightDimensionVector;
		public static const EIGHTD:Array = [d1UV, d2UV, d3UV,d4UV, d5UV, d6UV, d7UV, d8UV];
		public static const SIXD:Array = [d1UV, d2UV, d3UV,d4UV, d5UV, d6UV];
		public function Dimension(val : int = 0, unitV : EightDimensionVector = null) {
			d = val;
			uv = unitV;
		}
		public function toString():String{
			return "Dimension " + d;
		}
	}
}
