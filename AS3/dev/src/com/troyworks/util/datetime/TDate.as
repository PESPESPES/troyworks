package com.troyworks.util.datetime {
	import com.troyworks.data.DataChangedEvent;
	import com.troyworks.util.DesignByContract;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;	

	/**
	 * based off the XDate utility from P.J. Onori
	 * URL : 			http://www.somerandomdude.net/flash_xdate.html
	 * @author Troy Gardner, P.J. Onori
	 * 
	 * Description :	Extension of Macromedia's Date class for Flash MX 2004+. Various methods to public function get more detailed 
	 * date information. This class was designed for calendar-based applications and provides many useful
	 * methods to pull out all the data needed to do so.
	 * 
	 * It's been updated to have more transactional changes, and updated to AS3.0 event
	 * 
	 * 	Created : 		7/22/05, 9/17/05

	 */
	public class TDate extends Object implements IEventDispatcher {

		//REQUIRED For TEventDispatcher
		public var $tevD : EventDispatcher;

		
		// REQUIRED by DesignByContract
		public var ASSERT : Function;
		public var REQUIRE : Function;

		
		
		
		//protected var mask:Number = ;

		protected var monthDays : Number = NaN;
		protected var monthWeeks : Number = NaN;
		protected var weekArray : Array;

		private var lastDate : Date;

		
		private var innerDate : Date;

		public function TDate(yearOrTimevalue : Number = NaN, month : Number = NaN, date : Number = NaN, hour : Number = 0, min : Number = 0, sec : Number = 0, ms : Number = 0) {
 
			//innerDate = new Date(yearOrTimevalue, month, date, hour, min);
			trace("new TDate " + arguments.length);
			var va:int = 0;
			for(var i:int = 0; i < arguments.length; i++){
			   if(!isNaN(arguments[i])){
			   	va++;	
			   }
			}
			if(va == 0) {
				innerDate = new Date();
			}else if(va == 1) {
				innerDate = new Date(yearOrTimevalue);
			}else if(va == 2) {
				innerDate = new Date(yearOrTimevalue, month);
			}else if(va == 3) {
				innerDate = new Date(yearOrTimevalue, month, date);
			}else if(va == 4) {
				innerDate = new Date(yearOrTimevalue, month, date, hour);
			}else if(va == 5) {
				innerDate = new Date(yearOrTimevalue, month, date, hour, min);
			}else if(va == 6) {
				innerDate = new Date(yearOrTimevalue, month, date, hour, min, sec);
			} else {
				innerDate = new Date(yearOrTimevalue, month, date, hour, min, sec, ms);
			}
		//	innerDate = new Date(yearOrTimevalue, month, date, hour, min);
			
			//super.setProxiedObject(innerDate);
			//REQUIRE(arguments.length < 7, "TDate has invalid arguments, more than 7 passed!" + arguments.join(","));
			//TEventDispatcher.initialize(this);
			$tevD = new EventDispatcher();
			DesignByContract.initialize(this);
			//super.setYear(year);
			//super.setMonth(month);
			//super.setDate(date);
			setDaysInMonth();
			setWeeksInMonth();
			
	
			/*
			This class does not handle any time units lower than days at this point.
			setHours(hour);
			setMinutes(min);
			setSeconds(sec);
			setMilliseconds(ms);
			*/
		}

		protected function dispatchChangedEvent() : void {
			var evt : DataChangedEvent = new DataChangedEvent(Event.CHANGE);
			evt.oldVal = lastDate;
			evt.currentVal = this.innerDate;
			dispatchEvent(evt);
		}

		protected function startChangeTransaction() : void {
			lastDate = cloneAsDate();
		}

		protected function endChangeTransaction() : void {
			setDaysInMonth();
			setWeeksInMonth();
			dispatchChangedEvent();
		}

		//////////////////////////// MODIFIERS ////////////////////////////////////////////////
		public function decrementYear(num : Number = NaN) : Number {
			var by : Number = (isNaN(num)) ? 1 : num ;
			return setUTCFullYear(innerDate.getUTCFullYear() - by);
		}

		public function incrementYear(num : Number = NaN) : Number {
			var by : Number = (isNaN(num)) ? 1 : num ;
			return setUTCFullYear(innerDate.getUTCFullYear() + by);
		}

		public function decrementMonth(num : Number = NaN) : Number {
			var by : Number = (isNaN(num)) ? 1 : num ;
			return setUTCMonth(innerDate.getUTCMonth() - by);
		}

		public function incrementMonth(num : Number = NaN) : Number {
			var by : Number = (isNaN(num)) ? 1 : num ;
			return setUTCMonth(innerDate.getUTCMonth() + by);
		}

		public function decrementWeek(num : Number = NaN) : Number {
			var by : Number = (isNaN(num)) ? 1 : num ;
			return setUTCDate(innerDate.getUTCDate() - (by * 7));
		}

		public function incrementWeek(num : Number = NaN) : Number {
			var by : Number = (isNaN(num)) ? 1 : num ;
			return setUTCDate(innerDate.getUTCDate() + (by * 7));
		}

		public function decrementDay(num : Number = NaN) : Number {
			var by : Number = (isNaN(num)) ? 1 : num ;
			return setUTCDate(innerDate.getUTCDate() - by);
		}

		public function incrementDay(num : Number = NaN) : Number {
			var by : Number = (isNaN(num)) ? 1 : num ;
			return setUTCDate(innerDate.getUTCDate() + by);
		}

		public function decrementHour(num : Number = NaN) : Number {
			var by : Number = (isNaN(num)) ? 1 : num ;
			return setUTCHours(innerDate.getUTCHours() - by);
		}

		public function incrementHour(num : Number = NaN) : Number {
			var by : Number = (isNaN(num)) ? 1 : num ;
			return setUTCHours(innerDate.getUTCHours() + by);
		}

		public function decrementMinutes(num : Number = NaN) : Number {
			var by : Number = (isNaN(num)) ? 1 : num ;
			return setUTCMinutes(innerDate.getUTCMinutes() - by);
		}

		public function incrementMinutes(num : Number = NaN) : Number {
			var by : Number = (isNaN(num)) ? 1 : num ;
			return setUTCMinutes(innerDate.getUTCMinutes() + by);
		}

		public function decrementSeconds(num : Number = NaN) : Number {
			var by : Number = (isNaN(num)) ? 1 : num ;
			return setUTCSeconds(innerDate.getUTCSeconds() - by);
		}

		public function incrementSeconds(num : Number = NaN) : Number {
			var by : Number = (isNaN(num)) ? 1 : num ;
			return setUTCSeconds(innerDate.getUTCSeconds() + by);
		}

		public function decrementMilliseconds(num : Number = NaN) : Number {
			var by : Number = (isNaN(num)) ? 1 : num ;
			return setUTCMilliseconds(innerDate.getUTCMilliseconds() - by);
		}

		public function incrementMilliseconds(num : Number = NaN) : Number {
			var by : Number = (isNaN(num)) ? 1 : num ;
			return setUTCMilliseconds(innerDate.getUTCMilliseconds() + by);
		}

		public function gotoTodaysDate() : void {
			var currentDate : Date = new Date();
			startChangeTransaction();
			innerDate.setTime(currentDate.getTime());
			endChangeTransaction();	
		}

		//--------------- overridden from the Date Class ---------------------------------
		public function get dayUTC() : Number {
			return innerDate.dayUTC;
		}

		
		public function get minutes() : Number {
			return innerDate.minutes;
		}

		public function set minutes(newMinutes : Number) : void {
			startChangeTransaction();
			innerDate.minutes = newMinutes;
			endChangeTransaction();
		}

		
		public function get fullYear() : Number {
			return innerDate.fullYear;
		}

		public function set fullYear(newFullyear : Number) : void {
			startChangeTransaction();
			innerDate.fullYear = newFullyear;
			endChangeTransaction();
		}

		
		public function get millisecondsUTC() : Number {
			return innerDate.millisecondsUTC;
		}

		public function set millisecondsUTC(newMillisecondsutc : Number) : void {
			startChangeTransaction();
			innerDate.millisecondsUTC = newMillisecondsutc;
			endChangeTransaction();
		}

		
		public function get seconds() : Number {
			return innerDate.seconds;
		}

		public function set seconds(newSeconds : Number) : void {
			startChangeTransaction();
			innerDate.seconds = newSeconds;
			endChangeTransaction();
		}

		
		public function get timezoneOffset() : Number {
			return innerDate.timezoneOffset;
		}

		
		public function get month() : Number {
			return innerDate.month;
		}

		public function set month(newMonth : Number) : void {
			startChangeTransaction();
			innerDate.month = newMonth;
			endChangeTransaction();
		}

		
		public function get monthUTC() : Number {
			return innerDate.monthUTC;
		}

		public function set monthUTC(newMonthutc : Number) : void {
			startChangeTransaction();
			innerDate.monthUTC = newMonthutc;
			endChangeTransaction();
		}

		
		public function get minutesUTC() : Number {
			return innerDate.minutesUTC;
		}

		public function set minutesUTC(newMinutesutc : Number) : void {
			startChangeTransaction();
			innerDate.minutesUTC = newMinutesutc;
			endChangeTransaction();
		}

		
		public function get milliseconds() : Number {
			return innerDate.milliseconds;
		}

		public function set milliseconds(newMilliseconds : Number) : void {
			startChangeTransaction();
			innerDate.milliseconds = newMilliseconds;
			endChangeTransaction();
		}

		
		public function get hoursUTC() : Number {
			return innerDate.hoursUTC;
		}

		public function set hoursUTC(newHoursutc : Number) : void {
			startChangeTransaction();
			innerDate.hoursUTC = newHoursutc;
			endChangeTransaction();
		}

		
		public function get hours() : Number {
			return innerDate.hours;
		}

		public function set hours(newHours : Number) : void {
			startChangeTransaction();
			innerDate.hours = newHours;
			endChangeTransaction();
		}

		
		public function get day() : Number {
			return innerDate.day;
		}

		
		public function get fullYearUTC() : Number {
			return innerDate.fullYearUTC;
		}

		public function set fullYearUTC(newFullyearutc : Number) : void {
			startChangeTransaction();
			innerDate.fullYearUTC = newFullyearutc;
			endChangeTransaction();
		}

		
		public function get time() : Number {
			return innerDate.time;
		}

		public function set time(newTime : Number) : void {
		//	startChangeTransaction();
			innerDate.time = newTime;
		//	endChangeTransaction();
		}

		
		public function get dateUTC() : Number {
			return innerDate.dateUTC;
		}

		public function set dateUTC(newDateutc : Number) : void {
			startChangeTransaction();
			innerDate.dateUTC = newDateutc;
			endChangeTransaction();
		}

		//0-31
		public function get date() : Number {
			return innerDate.date;
		}

		public function set date(newDate : Number) : void {
			startChangeTransaction();
			innerDate.date = newDate;
			endChangeTransaction();
		}

		
		public function get secondsUTC() : Number {
			return innerDate.secondsUTC;
		}

		public function set secondsUTC(newSecondsutc : Number) : void {
			startChangeTransaction();
			innerDate.secondsUTC = newSecondsutc;
			endChangeTransaction();
		}

		
		/*Sets the year, according to local time, and returns the new time in milliseconds. Date*/
		public function setFullYear(value : Number) : Number {
			startChangeTransaction();
			var res : Number = innerDate.setFullYear.apply(this, arguments);
			endChangeTransaction();
			return res;
		}

		/*Sets the month and optionally the day of the month, according to local time, and returns the new time in milliseconds. Date*/ 

		public function setMonth(value : Number) : Number {
			startChangeTransaction();
			var res : Number = innerDate.setMonth.apply(this, arguments);
			endChangeTransaction();
			return res;
		}

		/*Sets the day of the month, according to local time, and returns the new time in milliseconds. Date*/ 
		public function setDate(value : Number) : Number {
			startChangeTransaction();
			var res : Number = innerDate.setDate.apply(this, arguments);
			endChangeTransaction();
			return res;
		}

		
		/*Sets the hour, according to local time, and returns the new time in milliseconds. Date*/ 
		public function setHours(value : Number) : Number {
			startChangeTransaction();
			var res : Number = innerDate.setHours.apply(this, arguments);
			endChangeTransaction();
			return res;
		}

		/*Sets the minutes, according to local time, and returns the new time in milliseconds. Date*/ 
		public function setMinutes(value : Number) : Number {
			startChangeTransaction();
			var res : Number = innerDate.setMinutes.apply(this, arguments);
			endChangeTransaction();
			return res;
		}

		/*Sets the date in milliseconds since midnight on January 1, 1970, and returns the new time in milliseconds. Date*/ 
		public function setSeconds(value : Number) : Number {
			startChangeTransaction();
			var res : Number = innerDate.setSeconds.apply(this, arguments);
			endChangeTransaction();
			return res;
		}

		/*Sets the milliseconds, according to local time, and returns the new time in milliseconds. Date*/ 
		public function setMilliseconds(value : Number) : Number {
			startChangeTransaction();
			var res : Number = innerDate.setMilliseconds.apply(this, arguments);
			endChangeTransaction();
			return res;
		}

		/*Sets the seconds, according to local time, and returns the new time in milliseconds. Date*/ 
		public function  setTime(millisecond : Number) : Number {
			startChangeTransaction();
			
			//var res : Number = innerDate.setTime(time);	//incorrect---> use following 
			var res : Number = innerDate.setTime(millisecond);
			//innerDate.setTime.apply(this, arguments);
			endChangeTransaction();
			return res;
		} 	

		/*Sets the year, in universal time (UTC), and returns the new time in milliseconds. Date*/ 
		public function setUTCFullYear(value : Number) : Number {
			startChangeTransaction();
			var res : Number = innerDate.setUTCFullYear.apply(this, arguments);
			endChangeTransaction();
			return res;
		}

		/*Sets the month, and optionally the day, in universal time(UTC) and returns the new time in milliseconds. Date*/ 
		public function setUTCMonth(value : Number) : Number {
			startChangeTransaction();
			var res : Number = innerDate.setUTCMonth.apply(this, arguments);
			endChangeTransaction();
			return res;
		}

		/*Sets the day of the month, in universal time (UTC), and returns the new time in milliseconds. Date*/ 
		public function setUTCDate(value : Number) : Number {
			startChangeTransaction();
			var res : Number = innerDate.setUTCDate.apply(this, arguments);
			endChangeTransaction();
			return res;
		}

		/*Sets the hour, in universal time (UTC), and returns the new time in milliseconds. Date*/
		public function setUTCHours(value : Number) : Number {
			startChangeTransaction();
			var res : Number = innerDate.setUTCHours.apply(this, arguments);
			endChangeTransaction();
			return res;
		}

		/*Sets the minutes, in universal time (UTC), and returns the new time in milliseconds. Date*/ 
		public function setUTCMinutes(value : Number) : Number {
			startChangeTransaction();
			var res : Number = innerDate.setUTCMinutes.apply(this, arguments);
			endChangeTransaction();
			return res;
		}

		public function setUTCSeconds(value : Number) : Number {
			startChangeTransaction();
			var res : Number = innerDate.setUTCSeconds.apply(this, arguments);
			endChangeTransaction();
			return res;
		}

		/*Sets the milliseconds, in universal time (UTC), and returns the new time in milliseconds. Date*/ 
		public function setUTCMilliseconds(value : Number) : Number {
			startChangeTransaction();
			var res : Number = innerDate.setUTCMilliseconds.apply(this, arguments);
			endChangeTransaction();
			return res;
		}

	/*	public function setYear(value : Number) : Number {
		startChangeTransaction();
		var res : Number = innerDate.setYear.apply(this, arguments);
		endChangeTransaction();
		return res;
		}*/

		public function isToday() : Boolean {
			var tmpDate : Date = new Date();
			if(tmpDate.getDate() == innerDate.getDate()) {
				return true;
			}
			return false;
		}

		public function isASunday() : Boolean {
			if(innerDate.getDay() == 0) {
				return true;
			}
			return false;
		}

		public function isAMonday() : Boolean {
			if(innerDate.getDay() == 1) {
				return true;
			}
			return false;
		}

		public function isATuesday() : Boolean {
			if(innerDate.getDay() == 2) {
				return true;
			}
			return false;
		}

		public function isWednesday() : Boolean {
			if(innerDate.getDay() == 3) {
				return true;
			}
			return false;
		}

		public function isAThurdsay() : Boolean {
			if(innerDate.getDay() == 4) {
				return true;
			}
			return false;
		}

		public function isAFriday() : Boolean {
			if(innerDate.getDay() == 5) {
				return true;
			}
			return false;
		}

		public function isASaturday() : Boolean {
			if(innerDate.getDay() == 6) {
				return true;
			}
			return false;
		}

		public function isAWeekday() : Boolean {
			var dN : Number = innerDate.getDay();
			if(  0 < dN && dN < 6 ) {
				return true;
			}
			return false;
		}

		public function isAWeekendDay() : Boolean {
			var dN : Number = innerDate.getDay();
			if(dN == 6 || dN == 0) {
				//equals Sunday 0 or Saturday 6
				return true;
			}
			return false;
		}

		/*
		 * Function:	setDaysInMonth
		 * Summary:		Finds the total amount of days in the object's month
		 * 				and sets 'daysInMonth' with the value
		 */
		public function setDaysInMonth() : void {
			var tempDate : Date = new Date(innerDate.getFullYear(), innerDate.getMonth() + 1, 0);
			this.monthDays = tempDate.getDate();
		}

		/*
		 * Function:	daysInMonth
		 * Summary:		Returns the total number of days in the object's month
		 * Return:      The total number of days in the month
		 */

		public function getDaysInMonth() : Number {
			
			if(isNaN(this.monthDays)) {
				setDaysInMonth();	
			}
			return this.monthDays;
		}

		/*
		 * Function:	getDaysLeftInMonth
		 * Summary:		Returns the total number of days left in the object's month
		 * Return:      The total number of days left in the month
		 */
		public function getDaysLeftInMonth() : Number {
			return this.getDaysInMonth() - innerDate.getDate();
		}

		/*
		 * Function:	getDaysInYear
		 * Summary:		Finds the total amount of days in the object's year
		 * 				primarily useful to detect leap years
		 * Return:      The total number of days in the year
		 */

		public function getDaysInYear() : Number {
			var daysInYear : Number = 0;
			var tempDate : Date = cloneAsDate();
			for (var i : Number = 0;i < 12; i++) {
				tempDate.setMonth(i);
				daysInYear += tempDate.getDate();			
			}
			return daysInYear;
		}

		/*
		 * Function:	getMonthStartDate
		 * Summary:		Finds the day (i.e Monday, Tuesday, etc.)
		 * 				that the first day of the object's month lands on
		 */
		public function getMonthStartDate() : Number {
			var tmpDate : Date = cloneAsDate();
			tmpDate.setDate(1);
			var day : Number = tmpDate.getDay();
			return day;
		}

		/*
		 * Function:	getMonthEndDate
		 * Summary:		Finds the day (i.e Monday, Tuesday, etc.)
		 * 				that the last day of the object's month lands on
		 */
		public function getMonthEndDate() : Number {
			var tmpDate : Date = cloneAsDate();
			tmpDate.setDate(getDaysInMonth());
			var day : Number = tmpDate.getDay();
			return day;
		}

		public function getDayOfYear() : Number {
			var onejan : Date = new Date(this.getFullYear(), 0, 1);
			return Math.ceil((innerDate.time - onejan.time) / 86400000);
		} 

		/*
		 * Function:	setWeeksInMonth
		 * Summary:		Sets the total number of weeks in the object's month
		 */
		public function setWeeksInMonth() : void {
			monthWeeks = 0;
			var tD : Date = new Date();
			for (var i : Number = 0;i < getDaysInMonth() + 1; i++) {
				tD.setDate(i);
				if((tD.getDay() == 6 && monthWeeks == 0) || (tD.getDay() == 0 && i != 1 )) {
					monthWeeks++;		
				}
			}
		}

		/*
		 * Function:	getWeeksInMonth
		 * Summary:		Gets the total number of weeks in the object's month
		 */

		public function getWeeksInMonth() : Number {
			return monthWeeks;
		}

		/*
		 * Function:	getDaysInWeeks
		 * Summary:		Returns an array with the total number of days
		 * 				for each week in the object's month
		 */

		public function getDaysInWeeks() : Array {
			var day : Number = 1;
			var weekCount : Number = 0;
			var daysCounted : Number = 0;
			var weekArray : Array = new Array();
			var days : Number = this.getDaysInMonth();
			var i : Number = -1;
			while(++i < days) {
				this.setDate(i + 1);
				if(innerDate.getDay() == 6 && weekCount == 0) {
					weekCount += 1;
					daysCounted = i;
					weekArray.push(daysCounted + 1);
				}
				else if(innerDate.getDay() == 0 && i < days - 7 && i != 0) {
					weekCount += 1;
					weekArray.push(7);
					daysCounted += 7;
				}
			}
			weekArray.push((days - 1) - (daysCounted + 1) + 1);
			return weekArray;
		}

		/*
		 * Function:	getDaysInWeek
		 * Summary:		Returns the total amount of days in a specified week
		 * 				of the object's month
		 */
		public function getDaysInWeek(week : Number) : Number {
			var weeks : Array = getDaysInWeeks();
			if(week > weeks.length || week < 0) {
				return NaN;
			}
			return weeks[week];
		}

		/*
		 * Function:	getDay
		 * Summary:		Finds the day for any date specified
		 */
		public static function getDayFrom(month : Number, year : Number, day : Number) : Number {
			var res : Date = new Date(year, month, day);
			return res.getDay();
		}

		
		
		public function clone() : TDate {
			//needed to get around type checking in FDT/Mtasc
			var res : TDate = new TDate(innerDate.time);
			return res;
		}

		public function cloneAsDate() : Date {
			//needed to get around type checking in FDT/Mtasc
			//	var f : Function = Date;
			var res : Date = new Date(innerDate.time);
			return res;
		}

		
		
		public function dispatchEvent(event : Event) : Boolean {
			return $tevD.dispatchEvent(event);
		}

		public function hasEventListener(type : String) : Boolean {
			return $tevD.hasEventListener(type);
		}

		public function willTrigger(type : String) : Boolean {
			return $tevD.willTrigger(type);
		}

		
		public function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void {
			$tevD.removeEventListener(type, listener, useCapture);
		}

		public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
			$tevD.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		public function isBeforeDate(date : *, byDuration : Number = 0, inclusive : Boolean = false) : Boolean {
			if(inclusive) {
				return  date.time <= (innerDate.time - byDuration);
			} else {
				return  date.time < (innerDate.time - byDuration);
			}
		}

		public function isAfterDate(date : *, byDuration : Number = 0, inclusive : Boolean = false) : Boolean {
			if(inclusive) {
				return  (innerDate.time + byDuration) <= date.time ;
			} else {
				return  (innerDate.time + byDuration) < date.time ;
			}
		}

		public function isSameTimeAsDate(date : *, byDuration : Number = 0, inclusive : Boolean = false) : Boolean {
			
			if(inclusive) {
				return  (innerDate.time - byDuration) <= date.time <= (innerDate.time + byDuration) ;
			} else {
				return  (innerDate.time - byDuration) < date.time < (innerDate.time + byDuration) ;
			}
		}

		public function getDate() : Number {
			return innerDate.getDate();
		}

		/*Returns the day of the month (an integer from 1 to 31) specified by a Date object according to local time. Date*/ 
		public function getDay() : Number {
			return innerDate.getDay();
		}

		/*Returns the day of the week (0 for Sunday, 1 for Monday, and so on) specified by this Date according to local time. Date*/ 
		public function getFullYear() : Number {
			return innerDate.getFullYear();
		} 

		/*Returns the full year (a four-digit number, such as 2000) of a Date object according to local time. Date*/ 
		public function getHours() : Number {
			return innerDate.getHours();
		} 

		/*Returns the hour (an integer from 0 to 23) of the day portion of a Date object according to local time. Date*/ 
		public function getMilliseconds() : Number {
			return innerDate.getMilliseconds();
		}  

		/*Returns the milliseconds (an integer from 0 to 999) portion of a Date object according to local time. Date*/ 
		public function getMinutes() : Number {
			return innerDate.getMinutes();
		} 

		/*Returns the minutes (an integer from 0 to 59) portion of a Date object according to local time. Date*/ 
		public function getMonth() : Number {
			return innerDate.getMonth();
		}  

		/*Returns the month (0 for January, 1 for February, and so on) portion of this Date according to local time. Date*/ 
		public function getSeconds() : Number {
			return innerDate.getSeconds();
		}  

		/*Returns the seconds (an integer from 0 to 59) portion of a Date object according to local time. Date*/ 
		public function getTime() : Number {
			return innerDate.getTime();
		}  

		/*Returns the number of milliseconds since midnight January 1, 1970, universal time, for a Date object. Date*/ 
		public function getTimezoneOffset() : Number {
			return innerDate.getTimezoneOffset();
		}  

		/*Returns the difference, in minutes, between universal time (UTC) and the computer's local time. Date*/ 
		public function getUTCDate() : Number {
			return innerDate.getUTCDate();
		}  

		/*Returns the day of the month (an integer from 1 to 31) of a Date object, according to universal time (UTC). Date*/ 
		public function getUTCDay() : Number {
			return innerDate.getUTCFullYear();
		}  

		/*Returns the day of the week (0 for Sunday, 1 for Monday, and so on) of this Date according to universal time (UTC). Date*/ 
		public function getUTCFullYear() : Number {
			return innerDate.getUTCFullYear();
		}  

		/*Returns the four-digit year of a Date object according to universal time (UTC). Date*/ 
		public function getUTCHours() : Number {
			return innerDate.getUTCHours();
		}  

		/*Returns the hour (an integer from 0 to 23) of the day of a Date object according to universal time (UTC). Date*/ 
		public function getUTCMilliseconds() : Number {
			return innerDate.getUTCMilliseconds();
		}  

		/*Returns the milliseconds (an integer from 0 to 999) portion of a Date object according to universal time (UTC). Date*/ 
		public function getUTCMinutes() : Number {
			return innerDate.getUTCMinutes();
		}  

		/*Returns the minutes (an integer from 0 to 59) portion of a Date object according to universal time (UTC). Date*/ 
		public function getUTCMonth() : Number {
			return innerDate.getUTCSeconds();
		} 

		/*Returns the month (0 [January] to 11 [December]) portion of a Date object according to universal time (UTC). Date*/ 
		public function getUTCSeconds() : Number {
			return innerDate.getUTCSeconds();
		}  

		/*Returns the seconds (an integer from 0 to 59) portion of a Date object according to universal time (UTC). Date*/ 
		public function  hasOwnProperty(name : String) : Boolean {
			return innerDate.hasOwnProperty(name);
		}  

		/*Indicates whether an object has a specified property defined. Object */ 
		public function  isPrototypeOf(theClass : Object) : Boolean {
			return innerDate.isPrototypeOf(theClass);
		}  

		/*Indicates whether an instance of the Object class is in the prototype chain of the object specified as the parameter. Object*/ 
		public function parse(date : String) : Number {
			return innerDate.getFullYear();
		}  

		/*[static] Converts a string representing a date into a number equaling the number of milliseconds elapsed since January 1, 1970, UTC. Date*/ 

		/*Indicates whether the specified property exists and is enumerable. Object */
		public function propertyIsEnumerable(name : String) : Boolean {
			return innerDate.propertyIsEnumerable(name);
		}

		/*Sets the availability of a dynamic property for loop operations. Object */
		/*	public function  setPropertyIsEnumerable(name : String, isEnum : Boolean = true) : void {
		innerDate.setPropertyIsEnumerable(name, isEnum);
		}*/  

		
		
		
		/*Sets the seconds, and optionally the milliseconds, in universal time (UTC) and returns the new time in milliseconds. Date*/ 
		public function   toDateString() : String {
			return innerDate.toDateString();
		}  

		/*Returns a string representation of the day and date only, and does not include the time or timezone. Date*/ 
		public function   toLocaleDateString() : String {
			return innerDate.toLocaleDateString();
		} 

		/*Returns a String representation of the day and date only, and does not include the time or timezone. Date*/ 
		public function   toLocaleString() : String {
			return innerDate.toLocaleString();
		}  

		/*Returns a String representation of the day, date, time, given in local time. Date*/ 
		public function   toLocaleTimeString() : String {
			return innerDate.toLocaleTimeString();
		}  

		/*Returns a String representation of the time only, and does not include the day, date, year, or timezone. Date*/ 
		public function   toString() : String {
			return innerDate.toString();
		}  

		/*Returns a String representation of the day, date, time, and timezone. Date*/ 
		public function    toTimeString() : String {
			return innerDate.toUTCString();
		}  

		/*Returns a String representation of the time and timezone only, and does not include the day and date. Date*/ 
		public function   toUTCString() : String {
			return innerDate.toUTCString();
		}  

		/*Returns a String representation of the day, date, and time in universal time (UTC). Date*/ 
		public function   UTC(year : Number, month : Number, date : Number = 1, hour : Number = 0, minute : Number = 0, second : Number = 0, millisecond : Number = 0) : Number {
			return Date.UTC(year, month, date, hour, minute, second, millisecond);
		}  

		/*[static] Returns the number of milliseconds between midnight on January 1, 1970, universal time, and the time specified in the parameters. Date*/ 
		public function   valueOf() : Number {
			return innerDate.valueOf();
		} 
/*Returns the number of milliseconds since midnight January 1, 1970, universal time, for a Date object.*/ 
	}
}