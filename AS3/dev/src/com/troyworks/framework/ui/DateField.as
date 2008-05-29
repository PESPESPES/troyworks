package com.troyworks.framework.ui { 
	import com.troyworks.calendar.Calendar;
	import com.troyworks.hsmf.AEvent;
	import com.troyworks.framework.model.BaseModelObject;
	import com.troyworks.events.TProxy;
	import com.troyworks.util.datetime.TDate;
	import mx.controls.TextInput;
	import mx.transitions.OnEnterFrameBeacon;
	import com.troyworks.events.EVTD;
	
	/**
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;
	public class DateField extends BaseComponent implements IHaveChildrenComponents {
		public var inputTxtA:TextInput;
		public var choose_btn:Button;
		public var cal:Calendar;
		
		public function DateField(initialState : Function, hsmfName : String, aInit : Boolean) {
			super(initialState, "DateField", aInit);
			
					tabEnabled =true;
					tabChildren = true;
					focusEnabled = true;
		}
		public function onSelectedDateChanged():void{
			public var selected:String = (cal.selectedDate.getMonth() +1)+ "/" + cal.selectedDate.getDate() +"/"+cal.selectedDate.getFullYear();
			trace("DateField.selected date *CHANGE*" + selected);
			inputTxtA.text= selected;
			public var e:EVTD = new EVTD();
			e.type ="change";
			e.target = this;
			this.dispatchEvent (e);
		}
		public function onUserSelectedDate(bypassEvent:Boolean):void{
			trace("DateField.onUserSelectedDate");
		
			cal.visible = false;
			cal.height = choose_btn.height;
			cal.width = choose_btn.width;
			public var e:EVTD = new EVTD();
			if(bypassEvent == null || bypassEvent == false){
			e.type ="focusOut";
			e.target = this;
			this.dispatchEvent (e);
			}
		}
		public function onOpenCalendar():void{
			cal.height = cal._oheight;
			cal.width = cal._owidth;
			cal.visible = true;
		}
		public function getSelectedDate():TDate{
			return cal.selectedDate;
		}
		public function setSelectedDate(date:Date):void{
			trace("DateField.setSelectedDateCHANGE");
			public var t:TDate = new TDate();
			t.setTime(date.getTime());
			cal.selectedDate = t;
	//				var e:EVTD = new EVTD();
	//		e.type ="change";
	//		e.target = this;
	//		this.dispatchEvent (e);
		}
		public function onSetFocus():void{
			trace("DateField.setFocus");
			public var e:EVTD = new EVTD();
			e.type ="focusIn";
			e.target = this;
			this.dispatchEvent (e);
			onOpenCalendar();
		}
		public function onKillFocus():void{
			trace("DateField.onKillFocus");
	
		
			if(!cal.hasFocus){
			 onUserSelectedDate(true);
			}
		}
		public function onChildClipLoad(_mc:MovieClip):void{
			if(_mc == cal){
	
				onUserSelectedDate(true);
			}
		}
		/*.................................................................*/
		function s0_viewAssetsLoaded(e : AEvent) : Function
		{
			this.onFunctionEnter ("s0_viewAssetsLoaded-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					inputTxtA.addEventListener("focusIn", TProxy.create(this, this.onSetFocus));
					var initObj:Object = new Object();
					initObj.x = choose_btn.x;
					initObj.y = choose_btn.y;
					cal = Calendar(attachMovie("TCalendar", "cal", getNextHighestDepth(), initObj));
					//snapshotDimensions(cal);
					cal.selectedDate.addEventListener(BaseModelObject.EVTD_MODEL_CHANGED, this, this.onSelectedDateChanged);
					cal.addEventListener(BaseModelObject.EVTD_MODEL_CHANGED, this, this.onUserSelectedDate);
			
					choose_btn.onRelease = TProxy.create(this, this.onOpenCalendar);
					return null;
				}
			}
			return super.s0_viewAssetsLoaded(e);
		}
	}
}