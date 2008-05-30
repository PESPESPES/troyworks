/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.core.cogs {

	public interface ICompositeStateMachine extends IStackableStateMachine{
		
		function iterator():Object;
		function addSubState(sm:IStateMachine):void;
		function removeSubState(sm:IStateMachine):void;
		function addTransition(from:IStateMachine, to:IStateMachine):void;
		function removeTransition(from:IStateMachine, to:IStateMachine):void;


		
	}
	
}
