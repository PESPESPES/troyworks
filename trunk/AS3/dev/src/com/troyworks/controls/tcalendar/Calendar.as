package com.troyworks.controls.tcalendar {
	import fl.controls.ComboBox; 

	import com.troyworks.framework.ui.BaseComponent;
	import com.troyworks.util.datetime.TDate;
	import com.troyworks.framework.model.BaseModelObject;
	import com.troyworks.hsmf.AEvent;
	import com.troyworks.events.TProxy;
	import mx.controls.ComboBox;
	import com.troyworks.events.EVTD;
	/**
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;
	import flash.text.TextField;
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
	
		public var hasFocus : Boolean = false;;
		public var childHasFocus:Boolean = false;
		public function Calendar() {
			super(null, "Calendar", true);
			selectedDate = new TDate();
			todaysDate = new TDate();
			selectedDate.addEventListener(BaseModelObject.EVTD_MODEL_CHANGED, this, this.onDateChanged);
		}
		public function gotoPrevYear() : void{
			selectedDate.decrementYear();
		}
		public function gotoPrevMonth() : void{
			selectedDate.decrementMonth();
		}
		public function gotoNextYear() : void{
			selectedDate.incrementYear();
		}
		public function gotoNextMonth() : void{
			selectedDate.incrementMonth();
		}
		public function gotoTodaysDate() : void{
			selectedDate.gotoTodaysDate();
		}
		public function onDateChanged() : void{
			//unloadDays();
			
			//loadCalendar();
			trace("OnDateChanged");
			Q_TRAN(s1_viewCreated);
		}
	// ///////////////////////////////////////////////////////////////////////////////////
		public function selectDate(newDate : Number) : void{
			selectedDate.setDate(newDate);
					this.dispatchEvent (
			{
				type : BaseModelObject.EVTD_MODEL_CHANGED, target : this, newVal:selectedDate
			});
		}
		protected function onYearComboChanged(evt:Object):void{
			trace(util.Trace.me(evt, "EVT onYearComboChanged",true));
			var cmb:ComboBox = ComboBox(evt.target);
			selectedDate.setFullYear(cmb.selectedItem.data);
		}
		protected function onMonthsComboChanged(evt:Object):void{
			trace(util.Trace.me(evt, "EVT onMonthsComboChanged",true));
				var cmb:ComboBox = ComboBox(evt.target);
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
		public function onSetFocus():void{
			var e:EVTD = new EVTD();
			e.type ="focusIn";
			e.target = this;
			this.dispatchEvent (e);
			hasFocus = true;
		}
		public function onKillFocus():void{
			var e:EVTD = new EVTD();
			e.type ="focusOut";
			e.target = this;
			this.dispatchEvent (e);
			hasFocus = false;
		}
	
		public function getSelectedDate() : TDate{
			return selectedDate;
		}
			/*.................................................................*/
		public function s0_viewAssetsLoaded(e : AEvent) : Function
		{
			this.onFunctionEnter ("s0_viewAssetsLoaded-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					REQUIRE(dayHead0 != null, "dayHead0 must be present");
					//////////////////////////// Populate the combo boxes ////////////////
					months_cmb.removeAll();
					for (var i : Number = 0; i < TDate.MONTH_NAMES.length; i++) {
						months_cmb.addItem({label:TDate.MONTH_NAMES[i] , data:i});
					}
					months_cmb.addEventListener("change", TProxy.create(this, this.onMonthsComboChanged));
					years_cmb.removeAll();
					for (var i : Number = 0; i < 70; i++) {
						var yr:Number = selectedDate.getFullYear() - i;
						years_cmb.addItem({label:yr , data:yr});
					}
					years_cmb.addEventListener("change", TProxy.create(this, this.onYearComboChanged));
					
					/////////////////////////// Create the Headers e.g. Monday, Tuesday ////////////////////////////////////////
					dayHeaderClips = new Array();
					for (var i : Number = 0; i<7; i++) {
						var day_mc : MovieClip;
						if (i>0) {
							day_mc = dayHead0.duplicateMovieClip( "dayHead"+i, 100+i);
						}else{
							day_mc = dayHead0;
						}
						trace("dayHead " + day_mc.name + "  i " + i);
						day_mc.x = dayHead0.x+i*25;
						day_mc.day.text = TDate.DAY_NAMES[i].substr(0, 2);
						dayHeaderClips.push(day_mc);
					}
					//////////// Link the buttons ///////////////////////////
					prevprevButton.onRelease = TProxy.create(this, this.gotoPrevYear) ;
					prevButton.onRelease  = TProxy.create(this, this.gotoPrevMonth) ;
					nextnextButton.onRelease = TProxy.create(this, this.gotoNextYear) ;
					nextButton.onRelease  = TProxy.create(this, this.gotoNextMonth) ;
					//nextButton.todayButton = TProxy.create(this, this.gotoPrevYear) ;
					return null;
				}
			}
			return super.s0_viewAssetsLoaded(e);
		}
		/*.................................................................*/
		public function s1_creatingView(e : AEvent) : Function
		{
			this.onFunctionEnter ("s1_creatingView-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
	
					return null;
				}
				case EXIT_EVT :
				{
					return null;
				}
				case INIT_EVT :
				{
					Q_INIT(s1_viewCreated);
					return null;
				}
			}
			return s0_viewAssetsLoaded;
		}
		/*.................................................................*/
		public function s1_viewCreated(e : AEvent) : Function
		{
			this.onFunctionEnter ("s1_creatingView-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{				///////////////////////////////////////////////////////////////////
					month.text = TDate.MONTH_NAMES[selectedDate.getMonth()]+", "+selectedDate.getFullYear();
					months_cmb.setSelectedIndex(selectedDate.getMonth());
					months_cmb.addEventListener("focusIn", TProxy.create(this, this.onSetFocus));
					months_cmb.addEventListener("focusOut", TProxy.create(this, this.onSetFocus));
					
					var today:Date = new Date();
					years_cmb.setSelectedIndex(today.getFullYear() -selectedDate.getFullYear());
					years_cmb.addEventListener("focusIn", TProxy.create(this, this.onSetFocus));
					years_cmb.addEventListener("focusOut", TProxy.create(this, this.onSetFocus));
					
					daysClips = new Array();
					/////////////////////////// Create the Days e.g. 1, 2, 3  ////////////////////////////////////////
					var daysNo : Number = selectedDate.daysInMonth;
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
							var day : CalendarDay = CalendarDay(this.attachMovie("TCalendarDay", "dayItem"+i, i, initObj));
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
				case EXIT_EVT :
				{
					dayItem0.gotoAndStop("normal");
					for (var i : String in daysClips){
						var dayItem_mc : MovieClip = MovieClip(daysClips[i]);
						dayItem_mc.removeMovieClip();
					}
					isReady = false;
					return null;
				}
				case INIT_EVT :
				{
					return null;
				}
			}
			return s0_viewAssetsLoaded;
		}
		/*.................................................................*/
		public function s1_destroyingView(e : AEvent) : Function
		{
			this.onFunctionEnter ("s1_destroyingView-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
	
					return null;
				}
				case EXIT_EVT :
				{
					return null;
				}
				case INIT_EVT :
				{
					return null;
				}
			}
			return s0_viewAssetsLoaded;
		}
	
	}
}