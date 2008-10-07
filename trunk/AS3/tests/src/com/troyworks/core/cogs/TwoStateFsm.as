package com.troyworks.core.cogs{
	import flash.events.Event;
	import com.troyworks.core.cogs.CogEvent;
	import com.troyworks.core.cogs.CogSignal;
	public class TwoStateFsm extends Fsm {
		public function TwoStateFsm(toOff:Boolean = false) {
			super();
			_initState=(toOff)?initial_to_OFF: initial;
			trace("new TwoStateFsm");

		}
		////////////////// ACTIONS ///////////////////////
		public function toggle():void{
				var evt:Event = CogEvent.getPulseEvent();
			dispatchEvent(evt);
		}
		public function requestToggle():void{
			var evt:Event = CogEvent.getCallbackEvent();
			dispatchEvent(evt);
		}
		////////////////// ACCESSORS ///////////////////////////
		public function isOff():Boolean{
			return isInState(OFF_state);
		}
		public function isOn():Boolean{
			return isInState(ON_state);
		}

		////////////////// STATES /////////////////////////////
		public function initial(event:CogEvent):void {
			trace("TwoStateFsm.initialState");
			tran(OFF_state);
			fsm_hasInited = true;
		}
		public function initial_to_OFF(event:CogEvent):void {
			//trace("TwoStateFsm.initial_to_OFF");
			tran(OFF_state);
			
			fsm_hasInited = false;
		//	fsm_inited();
		}

		public function ON_state(event:CogEvent):void {
			//trace("TwoStateFsm.ON_state " + event);
			switch(event.sig){
				case SIG_PULSE:
				requestTran(OFF_state);
				
				break;
				case SIG_CALLBACK:
				requestTran(OFF_state);
				break;
			}

		}
		public function OFF_state(event:CogEvent):void {
			//trace("TwoStateFsm.OFF_state " + event);
			switch(event.sig){
				case SIG_PULSE:
				requestTran(OFF_state);
				break;
				case SIG_CALLBACK:
				requestTran(ON_state);
				break;

			}
		}

	}
}