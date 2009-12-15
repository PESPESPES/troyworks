package com.troyworks.util.datetime {
	import com.troyworks.data.DataChangedEvent;	

	import flash.events.Event;	
	import flash.events.EventDispatcher;	

	/**
	 * TimeQty
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Oct 11, 2008
	 * DESCRIPTION ::
	 *  This is a utility to work with time at a millisecond level
	 *  precision.  It's primary benefits are allowing it to be 
	 *  somewhat set by incrementors e.g.
	 *  
	 *  td.seconds++;
	 *  
	 *  but these can also be zeroed out e.g.
	 *  
	 *  td.time = 1500;
	 *  td.seconds -= 5;
	 *  
	 *  
	 */
	 
	/*
	 * This is a utility for working in relative time or abstract durations, in millisecond precision.
	 * 
	 * Relative time differs from Calendar time as it's concerned with abstract
	 * durations, e.g. 1 week and 2 days, but has no particular point in calendar time
	 * it's glued to. 	these durations are immune to changes in calendar time, e.g. daylight savings, 
	 *	changing over days
	 * 
	 * This could also be used in date arithmetic, e.g. Date1 - Date2 = some delta of time
	 * 
	 * This class serves as a model for a presentation, that can be made up of flags
	 * can be quantized to some units of calendar time eg. year, minute second.
	 * 
	 * 
	 * e.g. 1100ms = 
	 * 
	 *     1 seconds if second enabled  
	 *     1 second 100ms if second and ms is enabled
	 *     11000ms if ms is enabled.
	 *     
	 *
	 * This is used on conjunction with the TDate, StopWatch and Counter class to peform 
	 * math operations, like 
	 * targetdate = date + 1 years, 2 months + 2 seconds;     
	 *	 
	 *
	 * Casting back into  calendar time can be done by via adding to some relative point in Calendar time
	 * e.g. 1970, 1900.  Note that moving in time by milliseconds, when cast back into Calendar time may not 
	 * be quite the place intended due to things like Leap year, speed of light etc ;)
	 * 
	 * 
	 * TODO create methods to convert from the milliseconds to anthing else, e.g. X millisoeconds is 1 year, 2 days, or 1.02 years.
	 *  
	 */
	public class TimeQuantity extends EventDispatcher {
		public static const CHANGED : String = "CHANGED";
		public static const START_CHANGE : String = "START_CHANGE";

		public static const ONE_SECOND : Number = 1000;
		public static const ONE_MINUTE : Number = 60 * TimeQuantity.ONE_SECOND;
		// milliseconds in a minute
		public static const ONE_HOUR : Number = TimeQuantity.ONE_MINUTE * 60;
		public static const ONE_DAY : Number = TimeQuantity.ONE_HOUR * 24;
		public static const ONE_WEEK : Number = TimeQuantity.ONE_DAY * 7;
		public static const ONE_MONTH : Number = TimeQuantity.ONE_WEEK * 4;
		public static const ONE_AVG_MONTH : Number = 365 / 12 * TimeQuantity.ONE_DAY;
		public static const ONE_QUARTER : Number = 365 * TimeQuantity.ONE_DAY / 4;
		public static const ONE_YEAR : Number = 365 * TimeQuantity.ONE_DAY;
		private var _msRelative : Number = 0;

		
		//////////////////////////
		private var _milliseconds : Number = 0;
		private var _seconds : Number = 0;
		private var _minutes : Number = 0;
		private var _hours : Number = 0;
		private var _days : Number = 0;
		private var _weeks : Number = 0;
		private var _months : Number = 0;
		private var _years : Number = 0;

		
		
		//////////////////////////
		public var bin_milliseconds : Boolean = true;
		public var bin_seconds : Boolean = true;
		public var bin_minutes : Boolean = true;
		public var bin_hours : Boolean = true;
		public var bin_days : Boolean = true;
		public var bin_weeks : Boolean = true;
		public var bin_months : Boolean = true;
		public var bin_quarters : Boolean = false;
		public var bin_years : Boolean = true;

		
		private var _curTimeQtyMS : Number = 0;
		private var _lastTimeQtyMS : Number = 0;

		
		
		public function TimeQuantity(ms : Number = 0) {
			super();
			_curTimeQtyMS = ms;
			endChangeTransation();
		}

		public static function parseRelativeTime(dateTime : Number, tdutil : TimeQuantity = null) : TimeQuantity {

			var rs : Number = (dateTime < 0) ? -1 : 1;
			var r : Number = Math.abs(dateTime);
			

			var res : TimeQuantity = (tdutil == null) ? new TimeQuantity(dateTime) : tdutil;
				
			tdutil._curTimeQtyMS = dateTime;
			
			if(res.bin_years && r >= ONE_YEAR) {
				res._years = Math.floor(r / TimeQuantity.ONE_YEAR) * rs;
				r = r % TimeQuantity.ONE_YEAR;
			} else {
				res._years = 0;
			}
			if(res.bin_months && r >= ONE_MONTH) {
				res._months = Math.floor(r / TimeQuantity.ONE_MONTH) * rs;
				r = r % TimeQuantity.ONE_MONTH;
			} else {
				res._months = 0;
			}
			
			if(res.bin_weeks && r >= ONE_WEEK) {
				res._weeks = Math.floor(r / TimeQuantity.ONE_WEEK) * rs;
				r = r % TimeQuantity.ONE_WEEK;
			} else {
				res._weeks = 0;
			}
			if(res.bin_days && r >= ONE_DAY) {	
				res._days = Math.floor(r / TimeQuantity.ONE_DAY) * rs;
				r = r % TimeQuantity.ONE_DAY;
			} else {
				res._days = 0;
			}

			///////////////////////////////////////////
			if(res.bin_hours && r >= ONE_HOUR) {	
				res._hours = Math.floor(r / TimeQuantity.ONE_HOUR) * rs;
				r = r % TimeQuantity.ONE_HOUR;	
			} else {
				res._hours = 0;
			}

			if(res.bin_minutes && r >= ONE_MINUTE) {	
				res._minutes = Math.floor(r / TimeQuantity.ONE_MINUTE) * rs;
				r = r % TimeQuantity.ONE_MINUTE;
			} else {
				res._minutes = 0;
			}

			if(res.bin_seconds && r >= ONE_SECOND) {
				res._seconds = Math.floor(r / TimeQuantity.ONE_SECOND) * rs;
				r = r % TimeQuantity.ONE_SECOND;
			} else {
				res._seconds = 0;
			}
			if(res.bin_milliseconds && r >= 1) {
				res._milliseconds = r * rs;
			} else {
				res._milliseconds = 0;
			}
			return res;
		}

		////////////////////////////////////////////////////////
		//    ACCESSORS 
		///////////////////////////////////////////////////////

		public function get time() : Number {
			return _curTimeQtyMS;
		}

		public function set time(ms : Number) : void {
			startChangeRequest();
			_curTimeQtyMS = ms;
			endChangeTransation(); 
		}

		public function zero() : void {
			startChangeRequest();
			_curTimeQtyMS = 0;
			endChangeTransation(); 
		}

		
		
		public function get milliseconds() : Number {
			return _milliseconds ;//_curTimeQtyMS;
		}

		
		public function set milliseconds(ms : Number) : void {
			startChangeRequest();
			_curTimeQtyMS -= _milliseconds; //zero
			_curTimeQtyMS = ms;
			endChangeTransation(); 
		}

		public function addMilliseconds(ms : Number) : void {
			startChangeRequest();
			_curTimeQtyMS += ms;
			endChangeTransation(); 
		}

		public function get seconds() : Number {
			
			//	trace("get seconds " + _seconds);
			return _seconds ;//_curTimeQtyMS / ONE_SECOND;
		}

		public function set seconds(s : Number) : void {
			startChangeRequest();
			_curTimeQtyMS -= _seconds * ONE_SECOND; //zero
			_curTimeQtyMS = s * ONE_SECOND;
			endChangeTransation(); 
		}

		public function addSeconds(s : Number) : void {
			startChangeRequest();
			_curTimeQtyMS += s * ONE_SECOND;
			endChangeTransation(); 
		}

		public function get minutes() : Number {
			return _minutes ;//_curTimeQtyMS / ONE_MINUTE;
		}

		public function set minutes(min : Number) : void {
			startChangeRequest();
			
			_curTimeQtyMS -= _minutes * ONE_MINUTE;
			_curTimeQtyMS = min * ONE_MINUTE;
			endChangeTransation(); 
		}

		public function set addMinutes(min : Number) : void {
			startChangeRequest();			
			_curTimeQtyMS += min * ONE_MINUTE;
			endChangeTransation(); 
		}

		public function get hours() : Number {
			return _hours ;//__curTimeQtyMS / ONE_HOUR;
		}

		public function set hours(h : Number) : void {
			startChangeRequest();
			_curTimeQtyMS -= _hours * ONE_HOUR; //zero
			_curTimeQtyMS = h * ONE_HOUR;
			endChangeTransation(); 
		}

		public function addHours(h : Number) : void {
			startChangeRequest();
			_curTimeQtyMS += h * ONE_HOUR;
			endChangeTransation(); 
		}

		public function get days() : Number {
			return _days ;//__curTimeQtyMS / ONE_DAY;
		}

		public function set days(d : Number) : void {
			startChangeRequest();
			
			_curTimeQtyMS -= _days * ONE_DAY;
			_curTimeQtyMS = d * ONE_DAY;
			endChangeTransation(); 
		}

		public function addDays(d : Number) : void {
			startChangeRequest();			
			_curTimeQtyMS += d * ONE_DAY;
			endChangeTransation(); 
		}

		public function get weeks() : Number {
			return _weeks ;//_ _curTimeQtyMS / ONE_WEEK;
		}

		public function set weeks(w : Number) : void {
			startChangeRequest();
			
			_curTimeQtyMS -= _weeks * ONE_WEEK;
			_curTimeQtyMS = w * ONE_WEEK;
			endChangeTransation(); 
		}

		public function addWeeks(w : Number) : void {
			startChangeRequest();
			_curTimeQtyMS += w * ONE_WEEK;
			endChangeTransation(); 
		}

		
		public function get months() : Number {
			
			return _months ;// _curTimeQtyMS / ONE_MONTH;
		}

		public function set months(m : Number) : void {
			startChangeRequest();
			_curTimeQtyMS -= _months * ONE_MONTH;
			_curTimeQtyMS = m * ONE_MONTH;
			endChangeTransation(); 
		}

		public function addMonths(m : Number) : void {
			startChangeRequest();			
			_curTimeQtyMS += m * ONE_MONTH;
			endChangeTransation(); 
		}

		public function get years() : Number {
			return _years ;// _curTimeQtyMS / ONE_YEAR;
		}

		public function set years(y : Number) : void {
			startChangeRequest();
			_curTimeQtyMS -= _years * ONE_YEAR; //zero
			_curTimeQtyMS = y * ONE_YEAR;
			endChangeTransation(); 
		}
		public function addYears(y : Number) : void {
			startChangeRequest();
			_curTimeQtyMS += y * ONE_YEAR;
			endChangeTransation(); 
		}
		private function endChangeTransation() : void {
			trace("endChangeTransation " + _curTimeQtyMS);
			TimeQuantity.parseRelativeTime(_curTimeQtyMS, this);
			var devt : DataChangedEvent = new DataChangedEvent(CHANGED);
			
			devt.currentVal = _curTimeQtyMS;
			devt.oldVal = _lastTimeQtyMS;
			dispatchEvent(devt);
		}

		private function startChangeRequest() : void {		
			
			
			_lastTimeQtyMS = _curTimeQtyMS;
			
		
			dispatchEvent(new Event(START_CHANGE));
		}

		override public function toString() : String {
			var res : Array = new Array();
			if(bin_years && years != 0) {
				res.push(years + " YEARS");
			}
			if(bin_months && months != 0) {
				res.push(months + " MONTHS");
			}
			if(bin_weeks && weeks != 0) {
				res.push(weeks + " WEEKS");
			}
			if(bin_days && days != 0) {	
				res.push(days + " DAYS");
			}
		
			///////////////////////////////////////////
			if(bin_hours && hours != 0) {	
				res.push(hours + " HOURS");
			}
		
			if(bin_minutes && minutes != 0) {	
				res.push(minutes + " MINUTES");
			}
		
			if(bin_seconds && seconds != 0) {
				res.push(seconds + " SECONDS");
			}
			if(bin_milliseconds && milliseconds != 0) {
				res.push(milliseconds + " MS");
			}
			return res.join(" ");
		}
	}
}
