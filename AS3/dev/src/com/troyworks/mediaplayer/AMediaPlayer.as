package com.troyworks.mediaplayer { 
	import com.troyworks.framework.ui.BaseComponent;
	import com.troyworks.hsmf.AEvent;
	
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
	public class AMediaPlayer extends BaseComponent{
		
		public static var PLAY_EVT : AEvent = AEvent.getNext("PLAY_EVT");
		public static var PAUSE_EVT : AEvent =  AEvent.getNext("PAUSE_EVT");
		public static var REWIND_AND_STOP_EVT : AEvent =  AEvent.getNext("REWIND_AND_STOP_EVT");
		public static var REWIND_AND_PLAY_EVT : AEvent =  AEvent.getNext("REWIND_AND_PLAY_EVT");
		public static var STARTED_CLIP_EVT : AEvent = AEvent.getNext("STARTED_CLIP_EVT");
		public static var FINISHED_CLIP_EVT : AEvent = AEvent.getNext("FINISHED_CLIP_EVT");	
		public static var STOP_EVT : AEvent =  AEvent.getNext("STOP_EVT");
		public static var GOTOANDSTOP_EVT : AEvent =  AEvent.getNext("GOTOANDSTOP_EVT");
		public static var GOTOANDPLAY_EVT : AEvent = AEvent.getNext("GOTOANDPLAY_EVT");
		public static var INCREMENT_FRAME_EVT : AEvent =  AEvent.getNext("INCREMENT_FRAME_EVT");
		public static var DECREMENT_FRAME_EVT : AEvent = AEvent.getNext("DECREMENT_FRAME_EVT");
		//public static var PLAYBACK_STATE_CHANGED_EVT : AEvent =  AEvent.getNext("PLAYBACK_STATE_CHANGED_EVT");
		//public static var PROGRESS_CHANGED_EVT : AEvent = AEvent.getNext("PROGRESS_CHANGED_EVT");
		public static var EVTD_PLAYBACK_STATE_CHANGED : String =  "EVTD_PLAYBACK_STATE_CHANGED";
		public static var EVTD_PROGRESS_CHANGED : String = "EVTD_PROGRESS_CHANGED";
	
		//
		public static var NEXTCLIP_EVT : AEvent =  AEvent.getNext("NEXTCLIP_EVT");
		public static var PREVCLIP_EVT : AEvent = AEvent.getNext( "PREVCLIP_EVT");
		//Static Events
		public static var PLAYFLV_EVT : AEvent =  AEvent.getNext("PLAYFLV_EVT");
		public static var PLAYMP3_EVT : AEvent =  AEvent.getNext( "PLAYMP3_EVT");
		public static var PLAYIMAGE_EVT : AEvent =  AEvent.getNext("PLAYIMAGE_EVT");
		public static var PLAYSWF_EVT : AEvent =  AEvent.getNext("PLAYSWF_EVT");
		public static var TRANS_IN_EVT : AEvent =  AEvent.getNext("TRANS_IN_EVT");
		public static var TRANS_OUT_EVT : AEvent =  AEvent.getNext("TRANS_OUT_EVT");
		public var clipSize:Number;
	
		public function AMediaPlayer(initialState : Function, hsmfName : String, aInit : Boolean) {
			super(initialState , hsmfName , aInit );
		}
	}
}