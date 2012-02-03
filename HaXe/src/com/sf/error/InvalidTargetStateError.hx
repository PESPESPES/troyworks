package com.sf.error;
import com.troyworks.core.cogs.StateMachine;
import haxe.PosInfos;

/**
 * ...
 * @author 0b1kn00b
 */

class InvalidTargetStateError extends Error {

	public function new(mchn:StateMachine,tgt,?pos:PosInfos) {
		super("State target is invalid on " + mchn.getStateMachineName() + " in " + pos.className);
	}
	
}