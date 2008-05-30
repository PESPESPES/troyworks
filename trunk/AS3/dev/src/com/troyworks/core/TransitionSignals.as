/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.core {

	public class TransitionSignals {
		
		///////////////// TRANSITIONS
		public static const REQUEST_TRANSIN : Signals = Signals.getNextSignal("REQUEST_TRANSIN");
		public static const TRANSIN_START : Signals = Signals.getNextSignal("TRANSIN_START");
		public static const TRANSIN_PROGRESS : Signals = Signals.getNextSignal("TRANS_IN_PROGRESS");
		public static const TRANSIN_FINISHED : Signals = Signals.getNextSignal("TRANSIN_FINISHED");
		public static const REQUEST_TRANSOUT : Signals = Signals.getNextSignal("REQUEST_TRANSOUT");
		public static const TRANSOUT_START : Signals = Signals.getNextSignal("TRANSOUT_START");
		public static const TRANSOUT_PROGRESS : Signals = Signals.getNextSignal("TRANSOUT_PROGRESS");
		public static const TRANSOUT_FINISHED : Signals = Signals.getNextSignal("TRANSOUT_FINISHED");

		
	}
	
}
