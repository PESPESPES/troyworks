package com.troyworks.ui { 
	/**
	 * @author Troy Gardner
	 */
	public class BoundsRelationship extends Number {
		public static var ARE_NOT_TOUCHING : Number = 0;
		public static var OVERLAPPING : Number = 1;
		public static var CONTAINS : Number = 2;
		public static var IS_CONTAINEDBY : Number = 4;
		//////////// NOT OVERLAPPING //////////////////
		public static var LEFT_OF : Number = 8;
		public static var RIGHT_OF : Number = 16;
		public static var ABOVE_OF : Number = 32;
		public static var BELOW_OF : Number = 64;
		////////// OVERLAPPING ///////////////////////
		public static var ON_LEFT_SIDE_OF : Number = 128;
		public static var ON_RIGHT_SIDE_OF : Number = 256;
		public static var ON_TOP_SIDE_OF : Number = 512;
		public static var ON_BOTTOM_SIDE_OF : Number = 1024;
		
		public function BoundsRelationship(val : Number) {
					super (val);
		}
	
		public function get isOverlapping():Boolean{
		//	trace(this + " " + OVERLAPPING);
			return (this & OVERLAPPING)>0;
		}
	
		public function get isLeftOf():Boolean{
			//trace(this + " " + LEFT_OF);
			return (this & LEFT_OF)>0;
		}
	
		public function get isRightOf():Boolean{
		//	trace(this + " " + RIGHT_OF);
			return (this & RIGHT_OF)>0;
		}
	
		public function get isAboveOf():Boolean{
			//trace(this + " " + ABOVE_OF);
			return (this & ABOVE_OF)>0;
		}
	
		public function get isBelowOf():Boolean{
			//trace(this + " " + BELOW_OF);
			return (this & BELOW_OF)>0;
		}
		public function get isOnLeftSideOf():Boolean{
			//trace(this + " " + LEFT_OF);
			return (this & ON_LEFT_SIDE_OF)>0;
		}
	
		public function get isOnRightSideOf():Boolean{
		//	trace(this + " " + RIGHT_OF);
			return (this & ON_RIGHT_SIDE_OF)>0;
		}
	
		public function get isOnTopSideOf():Boolean{
			//trace(this + " " + ABOVE_OF);
			return (this & ON_TOP_SIDE_OF)>0;
		}
	
		public function get isOnBottomSideOf():Boolean{
			//trace(this + " " + BELOW_OF);
			return (this & ON_BOTTOM_SIDE_OF)>0;
		}
	}
}