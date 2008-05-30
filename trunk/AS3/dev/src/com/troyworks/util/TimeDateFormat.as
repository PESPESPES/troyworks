/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.util {

	public class TimeDateFormat {
		//////////////////////////
		public var show_milliseconds : Boolean = false;
		public var show_seconds : Boolean = false;
		public var show_minute : Boolean = false;
		public var show_hour : Boolean = false;
		public var show_day : Boolean = false;
		public var show_week : Boolean = false;
		public var show_month : Boolean = false;
		public var show_year : Boolean = false;
		public function TimeDateFormat() {
			
		}
		public static function getDefaultMinSec():TimeDateFormat{
			var res:TimeDateFormat = new TimeDateFormat();
			res.show_seconds = true;
			res.show_minute = true;
			return res;
		}
		
	}
	
}
