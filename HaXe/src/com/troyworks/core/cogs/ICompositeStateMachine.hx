/**
* ...
* @author Default
* @version 0.1
*/
package com.troyworks.core.cogs;

interface ICompositeStateMachine implements IStackableStateMachine {

	function iterator() : Dynamic;
	function addSubState(sm : IStateMachine) : Void;
	function removeSubState(sm : IStateMachine) : Void;
	function addTransition(from : IStateMachine, to : IStateMachine) : Void;
	function removeTransition(from : IStateMachine, to : IStateMachine) : Void;
}

