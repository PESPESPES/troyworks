/**
 * ...
 * @author Default
 * @version 0.1
 */

package com.troyworks.util.datetime {

import flash.profiler.showRedrawRegions;	public class TimeDateFormat {
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
		//////////////////////////
		public var show_milliseconds : Boolean = false;
		public var show_seconds : Boolean = false;
		public var show_minute : Boolean = false;
		public var show_hour : Boolean = false;
		public var show_day : Boolean = false;
		public var show_week : Boolean = false;
		public var show_month : Boolean = false;
		public var show_quarters : Boolean = false;
		public var show_year : Boolean = false;

		public function TimeDateFormat() {
		}

		public static function getDefaultMinSec() : TimeDateFormat {
			var res : TimeDateFormat = new TimeDateFormat();
			res.show_seconds = true;
			res.show_minute = true;
			return res;
		}

		public static  function padTo(number : Number, characters : Number = 3, spacer : String = "0") : String {
			var res : Array = String(number).split('');
			if(res.length < characters) {
				var dif : int = characters - res.length;
				while(dif--) {
					res.unshift(spacer);
				}
			}
			return res.join('');
		}

		public static function formatToString(val : Number) : String {
			var res : TimeQuantity = TimeQuantity.parseRelativeTime(val);
			return res.hours + ":" + res.minutes + ":" + res.seconds + "." + res.milliseconds;
		}
		public static function toStopWatchString(val:Number, includeHours:Boolean = false) : String{
			var res:TimeQuantity = TimeQuantity.parseRelativeTime(val);
			if(includeHours){
				return padTo(res.minutes,2,"0")+":"+ padTo(res.seconds,2,"0");
			}else{
				return (res.hours)+":"+padTo(res.minutes,2,"0")+":"+ padTo(res.seconds,2,"0");
			}
		}
		
		public function toDateTimeString(val:Number) : String{
			var res:TimeQuantity = TimeQuantity.parseRelativeTime(val);
			return res.years+"-"+padTo(res.months,2,"0")+"-"+padTo(res.days,2,"0")+" "+ padTo(res.hours,2,"0")+":"+padTo(res.minutes,2,"0")+":"+ padTo(res.seconds,2,"0");
		}
		
		public function toClockString(val:Number) : String{
			var res:TimeQuantity = TimeQuantity.parseRelativeTime(val);
			return res.hours +":"+ res.minutes+":"+ res.seconds;
		}
		
		 public function toString(val:Number) : String{
			var res:TimeQuantity = TimeQuantity.parseRelativeTime(val);
			return res.hours +":"+ res.minutes+":"+ res.seconds+"."+ res.milliseconds;
		}
		
	
		
		//
		// PiXELWiT Number Suffix function.
		// Works with any positive whole number.
		// e.d. 13 -> 13th
		// e.g. 2 - 2nd
		public static function getNumberSuffix(num : Number) : String {
			if(num == 0)
				return "";
			if(Math.floor(num / 10) % 10 === 1)
				return "th";
			num %= 10;
			if(num > 3 || num === 0)
					return "th";
			if(num === 1)
					return "st";
			if(num === 2)
					return "nd";
			//else
			return "rd";
		}

		/*
		 * Function:	getDayName
		 * Summary:		Returns the name of the day specified in the language specified
		 * Parametets:	Number of days (starting w/ 0), Language of name (EN = english, FR = french, etc.)
		 */
		public static function getDayName(day : Number, lang : String) : String {
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
		public static function getMonthName(month : Number, lang : String) : String {
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
	}
}
