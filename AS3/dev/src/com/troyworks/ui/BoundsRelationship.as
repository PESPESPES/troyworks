package com.troyworks.ui {
	import flash.geom.Rectangle; 

	/**
	 * @author Troy Gardner
	 */
	public class BoundsRelationship extends Object {
		private var val:uint = 0;
		public var intersectionBounds:Rectangle;
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
		
		public function BoundsRelationship(val : uint) {
					super ();
					this.val = val;
		}
	
		public function get isOverlapping():Boolean{
		//	trace(this + " " + OVERLAPPING);
			return (val & OVERLAPPING)>0;
		}
	
		public function get isLeftOf():Boolean{
			//trace(val + " " + LEFT_OF);
			return (val & LEFT_OF)>0;
		}
	
		public function get isRightOf():Boolean{
		//	trace(val + " " + RIGHT_OF);
			return (val & RIGHT_OF)>0;
		}
	
		public function get isAboveOf():Boolean{
			//trace(val + " " + ABOVE_OF);
			return (val & ABOVE_OF)>0;
		}
	
		public function get isBelowOf():Boolean{
			//trace(val + " " + BELOW_OF);
			return (val & BELOW_OF)>0;
		}
		public function get isOnLeftSideOf():Boolean{
			//trace(val + " " + LEFT_OF);
			return (val & ON_LEFT_SIDE_OF)>0;
		}
	
		public function get isOnRightSideOf():Boolean{
		//	trace(val + " " + RIGHT_OF);
			return (val & ON_RIGHT_SIDE_OF)>0;
		}
	
		public function get isOnTopSideOf():Boolean{
			//trace(val + " " + ABOVE_OF);
			return (val & ON_TOP_SIDE_OF)>0;
		}
	
		public function get isOnBottomSideOf():Boolean{
			//trace(val + " " + BELOW_OF);
			return (val & ON_BOTTOM_SIDE_OF) > 0;
		}
		
		public function setFlags(resF : Number) : void {
			val = resF;
		}
	}
}