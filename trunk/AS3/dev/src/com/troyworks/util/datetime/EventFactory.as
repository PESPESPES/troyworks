package com.troyworks.util.datetime {
	import com.troyworks.geom.d1.LineQuery;	
	import com.troyworks.geom.d1.CompoundLine1D;	
	import com.troyworks.data.ArrayX;	
	import com.troyworks.geom.d1.Line1D;	

	/*
	 * EventFactory
	 *
	 *  Author: Troy Gardner  
	 * Copyright (c) TroyWorks 2007-2008   http://www.troyworks.com/
	 * Version: 1.0.0  Created:  Oct 2, 2009
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
	 * DESCRIPTION\
	 * 
	 * EventFactory is loaded up with a configuration and a Timetemplate 
	 * 
	 * TimeTemplate are a collection of tasks eg.
	 *   Make Tea Queue[
	 *     heat water: -3:00, steep tea: -1:00];
	 *     
	 *   Laundry Parallel
	 *   0[washer:-23:00];
	 *   then 1[dryer: -45:00]  repeat x 2 
	 *   
	 *   QA Website
	 *    [ ] test safari
	 *       [ ] test flash10  -1:00
	 *       [ ] test flash9  -1:00
	 *       [ ] test flash8  -1:00
	 *    [ ] test FireFox
	 *       [ ] test flash10  -1:00
	 *       [ ] test flash9 -1:00
	 *       [ ] test flash8 -1:00
	 *       
	 *    Where in the above cases it's serialzied into a list
	 *    of tasks to acheive in a partiuclar time, if you are track
	 *       
	 *    TimeTemplates are 'captured' into logs, when can then be compared
	 *    similar to golfing a par vs actual and difference.
	 *    
	 *    Your Score Report
	 *   QA Website  105%
	 *    [ ] test safari
	 *       [ ] test flash10  :56 par 1:00 = under time 3 seconds/4%
	 *       [ ] test flash9  :52 par 1:00  = under time 5%
	 *       [ ] test flash8  1:05 par 1:00  = over 2%
	 *    [ ] test FireFox
	 *       [ ] test flash10  -1:00
	 *       [ ] test flash9 -1:00
	 *       [ ] test flash8 -1:00

	 * 	 *    
	 */

	public class EventFactory {

		public var eventType : String = "Normal";
		public var trackStartDate : TDate = new TDate();
		public var trackEndDate : TDate = new TDate();
		public var duration : TimeQuantity = new TimeQuantity();

		public var curEventDate : TDate = new TDate();
		public var incrementBy : TimeQuantity = new TimeQuantity();
		public var blackOutDates : Array; //TODO
		//TODO add line for visualization and bounds checking
		//TODO add simple vs composite versions
		//TODO add Boolean/SQL  AND, OR, NOT
		public var SCHEDULE_MAX_ITEMS : int = 100;

		public function EventFactory() {
			super();
		}

		public function getSerializationString() : String {
			trace("EventFactory getSerializationString ");
			trace(" trackStartDate " + trackStartDate.toUTCString());
			trace(" trackEndDate " + trackEndDate.toUTCString());
			trace(" duration " + duration.toString());
			trace(" incrementBy " + incrementBy.toString());
			var strA : String = String(trackStartDate.time);
			var strB : String = String(trackEndDate.time);
			var base : Array = new Array();
			var resA : Array = new Array();
			var resB : Array = new Array();
			var filledBase : Boolean = false;
			for (var i : int = 0;i < strA.length; i++) {
				if(!filledBase && strA.charCodeAt(i) == strB.charCodeAt(i)) {
					base.push(strA.charAt(i));
					if(i < (strA.length - 1) && strA.charCodeAt(i + 1) != strB.charCodeAt(i + 1)) {
						filledBase = true;
					}
				} else {
					resA.push(strA.charAt(i));
					resB.push(strB.charAt(i));
				}
			}
			trace("strA " + strA);
			trace("strB " + strB);
			var baseN : Number = Number(base.join(""));
			var delta : Number = Number(resB.join("")) - Number(resA.join(""));
			return  base.join("") + "_" + resA.join("") + "_" + delta + "_" + (incrementBy.time / 1000) + "_" + (duration.time / 1000);
		}

		public function setSerializationString(str : String, eventType : String) : void {
			trace("EventFactory.setSerializationString");
			this.eventType = eventType;
			var ary : Array = str.split("_");
			var delta : Number = Number(ary[1]) + Number(ary[2]);
			trace("strA " + ary[0] + ary[1]);
			trackStartDate.time = Number(ary[0] + ary[1]);
			trackEndDate.time = Number(String(ary[0]) + String(delta)) ;
			incrementBy.time = Number(ary[3]) * 1000;
			duration.time = Number(ary[4]) * 1000;
			trace(eventType + "_EventFactory configured by SerializationSt ");
			trace(" trackStartDate " + trackStartDate.toUTCString());
			trace(" trackEndDate " + trackEndDate.toUTCString());
			trace(" duration " + duration.toString());
			trace(" incrementBy " + incrementBy.toString());
		}

		public function getSchedule(dateFrom : Date = null, dateTo : Date = null) : ArrayX {
			curEventDate = trackStartDate.clone();
			var res : ArrayX = new ArrayX();
			var i : int = 1;
			var curLin : Line1D;
			trace("incrementBy=>"+incrementBy)
			while(true) {
				if(trackStartDate.time <= curEventDate.time && curEventDate.time <= trackEndDate.time) {
					
					//if(dateFrom == null || dateFrom != null)
					trace(i++ + " " + curEventDate.toTimeString());//+ " " + curEventDate.time + " " + trackEndDate.time);
					curLin = new Line1D(eventType, NaN, curEventDate.time, duration.time);
					res.push(curLin);
					///////////////////Debug Injection ///////////////////////////					
					//if (i == 10){break;}
					///////////////////End Injection  ////////////////////////////
					
					//////////////////// INCREMENT /////////////////////////////
					if(incrementBy.years != 0) {
						//	trace("incrementing years " + incrementBy.years);
						curEventDate.incrementYear(incrementBy.years);	
					}
					if(incrementBy.months != 0) {
						//	trace("incrementing months " + incrementBy.months);

						curEventDate.incrementMonth(incrementBy.months);	
					}
					if(incrementBy.days != 0){
						curEventDate.incrementDay(incrementBy.days);
					}
					if(incrementBy.weeks != 0) {
						//	trace("incrementing weeks " + incrementBy.weeks);
						curEventDate.incrementWeek(incrementBy.weeks);	
					}
					if(incrementBy.hours != 0) {
						//	trace("incrementing hours " + incrementBy.hours);
						curEventDate.incrementHour(incrementBy.hours);	
					}
					if(incrementBy.minutes != 0) {
						//	trace("incrementing minutes " + incrementBy.minutes);

						curEventDate.incrementMinutes(incrementBy.minutes);	
					}
					if(incrementBy.seconds != 0) {
						//	trace("incrementing seocnds " + incrementBy.seconds);

						curEventDate.incrementSeconds(incrementBy.seconds);	
					}
				}else if (i > SCHEDULE_MAX_ITEMS) {
					//to many 
					trace("hitting limit of this schedule");
					break;					
				} else {
					break;
				}
			}
			return res;	
		}

		public function getNextEvent(now : Date = null) : * {
			var C : TDate = new TDate();
			if(now) {
				C.time = now.time;
			}
			var A : TDate = new TDate();
			A.time = C.time - duration.time;
			
			
			var Z : TDate = new TDate();
			Z.time = C.time + duration.time;
		
			curEventDate = trackStartDate.clone();
	
			var i : int = 1;
			var curLin : Line1D;
			var bestMatch : Line1D;
			while(true) {
				if(trackStartDate.time <= curEventDate.time && curEventDae.time <= trackEndDate.time) {
					
					//if(dateFrom == null || dateFrom != null)
					trace(i++ + " " + curEventDate.toTimeString());//+ " " + curEventDate.time + " " + trackEndDate.time);
					curLin = new Line1D(eventType, NaN, curEventDate.time, duration.time);
					if(curLin.Aposition < C.time && C.time <= curLin.Bposition) {
						trace("found one in progress start");
						bestMatch = curLin;
						break;
					}else if(C.time == curLin.Aposition) {
						trace("found one to start");
						bestMatch = curLin;
						break;
					}else if(C.time < curLin.Aposition) {
						trace("found next");
						bestMatch = curLin;
						break;
					}
					//res.addChild(curLin);
					//////////////////// INCREMENT /////////////////////////////
					if(incrementBy.years != 0) {
						//	trace("incrementing years " + incrementBy.years);
						curEventDate.incrementYear(incrementBy.years);	
					}
					if(incrementBy.months != 0) {
						//	trace("incrementing months " + incrementBy.months);

						curEventDate.incrementMonth(incrementBy.months);	
					}
					if(incrementBy.weeks != 0) {
						//	trace("incrementing weeks " + incrementBy.weeks);
						curEventDate.incrementWeek(incrementBy.weeks);	
					}
					if(incrementBy.hours != 0) {
						//	trace("incrementing hours " + incrementBy.hours);
						curEventDate.incrementHour(incrementBy.hours);	
					}
					if(incrementBy.minutes != 0) {
						//	trace("incrementing minutes " + incrementBy.minutes);

						curEventDate.incrementMinutes(incrementBy.minutes);	
					}
					if(incrementBy.seconds != 0) {
						//	trace("incrementing seocnds " + incrementBy.seconds);

						curEventDate.incrementSeconds(incrementBy.seconds);	
					}
				}else if (i > SCHEDULE_MAX_ITEMS) {
					//to many 
					trace("hitting limit of this schedule");
					break;					
				} else {
					break;
				}
			}
			////////////////////////////////////

			
			return bestMatch;
		}

		public function toString() : String {
			trace(eventType + "_EventFactory configured by SerializationSt ");
			trace(" trackStartDate " + trackStartDate.toUTCString());
			trace(" trackEndDate " + trackEndDate.toUTCString());
			trace(" duration " + duration.toString());
			trace(" incrementBy " + incrementBy.toString());
			return "com.troyworks.util.datetime.EventFactory";
		}
	}
}
