package com.troyworks.controls.tcalendar {
	import com.troyworks.data.valueobjects.ValueObject;

	import fl.controls.ComboBox;
	import fl.controls.List;

	import com.troyworks.core.cogs.CogEvent;
	import com.troyworks.data.DataChangedEvent;
	import com.troyworks.data.constraints.TDateRangeConstraint;
	import com.troyworks.data.valueobjects.TDateVO;
	import com.troyworks.framework.model.BaseModelObject;
	import com.troyworks.framework.ui.BaseComponent;
	import com.troyworks.util.Trace;
	import com.troyworks.util.datetime.TDate;
	import com.troyworks.util.datetime.TimeDateFormat;

	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Troy Gardner
	 */

	
	public class Calendar extends BaseComponent {

		// stores the selected date
		// you can get the selected date with getSelectedDate() function, too
		//public  var selectedDate : TDate;

		public var prevprevButton : InteractiveObject;
		public var prevButton : InteractiveObject;
		public var nextnextButton : InteractiveObject;
		public var nextButton : InteractiveObject;
		public var todayButton : InteractiveObject;
		public var ok_btn : InteractiveObject;
		public var close_btn : InteractiveObject;
		public var months_cmb : ComboBox;
		public var years_cmb : ComboBox;
		public var hour_lb : List;
		public var min_lb : List;

		
		protected var myDate : Date;

		protected var dayHead0 : MovieClip;
		protected var dayHeadClass : Class;
		protected var dayHead : MovieClip;

		public var month_txt : TextField;
		public var year_txt : TextField;
		public var hour_txt : TextField;
		public var min_txt : TextField;
		protected var dayItem0 : MovieClip;
		private var dayItem0Point : Point = new Point();
		protected var dayItem : CalendarDay;
		protected var dayItemClass : Class;
		protected var dayHeaderClips : Array;

		protected var daysClips : Array;

		public var todaysDate : TDate;
		public var DAYCLIP : Class;
		public var hasFocus : Boolean = false;
		public var childHasFocus : Boolean = false;
		public var dayClass : Class;
		private var dayUI : Sprite;
		private var overClip : Object;
		private var gap : Number = 5;
		public var yearFutureRangeRelativeToThisYear : Number = 1;
		public var yearPastRangeRelativeToThisYear : Number = 0;
		private var clockFormat : TimeDateFormat = new TimeDateFormat();
		private var months_cmbopen : Boolean;
		private var years_cmbopen : Boolean;
		public var dateVO : TDateVO;
		public var dateConstraint : TDateRangeConstraint;

		public function Calendar(initialState : String = "s_initial", hsmfName : String = "TCalendar", aInit : Boolean = false) {
			super(initialState, hsmfName, aInit);
			setStateMachineName("Calendar");
			trace("new TCalendar()");
			//selectedDate = new TDate();
			dateVO = new TDateVO(new TDate());
			dateVO.dispatchEventsEnabled = true;
			dateVO.addEventListener(ValueObject.DATA_CHANGE, onDateChanged);
			var minDate : TDate = new TDate();
			var maxDate : TDate = new TDate();
			maxDate.setFullYear(minDate.getFullYear() + 1);
			trace("DateConstraints are " + minDate + " " + maxDate);
			dateConstraint = new TDateRangeConstraint(minDate, maxDate);
			
			
			dateVO.constraint = dateConstraint.constrainToRange;
			todaysDate = new TDate();
			clockFormat.show_hour = true;
			clockFormat.show_minute = true;
			//selectedDate.addEventListener(Event.CHANGE, onDateChanged);
		}

		public function setView2( value : Sprite ) : void {
			trace("=========================================================");
			trace("Calendar set setView2----------------------" + value + " " + value.getChildByName("dayItem0"));
			_view = value;
			dayItem0 = value.getChildByName("dayItem0") as MovieClip;
			dayItem0Point.x = dayItem0.x;
			dayItem0Point.y = dayItem0.y;
			trace(_view + " " + dayUI + " DAYUICLASS " + getQualifiedClassName(dayUI));
			dayItemClass = getDefinitionByName(getQualifiedClassName(dayItem0)) as Class;
			trace(dayItem0);
			dayHead0 = value.getChildByName("dayHead0") as MovieClip;
		
			dayHeadClass = getDefinitionByName(getQualifiedClassName(dayHead0)) as Class;
			months_cmb = value.getChildByName("months_cmb") as ComboBox;
			years_cmb = value.getChildByName("years_cmb") as ComboBox;
			nextButton = value.getChildByName("nextButton") as InteractiveObject;
			nextnextButton = value.getChildByName("nextnextButton") as InteractiveObject;
			prevButton = value.getChildByName("prevButton") as InteractiveObject;
			prevprevButton = value.getChildByName("prevprevButton") as InteractiveObject;
			todayButton = value.getChildByName("todayButton") as InteractiveObject;
			ok_btn = value.getChildByName("ok_btn") as InteractiveObject;
			close_btn = value.getChildByName("close_btn") as InteractiveObject;
			//	gap = prevprevButton.x - (prevButton.x  + prevButton.width) * -1;
			//	trace("prevprevButtonprevprevButtonprevprevButtonprevprevButton " + prevprevButton);
			month_txt = value.getChildByName("month_txt") as TextField;
			year_txt = value.getChildByName("year_txt") as TextField;
			hour_txt = value.getChildByName("hour_txt") as TextField;
			min_txt = value.getChildByName("min_txt") as TextField;
			//calViewClass = Class(ApplicationDomain.currentDomain.getDefinition("TCalendar"));
			hour_lb = value.getChildByName("hour_lb") as List;
			min_lb = value.getChildByName("min_lb") as List;
			//requestTran(s0_viewAssetsLoaded);
				//view.tabEnabled = true;
			//view.tabChildren = true;
			//view.focusEnabled = true;
			//requestTran(s0_viewAssetsLoaded);
		}

		public function gotoPrevYear(evt : Event = null) : void {
			//selectedDate.decrementYear();
			var newVal : TDate = dateVO.value.clone();
			newVal.decrementYear();// = new TDate(newDate);
			dateVO.value = newVal;
		}

		public function gotoPrevMonth(evt : Event = null) : void {
			//selectedDate.decrementMonth();
			var newVal : TDate = dateVO.value.clone();
			newVal.decrementMonth();// = new TDate(newDate);
			dateVO.value = newVal;
		}

		public function gotoNextYear(evt : Event = null) : void {
			//selectedDate.incrementYear();
			var newVal : TDate = dateVO.value.clone();
			newVal.incrementYear();// = new TDate(newDate);
			dateVO.value = newVal;
		}

		public function gotoNextMonth(evt : Event = null) : void {
			//selectedDate.incrementMonth();
			var newVal : TDate = dateVO.value.clone();
			newVal.incrementMonth();// = new TDate(newDate);
			dateVO.value = newVal;
		}

		public function gotoTodaysDate(evt : Event = null) : void {
			//selectedDate.gotoTodaysDate();
			var newVal : TDate = dateVO.value.clone();
			newVal.gotoTodaysDate();// = new TDate(newDate);
			dateVO.value = newVal;
		}

		public function onDateChanged(evt : Event = null) : void {
			trace("Calendar.onDateChanged");
			//unloadDays();
			
			//loadCalendar();
			trace("OnDateChanged");
			tran(s1_viewCreated);
		}

		// ///////////////////////////////////////////////////////////////////////////////////
		public function selectDate(newDate : Number) : void {
			trace("!!!!!!!!!!!!!! SELECTE DATED !!!!!!!!!!!!" + newDate);
			var newVal : TDate = dateVO.value.clone();
			newVal.setDate(newDate);// = new TDate(newDate);
			dateVO.value = newVal;
			//		selectedDate.setDate(newDate);
			//var de : DataChangedEvent = new DataChangedEvent(BaseModelObject.EVTD_MODEL_CHANGED);
			//de.currentVal = selectedDate;
			//dispatchEvent(de);
		}

		protected function onYearComboChanged(evt : Object) : void {
			trace(Trace.me(evt, "EVT onYearComboChanged", true));
			var cmb : ComboBox = ComboBox(evt.target);
			trace("cmb.selectedItem.data " + cmb.selectedItem.data);
			//selectedDate.setFullYear(cmb.selectedItem.data);
			var newVal : TDate = dateVO.value.clone();
			newVal.setFullYear(cmb.selectedItem.data);
			dateVO.value = newVal;
		}

		protected function onMonthsComboChanged(evt : Object) : void {
			trace(Trace.me(evt, "EVT onMonthsComboChanged", true));
			var cmb : ComboBox = ComboBox(evt.target);
			trace("cmb.selectedItem.data " + cmb.selectedItem.data);
			var newVal : TDate = dateVO.value.clone();
			newVal.setMonth(cmb.selectedItem.data);
			dateVO.value = newVal;
		//	selectedDate.setMonth(cmb.selectedItem.data);
		}

		protected function onHourLBChanged(evt : Object) : void {
			trace("EVT onHourLBChanged=================");
			var cmb : List = List(evt.target);
			trace("cmb.selectedItem.data " + cmb.selectedItem.data);
			var newVal : TDate = dateVO.value.clone();
			newVal.setHours(cmb.selectedItem.data);
			dateVO.value = newVal;
		//	selectedDate.setHours(cmb.selectedItem.data);
		}

		protected function onMinLBChanged(evt : Object) : void {
			trace("EVT onMinLBChanged=================");
			var cmb : List = List(evt.target);
			trace("cmb.selectedItem.data " + cmb.selectedItem.data);
			
			var newVal : TDate = dateVO.value.clone();
			newVal.setMinutes(cmb.selectedItem.data);
			trace("date " + dateVO.value  + " newV " +  newVal);
			dateVO.value = newVal;
		//	selectedDate.setMinutes(cmb.selectedItem.data);
		}

		public function getStartWeekDay() : Number {
		
			myDate = new Date(dateVO.value.getFullYear(), dateVO.value.getMonth(), 1);
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

		public function onSetFocus(evt : Event = null) : void {
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
			return 	dateVO.value;
		}

		override public function s_initial(e : CogEvent) : Function {
			trace(getStateMachineName() + "************************* s_initial " + e.sig + " ******************");
			//		onFunctionEnter ("s_initial-", e, []);
			switch(e.sig) {
				case SIG_INIT :
					
					if(view != null) {
						return s0_viewAssetsLoaded;
					//	requestTran(s0_viewAssetsLoaded);
					} else {
						return s0_viewAssetsUnLoaded;
					//	requestTran(s0_viewAssetsUnLoaded);
					}
					break;
			}
			return s_root;
		}

		/*.................................................................*/
		override public function s0_viewAssetsLoaded(e : CogEvent) : Function {
			//this.onFunctionEnter ("s0_viewAssetsLoaded-", e, []);
			trace("TCalendar.s0_viewAssetsLoaded...................");
			switch (e.sig) {
				case SIG_ENTRY :
					{
					var i : int;
					REQUIRE(dayHead0 != null, "dayHead0 must be present");
					//////////////////////////// Populate the combo boxes ////////////////

					months_cmb.removeAll();
					for (i = 0;i < TimeDateFormat.MONTH_NAMES.length;i++) {
						months_cmb.addItem({label:TimeDateFormat.MONTH_NAMES[i], data:i});
					}
					//months_cmb.selectedIndex = selectedDate.getMonth();
					var today : Date = new Date();
					years_cmb.removeAll();
					var yr : Number;
					for (i = 0;i < yearFutureRangeRelativeToThisYear;i++) {
						yr = today.getFullYear() + (i + 1);
						years_cmb.addItem({label:yr, data:yr});
					}
					yr = today.getFullYear() ;
					years_cmb.addItem({label:yr, data:yr});
					for (i = 0;i < yearPastRangeRelativeToThisYear;i++) {
						yr = today.getFullYear() - (i + 1);
						years_cmb.addItem({label:yr, data:yr});
					}
					//years_cmb.selectedIndex = (today.getFullYear() - selectedDate.getFullYear());

					months_cmb.addEventListener("change", onMonthsComboChanged);
					years_cmb.addEventListener("focusIn", onSetFocus);
					years_cmb.addEventListener("focusOut", onSetFocus);
						
					months_cmb.addEventListener("focusIn", onSetFocus);
					months_cmb.addEventListener("focusOut", onSetFocus);
					years_cmb.addEventListener("change", onYearComboChanged);
					hour_lb.addEventListener("change", onHourLBChanged);
					min_lb.addEventListener("change", onMinLBChanged);
					min_lb.removeAll();
					var min : int = 0;
					while(min < 60) {
						if(min < 10) {
							min_lb.addItem({label:"0" + min, data:min});
						} else {
							min_lb.addItem({label:min, data:min});
						}
						min += 5;
					}
					var hr : int = 0;
					while(hr < 24) {
						
						if(hr < 12) {
							if(hr == 0) {
								hour_lb.addItem({label:"12am", data:hr});
							} else {
								hour_lb.addItem({label:hr + "am", data:hr});
							}
						} else {
							if(hr == 12) {
								hour_lb.addItem({label:"12pm", data:hr});
							} else {
								hour_lb.addItem({label:hr - 12 + "pm", data:hr});
							}
						}
						hr++;
					}
					/////////////////////////// Create the Headers e.g. Monday, Tuesday ////////////////////////////////////////
					dayHeaderClips = new Array();
					for (i = 0;i < 7;i++) {
						var day_mc : MovieClip;
					
						if (i > 0) {
							day_mc = new dayHeadClass();//.duplicateMovieClip("dayHead" + i, 100 + i);

							trace("dayHead " + day_mc.name + "  i " + i);
							day_mc.x = dayHead0.x + ( i * dayHead0.width) + gap;
							day_mc.y = dayHead0.y;
							day_mc.scaleX = dayHead0.scaleX;
							day_mc.scaleY = dayHead0.scaleY;
							day_mc.mouseChildren = false;
						
							_view.addChild(day_mc);
						} else {
							day_mc = dayHead0;
						}
						dayHeaderClips.push(day_mc);
						//trace("TimeDateFormat " + TimeDateFormat);
						//trace("TimeDateFormat.DAY_NAMES " + TimeDateFormat.DAY_NAMES);
						//trace("TimeDateFormat.DAY_NAMES " +i + " "+ TimeDateFormat.DAY_NAMES[i]);
						day_mc.label_txt.text = TimeDateFormat.DAY_NAMES[i].substr(0, 2);
					}
					//////////// Link the buttons ///////////////////////////
					if(prevprevButton) {
						prevprevButton.addEventListener(MouseEvent.CLICK, gotoPrevYear) ;
					}
					if(prevButton) {
						prevButton.addEventListener(MouseEvent.CLICK, gotoPrevMonth) ;
					}
					if(nextnextButton) {
						nextnextButton.addEventListener(MouseEvent.CLICK, gotoNextYear) ;
					}
					if(nextButton) {
						nextButton.addEventListener(MouseEvent.CLICK, gotoNextMonth) ;
					}
					if(todayButton) {
						todayButton.addEventListener(MouseEvent.CLICK, gotoTodaysDate) ;
					}
					if(month_txt) {
						month_txt.addEventListener(MouseEvent.ROLL_OVER, onMonthTextROLL_OVER);
					//	month_txt.addEventListener(MouseEvent.ROLL_OUT, onMonthTextROLL_OUT);
					}
					if(year_txt) {
						year_txt.addEventListener(MouseEvent.ROLL_OVER, onYearTextROLL_OVER);
						//year_txt.addEventListener(MouseEvent.ROLL_OUT, onYearTextROLL_OUT);
					}
					if(months_cmb) {
						months_cmb.visible = false;
						months_cmb.addEventListener(MouseEvent.ROLL_OVER, onMonthCmbROLL_OVER);
						months_cmb.addEventListener(MouseEvent.ROLL_OUT, onMonthTextROLL_OUT);	
						months_cmb.addEventListener(Event.OPEN, months_cmbopenHandler);
						months_cmb.addEventListener(Event.CLOSE, months_cmbcloseHandler);
					}
					if(years_cmb) {
						years_cmb.visible = false;
						years_cmb.addEventListener(MouseEvent.ROLL_OVER, onYearCmbROLL_OVER);
						years_cmb.addEventListener(Event.OPEN, years_cmbopenHandler);
						years_cmb.addEventListener(Event.CLOSE, years_cmbcloseHandler);
						years_cmb.addEventListener(MouseEvent.ROLL_OUT, onYearTextROLL_OUT);	
					}
					if(ok_btn) {
						ok_btn.addEventListener(MouseEvent.CLICK, onOKClick) ;
					}
					if(close_btn) {
						close_btn.addEventListener(MouseEvent.CLICK, onCloseClick) ;
					}
					requestTran(s1_viewCreated);
					return null;
					}
			}
			return s_root;//super.s0_viewAssetsLoaded;
		}

		private function months_cmbopenHandler(evt : Event = null) : void {
			months_cmbopen = true;
		}

		private function months_cmbcloseHandler(evt : Event = null) : void {
			months_cmbopen = false;
			onMonthTextROLL_OUT();
		}

		private function years_cmbopenHandler(evt : Event = null) : void {
			years_cmbopen = true;
		}

		private function years_cmbcloseHandler(evt : Event = null) : void {
			years_cmbopen = false;
			onYearTextROLL_OUT();
		}

		private function onMonthCmbROLL_OVER(evt : Event = null) : void {
			trace("onMonthCmbROLL_OVER");
			if(months_cmb) {
				months_cmb.visible = true;
			}
			if(month_txt) {
				//	month_txt.removeEventListener(MouseEvent.ROLL_OVER, onMonthTextROLL_OVER);
				month_txt.visible = !months_cmb.visible;
			}
		}

		private function onYearCmbROLL_OVER(evt : Event = null) : void {
			trace("onYearCmbROLL_OVER");
			if(years_cmb) {
				years_cmb.visible = true;
			}
			if(year_txt) {
				//	year_txt.removeEventListener(MouseEvent.ROLL_OVER, onYearTextROLL_OVER);
				year_txt.visible = !years_cmb.visible;
			}
		}

		private function onMonthTextROLL_OVER(evt : Event = null) : void {
			if(months_cmb) {
				months_cmb.visible = true;
			}
			if(month_txt) {
				month_txt.visible = !months_cmb.visible;
			}
		}

		private function onMonthTextROLL_OUT(evt : Event = null) : void {
			trace("onMonthTextROLL_OUT");
			if(months_cmb) {
				
				if(!months_cmbopen) {
					trace("!months_cmb");
					months_cmb.visible = false;
				}
			}
			if(month_txt) {
				month_txt.visible = !months_cmb.visible;
			}
		}

		private function onYearTextROLL_OVER(evt : Event = null) : void {
			if(years_cmb) {
				years_cmb.visible = true;
			}
			if(year_txt) {
				year_txt.visible = !years_cmb.visible;
			}
		}

		private function onYearTextROLL_OUT(evt : Event = null) : void {
			trace("onYearTextROLL_OUT");
			if(years_cmb) {
				trace("years_cmb");
				if(!years_cmbopen) {
					trace("!years_cmb");
					years_cmb.visible = false;
				}
			}
			if(year_txt) {
				year_txt.visible = !years_cmb.visible;
			}
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
		override public function s1_viewCreated(e : CogEvent) : Function {
			trace("TCalendar.s1_viewCreated");
			//	this.onFunctionEnter ("s1_creatingView-", e, []);
			switch (e.sig) {
				case SIG_ENTRY :
					{				
					var selectedDate : TDate = dateVO.value;//.clone();
					///////////////////////////////////////////////////////////////////
					month_txt.text = TimeDateFormat.MONTH_NAMES[selectedDate.getMonth()] + " " + selectedDate.getDate() + ",";
					year_txt.text = selectedDate.getFullYear() + "";
				
					months_cmb.selectedIndex = selectedDate.getMonth();
					var i : int;
					var ind : int;
					for(i = 0;i < years_cmb.length;i++) {
						trace(years_cmb.getItemAt(i).data + " YEAR=== " + selectedDate.getFullYear());
						if(years_cmb.getItemAt(i).data == selectedDate.getFullYear()) {
							ind = i;
							break;
						}
					}
					years_cmb.selectedIndex = ind;
					ind = 0;
					for(i = 0;i < hour_lb.length;i++) {
						trace(hour_lb.getItemAt(i).data + " YEAR=== " + selectedDate.getHours());
						if(hour_lb.getItemAt(i).data == selectedDate.getHours()) {
							ind = i;
							break;
						}
					}
					hour_lb.selectedIndex = ind;
					
					ind = 0;
					for(i = 0;i < min_lb.length;i++) {
						trace(min_lb.getItemAt(i).data + " MIN=== " + selectedDate.getMinutes());
						if(min_lb.getItemAt(i).data >= selectedDate.getMinutes()) {
							ind = i;
							break;
						}
					}
					min_lb.selectedIndex = ind;		
					var hrstr : String = hour_lb.selectedItem.label;
					if(hrstr.indexOf("AM")) {
						hour_txt.text = clockFormat.toAMPMClockString(selectedDate.time);//hour_lb.selectedItem.label;
//					min_txt.text = min_lb.selectedItem.label;
					}
					
					daysClips = new Array();
					/////////////////////////// Create the Days e.g. 1, 2, 3  ////////////////////////////////////////
					var daysNo : Number = selectedDate.getDaysInMonth();
					var startDay : Number = getStartWeekDay();
					var row : Number = 0;
					var col : Number = startDay;
					for ( i = 0;i < daysNo;i++) {
						var initObj : Object = new Object();
					
						////////////////////////////////////
						//XXX TODO name position
						//							var day : CalendarDay = new CalendarDay();//new DAYCLIP(), "dayItem"+i, i, initObj);
						var day : MovieClip;
						if(i > 0) {
							day = new dayItemClass();
							day.name = "dayItem" + i;
						} else {
							day = dayItem0;
						}
						day.x = dayItem0Point.x + col * dayItem0.width + gap;
						day.y = dayItem0Point.y + (row ) * dayItem0.height + gap;
						//this.attachMovie("TCalendarDay", "dayItem"+i, i, initObj));
						day.addEventListener(MouseEvent.ROLL_OVER, onDayRollOverHandler);
						day.addEventListener(MouseEvent.ROLL_OUT, onDayRollOutHandler);
						day.addEventListener(MouseEvent.CLICK, onDayPressHandler);
						day.myDate = i + 1;
						day.day_txt.text = String(day.myDate);
						day.calendar = this;
						day.buttonMode = true;
						day.mouseChildren = false;
						day.isOver_mc.visible = false;
						view.addChild(day);
						daysClips.push(day);
						col++;
						if (col >= 7) {
							col = 0;
							row++;
						}
					}
					updateUI();
					isReady = true;
					return null;
					}
				case SIG_EXIT :
					{
					dayItem0.gotoAndStop("normal");
					for (var j : String in daysClips) {
						var dayItem_mc : MovieClip = MovieClip(daysClips[j]);
						view.removeChild(dayItem_mc);
					}
					isReady = false;
					return null;
					}
			}
			return s0_viewAssetsLoaded;
		}

		/*.................................................................*/
		override public function s1_destroyingView(e : CogEvent) : Function {
			//this.onFunctionEnter ("s1_destroyingView-", e, []);
			switch (e.sig) {
				case SIG_ENTRY :
					{
	
					return null;
					}
				case SIG_EXIT :
					{
					return null;
					}
			}
			return s0_viewAssetsLoaded;
		}

		public function onDayRollOverHandler(evt : Event) : void {
			overClip = evt.target;
			updateUI();
		}

		
		public function onDayRollOutHandler(evt : Event) : void {
			evt.target.isOver_mc.visible = false;
			overClip = null;
			updateUI();
		}

		public function onDayPressHandler(evt : Event) : void {
			//
			trace("selected date " + evt.target.myDate);
			selectDate(evt.target.myDate);
			updateUI();
			//dispatchEvent(new Event("DATE_SELECTED"));
		}

		public function onOKClick(evt : Event) : void {
			dispatchEvent(new Event("DATE_SELECTED"));
		}

		public function onCloseClick(evt : Event) : void {
			dispatchEvent(new Event("DATE_SELECTION_CANCELED"));
			_view.visible = false;
		}

		public function updateUI() : void {
			var ary : Array = daysClips;// ["a","b","c"];
			var i : int = 0;
			var n : int = ary.length;
			for (;i < n;++i) {
				var cDay : Object = ary[i];
				//trace(i + " " + cDay);
				if(cDay == overClip) {
  	
					cDay.isOver_mc.visible = true;
				} else {
					cDay.isOver_mc.visible = false;
				}

				if(dateVO.value.getDate() == cDay.myDate) {
					cDay.isSelected_mc.visible = true;
				} else {
					cDay.isSelected_mc.visible = false;
				}
				if( cDay.myDate == todaysDate.getDate()) {
					cDay.isToday_mc.visible = true;
				} else {
					cDay.isToday_mc.visible = false;
				}
			}
		}
	}
}