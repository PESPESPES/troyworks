/* this class extends the basic flat state machine
* using the EventDispatcher for the Enter and Exit events.
* this is best for synchronizing multiple states together, at finer 
* granularity but slower performance 29ms/1000 state transitions
* vers 7ms/1000  of Fsm
*
*/
package com.troyworks.core.cogs;

import com.sf.Option;using com.sf.Option;

class FsmE extends Fsm {

	public function new() {
		super();
	}

	override function set_currentState(state : Option<CogEvent->Dynamic>) : Option<CogEvent -> Dynamic> {
		if(state == null)  {
			// No state transition taken if invalid target state
			return null;
		}
		var oldState : Option<CogEvent->Dynamic> = currentState;
		///////EXIT OLD STATES //////////////////////////////
		if(currentState != null)  {
			dispatchEvent(CogEvent.getExitEvent());
			removeEventListener(CogEvent.EVTD_COG_PRIVATE_EVENT, currentState);
			currentState = null;
		}
		addEventListener(CogEvent.EVTD_COG_PRIVATE_EVENT, state);
		dispatchEvent(CogEvent.getEnterEvent());
		currentState = state;
		// FINISHED - notify the rest of the world of the state change, if there is anybody there
		if(hasEventListener(CogExternalEvent.CHANGED))  {
			var cogE : CogExternalEvent = new CogExternalEvent(CogExternalEvent.CHANGED, oldState, currentState);
			dispatchEvent(cogE);
		}
		return state;
	}

}

