package com.troyworks.data.validators {
	import com.troyworks.core.Signals;	
	import com.troyworks.core.cogs.CogSignal;	
	import com.troyworks.core.cogs.CogEvent;	
	import com.troyworks.core.cogs.Fsm; 

	/**
	 * A composite validator 
	 * 
	 * In general RIA validation takes the form of two types both with
	 * the goal of providing immediate feedback to the user when something
	 * has gone wrong.
	 * 
	 * 1) 'live' - after a field has recieved focus, while a user is typing/entering values
	 *     eg. invalid characters, you have 3 characters left
	 * 2) 'completed' - after a field has lost focus, type and range checkiing
	 *     e.g.
	 * 
	 * In general Validators live in the spectrum here:
	 * 
	 * UI Field -> Format Parser -> Tmp Model -> Validator ->Model  
	 * 
	 * @author Troy Gardner
	 */
	public class Validator extends Fsm {

		public static const SIG_DATA_CHANGED:CogSignal = CogSignal.getNextSignal("SIG_DATA_CHANGED") ;
		public static const SIG_DATA_VALID:CogSignal  = CogSignal.getNextSignal("SIG_DATA_VALID") ;
		public static const SIG_DATA_INVALID:CogSignal  = CogSignal.getNextSignal("SIG_DATA_INVALID") ;
		public var validators : Array = new Array();
		private var curValue : Object;
		private var lastValue : Object;
		
		public function Validator(initStateNameAct : String =null, smName:String = "Validator", aInit : Boolean = true ) {
			super(initStateNameAct, smName, aInit);
		}

		public function addValidator(validator:Validator):void{
			validators.push(validator);
		}
		public function reset():void{
		
		}
		public function doValidation(val:Object):Boolean{
			var passed:Boolean = true;
			if(validators.length > 0){
				for (var i : Number = 0; i < validators.length; i++) {
					var cValidR:Validator = Validator(validators[i]);
					passed = cValidR.doValidation(val);
					
				}
			}
			return passed;
		}
		////////////////// ACCESSORS ///////////////////////////
		public function isInValid():Boolean{
			return isInState(s_invalid);
		}
		public function isValid():Boolean{
			return isInState(s_valid);
		}
		public function setValue(newValue:Object):void{
			if(newValue != curValue){
				lastValue = curValue;
				curValue = newValue;
				dispatchEvent(SIG_DATA_CHANGED.createPrivateEvent());
			}
		}

		////////////////// STATES /////////////////////////////
		public function s_invalid(event:CogEvent):void {
			trace("Validator.s_invalid " + event);
			switch(event.sig){
				case SIG_ENTRY:
				break;
				case SIG_DATA_CHANGED:
				tranFast(s_validating);	
				break;
				case SIG_DATA_VALID:
				tranFast(s_valid);
				break;
			}

		}
		public function s_valid(event:CogEvent):void {
			trace("Validator.s_valid " + event);
			switch(event.sig){
				case SIG_ENTRY:
				break;
				case SIG_DATA_CHANGED:
				tranFast(s_validating);	
				break;
				case SIG_DATA_INVALID:
				tranFast(s_invalid);
				break;
				
			}

		}
		public function s_validating(event:CogEvent):void {
			//trace("TwoStateFsm.ON_state " + event);
			switch(event.sig){
				case SIG_ENTRY:
				//should have 
				if(doValidation(curValue)){
					tranFast(s_valid);									
				}else{
					tranFast(s_invalid);				
				}
				break;
				case SIG_EXIT:
				//reset validators
				break;
			}

		}
	}
}