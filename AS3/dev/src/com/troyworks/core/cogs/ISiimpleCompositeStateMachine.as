/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.core.cogs {

	public class ASimpleCompositeStateMachine extends Fsm {
		private var _initState:IStateMachine;
		private var _enterState:IStateMachine;
		private var _inState:IStateMachine;
		private var _exitState:IStateMachine;
		public function ASimpleCompositeStateMachine(iniState:IStateMachine, enterState:IStateMachine, inState:IStateMachine, exitState:IStateMachine):void{
			
			_initState = iniState;
			_enterState = enterState;
			_inState = enterState;
			_exitState = exitState
		}
		////////////////// STATES /////////////////////////////
		public function initial(event:CogEvent):void {
			trace("TwoStateFsm.initialState");
			tran(s_OFF);
			fsm_inited();
		}
		////////////////// STATES /////////////////////////////
		public function s_requestingEnter(event:CogEvent):void {
			//trace("ASimpleCompositeStateMachine.s_requestingEnter " + event);
			switch(event.sig){
				case SIG_ENTRY:
				_enterState.dispatchEvent(event);
				tran(s_pendingEnter);
				break;
				case CogSignal.CALLBACK:
				requestTran(s_OFF);
				break;
			}

		}
		public function s_pendingEnter(event:CogEvent):void {
			//trace("ASimpleCompositeStateMachine.s_pendingEnter " + event);
			switch(event.sig){
				case CogSignal.PULSE:
				tran(s_OFF);
				break;
				case CogSignal.CALLBACK:
				requestTran(s_OFF);
				break;
			}

		}
	}
	
}
