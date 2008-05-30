/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.core.cogs {
	import flash.events.Event;	
	
	public class NullStateMachine implements IStateMachine, IFiniteStateMachine, IStackableStateMachine {
		
		public function NullStateMachine() {
		}
		
		public function initStateMachine() : void {
		}
		
		public function deactivateStateMachine() : void {
		}
		
		public function tran(targetState : Function, transOptions : TransitionOptions = null, crossAction : Function = null) : * {
			return null;
		}
		
		public function requestTran(state : Function, transOptions : TransitionOptions = null, crossAction : Function = null) : void {
		}
		
		public function isInState(state : Function) : Boolean {
			return null;
		}
		
		public function hasEventsInQue() : Boolean {
			return false;
		}
		
		public function getStateMachineName() : String {
			return "";
		}
		
		public function setStateMachineName(newName : String) : void {
		}
		
		public function dispatchEvent(event : Event) : Boolean {
			return false;
		}
		
		public function hasEventListener(type : String) : Boolean {
			return false;
		}
		
		public function willTrigger(type : String) : Boolean {
			return false;
		}
		
		public function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void {
		}
		
		public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
		}
		
		public function get stateMachine_hasInited() : Boolean {
			return false;
		}
		
		public function getParent() : IStateMachine {
			return null;
		}
		
		public function setParent(parent : IStateMachine, reciprocate : Boolean = true) : void {
		}
		
		public function getChild() : IStateMachine {
			return null;
		}
		
		public function setChild(parent : IStateMachine, reciprocate : Boolean = true) : void {
		}
	}
	
}
