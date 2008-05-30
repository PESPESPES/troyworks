package com.troyworks.data.constraints {

	/**
	 * @author Troy Gardner
	 */
	public class Constraint {
		public static function passUnchanged(val:Object):Object{
			return val;
		}
		public static function round(val:Number):Number{
			return Math.round(val);
		}
		
	}
}
