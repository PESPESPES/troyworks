package com.troyworks.cogs
{
	/* this class extends the basic flat state machine
	* using the EventDispatcher for the Enter and Exit events.
	* this is best for synchronizing multiple states together, at finer 
	* granularity but slower performance 29ms/1000 state transitions
	* vers 7ms/1000  of Fsm
	*
	*/
	public class FsmE extends Fsm {
		
		public function FsmE() {
			super();
		}

		override public function set currentState(state:Function):void {
			if (state == null) {
				// No state transition taken if invalid target state
				return;
			}
			/////// valid state transition ////////////////////
			var oldState:Function=_currentState;
			///////EXIT OLD STATES //////////////////////////////
			if (_currentState != null) {
				dispatchEvent(CogEvent.getExitEvent());
				removeEventListener(CogEvent.EVTD_COG_PRIVATE_EVENT,_currentState);
				_currentState=null;
			}
			
			///////No we are betwen state, FIRE BETWEEN STATE TRANSITION EVENTS /////////////////////

			////////ENTER NEW STATE //////////////////////////////
			addEventListener(CogEvent.EVTD_COG_PRIVATE_EVENT,state);
			dispatchEvent(CogEvent.getEnterEvent());
			_currentState=state;

			// FINISHED - notify the rest of the world of the state change, if there is anybody there
			if (hasEventListener(CogExternalEvent.CHANGED)) {
			var cogE:CogExternalEvent=new CogExternalEvent(CogExternalEvent.CHANGED,oldState,_currentState);
			dispatchEvent(cogE);
			}

		}

	}
}