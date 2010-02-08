package com.troyworks.controls.tdatefield {
	import com.troyworks.data.valueobjects.TDateVO;
	import com.troyworks.controls.tcalendar.Calendar;
	import com.troyworks.core.cogs.CogEvent;
	import com.troyworks.framework.ui.BaseComponent;
	import com.troyworks.framework.ui.IHaveChildrenComponents;
	import com.troyworks.util.datetime.TDate;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author Troy Gardner
	 */

	public class DateField extends BaseComponent implements IHaveChildrenComponents {
		public var input_txt : TextField;
		public var choose_btn : SimpleButton;

		public var cal : Calendar;
		public var calView : Sprite;
		public var calViewClass : Class;
	

		public function DateField(initialState : String = "s_initial", hsmfName : String = "DateField", aInit : Boolean = false) {
			
			super(initialState, "DateField", aInit);
			trace("DateField();.........................");
		}

		override public function set view( value : Sprite ) : void {
			trace("set view----------------------");
			super.view = value;
			input_txt = view.getChildByName("input_txt") as TextField;
			choose_btn = view.getChildByName("choose_btn") as SimpleButton;
			calView = view.getChildByName("calBox") as Sprite;
			
			//calViewClass = Class(ApplicationDomain.currentDomain.getDefinition("Calendar"));
			//requestTran(s0_viewAssetsLoaded);
				//view.tabEnabled = true;
			//view.tabChildren = true;
			//view.focusEnabled = true;
		}

		public function onSelectedDateChanged(evt:Event =null) : void {
			var selected : String = (cal.dateVO.value.getMonth() + 1) + "/" + cal.dateVO.value.getDate() + "/" + cal.dateVO.value.getFullYear() + " @ "  + cal.hour_txt.text;
			trace("DateField.selected date *CHANGE*" + selected);
			input_txt.text = selected;
			calView.visible = false;
			var e : Event = new Event(Event.CHANGE);
			this.dispatchEvent(e);
		}

		public function onUserSelectedDate(bypassEvent : Boolean) : void {
			trace("DateField.onUserSelectedDate");
			var selected : String = (cal.dateVO.value.getMonth() + 1) + "/" + cal.dateVO.value.getDate() + "/" + cal.dateVO.value.getFullYear();
			trace("DateField.selected date *CHANGE*" + selected);
			input_txt.text = selected;
	
			calView.visible = false;
			//	cal.height = choose_btn.height;
			//	cal.width = choose_btn.width;
			var e : Event = new Event("FOCUS_OUT");
			if( bypassEvent == false) {
				//		e.type = "focusOut";
				//		e.target = this;
				this.dispatchEvent(e);
			}
		}

		public function onOpenCalendar(evt : Event = null) : void {
			if(calView) {
				//calView.height = cal._oheight;
				//calView.width = cal._owidth;
				calView.visible = !calView.visible;
			}
		}

		public function getSelectedDate() : TDate {
			return cal.dateVO.value;
		}

		public function setSelectedDate(date : Date) : void {
			trace("DateField.setSelectedDateCHANGE");
			var t : TDate = new TDate();
			t.setTime(date.getTime());
			cal.dateVO.value = t;
			var e : Event = new Event(Event.CHANGE);
			dispatchEvent(e);
		}

		public function onSetFocus(evt : Event = null) : void {
			trace("DateField.setFocus");
			var e : Event = new Event("FOCUS_IN");
			this.dispatchEvent(e);
			onOpenCalendar();
		}

		public function onKillFocus(evt : Event = null) : void {
			trace("DateField.onKillFocus");
	
		
	//		if(!cal.hasFocus) {
	//			onUserSelectedDate(true);
	//		}
		}

		override public function onChildClipLoad(_mc : MovieClip) : void {
		//	if(_mc == cal) {
	
		//		onUserSelectedDate(true);
	//		}
		}

		override public function s_initial(e : CogEvent) : Function {
			trace(getStateMachineName()+ "************************* s_initial " + e.sig + " ******************");
			//		onFunctionEnter ("s_initial-", e, []);
			switch(e.sig) {
				case SIG_INIT :
					
					if(view != null) {
						//	return s0_viewAssetsLoaded;
						requestTran(s0_viewAssetsLoaded);
					} else {
						//	return s0_viewAssetsUnLoaded;
						requestTran(s0_viewAssetsUnLoaded);
					}
					break;
			}
			return s_root;
		}

		/*.................................................................*/
		override public function s0_viewAssetsLoaded(e : CogEvent) : Function {
			//	this.onFunctionEnter("s0_viewAssetsLoaded-", e, []);
			trace(getStateMachineName()+ "s0_viewAssetsLoaded.................................................");
			switch (e.sig) {
				case SIG_ENTRY :
					input_txt.addEventListener("focusIn", onSetFocus);
					choose_btn.addEventListener(MouseEvent.CLICK, onOpenCalendar);
					//calView = new calViewClass();
					//	calView.x = choose_btn.x;
					//	calView.y = choose_btn.y;
				//	calView.visible = false;
					//	view.addChild(calView);
					cal = new Calendar();
					trace("new TCalcde " + cal );
					cal.setView2(calView);
					trace("new cal.view " + cal.view);
					cal.initStateMachine();
					cal.addEventListener("DATE_SELECTED",onSelectedDateChanged);
					calView.visible = false;
					//cal.selectedDate.addEventListener(Event.CHANGE, onUserSelectedDate);
					//cal.gotoTodaysDate();
					//snapshotDimensions(cal);
					//	cal.selectedDate.addEventListener(BaseModelObject.EVTD_MODEL_CHANGED, this, this.onSelectedDateChanged);
					//	cal.addEventListener(BaseModelObject.EVTD_MODEL_CHANGED, this, this.onUserSelectedDate);
			
					//		choose_btn.onRelease = TProxy.create(this, this.onOpenCalendar);
					return null;
			}
			return s_root;//super.s0_viewAssetsLoaded;//(e);
		}
	}
}