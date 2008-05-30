/**
* This represents a model level focusmanagement, in where typically a contextual menu
* tweens between active states, coordinating fade in/ fade out and tween animate in appropriately.
* 
* @author Default
* @version 0.1
*/

package com.troyworks.core.patterns {
	import com.troyworks.core.cogs.CogEvent;	
	import com.troyworks.core.Signals;	
	import com.troyworks.core.cogs.Hsm;	
	
	public class SingleFocus extends Hsm {
		/* cache the signals for clarity in code and performance reasons */

//		public static  const REQUEST_RECORD:Signals = Signals.RECORD;
//		public static  const PLAY_FROM_BEGINNING:Signals = Signals.REWIND_AND_PLAY;



		public function SingleFocus(initState:String = "s_initial") {
			super(initState, "SingleFocus");
		}
		///////////////////// STATES ///////////////////////////////

		/*.................................................................*/
		 public function s_initial(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_INIT :
				     return s_nothingFocused;
			}
			return  s_root;
		}
		/*.................................................................*/
		// no contextual menu
		public function s_nothingFocused(e : CogEvent):Function {

			switch (e.sig) {
				case SIG_ENTRY :
					return null;
				case SIG_EXIT :
					return null;
			//	case SIG_INIT :
			//		return s_1;
			}
			return  s_root;
		}		
		/*.................................................................*/
		// build the contextual menu
		public function s_focusingIntoSomething(e : CogEvent):Function {

			switch (e.sig) {
				case SIG_ENTRY :
					return null;
				case SIG_EXIT :
					return null;
			//	case SIG_INIT :
			//		return s_1;
			}
			return  s_root;
		}
		/*.................................................................*/
		// destroy the contextual menu
		public function s_focusingOutToNothing(e : CogEvent):Function {

			switch (e.sig) {
				case SIG_ENTRY :
					return null;
				case SIG_EXIT :
					return null;
			//	case SIG_INIT :
			//		return s_1;
			}
			return  s_root;
		}
		/*.................................................................*/
		// something should have the contextual menu
		public function s_somethingFocused(e : CogEvent):Function {

			switch (e.sig) {
				case SIG_ENTRY :
					return null;
				case SIG_EXIT :
					return null;
			//	case SIG_INIT :
			//		return s_1;
			}
			return  s_root;
		}		
		//////////////////////// L2 ////////////////////////////////////////
		// If we are below here something has a valid focus, and deserves
		// the focus/contextual cloud.
		/*.................................................................*/
		// setup the transition
		public function s_requestedIsNotFocused(e : CogEvent):Function {

			switch (e.sig) {
				case SIG_ENTRY :
					return null;
				case SIG_EXIT :
					return null;
			//	case SIG_INIT :
			//		return s_1;
			}
			return  s_somethingFocused;
		}
		/*.................................................................*/
		// perform the transition
		public function s_refocusing(e : CogEvent):Function {

			switch (e.sig) {
				case SIG_ENTRY :
				// last requested losing focus
				// lost focus
				// moving to next focused
				// reached next focused
				// - can't focus
				// - has focused requested
					return null;
				case SIG_EXIT :
					return null;
			//	case SIG_INIT :
			//		return s_1;
			}
			return  s_somethingFocused;
		}		
		/*.................................................................*/
		// finished building menu, stop state, 
		public function s_requestedFocused(e : CogEvent):Function {

			switch (e.sig) {
				case SIG_ENTRY :
					return null;
				case SIG_EXIT :
					return null;
			//	case SIG_INIT :
			//		return s_1;
			}
			return  s_somethingFocused;
		}
	}
	
}
