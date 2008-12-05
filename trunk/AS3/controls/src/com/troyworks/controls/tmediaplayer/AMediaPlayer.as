package com.troyworks.controls.tmediaplayer {
	import com.troyworks.data.ArrayX;	
	import com.troyworks.core.cogs.Hsm;	
	import com.troyworks.core.Signals; 

	/*******************************************************
	 * An abstract class for concrete media player to extend
	 * it's primary function in life is to provide a consistent
	 * event model for them to extend so that interfaces to the 
	 * media player (e.g nav controllers) can deal with things gracefully
	 * 
	 * There are a few different models of playback
	 * 
	 * WinAmp Features =============================
	 * RepeatMode:
	 * - no repeat (plays once and stops)
	 * - currentClipRepeat (plays infinitely)
	 * - playListRepeat (cycles list infinitely)
	 * Shuffling:
	 * - shufflePlaylist 
	 * -play(restarts clip)
	 * -pause (pauses clip)
	 * - stop (stops
	 * 
	 * YouTube=============================================================:
	 * - autoStart = true (e.g. on hitting a page)
	 * - stopAtEnd = true
	 * - pause/playbutton
	 * - rewind and stop button
	 * - seek bar that when clicked or dragged maintains the paused or play state 
	 * First startup or paused
	 * [playbutton, rewindAndStop] [X seek/scrub--------bar] | [cur/totaltime] | [volume---- Mute] | [minSize, maxSize]
	 * During Playback
	 *  pausebutton, rewindAndStop] [seek/scrub---X-----bar] | [cur/totaltime] | [volume---- Mute] | [minSize, maxSize]
	 * When finished (rewinds but keeps the status at end to indicate completed).
	 *  [playbutton, rewindAndStop] [Xseek/scrub--------bar] | [3:00/3:00] | [volume---- Mute] | [minSize, maxSize]
	 */
	public class AMediaPlayer extends Hsm {

		public static var SIG_PLAY : Signals = Signals.PLAY;
		public static var SIG_PAUSE : Signals = Signals.PAUSE;
		public static var SIG_REWIND_AND_STOP : Signals = Signals.REWIND_AND_STOP;
		public static var SIG_REWIND_AND_PLAY : Signals = Signals.REWIND_AND_PLAY;
		public static var SIG_STOP : Signals = Signals.STOP;
		public static var SIG_GOTOANDSTOP : Signals = Signals.GOTOANDSTOP;
		public static var SIG_GOTOANDPLAY : Signals = Signals.GOTOANDPLAY;

		
		public static var SIG_STARTED_CLIP : Signals = Signals.STARTED;
		public static var SIG_FINISHED_CLIP : Signals = Signals.FINISHED;	
		public static var SIG_INCREMENT_FRAME : Signals = Signals.INCREMENT_FRAME;
		public static var SIG_DECREMENT_FRAME : Signals = Signals.DECREMENT_FRAME;
		//public static var SIG_PLAYBACK_STATE_CHANGED : Signals =  Signals.getNext("PLAYBACK_STATE_CHANGED");
		//public static var SIG_PROGRESS_CHANGED : Signals = Signals.getNext("PROGRESS_CHANGED");
		public static var EVTD_PLAYBACK_STATE_CHANGED : String = "EVTD_PLAYBACK_STATE_CHANGED";
		public  static var EVTD_PROGRESS_CHANGED : String = "EVTD_PROGRESS_CHANGED";

		//
		public static var SIG_NEXTCLIP : Signals = Signals.GOTO_NEXT;
		public static var SIG_PREVCLIP : Signals = Signals.GOTO_PREVIOUS;
		//Static Events
		public static var SIG_PLAYFLV : Signals = Signals.PLAYFLV;
		public static var SIG_PLAYMP3 : Signals = Signals.PLAYMP3;
		public static var SIG_PLAYIMAGE : Signals = Signals.PLAYIMAGE;
		public static var SIG_PLAYSWF : Signals = Signals.PLAYSWF;
		public static var SIG_TRANS_IN : Signals = Signals.TRANSIN_START;
		public static var SIG_TRANS_OUT : Signals = Signals.TRANSOUT_START;
		public var clipSize : Number;
		public var __cStateOpts : ArrayX;

		public function AMediaPlayer(initialState : String = "s_initial", hsmfName : String = "AMediaPlayer", aInit : Boolean = true) {
			super(initialState, hsmfName, aInit);
		}
	}
}