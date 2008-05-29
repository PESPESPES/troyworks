package com.troyworks.util.datetime { 
	import com.troyworks.datastructures.enums.TypedNumericEnumeration;
	
	/**
	 * This is used for masking valid date operations.
	 * e.g. if working on a calendar and only displaying dates, the hour/minute etc aren't relevant
	 * so shouldn't be included.
	 * 
	 * @author Troy Gardner
	 */
	public class TDateEnum extends TypedNumericEnumeration {
		public static var MILLISECOND : TDateEnum = new TDateEnum(0, "MILLISECOND");
		public static var SECOND : TDateEnum = new TDateEnum(1, "SECOND");
		public static var MINUTE : TDateEnum = new TDateEnum(2, "MINUTE");
		public static var HOUR : TDateEnum = new TDateEnum(4, "HOUR");
		
		public static var DAY : TDateEnum = new TDateEnum(8, "DAY");
		public static var WEEK : TDateEnum = new TDateEnum(16, "WEEK");
		public static var MONTH : TDateEnum = new TDateEnum(32, "MONTH");
		public static var YEAR : TDateEnum = new TDateEnum(64, "YEAR");
		
		public static var ALL : TDateEnum = new TDateEnum(MILLISECOND|SECOND|MINUTE |HOUR | DAY | WEEK | MONTH | YEAR, "ALL");
		
		
		public function TDateEnum(val : Number, name : String) {
			super(val, name);
		}
	
	}
}