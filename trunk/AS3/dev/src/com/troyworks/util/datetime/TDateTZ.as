package com.troyworks.util.datetime {
	import com.troyworks.util.datetime.TDate;
	
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
		private var _timeZone:String;

		
		public function TDateTZ(zones:Dictionary, timeZone:String = "" ,year : Number = NaN, month : Number = NaN, date : Number = NaN, hour : Number = NaN, min : Number = NaN, sec : Number = NaN, ms : Number = NaN){
			super(year, month, date, hour, min, sec, ms);
			this.zones = zones;
			timeZone = (timeZone == "")?"Etc/GMT":timeZone;
			_timeZone = timeZone;
			var tmp:Date = new Date;
			var tempTime:Number = tmp.timezoneOffset;
			_timeZoneOffset = getOffset(timeZone);
			var dif:Number = _timeZoneOffset - tempTime;
			setTime(getTime()-dif*60000);
		}
		
		override public function get timezoneOffset ():Number{
			return _timeZoneOffset;
		}
		
		public function set timeZone (TimeZone:String){
			_timeZone = TimeZone;
			var tempTime:Number = _timeZoneOffset;
			_timeZoneOffset = getOffset(TimeZone);
			var dif:Number = _timeZoneOffset - tempTime;
			setTime(getTime()-dif*60000);
		}
		
		public function get timeZone (){
			return _timeZone;
		}
		
		public override function toString():String{
			var str:String = super.toString();
			var parts:Array = str.split(" ");
			var hrs:int = -1*(_timeZoneOffset/60);
			var mins:int = _timeZoneOffset%60;
			var hr:String = (hrs>0)?("+"+hrs):hrs.toString();
			var h:String = hr.substr(1);
			h = (h.length<2)?"0"+h:h;
			h = hr.charAt(0)+h;			
			var min:String = (mins<10)?("0"+mins):mins.toString();
			parts[4] = "GMT"+h+min;
			return parts.join(" ");
		}
		
		public override function toTimeString():String{
			var str:String = super.toTimeString();
			var parts:Array = str.split(" ");
			var hrs:int = -1*(_timeZoneOffset/60);
			var mins:int = _timeZoneOffset%60;
			var hr:String = (hrs>0)?("+"+hrs):hrs.toString();
			var h:String = hr.substr(1);
			h = (h.length<2)?"0"+h:h;
			h = hr.charAt(0)+h;			
			var min:String = (mins<10)?("0"+mins):mins.toString();
			parts[1] = "GMT"+h+min;
			return parts.join(" ");
		}
		
		private function getOffset (timeZone:String):int{
			timeZone = (timeZone == "")?"Etc/GMT":timeZone;
			var val:String = this.zones[timeZone];
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
		//public
	}
}
