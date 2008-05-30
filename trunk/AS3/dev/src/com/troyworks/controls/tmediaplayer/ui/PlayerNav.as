package com.troyworks.controls.tmediaplayer.ui {
	import com.troyworks.controls.tbutton.MCButton; 
	import com.troyworks.framework.ui.BaseComponent;

	import com.troyworks.hsmf.AEvent;
	import com.troyworks.data.ArrayX;
	/**
	 * @author Troy Gardner
	 */
	import flash.text.TextField;
	public class PlayerNav extends BaseComponent {
	
		public var fullscreenModeBtn_mc : MCButton;
		public var normalscreenModeBtn_mc : MCButton;
	
		public var recordBtn_mc : MCButton;
		public var replayClipBtn_mc : MCButton;
		public var fastForwardClipBtn_mc : MCButton;
		public var playClipBtn_mc : MCButton;
		public var pauseClipBtn_mc : MCButton;
		public var rewindClipBtn_mc : MCButton;
		////////////////////////////////
		public var prevClipBtn_mc : MCButton;
		public var nextClipBtn_mc : MCButton;
		public var display_txt : TextField;
	
		public static var FULLSCREEN_CLIP : String = "FULLSCREEN_CLIP";
		public static var RECORD_CLIP : String = "RECORD_CLIP";
		public static var REPLAY_CLIP : String = "REPLAY_CLIP";
		public static var FAST_FORWARD_CLIP : String = "FAST_FORWARD_CLIP";
		public static var PLAY_CLIP : String = "PLAY_CLIP";
		public static var PAUSE_CLIP : String = "PAUSE_CLIP";
		public static var REWIND_AND_STOP : String = "REWIND_AND_STOP";
		public static var REWIND_AND_PLAY : String = "REWIND_AND_PLAY";	
		public static var FASTFORWARD_PLAY : String = "FASTFORWARD_PLAY";	
		public static var SEEK_TO:String = "SEEK_TO";
				
		/*****************************************************
		 *  Constructor
		 */
		public function PlayerNav() {
			super(s0_viewAssetsUnLoaded, "PlayerNav");
		}
		public function onPlayerStateChanged(_ary : ArrayX) : void {
		//	REQUIRE(_ary != null && _ary is ArrayX, " PlayerNav.onPlayerStateChanged invalid arguments");
			var _ary2 : ArrayX = _ary;// ArrayX(_ary[0]);
	//		_ary2.appendArray(_ary[1]);
			trace("HIGHLIGHTP 1111111111111111111111  PlayerNav.onPlayerStateChanged  " + _ary.length+"  11111111111111111111111 \r"+ _ary.join("\r"));//util.Trace.me(_ary, "_ary", true));
			trace(util.Trace.me(_ary[0], "_ary[0]", true));
			trace(util.Trace.me(_ary2, "_ary2", true));
			//////PLAYLIST FEATURES ////////////////////
			prevClipBtn_mc.visible = false;
			nextClipBtn_mc.visible = false;
			///// PLAYER FEATURES ////////////////////////
			var fullScreen : Boolean = _ary2.contains(FULLSCREEN_CLIP);
			 if(fullscreenModeBtn_mc.visible){
				fullscreenModeBtn_mc.enabled =fullScreen;
			 }else{
				fullscreenModeBtn_mc.enabled =fullScreen;
			 }
	
			recordBtn_mc.enabled = _ary2.contains(RECORD_CLIP);
			///// Current Clip FEATURES //////////////////
			replayClipBtn_mc.enabled = _ary2.contains(REPLAY_CLIP);
			fastForwardClipBtn_mc.enabled = _ary2.contains(FAST_FORWARD_CLIP);
	
			var canPlay : Boolean = _ary2.contains(PLAY_CLIP);
			if(_ary2.length == 4){
				REQUIRE(canPlay == true, "CanPlay should be true");
			}
			if(canPlay){
				//ENABLE the play and hide the pause button
				trace("HIGHLIGHTG canPlay");
				playClipBtn_mc.enabled =true;
				playClipBtn_mc.visible =true;
				pauseClipBtn_mc.visible = false ;
			//	pauseClipBtn_mc.enabled = false;
			}else{
				trace("HIGHLIGHTO can'tPlay");
				//ENABLE the pause and hide the play button
				var canPause : Boolean = _ary2.contains(PAUSE_CLIP);
				pauseClipBtn_mc.visible = canPause ;
				pauseClipBtn_mc.enabled = canPause;
				//playClipBtn_mc.enabled =false;
				playClipBtn_mc.visible =false;
			}
			rewindClipBtn_mc.enabled = false;//enabled = false;// _ary2.contains(REWIND_AND_STOP);
		
		}
		public function s1_creatingView(e : AEvent) : Function
		{
			this.onFunctionEnter ("s1_creatingView-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
	
					return null;
				}
				case EXIT_EVT :
				{
					return null;
				}
				case INIT_EVT :
				{
					Q_TRAN(s1_viewCreated);
					return null;
				}
			}
			return this.s0_viewAssetsLoaded;
		}
		/*.................................................................*/
		public function s1_viewCreated(e : AEvent) : Function
		{
			this.onFunctionEnter ("s1_viewCreated-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					onPlayerStateChanged(new ArrayX());
					return null;
				}
				case EXIT_EVT :
				{
					return null;
				}
				case INIT_EVT :
				{
					return null;
				}
				case STATE_CHANGED_EVT:
				{
					trace(util.Trace.me(Object(e).args, " HANDLING EVENT-------------------", true));
	
					onPlayerStateChanged(Object(e).args[0].stackOpts);
					return null;
				}
				default:
					trace(util.Trace.me(e, "EVENT NOT HANLDED", true));
			}
			return this.s0_viewAssetsLoaded;
		}
	
	}
}