/**
* This deals with composite heirarchical states (as is typical for Chain and Score)
* @author Default
* @version 0.1
*/
package com.troyworks.core.cogs;

interface ICompositeStackable implements IStateMachine {

	function getParent() : IStateMachine;
	function setParent(parent : IStateMachine, reciprocate : Bool = true) : Void;
	function getChild() : IStateMachine;
	function addChild(parent : IStateMachine, reciprocate : Bool = true) : Void;
	function removeChild(parent : IStateMachine, reciprocate : Bool = true) : Void;
}

