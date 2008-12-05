package com.troyworks.framework.ui {
	import flash.display.MovieClip;
	import flash.events.Event;

	import com.troyworks.controls.tcalendar.Calendar;
	import com.troyworks.core.cogs.CogEvent;
	import com.troyworks.core.events.TProxy;
	import com.troyworks.framework.model.BaseModelObject;
	import com.troyworks.framework.ui.BaseComponent;
	import com.troyworks.framework.ui.IHaveChildrenComponents;
	import com.troyworks.util.datetime.TDate;

	import fl.controls.Button;
	import fl.controls.TextInput; 

	/**
	 * @author Troy Gardner
	 */

	public class DateField extends BaseComponent implements IHaveChildrenComponents {
		public var inputTxtA : TextInput;
		public var choose_btn : Button;
		public var cal : Calendar;

		public function DateField(initialState : String = "s_initial", hsmfName : String = "DateField", aInit : Boolean = false) {
			super(initialState, "DateField", aInit);
			
			view.tabEnabled = true;
			view.tabChildren = true;
			view.focusEnabled = true;
		}

		public function onSelectedDateChanged() : void {
			var selected : String = (cal.selectedDate.getMonth() + 1) + "/" + cal.selectedDate.getDate() + "/" + cal.selectedDate.getFullYear();
			trace("DateField.selected date *CHANGE*" + selected);
			inputTxtA.text = selected;
			var e : Event = new Event();
			e.type = "change";
			e.target = this;
			this.dispatchEvent(e);
		}

		public function onUserSelectedDate(bypassEvent : Boolean) : void {
			trace("DateField.onUserSelectedDate");
		
			cal.visible = false;
			cal.height = choose_btn.height;
			cal.width = choose_btn.width;
			var e : Event = new Event();
			if(bypassEvent == null || bypassEvent == false) {
				e.type = "focusOut";
				e.target = this;
				this.dispatchEvent(e);
			}
		}

		public function onOpenCalendar() : void {
			cal.height = cal._oheight;
			cal.width = cal._owidth;
			cal.visible = true;
		}

		public function getSelectedDate() : TDate {
			return cal.selectedDate;
		}

		public function setSelectedDate(date : Date) : void {
			trace("DateField.setSelectedDateCHANGE");
			var t : TDate = new TDate();
			t.setTime(date.getTime());
			cal.selectedDate = t;
	//				var e:Event = new Event();
	//		e.type ="change";
	//		e.target = this;
	//		this.dispatchEvent (e);
		}

		public function onSetFocus() : void {
			trace("DateField.setFocus");
			var e : Event = new Event();
			e.type = "focusIn";
			e.target = this;
			this.dispatchEvent(e);
			onOpenCalendar();
		}

		public function onKillFocus() : void {
			trace("DateField.onKillFocus");
	
		
			if(!cal.hasFocus) {
				onUserSelectedDate(true);
			}
		}

		override public function onChildClipLoad(_mc : MovieClip) : void {
			if(_mc == cal) {
	
				onUserSelectedDate(true);
			}
		}

		/*.................................................................*/
		override function s0_viewAssetsLoaded(e : CogEvent) : Function {
		//	this.onFunctionEnter("s0_viewAssetsLoaded-", e, []);
			switch (e.sig) {
				case SIG_ENTRY :
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