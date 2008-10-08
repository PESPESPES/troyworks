package com.troyworks.util {
	import flash.events.EventDispatcher;
	 
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
	public class TimeDateUtil extends EventDispatcher
	{
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
		private var a_millisecond : Number;
		private var a_second : Number;
		private var a_minute : Number;
		private var a_hour : Number;
		private var a_day : Number;
		private var a_week : Number;
		private var a_month : Number;
		private var a_year : Number;
		
//		public var milliseconds : Number;
//		public var seconds : Number;
//		public var minute : Number;
//		public var hour : Number;
//		public var day : Number;
//		public var week : Number;
//		public var month : Number;
//		public var year : Number;	
		/////
		//dateformat
		public function TimeDateUtil(relativeTimeMS:Number = 0) {
			_msRelative = relativeTimeMS;
		}
		public static function parseRelativeTime(dateTime : Number) : TimeDateUtil{
			var r : Number = dateTime;
			var res:TimeDateUtil = new TimeDateUtil(dateTime);

			if(r > oneYear){
				res.a_year = Math.floor(r/TimeDateUtil.oneYear);
				r = r % TimeDateUtil.oneYear;
			}else{
				res.a_year = 0;
			}
			if(r > oneMonth){
				res.a_month = Math.floor(r/TimeDateUtil.oneMonth);
				r = r % TimeDateUtil.oneMonth;
			}else{
				res.a_month = 0;
			}
			if(r > oneDay){	
				res.a_day = Math.floor(r/TimeDateUtil.oneDay);
				r = r % TimeDateUtil.oneDay;
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
				res.a_second = Math.floor(r/TimeDateUtil.oneSecond);
				r = r % TimeDateUtil.oneSecond;
			}else{
				res.a_second = 0;
			}

			res.a_millisecond = r;
			return res;
			
		}
		public static  function padTo(number:Number, characters:Number=3, spacer:String = "0"):String{
			var res:Array = String(number).split('');
			if(res.length < characters){
				var dif:int =   characters - res.length;
				while(dif--){
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
		public static function getNumberSuffix(num : Number) : String
		{
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
			return padTo(res.a_minute,2,"0")+":"+ padTo(res.a_second,2,"0");
		}
		
		public function toDateTimeString() : String{
			var res:TimeDateUtil = TimeDateUtil.parseRelativeTime(_msRelative);
			return res.a_year+"-"+padTo(res.a_month,2,"0")+"-"+padTo(res.a_day,2,"0")+" "+ 
			padTo(res.a_hour,2,"0")+":"+padTo(res.a_minute,2,"0")+":"+ padTo(res.a_second,2,"0");
		}
		
		public function toClockString() : String{
			var res:TimeDateUtil = TimeDateUtil.parseRelativeTime(_msRelative);
			return res.a_hour +":"+ res.a_minute+":"+ res.a_second;
		}
		
		override public function toString() : String{
			var res:TimeDateUtil = TimeDateUtil.parseRelativeTime(_msRelative);
			return res.a_hour +":"+ res.a_minute+":"+ res.a_second+"."+ res.a_millisecond;
		}
		
		public function getRelativeTimeMs():Number
		{
			return _msRelative;
		}
	
		public static function formatToString(val : Number) : String{
			var res:TimeDateUtil = TimeDateUtil.parseRelativeTime(val);
			return res.a_hour +":"+ res.a_minute+":"+ res.a_second+"."+ res.a_millisecond;
		}
		
		public function get millisecond():Number
		{
			return a_millisecond;
		}

		public function set millisecond(ms:Number):void
		{
//			startChangeRequest();
			_msRelative += ms;
			parseRelativeTime(_msRelative);
//			endChangeTransation(); //reupdate values from the parseRelativeTime
		}
		
		public function get second():Number
		{
			return a_second;
		}

		public function set second(s:Number):void
		{
//			startChangeRequest();
			_msRelative += s*oneSecond;
			parseRelativeTime(_msRelative);
//			endChangeTransation(); //reupdate values from the parseRelativeTime
		}
		
		public function get minute():Number
		{
			return a_minute;
		}

		public function set minute(min:Number):void
		{
//			startChangeRequest();
			_msRelative += min*oneMinute;
			parseRelativeTime(_msRelative);
//			endChangeTransation(); //reupdate values from the parseRelativeTime
		}
		
		public function get hour():Number
		{
			return a_hour;
		}

		public function set hour(h:Number):void
		{
//			startChangeRequest();
			_msRelative += h*oneHour;
			parseRelativeTime(_msRelative);
//			endChangeTransation(); //reupdate values from the parseRelativeTime
		}
		
		public function get day():Number
		{
			return a_day;
		}

		public function set day(d:Number):void
		{
//			startChangeRequest();
			_msRelative += d*oneDay;
			parseRelativeTime(_msRelative);
//			endChangeTransation(); //reupdate values from the parseRelativeTime
		}
		
		public function get week():Number
		{
			return a_week;
		}

		public function set week(w:Number):void
		{
//			startChangeRequest();
			_msRelative += w*oneWeek;
			parseRelativeTime(_msRelative);
//			endChangeTransation(); //reupdate values from the parseRelativeTime
		}
		
		public function get month():Number
		{
			return a_month;
		}

		public function set month(m:Number):void
		{
//			startChangeRequest();
			_msRelative += m*oneMonth;
			parseRelativeTime(_msRelative);
//			endChangeTransation(); //reupdate values from the parseRelativeTime
		}
		
		public function get year():Number
		{
			return a_year;
		}

		public function set year(y:Number):void
		{
//			startChangeRequest();
			_msRelative += y*oneYear;
			parseRelativeTime(_msRelative);
//			endChangeTransation(); //reupdate values from the parseRelativeTime
		}

	}
}