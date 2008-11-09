
/**
 * TextFieldEmailValidator
 * @author Troy Gardner
 * AUTHOR :: Troy Gardner
 * AUTHOR SITE :: http://www.troyworks.com/
 * CREATED :: Aug 21, 2008
 * DESCRIPTION ::
 *
 */

package com.troyworks.controls.tform {
	import com.troyworks.events.EventTranslator;	
	import com.troyworks.events.EventAdapter;	
	import com.troyworks.data.validators.*;

	import flash.events.FocusEvent;	

	import com.troyworks.core.cogs.Hsm;	

	import flash.text.TextField;	

	import com.troyworks.data.DataChangedEvent;	
	import com.troyworks.core.cogs.Fsm;

	import flash.events.Event;

	import com.troyworks.core.cogs.CogEvent;
	import com.troyworks.core.cogs.CogSignal;

	/*********************************************
	 * This mimicks a toggleable switch, e.g a light switch
	 * with an DIRTY, CLEAN and a toggle push button.
	 * 
	 * This is a simple pattern that comes up often and is good
	 * not to reinvent.
	 * *********************************************/
	public class TextFieldEmailValidator extends Hsm {

		public var txt : TextField;
		private var _nextState : Function;

		public var lastValue : String;
		public var curValue : String;

	
		public var sigDirtyEvtGenerator : EventTranslator;	
		public var sigCleanEvtGenerator : EventTranslator;	
		
		public static const  SIG_DIRTY : CogSignal = CogSignal.getNextSignal("DIRTY");
		public static const  SIG_CLEAN : CogSignal = CogSignal.getNextSignal("CLEAN");	

		public static const SIG_HAS_FOCUS : CogSignal = CogSignal.getNextSignal("HAS_FOCUS");
		public var sigFocusEvtGenerator : EventTranslator;	
		public static const SIG_DOES_NOT_HAVE_FOCUS : CogSignal = CogSignal.getNextSignal("SIG_DOES_NOT_HAVE_FOCUS");		
		public var sigNoFocusEvtGenerator : EventTranslator;	
		
		public var emailValidator:EmailValidator = new EmailValidator();
		public function TextFieldEmailValidator(txt : TextField, initStateNameAct : String = "s_hasNotHadFocus", smName : String = "DIRTY_FSM", aInit : Boolean = true) {
			super(initStateNameAct, smName, aInit);
			this.txt = txt;
			//dispatchEvent(SIG.createPrivate);
			//////////// create event translators, so we can if we desire remove them later //////
			sigDirtyEvtGenerator = createSignalDispatcher(SIG_DIRTY);
			//sigCleanEvtGenerator = createSignalDispatcher(SIG_DIRTY);
			sigFocusEvtGenerator = createSignalDispatcher(SIG_HAS_FOCUS);
			sigNoFocusEvtGenerator = createSignalDispatcher(SIG_DOES_NOT_HAVE_FOCUS);
			txt.addEventListener(Event.CHANGE, sigDirtyEvtGenerator.dispatchEvent);
			
			txt.addEventListener(FocusEvent.FOCUS_OUT, sigNoFocusEvtGenerator.dispatchEvent);
			txt.addEventListener(FocusEvent.FOCUS_IN, sigFocusEvtGenerator.dispatchEvent);
			//			_initState= s_initial;
			//		_nextState = (startClean)?s__CLEAN: s__DIRTY;
			trace("new TextFieldEmailValidator");
		}

		public function onFieldChanged(evt : Event) : void {
			trace("onFieldChanged " + evt.target.text);
		}

		public function set value(newVal : String) : void {
			if(curValue != newVal) {
				lastValue = curValue;
				curValue = newVal;	
				fireDirty();				
			}
		}

		////////////////// ACCESSORS /////////////////////
		public function isDIRTY() : Boolean {
			return (stateMachine_hasInited && isInState(s__DIRTY));
		}

		public function isCLEAN() : Boolean {
			return (stateMachine_hasInited && isInState(s__CLEAN));
		}

		////////////////// METHODS ///////////////////////

		public function fireDirty() : void {
			var evt : Event = SIG_DIRTY.createPrivateEvent();
			dispatchEvent(evt);
		}

		public function fireClean() : void {
			var evt : Event = SIG_CLEAN.createPrivateEvent();
			dispatchEvent(evt);	
		}



		////////////////// STATES /////////////////////////////
		public function s_hasNotHadFocus(event : CogEvent) : Function {
			trace("TextFieldEmailValidator.s_hasNotHadFocus " + event);
			switch(event.sig) {
				case SIG_ENTRY:
					return null;
				case SIG_HAS_FOCUS:
					tran(s__CLEAN);
  					return null;
  				case SIG_EXIT:
  					txt.text = "";
  				    return null;	
			}
			return s_root;   
		}

		public function s_hasHadFocus(event : CogEvent) : Function {
			trace("TextFieldEmailValidator.s_hasHadFocus " + event);
			switch(event.sig) {
				case SIG_ENTRY:
					//txt.text = "";
					break;
			    
				case SIG_INIT:
					tran(s_hasInputFocus);
					break;
			}
			return s_root;   
		}

		public function s_hasInputFocus(event : CogEvent) : Function {
			trace("TextFieldEmailValidator.s_hasInputFocus " + event);
			switch(event.sig) {
				case SIG_ENTRY:
					break;
			    
				case SIG_INIT:
					tran(s__CLEAN);
					break;
			}
			return s_hasHadFocus;   
		}

		public function s_doesNotHaveInputFocus(event : CogEvent) : Function {
			trace("TextFieldEmailValidator.s_doesNotHaveInputFocus " + event);
			switch(event.sig) {
				case SIG_ENTRY:
					txt.text = "";
					break;
			    
				case SIG_INIT:
					tran(s__CLEAN);
					break;
			}
			return s_hasHadFocus;   
		}	
		public function s__CLEAN(event : CogEvent) : Function {
			trace("TextFieldEmailValidator.s__CLEAN " + event);
			switch(event.sig) {
		
				case SIG_DIRTY:
					tran(s__DIRTY, null, crossCleanToDirty);
					break;
			}
			
			return s_hasHadFocus;
		}
		public function s__DIRTY(event : CogEvent) : Function {
			trace("TextFieldEmailValidator.s__DIRTY " + event);
			switch(event.sig) {
				case SIG_ENTRY:
					var evt : DataChangedEvent = new DataChangedEvent();
					evt.oldVal = lastValue;
					evt.currentVal = curValue;						
					dispatchEvent(evt);
					///////// VALIDATE /////////////
					if(emailValidator.doValidation(cur))
					break;
				case SIG_CLEAN:
					tran(s__CLEAN, null, crossDirtyToClean);
					break;
			}
			return s_hasHadFocus;
		}
		////////////// cross actions /////////////////////
		private function crossDirtyToClean() {
			trace("crossDirtyToClean");
		}

		private function crossCleanToDirty() {
			trace("crossCleanToDirty");
		}

	}
}