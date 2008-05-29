package com.troyworks.util { 
	/*
	A utility for comparing two times and c
	reating duration based on milisecond resolution.
	duration can be quantized to some units of calendar time eg. year, minute second.
	these durations are immune to changes in calendar time, 
	e.g. daylight savings, 
	changing over days
	
	but can be converted to calendar time via adding to some relative point in Calendar time
	e.g. 1970, 1900.
	*/
	public class TimeDateUtil extends Number {
		public static var oneSecond = 1000;
		public static var oneMinute = 60*TimeDateUtil.oneSecond;
		// milliseconds in a minute
		public static var oneHour = TimeDateUtil.oneMinute*60;
		public static var oneDay = TimeDateUtil.oneHour*24;
		public static var oneWeek = TimeDateUtil.oneDay*7;
		public static var oneMonth = TimeDateUtil.oneWeek*4;
		public static var oneAveMonth = 365/12*TimeDateUtil.oneDay;
		public static var oneQuarter = 365*TimeDateUtil.oneDay/4;
		public static var oneYear = 365*TimeDateUtil.oneDay;
		//////////////////////////
		public var a_milliseconds : Number;
		public var a_seconds : Number;
		public var a_minute : Number;
		public var a_hour : Number;
		public var a_day : Number;
		public var a_week : Number;
		public var a_month : Number;
		public var a_year : Number;
		
		public var milliseconds : Number;
		public var seconds : Number;
		public var minute : Number;
		public var hour : Number;
		public var day : Number;
		public var week : Number;
		public var month : Number;
		public var year : Number;	
		/////
		//dateformat
		public function TimeDateUtil() {
		}
		public static function formatDateTime(dateTime : Number, dateTimeFormat : Object) : TimeDateUtil{
			var r : Number = dateTime;
			var res = new TimeDateUtil();
			if(false){
				res.a_year = Math.floor(r/TimeDateUtil.oneYear);
				r = r & TimeDateUtil.oneYear;
				res.a_month = Math.floor(r/TimeDateUtil.oneMonth);
				r = r & TimeDateUtil.oneMonth;
				res.a_day = Math.floor(r/TimeDateUtil.oneDay);
				r = r & TimeDateUtil.oneDay;
			}
			///////////////////////////////////////////
			res.a_hour = Math.floor(r/TimeDateUtil.oneHour);
			r = r % TimeDateUtil.oneHour;
			res.a_minute = Math.floor(r/TimeDateUtil.oneMinute);
			r = r % TimeDateUtil.oneMinute;
			res.a_seconds = Math.floor(r/TimeDateUtil.oneSecond);
			r = r % TimeDateUtil.oneSecond;
			res.a_milliseconds = r;
			return res;
			
		}
		public static function padTo(number:Number, characters:Number, spacer:String):String{
			var res:Array = String(number).split('');
			if(res.length < characters){
				while(--characters){
					res.unshift(spacer);
				}
			}
			return res.join('');
		}
		//
	// PiXELWiT Number Suffix function.
	// Works with any positive whole number.
	// e.d. 13 -> 13th
	// e.g. 2 - 2nd
		public function getNumberSuffix(num : Number) : String{
			if(num == 0)
				return "";
			if(Math.floor(num/10)%10===1)
				return "th";
			num %= 10;
			if(num>3 || num===0)
					return "th";
			if(num===1)
					return "st";
			if(num===2)
					return "nd";
			//else
			return "rd";
	}
	//
		public function toString() : String{
			var res = TimeDateUtil.formatDateTime(this);
			return res.a_hour +":"+ res.a_minute+":"+ res.a_seconds+"."+ res.a_milliseconds;
		}
	
		public static function FormatToString(val : Number) : String{
			var res = TimeDateUtil.formatDateTime(val);
			return res.a_hour +":"+ res.a_minute+":"+ res.a_seconds+"."+ res.a_milliseconds;
		}
	}
	
}