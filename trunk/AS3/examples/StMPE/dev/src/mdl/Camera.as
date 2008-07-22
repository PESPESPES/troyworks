package mdl{
	import com.troyworks.data.ConstrainedNumber;

	/**
	 * @author Troy Gardner
	 */
	public class Camera extends EightDimensionParticle {
		public var focalLength : Number = 300;
		public var vpX : Number = 0;
		public var vpY : Number = 0;
		public var vpZ : Number = 0;
		
		public var V : EightDimensionVector = new EightDimensionVector();
		public var H : EightDimensionVector = new EightDimensionVector();

		public var rotationD1 : ConstrainedNumber = ConstrainedNumber.get0To360();
		public var rotationD2 : ConstrainedNumber = ConstrainedNumber.get0To360();
		public var rotationD3 : ConstrainedNumber = ConstrainedNumber.get0To360();
		public var rotationD4 : ConstrainedNumber = ConstrainedNumber.get0To360();
		public var rotationD5 : ConstrainedNumber = ConstrainedNumber.get0To360();
		public var rotationD6 : ConstrainedNumber = ConstrainedNumber.get0To360();
		public var rotationD7 : ConstrainedNumber = ConstrainedNumber.get0To360();
		public var rotationD8: ConstrainedNumber = ConstrainedNumber.get0To360();

		public function Camera() {
			super();
			V.d1 = 1;
			V.name = "V";
			H.d2 = 2;
			H.name = "H";
		}
		
		public function set rotationX(val : Number) : void {
		//	trace(mdl.curXaxis + " setX " + val);
			setRotate(modl.curXaxis, val);
		}

		public function get rotationX() : Number {
			return getRotate(modl.curXaxis);
		}
		public function set rotationY(val : Number) : void {
		//	trace(mdl.curYaxis + " setY " + val);
			setRotate(modl.curYaxis, val);
		}

		public function get rotationY() : Number {
			return getRotate(modl.curYaxis);
		}
		public function set rotationZ(val : Number) : void {
		//	trace(mdl.curZaxis + " setZ " + val);
			setRotate(modl.curZaxis, val);
		}

		public function get rotationZ() : Number {
			return getRotate(modl.curZaxis);
		}
		
		private function getRotate(dim:Dimension):Number{
				switch(dim) {
				case Dimension.D1:
					return rotationD1.value;
				case Dimension.D2:
					return rotationD2.value;
				case Dimension.D3:
					return rotationD3.value;
				case Dimension.D4:
					return rotationD4.value;
				case Dimension.D5:
					return rotationD5.value;
				case Dimension.D6:
					return rotationD6.value;
				case Dimension.D7:
					return rotationD7.value;
				case Dimension.D8:
					return rotationD8.value;
			}
			return 0;
		}
		private function setRotate(dim:Dimension, val:Number):void{
			switch(dim) {
				case Dimension.D1:
					rotationD1.setTo(val);
					break;
				case Dimension.D2:
					rotationD2.setTo(val);
					break;
				case Dimension.D3:
					rotationD3.setTo(val);
					break;
				case Dimension.D4:
					rotationD4.setTo(val);
					break;
				case Dimension.D5:
					rotationD5.setTo(val);
					break;
				case Dimension.D6:
					rotationD6.setTo(val);
					break;
				case Dimension.D7:
					rotationD7.setTo(val);
					break;
				case Dimension.D8:
					rotationD8.setTo(val);
					break;
			}
		}
	}
}
