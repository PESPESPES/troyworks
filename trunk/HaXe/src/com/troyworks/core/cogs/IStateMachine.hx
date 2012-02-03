/**************************************
* 
* IStateMachine
*    IFiniteStateMachine
*       IHeirarchicalStateMachine
* 
* 
* *************************************/
package com.troyworks.core.cogs;
import flash.events.Event;
import com.sf.Option;using com.sf.Option;
import flash.events.IEventDispatcher;

interface IStateMachine implements IEventDispatcher {
	var stateMachine_hasInited(getStateMachine_hasInited, never) : Bool;

	function initStateMachine() : Void;
	function deactivateStateMachine() : Void;
	function getStateMachine_hasInited() : Bool;
	/* transition immediately, risk of single threaded not callling transition and code as expected past transitions
	 * crossAction should be return 'immediately' meaning not call/callback, for that introduce a new state*/
	function tran(targetState : Dynamic, transOptions : TransitionOptions = null, crossAction : Void -> Void= null,?pos:haxe.PosInfos) : Dynamic;
	/* safe but slow transition, qued
	 *  crossAction should be return 'immediately' meaning not call/callback, for that introduce a new state*/
	function requestTran(state : Dynamic , transOptions : TransitionOptions = null, crossAction : Void -> Void= null) : Void;
	function isInState(state : Dynamic ) : Bool;
	function hasEventsInQue() : Bool;
	function getStateMachineName() : String;
	function setStateMachineName(newName : String) : Void;
}

