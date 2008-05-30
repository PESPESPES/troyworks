package com.troyworks.data.constraints {
	import com.troyworks.data.constraints.Constraint;
	
	/**
	 * @author Troy Gardner
	 */
	public class NumberConstraint extends Constraint {
		var grid:Number = 1;
		var gridOffset:Number = 0;
		
		public var min:Number =0;
		public var max:Number = 0;
		
		public function NumberConstraint() {
		}
		public static function passUnchanged(val:Number):Number{
			return val;
		}
		public static function round(val:Number):Number{
			return Math.round(val);
		}
		public function toGrid(val:Number):Number{
			return gridOffset + (grid*Math.round(val/grid));
		}

		
	}
}
