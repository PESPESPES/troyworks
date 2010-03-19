package com.troyworks.controls.tcalendar { 
	/**
	 * @author Troy Gardner
	 */
	import com.troyworks.util.InitObject;	
	
	import flash.events.MouseEvent;	
	import flash.display.SimpleButton;	
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class CalendarDay extends MovieClip {
		public var myDate : Number;
		public var calendar : Calendar;

		//UI
		public var day_txt : TextField;
		public var dayButton : SimpleButton;
		public var isOver_mc : MovieClip;
		public var isSelected_mc : MovieClip;
		public var isToday_mc : MovieClip;
		public var background_mc : MovieClip;

		public function CalendarDay() {
			super();
			//addFrameScript(0, onFrame0);
			//InitObject.bindView(this, viewToBind)
			trace("day_txt" + day_txt);
		}

		public function onFrame0() : void {
			trace("CaldendarDay.onFrame0()" + myDate + " " + day_txt);
			day_txt.text = String(myDate);
			isOver_mc.visible = false;
			addEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);
			addEventListener(MouseEvent.CLICK, onPressHandler);
			updateUI();	
		}

		public function updateUI() : void {
			if(calendar.dateVO.value.getDate() == myDate) {
				isSelected_mc.visible = true;
			} else {
				isSelected_mc.visible = false;
			}
			if( myDate == calendar.todaysDate.getDate()) {
				isToday_mc.visible = true;
			} else {
				isToday_mc.visible = false;
			}
		}

		public function onRollOverHandler() : void {
			isOver_mc.visible = true;
		}

		public function onRollOutHandler() : void {
			isOver_mc.visible = false;
		}

		public function onPressHandler() : void {
			calendar.selectDate(myDate);
		};
	}
}