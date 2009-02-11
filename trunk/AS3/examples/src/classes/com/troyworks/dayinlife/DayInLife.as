/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.dayinlife {
	import com.troyworks.core.cogs.*;
	import com.troyworks.core.patterns.AsyncEnterExit;
	import com.troyworks.core.SignalEventAdaptor;
	import com.troyworks.core.Signals;
	import flash.display.MovieClip;
	
	public class DayInLife extends Hsm{
		protected var atHome:IStackableStateMachine; 
		protected var inCommute:IStackableStateMachine; 
		protected var atWork:IStackableStateMachine; 
		protected var destination:Function;
		
		
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
		
		
		
		public const REQUEST_GOTO_HOME:CogSignal = CogSignal.getNextSignal("REQUEST_GOTO_HOME");
		public const REQUEST_GOTO_WORK:CogSignal = CogSignal.getNextSignal("REQUEST_GOTO_WORK");
		
		public function DayInLife(initState:String = "s_initial", tl : MovieClip = null) {
			super(initState, "DayInLife");
			trace("new DayInLife------------------");
			
			enterAdapter =  new SignalEventAdaptor(dispatchEvent, ENTERED);
			exitAdapter =  new SignalEventAdaptor(dispatchEvent, EXITED);
			
			
			
			
			atHome = new AtHome() as IStackableStateMachine;
			atHome.addEventListener(CogSignal.INIT.name, enterAdapter.relayEvent);
			inCommute = new Driving() as IStackableStateMachine;
			
			atWork = new AtWork() as IStackableStateMachine;
		}
		////////////////////// TESTS //////////////////////////////////
				////////////////// ACCESSORS ///////////////////////////
		public function isAtHome():Boolean{
			return isInState(s_atHome);
		}
		public function isAtWork():Boolean{
			return isInState(s_atWork);
		}
		public function isCommuting():Boolean{
			return isInState(s_inCommute);
		}
		///////////////////// TRIGGERS ///////////////////////////////
		public function goHome():Object{
			return dispatchEvent(REQUEST_GOTO_HOME.createPrivateEvent());
		}
		public function goToWork():Object{
			return dispatchEvent(REQUEST_GOTO_WORK.createPrivateEvent());
		}
		///////////////////// STATES ///////////////////////////////
		/*.................................................................*/
		public function s_initial(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_INIT :
					return s_atHome;
			}
			//return  super.s_initial(e);
				return  s_root;
		}
		/*.................................................................*/
		public function s_dayTime(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_ENTRY :
					return null;
				case SIG_EXIT :
					return null;
				case REQUEST_GOTO_WORK :	
					destination = s_atWork;
					tran(s_inCommute);
					return null;
				case REQUEST_GOTO_HOME :	
					destination = s_atWork;
					tran(s_inCommute);
					return null;
				
			}
			return  s_root;
		}
		/*.................................................................*/
		public function s_atHome(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_ENTRY :
				trace("ENTERING AT HOME " + atHome);
					setChild(atHome, false);
				     atHome.initStateMachine();
					return null;
			//	case ENTERED:
			//		trace("ENTERED AT HOME ");
			//		return null;
					
				case SIG_EXIT :
					trace("EXITING AT HOME ");
				     atHome.deactivateStateMachine();
					 setChild(null, false);
					return null;
			}
			return  s_dayTime;
		}
		
		/*.................................................................*/
		public function s_inCommute(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_ENTRY :
					callbackIn(1500);
					return null;
				case SIG_EXIT :
					return null;
				case SIG_CALLBACK :	
					//////////// GOTO HOME OR WORK DEPENDING ON WHERE WE ARE COMING FROM
					tran(destination);
					return null;
			}
			return  s_dayTime;
		}
		/*.................................................................*/
		public function s_atWork(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_ENTRY :
					setChild(atWork, false);
				     atWork.initStateMachine();
					return null;
				case SIG_EXIT :
					trace("EXITING AT WORK ");
				     atWork.deactivateStateMachine();
					 setChild(null, false);
					return null;
			}
			return  s_dayTime;
		}
	}
	
}
