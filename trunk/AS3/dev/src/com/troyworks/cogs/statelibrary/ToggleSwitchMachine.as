package com.troyworks.cogs.statelibrary
{
	import com.troyworks.cogs.Fsm;
	import flash.events.Event;
	import com.troyworks.cogs.CogEvent;
	import com.troyworks.cogs.CogSignal;

	/*********************************************
	 * This mimicks a toggleable switch, e.g a light switch
	 * with an ON, OFF and a toggle push button.
	 * 
	 * This is a simple pattern that comes up often and is good
	 * not to reinvent.
	 * *********************************************/
	 class ToggleSwitchMachineSignal extends CogSignal{
		public static const  TOGGLE_SIG : CogSignal =CogSignal.getNextSignal("TOGGLE");	
	}
	 class ToggleSwitchMachineEvent extends CogEvent{
		public static function getToggleEvent():ToggleSwitchMachineEvent{
		  return new ToggleSwitchMachineEvent(CogEvent.EVTD_COG_PRIVATE_EVENT,ToggleSwitchMachineSignal.TOGGLE_SIG);
		}
	}

	public class ToggleSwitchMachine extends Fsm
	{
		private var _nextState:Function;
		public function ToggleSwitchMachine(defaultOff:Boolean){
			super();
			_initState= s_initial;
			_nextState = (defaultOff)?s_OFF: s_ON;
			trace("new ToggleSwitchMachine");

		}
		////////////////// ACCESSORS /////////////////////
		public function isON():Boolean{
			return (hasInited() && isInState(s_ON));
		}
		public function isOFF():Boolean{
			return (hasInited() && isInState(s_OFF));
		}

		////////////////// METHODS ///////////////////////
		public function toggle():void{
			var evt:Event = ToggleSwitchMachineEvent.getToggleEvent();
			dispatchEvent(evt);
		}
		public function turnOff():void{
			if(hasInited() && !isInState(s_OFF)){
				currentState = s_OFF;
			}
		}
		public function turnON():void{
			if(hasInited() && !isInState(s_ON)){
				currentState = s_ON;
			}
		}
		////////////////// STATES /////////////////////////////
		public function s_initial(event:CogEvent):void {
			currentState=_nextState;
			//hasInited= ;
		}

		public function s_ON(event:CogEvent):void {
			//trace("TwoStateFsm.s_ON " + event);
			if(isInState(s_ON)){
			switch(event.sig){
				case SIG_PULSE:
				currentState = s_OFF;
				break;
			}
			}

		}
		public function s_OFF(event:CogEvent):void {
			//trace("TwoStateFsm.s_OFF " + event);
			if(isInState(s_OFF)){
			switch(event.sig){
				case SIG_PULSE:
				currentState = s_ON;
				break;
			}
			}
		}

	}
}