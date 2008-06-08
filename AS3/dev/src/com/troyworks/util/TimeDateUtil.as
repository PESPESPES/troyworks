package com.troyworks.util { 
	/*
	A utility for comparing two times and creating duration based on milisecond resolution.
	duration can be quantized to some units of calendar time eg. year, minute second.
	these durations are immune to changes in calendar time, 
	e.g. daylight savings, 
	changing over days
	
	but can be converted to calendar time via adding to some relative point in Calendar time
	e.g. 1970, 1900.
	 * 
	 * Note that moving in time by milliseconds, when cast back into Calendar time may not 
	 * be quite the place intended due to things like Leap year, speed of light etc ;) 
	*/
	public class TimeDateUtil {
		public static const oneSecond:Number = 1000;
		public static const oneMinute:Number = 60*TimeDateUtil.oneSecond;
		// milliseconds in a minute
		public static const oneHour:Number = TimeDateUtil.oneMinute*60;
		public static const oneDay:Number = TimeDateUtil.oneHour*24;
		public static const oneWeek:Number = TimeDateUtil.oneDay*7;
		public static const oneMonth:Number = TimeDateUtil.oneWeek*4;
		public static const oneAveMonth:Number = 365/12*TimeDateUtil.oneDay;
		public static const oneQuarter:Number = 365*TimeDateUtil.oneDay/4;
		public static const oneYear:Number = 365*TimeDateUtil.oneDay;
		private var _msRelative:Number;
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
		public function TimeDateUtil(relativeTimeMS:Number = 0) {
			_msRelative = relativeTimeMS;
		}
		public static function parseRelativeTime(dateTime : Number) : TimeDateUtil{
			var r : Number = dateTime;
			var res:TimeDateUtil = new TimeDateUtil();

			if(r > oneYear){
				res.a_year = Math.floor(r/TimeDateUtil.oneYear);
				r = r & TimeDateUtil.oneYear;
			}else{
				res.a_year = 0;
			}
			if(r > oneMonth){
				res.a_month = Math.floor(r/TimeDateUtil.oneMonth);
				r = r & TimeDateUtil.oneMonth;
			}else{
				res.a_month = 0;
			}
			if(r > oneDay){	
				res.a_day = Math.floor(r/TimeDateUtil.oneDay);
				r = r & TimeDateUtil.oneDay;
			}else{
				res.a_day = 0;
			}

			///////////////////////////////////////////
			if(r > oneHour){	
				res.a_hour = Math.floor(r/TimeDateUtil.oneHour);
				r = r % TimeDateUtil.oneHour;	
			}else{
				res.a_hour = 0;
			}

			if(r > oneMinute){	
				res.a_minute = Math.floor(r/TimeDateUtil.oneMinute);
				r = r % TimeDateUtil.oneMinute;
			}else{
				res.a_minute = 0;
			}

			if(r > oneSecond){
				res.a_seconds = Math.floor(r/TimeDateUtil.oneSecond);
				r = r % TimeDateUtil.oneSecond;
			}else{
				res.a_seconds = 0;
			}

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
		public static function getNumberSuffix(num : Number) : String{
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
		public function toStopWatchString() : String{
			var res:TimeDateUtil = TimeDateUtil.parseRelativeTime(_msRelative);
			return padTo(res.a_minute,2,"0")+":"+ padTo(res.a_seconds,2,"0");
		}

		public function toClockString() : String{
			var res:TimeDateUtil = TimeDateUtil.parseRelativeTime(_msRelative);
			return res.a_hour +":"+ res.a_minute+":"+ res.a_seconds;
		}
		public function toString() : String{
			var res:TimeDateUtil = TimeDateUtil.parseRelativeTime(_msRelative);
			return res.a_hour +":"+ res.a_minute+":"+ res.a_seconds+"."+ res.a_milliseconds;
		}
	
		public static function formatToString(val : Number) : String{
			var res:TimeDateUtil = TimeDateUtil.parseRelativeTime(val);
			return res.a_hour +":"+ res.a_minute+":"+ res.a_seconds+"."+ res.a_milliseconds;
		}
	}
	
}