package com.troyworks.core.patterns {
	import com.troyworks.core.cogs.Fsm;
	import flash.events.Event;
	import com.troyworks.core.cogs.CogEvent;
	import com.troyworks.core.cogs.CogSignal;

	/*********************************************
	 * This mimicks a toggleable switch, e.g a light switch
	 * with an DIRTY, CLEAN and a toggle push button.
	 * 
	 * This is a simple pattern that comes up often and is good
	 * not to reinvent.
	 * *********************************************/
	public class VariableDirtyCleanMachine extends Fsm
	{
		public var last:Object;
		public var diff:Object;
		
				
		public static const  SIG_DIRTY : CogSignal =CogSignal.getNextSignal("DIRTY");
		public static const  SIG_CLEAN : CogSignal =CogSignal.getNextSignal("CLEAN");		
			
		public function VariableDirtyCleanMachine(initStateNameAct : String ="s_CLEAN", smName:String = "DIRTY_FSM", aInit : Boolean = true){
			super(initStateNameAct, smName, aInit);
			trace("new DirtyCleanMachine");

		}
		////////////////// ACCESSORS /////////////////////
		public function isDIRTY():Boolean{
			return (fsm_hasInited && isInState(s_DIRTY));
		}
		public function isCLEAN():Boolean{
			return (fsm_hasInited && isInState(s_CLEAN));
		}

		////////////////// METHODS ///////////////////////
		
		public function fireDirty():void{
			var evt:Event = SIG_DIRTY.createPrivateEvent();
			dispatchEvent(evt);
		}
		public function fireClean():void{
			var evt:Event = SIG_CLEAN.createPrivateEvent();
			dispatchEvent(evt);	
		}
		
		private function crossDirtyToClean(){
			trace("crossDirtyToClean");
		}
		private function crossCleanToDirty(){
			trace("crossCleanToDirty");
		}
		
		////////////////// STATES /////////////////////////////
		

		public function s_DIRTY(event:CogEvent):void {
			trace("DirtyCleanMachine.s_DIRTY " + event);
			switch(event.sig){
				case SIG_CLEAN:
				tran(s_CLEAN, null, crossDirtyToClean);
				break;
			}

		}
		public function s_CLEAN(event:CogEvent):void {
			trace("DirtyCleanMachine.s_CLEAN " + event);
			switch(event.sig){
		
				case SIG_DIRTY:
				tran(s_DIRTY, null, crossCleanToDirty);
				break;
			}
		}

	}
}