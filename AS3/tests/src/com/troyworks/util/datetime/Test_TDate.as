package com.troyworks.util.datetime {
	import com.troyworks.geom.d1.Line1D;	
	import com.troyworks.data.ArrayX;	
	import com.troyworks.apps.tester.SynchronousTestSuite;

	/*
	 * Test_TDate
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
	 * DESCRIPTION
	 */

	public class Test_TDate extends SynchronousTestSuite {
		private var td : TDate;

		public function Test_TDate() {
			super();
		}

		/*	public function test_setWeeksInMonth() : Boolean {
		var res : Boolean = true;
		td = new TDate();
		td.setWeeksInMonth();
		var cnt:int = 24;
		while(cnt--){
		trace(td.fullYear + " " + td.month + " has weeks " + td.getWeeksInMonth());
		td.incrementMonth();
		td.setWeeksInMonth();
		//res = ASSERT(td.time == 0, "TimeQuantitymust be equal to 0 " + td.time);
		}
		
		return res;
		}*/
		/*public function test_incrementWeek() : Boolean {
		var res : Boolean = true;
		td = new TDate();
		//////////// SET ORIGIN DATE////////////
		td.setUTCMonth(9);
		td.setUTCDate(1);
		//////////// SET ORIGIN TIME////////////
		td.setUTCHours(16);
		td.setUTCMinutes(0);
		td.setUTCSeconds(0);
		var cnt:int = 52; //REPEAT 52 times (1 year)
		var i:int=0;
		while(cnt--){
		trace(i++ + " " +td.toTimeString());
		td.incrementWeek();
		//res = ASSERT(td.time == 0, "TimeQuantitymust be equal to 0 " + td.time);
		}
		return res;
		}*/
		/*public function test_incrementWeekFromTo() : Boolean {
		var res : Boolean = true;
		var startDate : TDate = new TDate();
		var trackStartDate : TDate = new TDate();
		//////////// SET ORIGIN DATE////////////
		startDate.setUTCMonth(9);
		startDate.setUTCDate(1);
		startDate.setUTCFullYear(2009);
		endDate.setUTCMonth(11);
		endDate.setUTCDate(31);
		endDate.setUTCFullYear(2009);
		//////////// SET ORIGIN TIME////////////
		startDate.setUTCHours(16);
		startDate.setUTCMinutes(0);
		startDate.setUTCSeconds(0);
		endDate.setUTCHours(16);
		endDate.setUTCMinutes(0);
		endDate.setUTCSeconds(0);
			
		var i : int = 1;
		while(true) {
		trace(i++ + " " + startDate.toTimeString());
				
		if(startDate.time >= endDate.time) {
		break;
		} else {
		startDate.incrementWeek();	
		}
		}
		return res;
		}*/
		
		/*	public function test_incrementHourFromTo() : Boolean {
		var res : Boolean = true;
		var startDate : TDate = new TDate();
		var endDate : TDate = new TDate();
		//////////// SET ORIGIN DATE////////////
		startDate.setUTCMonth(9);
		startDate.setUTCDate(1);
		startDate.setUTCFullYear(2009);
		endDate.setUTCMonth(9);
		endDate.setUTCDate(1);
		endDate.setUTCFullYear(2009);
		//////////// SET ORIGIN TIME////////////
		startDate.setUTCHours(20);
		startDate.setUTCMinutes(0);
		startDate.setUTCSeconds(0);
		endDate.setUTCHours(24);
		endDate.setUTCMinutes(0);
		endDate.setUTCSeconds(0);
			
		var i : int = 1;
		while(true) {
		trace(i++ + "HR " + startDate.toTimeString() + " " + startDate.time + " "+  endDate.time);
				
		if(startDate.time >= endDate.time) {
		break;
		} else {
		startDate.incrementHour();	
		}
		}
		return res;
		}*/
		/*public function test_EventFactoryincrementHourFromTo() : Boolean {
		var res : Boolean = true;
		var evtF : EventFactory = new EventFactory();
		//////////// SET ORIGIN DATE////////////
		evtF.startDate.setUTCMonth(9);
		evtF.startDate.setUTCDate(1);
		evtF.startDate.setUTCFullYear(2009);
		evtF.endDate.setUTCMonth(9);
		evtF.endDate.setUTCDate(1);
		evtF.endDate.setUTCFullYear(2009);
		//////////// SET ORIGIN TIME////////////
		evtF.startDate.setUTCHours(20);
		evtF.startDate.setUTCMinutes(0);
		evtF.startDate.setUTCSeconds(0);
		evtF.endDate.setUTCHours(24);
		evtF.endDate.setUTCMinutes(0);
		evtF.endDate.setUTCSeconds(0);
		
		evtF.incrementBy.hours = 1/3;
		trace("CONFIG= " + evtF.getSerializationString());
		evtF.getSchedule();
		return res;
		}*/
		/*public function test_EventFactoryConfig() : Boolean {
		var res : Boolean = true;
		var evtF : EventFactory = new EventFactory();
		var evtBBB : EventFactory = new EventFactory();
		//////////// SET ORIGIN DATE////////////
		evtF.trackStartDate.setUTCMonth(9);
		evtF.trackStartDate.setUTCDate(2);
		evtF.trackStartDate.setUTCFullYear(2009);
		evtF.trackEndDate.setUTCMonth(9);
		evtF.trackEndDate.setUTCDate(30);
		evtF.trackEndDate.setUTCFullYear(2009);
		//////////// SET ORIGIN TIME////////////
		evtF.trackStartDate.setUTCHours(20);
		evtF.trackStartDate.setUTCMinutes(0);
		evtF.trackStartDate.setUTCSeconds(0);
		evtF.trackEndDate.setUTCHours(20);
		evtF.trackEndDate.setUTCMinutes(0);
		evtF.trackEndDate.setUTCSeconds(0);
		evtF.incrementBy.weeks = 1;
		evtF.duration.hours = 4;
		var config:String =  evtF.getSerializationString(); 
		trace("CONFIG= " +config);
		evtBBB.setSerializationString(config);
			
			
		evtBBB.getSchedule();
		return res;
		}*/
		/*public function test_EventFactoryConfigMultiEntry() : Boolean {
			var res : Boolean = true;
			var evtLIVE : EventFactory = new EventFactory();
			var evtREPLAY1 : EventFactory = new EventFactory();
			var evtREPLAY2 : EventFactory = new EventFactory();
			var evtDOWNLOAD : EventFactory = new EventFactory();
			var evtBLACKOUT : EventFactory = new EventFactory();
			//////////// SET ORIGIN DATE////////////
			evtLIVE.trackStartDate.setUTCMonth(8);
			evtLIVE.trackStartDate.setUTCDate(2);
			evtLIVE.trackStartDate.setUTCFullYear(2009);
			evtLIVE.trackEndDate.setUTCMonth(10);
			evtLIVE.trackEndDate.setUTCDate(3);
			evtLIVE.trackEndDate.setUTCFullYear(2009);
			//////////// SET ORIGIN TIME////////////
			evtLIVE.trackStartDate.setUTCHours(20);
			evtLIVE.trackStartDate.setUTCMinutes(0);
			evtLIVE.trackStartDate.setUTCSeconds(0);
			evtLIVE.trackEndDate.setUTCHours(20);
			evtLIVE.trackEndDate.setUTCMinutes(0);
			evtLIVE.trackEndDate.setUTCSeconds(0);
			evtLIVE.incrementBy.weeks = 1;
			evtLIVE.duration.hours = 4;
			evtLIVE.eventType = "LIVE";
			var config : String = evtLIVE.getSerializationString(); 
			trace("CONFIG= " + config);
			//////////// ECHO1 ///////////////////////
			evtREPLAY1.setSerializationString(config, "REPLAY1");
			evtREPLAY1.trackStartDate.setUTCDate(evtLIVE.trackStartDate.getUTCDate() + 1);
			evtREPLAY1.trackStartDate.setUTCHours(6);
			evtREPLAY1.trackEndDate.setUTCHours(6);
			evtREPLAY1.trackEndDate.setUTCDate(evtLIVE.trackEndDate.getUTCDate() + 1);
			//////////// ECHO2 ///////////////////////
			evtREPLAY2.setSerializationString(config, "REPLAY2");
			evtREPLAY2.trackStartDate.setUTCDate(evtLIVE.trackStartDate.getUTCDate() + 3);
			evtREPLAY2.trackStartDate.setUTCHours(12);
			evtREPLAY2.trackEndDate.setUTCHours(12);
			evtREPLAY2.trackEndDate.setUTCDate(evtLIVE.trackEndDate.getUTCDate() + 3);
			//////////// ECHO3 ///////////////////////
			evtREPLAY2.setSerializationString(config, "DOWNLOAD");
			evtREPLAY2.duration.zero();
			evtREPLAY2.duration.hours = 24;
			evtREPLAY2.toString();
			evtREPLAY2.trackStartDate.setUTCDate(evtLIVE.trackStartDate.getUTCDate() + 4);
			evtREPLAY2.trackStartDate.setUTCHours(0);
			evtREPLAY2.trackEndDate.setUTCHours(0);
			evtREPLAY2.trackEndDate.setUTCDate(evtLIVE.trackEndDate.getUTCDate() + 4);
			var resX : ArrayX = evtLIVE.getSchedule();
			resX.appendArray(evtREPLAY1.getSchedule());
			resX.appendArray(evtREPLAY2.getSchedule());
			resX.sortOn(["Aposition"], [Array.NUMERIC]);
			trace("YOUR SCHEDULE IS========================= ");
			for (var i : int = 0;i < resX.length; i++) {
				var cLine : Line1D = resX[i] as Line1D;
				trace(i + "  " + cLine.toUTCString());
			}
			return res;
		}*/
				public function test_EventFactoryConfigMultiEntry() : Boolean {
			var res : Boolean = true;
			var evtLIVE : EventFactory = new EventFactory();
			
			//////////// SET ORIGIN DATE////////////
			evtLIVE.trackStartDate.setUTCMonth(8);
			evtLIVE.trackStartDate.setUTCDate(2);
			evtLIVE.trackStartDate.setUTCFullYear(2009);
			evtLIVE.trackEndDate.setUTCMonth(10);
			evtLIVE.trackEndDate.setUTCDate(3);
			evtLIVE.trackEndDate.setUTCFullYear(2009);
			//////////// SET ORIGIN TIME////////////
			evtLIVE.trackStartDate.setUTCHours(20);
			evtLIVE.trackStartDate.setUTCMinutes(0);
			evtLIVE.trackStartDate.setUTCSeconds(0);
			evtLIVE.trackEndDate.setUTCHours(20);
			evtLIVE.trackEndDate.setUTCMinutes(0);
			evtLIVE.trackEndDate.setUTCSeconds(0);
			evtLIVE.incrementBy.weeks = 1;
			evtLIVE.duration.hours = 4;
			evtLIVE.eventType = "LIVE";
			var resX : ArrayX = evtLIVE.getSchedule();
			resX.sortOn(["Aposition"], [Array.NUMERIC]);
			trace("YOUR SCHEDULE IS========================= ");
			for (var i : int = 0;i < resX.length; i++) {
				var cLine : Line1D = resX[i] as Line1D;
				trace(i + "  " + cLine.toUTCString());
			}
			trace("NEXT Enry " +  evtLIVE.getNextEvent(null).toUTCString());
			
			
			return res;
		}
	}
}
