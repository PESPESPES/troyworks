/**
* ...
* @author Default
* @version 0.1
*/
package com.troyworks.core.cogs;

interface IStackableStateMachine implements IStateMachine {

	function getParent() : IStateMachine;
	function setParent(parent : IStateMachine, reciprocate : Bool = true) : Void;
	function getChild() : IStateMachine;
	function setChild(parent : IStateMachine, reciprocate : Bool = true) : Void;
}

