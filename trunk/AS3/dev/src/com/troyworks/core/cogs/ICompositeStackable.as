/**
* This deals with composite heirarchical states (as is typical for Chain and Score)
* @author Default
* @version 0.1
*/

package com.troyworks.core.cogs {

	public interface ICompositeStackable extends IStateMachine{
		function getParent():IStateMachine;
		function setParent(parent:IStateMachine, reciprocate:Boolean = true):void;
		function getChild():IStateMachine;
		function addChild(parent:IStateMachine, reciprocate:Boolean = true):void;
		function removeChild(parent:IStateMachine, reciprocate:Boolean = true):void;
		
	}
	
}
