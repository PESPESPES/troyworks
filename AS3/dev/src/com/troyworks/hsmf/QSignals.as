package com.troyworks.hsmf { 
	/**
	 * @author Troy Gardner
	 */
	public class QSignals extends Signal{
		public static var Q_EMPTY_SIG : QSignals = new QSignals (0, "EMPTY");
		public static var Q_INIT_SIG : QSignals = new QSignals (1, "INIT");
		public static var Q_ENTRY_SIG : QSignals = new QSignals (2, "ENTRY");
		public static var Q_EXIT_SIG : QSignals = new QSignals (4, "EXIT");
		public static var Q_TRACE_SIG : QSignals = new QSignals (8, "TRACE");
		public static var Q_PULSE_SIG : QSignals = new QSignals (16, "PULSE");
		public static var Q_CALLBACK_SIG : QSignals = new QSignals (32, "CALLBACK");
		public static var Q_GETOPTS_SIG : QSignals = new QSignals (64, "GETOPTS");
		public static var Q_TERMINATE_SIG : QSignals = new QSignals (128, "TERMINATE");
		public static var Q_STATE_CHANGED_SIG : QSignals = new QSignals (256, "STATE_CHANGED_EVT");
	
		public static var USER_SIG : Signal = new Signal (Signal.SignalUserIDz, "USER");
	}
}