package com.troyworks.core.cogs
{
	import flash.events.IEventDispatcher;
	
	/**************************************
	* 
	* IStateMachine
	*    IFiniteStateMachine
	*       IHeirarchicalStateMachine
	* 
	* 
	* *************************************/
	public interface IStateMachine extends IEventDispatcher 
	{
		
		function initStateMachine():void;
		function deactivateStateMachine():void;
		function get stateMachine_hasInited():Boolean;
		
		/* transition immediately, risk of single threaded not callling transition and code as expected past transitions
		 * crossAction should be return 'immediately' meaning not call/callback, for that introduce a new state*/
		function tran(targetState:Function, transOptions:TransitionOptions = null, crossAction:Function= null):*;
		/* safe but slow transition, qued
		 *  crossAction should be return 'immediately' meaning not call/callback, for that introduce a new state*/
		function requestTran(state:Function, transOptions:TransitionOptions = null, crossAction:Function = null):void;
		
		function isInState(state:Function):Boolean;
		function hasEventsInQue():Boolean;
		function getStateMachineName():String;
		function setStateMachineName(newName:String):void;

	}
}