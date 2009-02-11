package com.troyworks.core.patterns {
	import com.troyworks.core.cogs.CogEvent;	
	import com.troyworks.core.cogs.CogSignal;	
	import com.troyworks.core.cogs.Fsm;
	
	/**
	 * ValidInvalidMachine
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Aug 23, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class ValidInvalidMachine extends Fsm {
		public static const SIG_DATA_CHANGED : CogSignal = CogSignal.getNextSignal("DATA_CHANGED");
		public static const SIG_DATA_VALID : CogSignal = CogSignal.getNextSignal("DATA_VALID");
		public static const SIG_DATA_INVALID : CogSignal = CogSignal.getNextSignal("DATA_INVALID");
		
		protected var lastValid:Boolean = false;
		protected var curValid:Boolean = false;
		
		public function ValidInvalidMachine(initStateNameAct : String = null, smName : String = "ValidInvalidFSM", aInit : Boolean = true) {
			super(initStateNameAct, smName, aInit);
		}
		////////////////// ACCESSORS ///////////////////////////
		public function isInValid():Boolean{
			return isInState(s_invalid);
		}
		public function isValid():Boolean{
			return isInState(s_valid);
		}
		public function setValidity(newValidity:Boolean):void{
			if(newValidity != curValid){
				lastValid = curValid;
				curValid = lastValid;
				if(curValid){
					dispatchEvent(SIG_DATA_VALID.cachedEvent);
				}else{
					dispatchEvent(SIG_DATA_INVALID.cachedEvent);
				}
				//dispatchEvent(SIG_DATA_CHANGED.createPrivateEvent());
			}
		}

		////////////////// STATES /////////////////////////////
		public function s_invalid(event:CogEvent):void {
			trace("Validator.s_invalid " + event);
			switch(event.sig){
				case SIG_DATA_VALID:
				tranFast(s_valid);
				break;
			}

		}
		public function s_valid(event:CogEvent):void {
			trace("Validator.s_valid " + event);
			switch(event.sig){
				case SIG_DATA_INVALID:
				tranFast(s_invalid);
				break;
				
			}

		}
	}
}
