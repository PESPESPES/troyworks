package com.troyworks.util.datetime {
	import flash.events.IEventDispatcher;	
	import flash.events.EventDispatcher; 

	import com.troyworks.util.DesignByContract;
	import com.troyworks.framework.model.BaseModelObject;

	import flash.events.Event;	

	/* 
	- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Title : 		XDate Class
	Author : 		P.J. Onori
	URL : 			http://www.somerandomdude.net/flash_xdate.html
	
	Description :	Extension of Macromedia's Date class for Flash MX 2004+. Various methods to get more detailed 
	date information. This class was designed for calendar-based applications and provides many useful
	methods to pull out all the data needed to do so.
	
	Created : 		7/22/05
	Modified : 		9/17/05
	
	- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	 */
	
	/**
	 * based off the XDate utility from P.J. Onori
	 * URL : 			http://www.somerandomdude.net/flash_xdate.html
	 * @author Troy Gardner
	 */
	public class TDate extends Date implements IEventDispatcher {

		//REQUIRED For TEventDispatcher
		public var $tevD : EventDispatcher;
		public var dispatchEvent : Function;
		//			public var eventListenerExists:Function;
		public var addEventListener : Function;
		public var removeEventListener : Function;
		public var removeAllEventListeners : Function;

		// REQUIRED by DesignByContract
		public var ASSERT : Function;
		public var REQUIRE : Function;

		
		// Time Values.. useful for more than just finding the date.
	   
		/* How many milliseconds are in a second*/
		public static var SECOND : Number = 1000;
		/* How many milliseconds are in a minute*/
		public static var MINUTE : Number = SECOND * 60;
		/* How many milliseconds are in an hour*/
		public static var HOUR : Number = MINUTE * 60;
		/* How many milliseconds are in a day*/
		public static var DAY : Number = HOUR * 24;
		/* How many milliseconds are in a week*/
		public static var WEEK : Number = DAY * 7;
		/* How many milliseconds are in average month*/
		public static var MONTH : Number = (365 * DAY) / 12;
		/* How many milliseconds are in average 3 month period */
		public static var QUARTER : Number = MONTH * 3;
		/* How many milliseconds are in a year*/
		public static var YEAR : Number = DAY * 365;

		//protected var mask:Number = ;

		protected var monthDays : Number;
		protected var monthWeeks : Number;
		protected var weekArray : Array;

		public var lastDate : Date = null;

		/*
		Day names in various langauges (sorry, no Arabic or Eastern langauges at this point).
		EN - English
		SP - Spanish
		FR - French
		GR - German
		IT - Italian
		 */

		protected static var dayNameEN : Array = new Array("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday");
		protected static  var dayNameSP : Array = new Array("El Domingo", "El Lunes", "El Martes", "El Miércoles", "El Jueves", "El Viernes", "El Sábado");
		protected static  var dayNameFR : Array = new Array("Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi");
		protected static  var dayNameDE : Array = new Array("Sonntag", "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag");
		protected static  var dayNameIT : Array = new Array("Domenica", "Lunedì", "Martedì", "Mercoledì", "Giovedì", "Venerdì", "Sabato");
		public static var dayNameRO : Array = new Array("Luni", "Marti", "Miercuri", "Joi", "Vineri", "Sambata", "Duminica");
		public static var DAY_NAMES : Array = dayNameEN;
		/*
		Month names in various langauges.
		EN - English
		SP - Spanish
		FR - French
		DE - German
		IT - Italian
		 */
		public static var monthNameRO : Array = new Array("Ianuarie", "Februarie", "Martie", "Aprilie", "Mai", "Iunie", "Iulie", "August", "Septembrie", "Octombrie", "Noiembrie", "Decembrie");
		protected static  var monthNameEN : Array = new Array("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December");
		protected static  var monthNameSP : Array = new Array("Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre");
		protected static  var monthNameFR : Array = new Array("Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre");
		protected static  var monthNameDE : Array = new Array("Januar", "Februar", "Marschiert", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember");
		protected static  var monthNameIT : Array = new Array("Gennaio", "Febbraio", "Marzo", "Aprile", "Maggio", "Giugno", "Luglio", "Agosto", "Settembre", "Ottobre", "Novembre", "Dicembre");
		public static var MONTH_NAMES : Array = monthNameEN;

		public function TDate(year : Number = NaN, month : Number = NaN, date : Number = NaN, hour : Number = NaN, min : Number = NaN, sec : Number = NaN, ms : Number = NaN) {
			super(year, month, date, hour, min, sec, ms);
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
			dispatchEvent({
				type : BaseModelObject.EVTD_MODEL_CHANGED, target : this, oldVal:lastDate, newVal:this
			});
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
		public function decrementYear(num : Number) : Number {
			var by : Number = (num == null) ? 1 : num ;
			return setYear(super.getFullYear() - by);
		}

		public function incrementYear(num : Number) : Number {
			var by : Number = (num == null) ? 1 : num ;
			return setYear(super.getFullYear() + by);
		}

		public function decrementMonth(num : Number) : Number {
			var by : Number = (num == null) ? 1 : num ;
			return setMonth(super.getMonth() - by);
		}

		public function incrementMonth(num : Number) : Number {
			var by : Number = (num == null) ? 1 : num ;
			return setMonth(super.getMonth() + by);
		}

		public function gotoTodaysDate() : void {
			var currentDate : Date = new Date();
			super.setTime(currentDate.getTime());	
		}

		//--------------- overridden from the Date Class ---------------------------------
		public function setFullYear(value : Number) : Number {
			startChangeTransaction();
			var res : Number = super.setFullYear.apply(this, arguments);
			endChangeTransaction();
			return res;
		}

		public function setMonth(value : Number) : Number {
			startChangeTransaction();
			var res : Number = super.setMonth.apply(this, arguments);
			endChangeTransaction();
			return res;
		}

		public function setDate(value : Number) : Number {
			startChangeTransaction();
			var res : Number = super.setDate.apply(this, arguments);
			endChangeTransaction();
			return res;
		}

		public function setHours(value : Number) : Number {
			startChangeTransaction();
			var res : Number = super.setHours.apply(this, arguments);
			endChangeTransaction();
			return res;
		}

		public function setMinutes(value : Number) : Number {
			startChangeTransaction();
			var res : Number = super.setMinutes.apply(this, arguments);
			endChangeTransaction();
			return res;
		}

		public function setSeconds(value : Number) : Number {
			startChangeTransaction();
			var res : Number = super.setSeconds.apply(this, arguments);
			endChangeTransaction();
			return res;
		}

		public function setMilliseconds(value : Number) : Number {
			startChangeTransaction();
			var res : Number = super.setMilliseconds.apply(this, arguments);
			endChangeTransaction();
			return res;
		}

		public function setUTCFullYear(value : Number) : Number {
			startChangeTransaction();
			var res : Number = super.setUTCFullYear.apply(this, arguments);
			endChangeTransaction();
			return res;
		}

		public function setUTCMonth(value : Number) : Number {
			startChangeTransaction();
			var res : Number = super.setUTCMonth.apply(this, arguments);
			endChangeTransaction();
			return res;
		}

		public function setUTCDate(value : Number) : Number {
			startChangeTransaction();
			var res : Number = super.setUTCDate.apply(this, arguments);
			endChangeTransaction();
			return res;
		}

		public function setUTCHours(value : Number) : Number {
			startChangeTransaction();
			var res : Number = super.setUTCHours.apply(this, arguments);
			endChangeTransaction();
			return res;
		}

		public function setUTCMinutes(value : Number) : Number {
			startChangeTransaction();
			var res : Number = super.setUTCMinutes.apply(this, arguments);
			endChangeTransaction();
			return res;
		}

		public function setUTCSeconds(value : Number) : Number {
			startChangeTransaction();
			var res : Number = super.setUTCSeconds.apply(this, arguments);
			endChangeTransaction();
			return res;
		}

		public function setUTCMilliseconds(value : Number) : Number {
			startChangeTransaction();
			var res : Number = super.setUTCMilliseconds.apply(this, arguments);
			endChangeTransaction();
			return res;
		}

		public function setYear(value : Number) : Number {
			startChangeTransaction();
			var res : Number = super.setYear.apply(this, arguments);
			endChangeTransaction();
			return res;
		}

		public function isToday() : Boolean {
			var tmpDate : Date = new Date();
			if(tmpDate.getDate() == super.getDate()) {
				return true;
			}
			return false;
		}

		public function isASunday() : Boolean {
			if(super.getDay() == 0) {
				return true;
			}
			return false;
		}

		public function isAMonday() : Boolean {
			if(super.getDay() == 1) {
				return true;
			}
			return false;
		}

		public function isATuesday() : Boolean {
			if(super.getDay() == 2) {
				return true;
			}
			return false;
		}

		public function isWednesday() : Boolean {
			if(super.getDay() == 3) {
				return true;
			}
			return false;
		}

		public function isAThurdsay() : Boolean {
			if(super.getDay() == 4) {
				return true;
			}
			return false;
		}

		public function isAFriday() : Boolean {
			if(super.getDay() == 5) {
				return true;
			}
			return false;
		}

		public function isASaturday() : Boolean {
			if(super.getDay() == 6) {
				return true;
			}
			return false;
		}

		public function isAWeekday() : Boolean {
			var dN : Number = super.getDay();
			if(  0 < dN || dN < 6 ) {
				return true;
			}
			return false;
		}

		public function isAWeekendDay() : Boolean {
			var dN : Number = super.getDay();
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
		function setDaysInMonth() : void {
			var tempDate : Date = new Date(super.getYear(), this.getMonth() + 1, 0);
			this.monthDays = tempDate.getDate();
		}

		/*
		 * Function:	daysInMonth
		 * Summary:		Returns the total number of days in the object's month
		 * Return:      The total number of days in the month
		 */

		function getDaysInMonth() : Number {
			return this.monthDays;
		}

		/*
		 * Function:	getDaysLeftInMonth
		 * Summary:		Returns the total number of days left in the object's month
		 * Return:      The total number of days left in the month
		 */
		function getDaysLeftInMonth() : Number {
			return this.getDaysInMonth() - super.getDate();
		}

		/*
		 * Function:	getDaysInYear
		 * Summary:		Finds the total amount of days in the object's year
		 * 				primarily useful to detect leap years
		 * Return:      The total number of days in the year
		 */

		function getDaysInYear() : Number {
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
		function getMonthStartDate() : Number {
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
		function getMonthEndDate() : Number {
			var tmpDate : Date = cloneAsDate();
			tmpDate.setDate(getDaysInMonth());
			var day : Number = tmpDate.getDay();
			return day;
		}

		/*
		 * Function:	setWeeksInMonth
		 * Summary:		Sets the total number of weeks in the object's month
		 */
		function setWeeksInMonth() : void {
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

		function getWeeksInMonth() : Number {
			return monthWeeks;
		}

		/*
		 * Function:	getDaysInWeeks
		 * Summary:		Returns an array with the total number of days
		 * 				for each week in the object's month
		 */

		function getDaysInWeeks() : Array {
			var day : Number = 1;
			var weekCount : Number = 0;
			var daysCounted : Number = 0;
			var weekArray : Array = new Array();
			var days : Number = this.getDaysInMonth();
			var i : Number = -1;
			while(++i < days) {
				this.setDate(i + 1);
				if(super.getDay() == 6 && weekCount == 0) {
					weekCount += 1;
					daysCounted = i;
					weekArray.push(daysCounted + 1);
				}
				else if(super.getDay() == 0 && i < days - 7 && i != 0) {
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
		function getDaysInWeek(week : Number) : Number {
			var weeks : Array = daysInWeeks;
			if(week > weeks.length || week < 0) {
				return null;
			}
			return weeks[week];
		}

		/*
		 * Function:	getDay
		 * Summary:		Finds the day for any date specified
		 */
		function getDay(month : Number, year : Number, day : Number) : Number {
			var res : Date = new Date(year, month, day);
			return res.getDay();
		}

		/*
		 * Function:	getDayName
		 * Summary:		Returns the name of the day specified in the language specified
		 * Parametets:	Number of days (starting w/ 0), Language of name (EN = english, FR = french, etc.)
		 */
		function getDayName(day : Number, lang : String) : String {
			if(day >= 0 || day <= 6) {
				switch(lang) {
					case "EN":
						return dayNameEN[day];
						break;
					case "SP":
						return dayNameSP[day];
						break;
					case "FR":
						return dayNameFR[day];
						break;
					case "DE":
						return dayNameDE[day];
						break;
					case "IT":
						return dayNameIT[day];
						break;
					default :
						return dayNameEN[day];
						break;	
				}
			}
			else {
				return null;
			}
		}

		/*
		 * Function:	getMonthName
		 * Summary:		Returns the name of the month specified in the language specified
		 * Parametets:	Number of month (starting w/ 0), Language of name (EN = english, FR = french, etc.)
		 */
		function getMonthName(month : Number, lang : String) : String {
			if(month >= 0 || month <= 11) {
				switch(lang) {
					case "EN":
						return monthNameEN[month];
						break;
					case "SP":
						return monthNameSP[month];
						break;
					case "FR":
						return monthNameFR[month];
						break;
					case "DE":
						return monthNameDE[month];
						break;
					case "IT":
						return monthNameIT[month];
						break;
					default :
						return monthNameEN[month];
						break;	
				}
			}
			else {
				return null;
			}
		}

		public function clone() : TDate {
			//needed to get around type checking in FDT/Mtasc
			var res : TDate = new TDate(this.time);
			return res;
		}

		public function cloneAsDate() : Date {
			//needed to get around type checking in FDT/Mtasc
			//	var f : Function = Date;
			var res : Date = new Date(this.time);
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
	}
}