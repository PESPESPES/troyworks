/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.core.cogs {

	public interface IStackableStateMachine extends IStateMachine{
		function getParent():IStateMachine;
		function setParent(parent:IStateMachine, reciprocate:Boolean = true):void;
		function getChild():IStateMachine;
		function setChild(parent:IStateMachine, reciprocate:Boolean = true):void;
		
	}
	
}
