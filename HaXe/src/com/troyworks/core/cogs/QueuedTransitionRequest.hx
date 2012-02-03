/**
* ...
* @author Default
* @version 0.1
*/
package com.troyworks.core.cogs;
import flash.events.Event;
import com.sf.Option;using com.sf.Option;
import com.troyworks.core.cogs.StateMachine;

class QueuedTransitionRequest {

	//////////////////////////////////////////////////////////////////
	public var trg 			: State;
	public var opts 		: TransitionOptions;
	public var crossAction 	: Void->Void;
	//public var doInitDiscovery:Boolean = false;
	public function new(targetState : State, transOptions : TransitionOptions = null, crossLCAAction : Void->Void = null) {
		trg = targetState;
		opts = ((transOptions == null)) ? TransitionOptions.DEFAULT : transOptions;
		crossAction = crossLCAAction;
	}

}

