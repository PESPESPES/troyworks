/**
* This is a template for states that have entering, exiting states that are pluggable.
* The gist of this is creating a template sitemap in one layer the interface/sitemap with 
* the concrete/pluggable implementors as separate (or even composite) states, yet share
* a common single activation heirarchy.
* 
* eg. A foundational sitemap might be AtHome InCommute AtWork, where each is implemented by a statemachine
* with a 
* 
* @author Default
* @version 0.1
*/

package com.troyworks.core.patterns {
	import com.troyworks.core.cogs.CogSignal;
	import com.troyworks.core.cogs.EightStateMachineEvent;
	import com.troyworks.core.cogs.Hsm;
	import com.troyworks.core.cogs.CogEvent;
	import com.troyworks.core.cogs.CogExternalEvent;
	import com.troyworks.core.cogs.IStackableStateMachine;
	import com.troyworks.core.Signals;
	import com.troyworks.core.SignalEventAdaptor;
	public class AsyncEnterExit extends Hsm{
		
		public var enteringState:IStackableStateMachine;
		public var enteredState:IStackableStateMachine;
		public var exitingState:IStackableStateMachine;
		
		public var enterAdapter:SignalEventAdaptor;
		public var exitAdapter:SignalEventAdaptor;
	
		
		public const REQUEST_INIT:Signals = Signals.REQUEST_INITIALIZATION;
		public const INITIALIZED:Signals = Signals.INITIALIZED;
		
		public const REQUEST_ENTER:Signals = Signals.REQUEST_ENTER;
		public const ENTERED:Signals = Signals.ENTERED;
		
		public const REQUEST_EXIT:Signals = Signals.REQUEST_EXIT;
		public const EXITED:Signals = Signals.EXITED;

		public const REQUEST_DEACTIVATION:Signals = Signals.REQUEST_DEACTIVATION;
		public const DEACTIVATED:Signals = Signals.DEACTIVATED;

		public function AsyncEnterExit(initState:String, hsmName:String) {
			super(initState, hsmName);
			enterAdapter =  new SignalEventAdaptor(dispatchEvent, ENTERED);
			exitAdapter =  new SignalEventAdaptor(dispatchEvent, EXITED);
		}
		public function request_ENTER():void{
			trace("HIGHLIGHTO firing SELF");
			dispatchEvent(REQUEST_ENTER.createPrivateEvent());
		}	
		public function request_EXIT():void{
			trace("HIGHLIGHTO firing SELF");
			dispatchEvent(REQUEST_EXIT.createPrivateEvent());

		}	
		public function setEnteringState(fn:IStackableStateMachine):void{
			if(enteringState != null){
				enteringState.removeEventListener(CogExternalEvent.INIT, enterAdapter.relayEvent );
				enteringState.setParent(null);
			}
			if(enteringState != fn){
				enteringState = fn;
				enteringState.addEventListener(CogExternalEvent.INIT, enterAdapter.relayEvent );
				fn.setParent(this);
			}
		}
		public function setEnteredState(fn:IStackableStateMachine):void{
			enteredState = fn;
			fn.setParent(this);
		}		
		public function setExitingState(fn:IStackableStateMachine):void{
			exitingState = fn;
			exitingState.addEventListener(EXITED.name, dispatchEvent);
			fn.setParent(this);
		}
	
		///////////////////// STATES ///////////////////////////////
		/*.................................................................*/
		public function s_initial(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_INIT :
					return s_exited;
			}
			return  s_root;
		//	return  super.s_initial(e);
		}
		/*.................................................................*/
		public function s_smOn(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_ENTRY :
					return null;
				case SIG_EXIT :
					return null;
			}
			return  s_root;
		}
		/*.................................................................*/
		public function s_exited(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_ENTRY :
					return null;
				case SIG_EXIT :
					return null;
			}
			return  s_smOn;
		}
		/*.................................................................*/
		public function s_entering(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_ENTRY :
					setChild(enteringState, false);
					enteringState.initStateMachine();
					return null;
				case SIG_EXIT :
					enteringState.deactivateStateMachine();
					setChild(null, false);
					return null;
			}
			return  s_smOn;
		}

		/*.................................................................*/
		public function s_entered(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_ENTRY :
					setChild(enteredState, false);
					enteredState.initStateMachine();
					return null;
				case SIG_EXIT :
					setChild(null, false);
					enteredState.deactivateStateMachine();				
					return null;
			}
			return  s_smOn;
		}
		/*.................................................................*/
		public function s_exiting(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_ENTRY :
					setChild(exitingState, false);
					exitingState.initStateMachine();
					return null;
				case SIG_EXIT :
					exitingState.deactivateStateMachine();
					setChild(null, false);
					return null;
			}
			return  s_smOn;
		}		


	}
	
}
