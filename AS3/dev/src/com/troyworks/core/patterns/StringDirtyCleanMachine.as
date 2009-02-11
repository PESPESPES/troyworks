package com.troyworks.core.patterns {
	import com.troyworks.data.DataChangedEvent;	
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
	public class StringDirtyCleanMachine extends Fsm
	{
		private var _nextState:Function;
		
		public var lastValue:String;
		public var curValue:String;
		
		
		public static const  SIG_DIRTY : CogSignal =CogSignal.getNextSignal("DIRTY");
		public static const  SIG_CLEAN : CogSignal =CogSignal.getNextSignal("CLEAN");		
			
		public function StringDirtyCleanMachine(initStateNameAct : String ="s_CLEAN", smName:String = "DIRTY_FSM", aInit : Boolean = true){
			super(initStateNameAct, smName, aInit);
//			_initState= s_initial;
	//		_nextState = (startClean)?s_CLEAN: s_DIRTY;
			trace("new StringDirtyCleanMachine");

		}
		
		public function set value(newVal:String):void{
			if(curValue != newVal){
				lastValue = curValue;
				curValue = newVal;	
				fireDirty();				
			}
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
			trace("StringDirtyCleanMachine.s_DIRTY " + event);
			switch(event.sig){
				case SIG_ENTRY:
						var evt:DataChangedEvent = new DataChangedEvent();
						evt.oldVal = lastValue;
						evt.currentVal = curValue;						
						dispatchEvent(evt);
				break;
				case SIG_CLEAN:
				tranFast(s_CLEAN, null, crossDirtyToClean);
				break;
			}

		}
		public function s_CLEAN(event:CogEvent):void {
			trace("StringDirtyCleanMachine.s_CLEAN " + event);
			switch(event.sig){
		
				case SIG_DIRTY:
				tranFast(s_DIRTY, null, crossCleanToDirty);
				break;
			}
		}

	}
}