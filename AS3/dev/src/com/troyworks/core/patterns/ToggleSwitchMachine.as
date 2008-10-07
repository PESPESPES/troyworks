package com.troyworks.core.patterns {
	import com.troyworks.core.cogs.Fsm;
	import flash.events.Event;
	import com.troyworks.core.cogs.CogEvent;
	import com.troyworks.core.cogs.CogSignal;

	/*********************************************
	 * This mimicks a toggleable switch, e.g a light switch
	 * with an ON, OFF and a toggle push button.
	 * 
	 * This is a simple pattern that comes up often and is good
	 * not to reinvent.
	 * *********************************************/
	public class ToggleSwitchMachine extends Fsm
	{
		private var _nextState:Function;
		public static const  SIG_ON : CogSignal =CogSignal.getNextSignal("ON");
		public static const  SIG_OFF : CogSignal =CogSignal.getNextSignal("OFF");		
		public static const  SIG_TOGGLE : CogSignal =CogSignal.getNextSignal("TOGGLE");
		public function ToggleSwitchMachine(defaultOff:Boolean){
			super();
			_initState= s_initial;
			_nextState = (defaultOff)?s_OFF: s_ON;
			trace("new ToggleSwitchMachine");

		}
		////////////////// ACCESSORS /////////////////////
		public function isON():Boolean{
			return (fsm_hasInited && isInState(s_ON));
		}
		public function isOFF():Boolean{
			return (fsm_hasInited && isInState(s_OFF));
		}

		////////////////// METHODS ///////////////////////
		public function toggle():void{
			dispatchEvent(SIG_TOGGLE.createPrivateEvent());
		}
		public function turnOff():void{
			if(fsm_hasInited && !isInState(s_OFF)){
				tran(s_OFF);
			}
		}
		public function turnON():void{
			if(fsm_hasInited && !isInState(s_ON)){
				tran(s_ON);
			}
		}
		////////////////// STATES /////////////////////////////
		public function s_initial(event:CogEvent):void {
			tran(_nextState);
			//hasInited= ;
		}

		public function s_ON(event:CogEvent):void {
			//trace("TwoStateFsm.s_ON " + event);
			if(isInState(s_ON)){
			switch(event.sig){
				case SIG_PULSE:
				tran(s_OFF);
				break;
			}
			}

		}
		public function s_OFF(event:CogEvent):void {
			//trace("TwoStateFsm.s_OFF " + event);
			if(isInState(s_OFF)){
			switch(event.sig){
				case SIG_PULSE:
				tran(s_ON);
				break;
			}
			}
		}

	}
	/*class ToggleSwitchMachineSignal extends CogSignal{
			
	}
	 class ToggleSwitchMachineEvent extends CogEvent{
		public static function getToggleEvent():ToggleSwitchMachineEvent{
		  return new ToggleSwitchMachineEvent(CogEvent.EVTD_COG_PRIVATE_EVENT,ToggleSwitchMachineSignal.TOGGLE_SIG);
		}
	}*/
	
}