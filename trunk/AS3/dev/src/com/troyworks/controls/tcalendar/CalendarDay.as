package com.troyworks.calendar { 
	/**
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;
	import flash.text.TextField;
	public class CalendarDay extends MovieClip{
		public var myDate:Number;
		public var calendar:Calendar;
	
	//UI
		public var day_txt:TextField;
		public var dayButton:Button;
		public var isOver_mc:MovieClip;
		public var isSelected_mc:MovieClip;
		public var isToday_mc:MovieClip;
		public var background_mc:MovieClip;
		
		public function CalendarDay() {
			super();
		}
		public function onLoad():void{
			trace("CaldendarDay.onLoad()" + myDate);
			day_txt.text = String(myDate);
				isOver_mc.visible = false;
			updateUI();	
		}
	
		public function updateUI():void{
			if(calendar.selectedDate.getDate()== myDate){
				isSelected_mc.visible = true;
			}else{
				isSelected_mc.visible = false;
			}
			if( myDate  == calendar.todaysDate.getDate()){
				isToday_mc.visible = true;
			}else{
				isToday_mc.visible = false;
			}
		}
		public function onRollOver():void{
			isOver_mc.visible = true;
		}
		public function onRollOut():void{
			isOver_mc.visible = false;
		}
		public function onPress():void {
			calendar.selectDate(myDate);
		};
	}
}