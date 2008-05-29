package com.troyworks.util.datetime { 
	/**
	 * This is used on conjunction with the TDate class to peform 
	 * math operations, like 
	 * targetdate = date + 1 years, 2 months + 2 seconds;
	 * 
	 * and also acts as measurements of differences e.g. Date1 - date2 = timeMeasurement.
	 * 
	 * TODO create methods to protect and set months to integer
	 * TODO create methods to convert from the milliseconds to anthing else, e.g. X millisoeconds is 1 year, 2 days, or 1.02 years.
	 * 
	 * @author Troy Gardner
	 */
	public class TDateTimeMeasurement {
		public var years : Number = 0;
		public var months : Number = 0;
		public var days : Number = 0;
		public var 	hour : Number = 0;
		public var  min : Number = 0;
		public var  sec : Number = 0;
		public var  ms : Number = 0;
		
	}
}