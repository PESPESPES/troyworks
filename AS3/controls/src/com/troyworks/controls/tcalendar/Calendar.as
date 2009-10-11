package com.troyworks.controls.tcalendar {
	import flash.events.IEventDispatcher;	

	import fl.controls.ComboBox;

	import com.troyworks.core.cogs.CogEvent;
	import com.troyworks.data.DataChangedEvent;
	import com.troyworks.framework.model.BaseModelObject;
	import com.troyworks.framework.ui.BaseComponent;
	import com.troyworks.util.Trace;
	import com.troyworks.util.datetime.TDate;
	import com.troyworks.util.datetime.TimeDateFormat;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;		

	/**
	 * @author Troy Gardner
	 */

	
	public class Calendar extends BaseComponent {

		// stores the selected date
		// you can get the selected date with getSelectedDate() function, too
		public  var selectedDate : TDate;

		public var prevprevButton : MovieClip;
		public var prevButton : MovieClip;
		public var nextnextButton : MovieClip;
		public var nextButton : MovieClip;
		public var todayButton : MovieClip;
		public var months_cmb : ComboBox;
		public var years_cmb : ComboBox;

		protected var myDate : Date;

		protected var dayHead0 : MovieClip;

		protected var dayHead : MovieClip;

		protected var month : TextField;

		protected var dayItem0 : CalendarDay;

		protected var dayItem : CalendarDay;

		protected var dayHeaderClips : Array;

		protected var daysClips : Array;

		public var todaysDate : TDate;
		public var DAYCLIP : Class;
		public var hasFocus : Boolean = false;
		public var childHasFocus : Boolean = false;
		public var dayClass : Class;

		public function Calendar() {
			super(null, "Calendar", true);
			selectedDate = new TDate();
			todaysDate = new TDate();
			selectedDate.addEventListener(BaseModelObject.EVTD_MODEL_CHANGED, this.onDateChanged);
		}

		public function gotoPrevYear() : void {
			selectedDate.decrementYear();
		}

		public function gotoPrevMonth() : void {
			selectedDate.decrementMonth();
		}

		public function gotoNextYear() : void {
			selectedDate.incrementYear();
		}

		public function gotoNextMonth() : void {
			selectedDate.incrementMonth();
		}

		public function gotoTodaysDate() : void {
			selectedDate.gotoTodaysDate();
		}

		public function onDateChanged() : void {
			//unloadDays();
			
			//loadCalendar();
			trace("OnDateChanged");
			tran(s1_viewCreated);
		}

		// ///////////////////////////////////////////////////////////////////////////////////
		public function selectDate(newDate : Number) : void {
			selectedDate.setDate(newDate);
			var de : DataChangedEvent = new DataChangedEvent(BaseModelObject.EVTD_MODEL_CHANGED);
			de.currentVal = selectedDate;
			dispatchEvent(de);
		}

		protected function onYearComboChanged(evt : Object) : void {
			trace(Trace.me(evt, "EVT onYearComboChanged", true));
			var cmb : ComboBox = ComboBox(evt.target);
			selectedDate.setFullYear(cmb.selectedItem.data);
		}

		protected function onMonthsComboChanged(evt : Object) : void {
			trace(Trace.me(evt, "EVT onMonthsComboChanged", true));
			var cmb : ComboBox = ComboBox(evt.target);
			selectedDate.setMonth(cmb.selectedItem.data);
		}

		public function getStartWeekDay() : Number {
			myDate = new Date(selectedDate.getFullYear(), selectedDate.getMonth(), 1);
			var weekDay : Number = myDate.getDay();
			/*if (SELECTED_LANGUAGE == LANGUAGE_RO) {
			if (weekDay == 0) {
			weekDay = 6;
			} else {
			weekDay--;
			}
			}*/
			return weekDay;
		}

		public function onSetFocus() : void {
			var e : Event = new Event("focusIn");
			
		
			this.dispatchEvent(e);
			hasFocus = true;
		}

		public function onKillFocus() : void {
			var e : Event = new Event("focusOut");
			this.dispatchEvent(e);
			hasFocus = false;
		}

		public function getSelectedDate() : TDate {
			return selectedDate;
		}

		/*.................................................................*/
		override public function s0_viewAssetsLoaded(e : CogEvent) : Function {
			//this.onFunctionEnter ("s0_viewAssetsLoaded-", e, []);
			switch (e.sig) {
				case SIG_ENTRY :
					{
					var i : int;
					REQUIRE(dayHead0 != null, "dayHead0 must be present");
					//////////////////////////// Populate the combo boxes ////////////////
					months_cmb.removeAll();
					for (i = 0;i < TimeDateFormat.MONTH_NAMES.length; i++) {
						months_cmb.addItem({label:TimeDateFormat.MONTH_NAMES[i], data:i});
					}
					months_cmb.addEventListener("change", onMonthsComboChanged);
					years_cmb.removeAll();
					for (i = 0;i < 70; i++) {
						var yr : Number = selectedDate.getFullYear() - i;
						years_cmb.addItem({label:yr, data:yr});
					}
					years_cmb.addEventListener("change", onYearComboChanged);
					
					/////////////////////////// Create the Headers e.g. Monday, Tuesday ////////////////////////////////////////
					dayHeaderClips = new Array();
					for (i = 0;i < 7; i++) {
						var day_mc : MovieClip;
						if (i > 0) {
							day_mc = dayHead0.duplicateMovieClip("dayHead" + i, 100 + i);
						} else {
							day_mc = dayHead0;
						}
						trace("dayHead " + day_mc.name + "  i " + i);
						day_mc.x = dayHead0.x + i * 25;
						day_mc.day.text = TimeDateFormat.DAY_NAMES[i].substr(0, 2);
						dayHeaderClips.push(day_mc);
					}
					//////////// Link the buttons ///////////////////////////
					if(prevprevButton) {
						prevprevButton.addEventListener(MouseEvent.CLICK, gotoPrevYear) ;
					}
					if(prevprevButton) {
						prevButton.addEventListener(MouseEvent.CLICK, gotoPrevMonth) ;
					}
					if(prevprevButton) {
						nextnextButton.addEventListener(MouseEvent.CLICK, gotoNextYear) ;
					}
					if(prevprevButton) {
						nextButton.addEventListener(MouseEvent.CLICK, gotoNextMonth) ;
					}
					//nextButton.todayButton = TProxy.create(this, this.gotoPrevYear) ;
					return null;
					}
			}
			return super.s0_viewAssetsLoaded(e);
		}

		/*.................................................................*/
		override public function s1_creatingView(e : CogEvent) : Function {
			//	this.onFunctionEnter ("s1_creatingView-", e, []);
			switch (e.sig) {
				case SIG_ENTRY :
					{
	
					return null;
				}
				case SIG_EXIT :
				{
					return null;
				}
				case SIG_INIT :
				{
				//	Q_INIT();
					return s1_viewCreated;
				}
			}
			return s0_viewAssetsLoaded;
		}
		/*.................................................................*/
		override public function s1_viewCreated(e : CogEvent) : Function
		{
		//	this.onFunctionEnter ("s1_creatingView-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{				///////////////////////////////////////////////////////////////////
					month.text = TimeDateFormat.MONTH_NAMES[selectedDate.getMonth()]+", "+selectedDate.getFullYear();
					months_cmb.selectedIndex(selectedDate.getMonth());
					months_cmb.addEventListener("focusIn",onSetFocus);
					months_cmb.addEventListener("focusOut",onSetFocus);
					
					var today:Date = new Date();
					years_cmb.selectedIndex(today.getFullYear() -selectedDate.getFullYear());
					years_cmb.addEventListener("focusIn",onSetFocus);
					years_cmb.addEventListener("focusOut",onSetFocus);
					
					daysClips = new Array();
					/////////////////////////// Create the Days e.g. 1, 2, 3  ////////////////////////////////////////
					var daysNo : Number = selectedDate.getDaysInMonth();
					var startDay : Number = getStartWeekDay();
					var row : Number = 0;
					var col : Number = startDay;
					for (var i : Number = 0; i<daysNo; i++) {
						var initObj:Object = new Object();
						initObj.x = dayHead0.x+col*25;
						initObj.y = dayHead0.y+(row+1)*20;
						initObj.myDate = i+1;
						initObj.calendar = this;
						////////////////////////////////////
						//XXX TODO name position
							var day : CalendarDay = new CalendarDay();//new DAYCLIP(), "dayItem"+i, i, initObj);
							//this.attachMovie("TCalendarDay", "dayItem"+i, i, initObj));
							day.name = "dayItem"+i;
							view.addChild(day);
								daysClips.push(day);
							col++;
							if (col>=7) {
							   col = 0;
							   row++;
							}
						
					}
					isReady = true;
					return null;
				}
				case SIG_EXIT :
				{
					dayItem0.gotoAndStop("normal");
					for (var j : String in daysClips){
						var dayItem_mc : MovieClip = MovieClip(daysClips[j]);
						view.removeChild(dayItem_mc);
					}
					isReady = false;
					return null;
				}
				case SIG_INIT :
				{
					return null;
				}
			}
			return s0_viewAssetsLoaded;
		}
		/*.................................................................*/
		override public function s1_destroyingView(e : CogEvent) : Function
		{
			//this.onFunctionEnter ("s1_destroyingView-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
	
					return null;
				}
				case SIG_EXIT :
				{
					return null;
				}
				case SIG_INIT :
				{
					return null;
				}
			}
			return s0_viewAssetsLoaded;
		}
	}
}