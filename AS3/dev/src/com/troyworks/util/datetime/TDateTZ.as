package com.troyworks.util.datetime {
	import com.troyworks.util.datetime.TDate;
	import flash.events.Event;
	/*
	 * TDateTX
	 *
	 *  Author: Troy Gardner  
	 * Copyright (c) TroyWorks 2007-2008   http://www.troyworks.com/
	 * Version: 1.0.0  Created:  Oct 17, 2009
	 * 
	 * License Agreement
	 * 
	 * Permission is hereby granted, free of charge, to any person obtaining a copy
	 * of this software and associated documentation files (the "Software"), to deal
	 * in the Software without restriction, including without limitation the rights
	 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	 * copies of the Software, and to permit persons to whom the Software is
	 * furnished to do so, subject to the following conditions:
	 * 
	 * The above copyright notice and this permission notice shall be included in
	 * all copies or substantial portions of the Software.
	 * 
	 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	 * THE SOFTWARE.
	 *
	 * DESCRIPTION
	 */

	import flash.utils.Dictionary;

	public class TDateTZ extends TDate {
	private var zones:Dictionary;
		private var _timeZoneOffset:Number;
		private var _dlsOffset:Number;
		private var _timeZone:String;
		private var Rules:Array;
		private var fRules:Array;
				
		public function TDateTZ(zones:Dictionary,rules:Array ,timeZone:String = "" ,year : Number = NaN, month : Number = NaN, date : Number = NaN, hour : Number = 0, min : Number = 0, sec : Number = 0, ms : Number = 0){
			super(year, month, date, hour, min, sec, ms);
			Rules = rules;
			this.zones = zones;
			timeZone = (timeZone == "")?"Etc/GMT":timeZone;
			_timeZone = timeZone;
			
			var tmp:Date = new Date;
			var tempTime:Number = tmp.timezoneOffset;
			_timeZoneOffset = getOffset(timeZone);
			var dif:Number = _timeZoneOffset - tempTime;
			setTime(getTime()+ dif*60000);			
			////////////////////////////////////////////////////////
			_dlsOffset = getCurrentRuleOffset ();
			setTime(getTime()- _dlsOffset);			
			////////////////////////////////////////////////////////
			
		}
		
		
		override public function get timezoneOffset ():Number{
			return (_timeZoneOffset - _dlsOffset/60000);
		}
		
		
		public function set timeZone (TimeZone:String){
			var tempTime:Number = _timeZoneOffset;
			_timeZoneOffset = getOffset(TimeZone);
			var dif:Number = _timeZoneOffset - tempTime;
			setTime(getTime() + dif*60000);
			////////////////////////////////////////////////////////
			_dlsOffset = getCurrentRuleOffset ();
			setTime(getTime()- _dlsOffset);			
			////////////////////////////////////////////////////////

		}
		
		public function get timeZone (){
			return _timeZone;
		}
		
		public function changeTimeZone (TimeZone:String , updateTime:Boolean = true){
			if (updateTime){
				timeZone = TimeZone;
			}
			else{
				_timeZone = TimeZone;
				_timeZoneOffset = getOffset(TimeZone);				
			}
		}
		public override function toString():String{
			var tmpD:Date = new Date(super.getTime());			
			var tmpOffset = _timeZoneOffset - _dlsOffset/60000;
			var dif:Number = tmpOffset - super.getTimezoneOffset();
			tmpD.setTime(getTime() - dif*60000);
			var str = tmpD.toString();			
			var parts:Array = str.split(" ");
			
			var hrs:int = -1*(tmpOffset/60);
			var mins:int = tmpOffset%60;
			mins = (mins < 0)?(-1*mins):mins;			
			var hr:String = (hrs>0)?("+"+hrs):hrs.toString();
			if (hrs == 0 )
				hr = " "+hr;
			var h:String = hr.substr(1);
			h = (h.length<2)?"0"+h:h;
			h = hr.charAt(0)+h;			
			var min:String = (mins<10)?("0"+mins):mins.toString();
			parts[4] = "GMT"+h+min;
			return parts.join(" ");
		}
		
		public override function toTimeString():String{
			var tmpD:Date = new Date(super.getTime());	
			var tmpOffset = _timeZoneOffset - _dlsOffset/60000;
			var dif:Number = tmpOffset - super.getTimezoneOffset();
			tmpD.setTime(getTime() - dif*60000);
			var str = tmpD.toTimeString();

			var parts:Array = str.split(" ");
			var hrs:int = -1*(tmpOffset/60);
			var mins:int = tmpOffset%60;
			var hr:String = (hrs>0)?("+"+hrs):hrs.toString();
			var h:String = hr.substr(1);
			h = (h.length<2)?"0"+h:h;
			h = hr.charAt(0)+h;			
			var min:String = (mins<10)?("0"+mins):mins.toString();
			parts[1] = "GMT"+h+min;
			return parts.join(" ");
		}
		private function filterRules (){
			fRules = new Array ();
			var rName = this.zones[_timeZone][2];
			
			for (var i=0; i<this.Rules.length; i++){
				if (this.Rules[i][0] == rName){
					fRules.push(this.Rules[i]);
					//trace (this.Rules[i]);
				}
			}
		}
		private function findMax (from:int):Number{
			for (var i=from; i>-1; i--){
				if (fRules[i][6] == "max")
				{
					return i;
				}
			}
			return -1;
		}
		private function getCurrentRuleOffset ():Number{
			var time:Number = super.getTime();
			var t:Date;
			var newt : Date;
			
			for (var i = fRules.length-1; i>-1; i--){
				trace("Rule1 = "+fRules[i]);
				if (fRules[i][6] == "max")
				{					
					var prev = findMax(i-1);
					if (prev > -1){						
						trace("Rule2 = "+fRules[prev]);
						if (fRules[prev][2] > fRules[i][2])
						{
							newt = new Date (getFullYear()-1,fRules[prev][2],fRules[prev][3]);	
							t = new Date (getFullYear(),fRules[i][2],fRules[i][3]);	
						}
						else
						{
							newt = new Date (getFullYear(),fRules[prev][2],fRules[prev][3]);	
							t = new Date (getFullYear(),fRules[i][2],fRules[i][3]);	
						}
						trace("This = "+t+" That="+newt);
						if (time < t.time && time > newt.time){
							trace("applying that");
							return fRules[prev][5];
						}						
						else
						{
							trace("applying this");							
							return fRules[i][5];
						}
					}
					else
					{
						t = new Date (getFullYear(),fRules[i][2],fRules[i][3]);	
					}					
				}
				else if (fRules[i][6] == "only")
					t = new Date (fRules[i][1],fRules[i][2],fRules[i][3]);
				else 
					t = new Date (fRules[i][6],fRules[i][2],fRules[i][3]);

				if (t.time < time){		
					return fRules[i][5];
				}
			}
			return 0;
		}
		
	
		private function getOffset (timeZone:String):int{
			_timeZone = (timeZone == "")?"Etc/GMT":timeZone;
			filterRules();
			var val:String = this.zones[_timeZone][1];
			var parts:Array = val.split(":");
			var hrs:int;
			var mins:int=0;
			var factor:int =1;
			if (timeZone.indexOf("Etc/")!=0)
				factor = -1;
			
			hrs = factor*int(parts[0]);
			if (parts.length == 2){
				mins = int(parts[1]);
			}
			
			var total = hrs*60;
			if (hrs<0){
				total = total-mins;
			}
			else{
				total = total+mins;
			}
			return total;
		}
		public override function clone(): TDate {
			var tmp : Date = new Date (time);				
			var tzdate : TDateTZ = new TDateTZ (zones,Rules,timeZone,tmp.getFullYear(),tmp.getMonth(),tmp.getDate(), tmp.getHours(),tmp.getMinutes(),tmp.getSeconds(),tmp.getMilliseconds());
			return tzdate;
		}
		
		
		public override function get minutes() : Number {
			return getDateCopy().minutes;
		}

		public override function set minutes(newMinutes : Number) : void {
			var tmpD:Date = new Date(super.getTime());
			tmpD.minutes = newMinutes;
			changeState(tmpD);
		}

		
		public override function get fullYear() : Number {
			return getDateCopy().fullYear;
		}
		

		public override function get seconds() : Number {
			return getDateCopy().seconds;
		}
		
		private function changeState ( tmpD :Date)
		{
			var dif:Number = _timeZoneOffset - super.getTimezoneOffset();
			tmpD.setTime(tmpD.getTime() + dif*60000);
			super.time= tmpD.time;
			////////////////////////////////////////////////////////
			_dlsOffset = getCurrentRuleOffset ();
			setTime(getTime()- _dlsOffset);			
			////////////////////////////////////////////////////////			
		}
		public override function set seconds(newSeconds : Number) : void {
			var tmpD:Date = new Date(super.getTime());
			tmpD.seconds = newSeconds;
			changeState (tmpD );
		}

		
		public override function get month() : Number {
			var tmpD:Date = new Date(super.getTime());			
			var dif:Number = (_timeZoneOffset - _dlsOffset/60000 ) - super.getTimezoneOffset();
			tmpD.setTime(getTime() - dif*60000);			
			return tmpD.month;
		}

		public override function set month(newMonth : Number) : void {
			var tmpD:Date = new Date(super.getTime());
			tmpD.month = newMonth;			
			changeState (tmpD );
		}
		
		public override function get milliseconds() : Number {
			return getDateCopy().milliseconds;
		}

		public override function set milliseconds(newMilliseconds : Number) : void {
			var tmpD:Date = new Date(super.getTime());
			tmpD.milliseconds = milliseconds;			
			changeState (tmpD );
		}
		
		public override function get hours() : Number {
			return getDateCopy().hours;
		}

		public override function set hours(newHours : Number) : void {
			var tmpD:Date = new Date(super.getTime());
			tmpD.hours = newHours;			
			changeState (tmpD );
		}

		
		public override function get day() : Number {
			return getDateCopy().day;
		}
		
		public override function get time() : Number {
			return getDateCopy().time;
		}
		
		
		public override function set time(newTime : Number) : void {
			var tmpD:Date = new Date(super.getTime());
			tmpD.time = newTime;			
			changeState (tmpD );
		}

		public override function get date() : Number {
			return getDateCopy().date;
		}

		public override function set date(newDate : Number) : void {
			var tmpD:Date = new Date(super.getTime());
			tmpD.date = newDate;			
			changeState (tmpD );
		}
		
		public override function toDateString():String{
			return getDateCopy().toDateString();
		}
		public override function toLocaleDateString():String{
			return getDateCopy().toLocaleDateString();
		}
		public override function toLocaleString():String{
			return getDateCopy().toLocaleString();
		}
		public override function toLocaleTimeString():String{			
			return getDateCopy().toLocaleTimeString();
		}		
		
		private function getDateCopy ():Date{
			var tmpD:Date = new Date(super.getTime());			
			var dif:Number = (_timeZoneOffset - _dlsOffset/60000 ) - super.getTimezoneOffset();
			tmpD.setTime(getTime() - dif*60000);
			return tmpD;
		}
	}
}
