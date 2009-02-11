package com.troyworks.core.patterns {
	import com.troyworks.core.cogs.Fsm;
	import com.troyworks.core.cogs.CogEvent;	
	import com.troyworks.core.cogs.CogSignal;	
		
	
	/**
	 * RequiredOptionalMachine
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Aug 23, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class RequiredOptionalMachine extends Fsm {
		public static const SIG_REQUIRED : CogSignal = CogSignal.getNextSignal("DATA_CHANGED");
		public static const SIG_NOT_REQUIRED : CogSignal = CogSignal.getNextSignal("DATA_NOT_REQUIRED");
		
		protected var lastValid:Boolean = false;
		protected var curValid:Boolean = false;
		
		
		public function RequiredOptionalMachine(initStateNameAct : String = "s_optional", smName : String = "FSM", aInit : Boolean = true) {
			super(initStateNameAct, smName, aInit);
		}
				////////////////// ACCESSORS ///////////////////////////
		public function isInValid():Boolean{
			return isInState(s_optional);
		}
		public function isValid():Boolean{
			return isInState(s_required);
		}
		public function setValidity(newValidity:Boolean):void{
			if(newValidity != curValid){
				lastValid = curValid;
				curValid = lastValid;
				if(curValid){
					dispatchEvent(SIG_REQUIRED.cachedEvent);
				}else{
					dispatchEvent(SIG_NOT_REQUIRED.cachedEvent);
				}
				//dispatchEvent(SIG_REQUIRED.createPrivateEvent());
			}
		}

		////////////////// STATES /////////////////////////////
		public function s_optional(event:CogEvent):void {
			trace("Validator.s_optional " + event);
			switch(event.sig){
				case SIG_REQUIRED:
				tranFast(s_required);
				break;
			}

		}
		public function s_required(event:CogEvent):void {
			trace("Validator.s_required " + event);
			switch(event.sig){
				case SIG_NOT_REQUIRED:
				tranFast(s_optional);
				break;
				
			}

		}
	}		
}
