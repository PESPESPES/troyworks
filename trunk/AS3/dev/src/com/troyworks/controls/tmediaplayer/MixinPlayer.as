package com.troyworks.controls.tmediaplayer { 
	import com.troyworks.data.ArrayX;
	import com.troyworks.events.TProxy;
	import com.troyworks.framework.ui.MCButton;
	import com.troyworks.hsmf.AEvent;
	import com.troyworks.tmediaplayer.model.PlayHead;
	import com.troyworks.tmediaplayer.ui.PlayerNav;
	import com.troyworks.tmediaplayer.ui.SeekBarNav;
	import com.troyworks.util.TimeDateUtil;
	
	import flash.external.ExternalInterface;
	/**
	 * This class is a wrapper for a given loaded swf to convert
	 * it into a suitable clip for playback in a shell at the correct frame rate
	 * 
	 * @author Troy Gardner
	 */
	import flash.utils.clearInterval;
	import flash.system.fscommand;
	import flash.display.MovieClip;
	import flash.utils.setInterval;
	public class MixinPlayer extends AMediaPlayer {
	
		public var base_mc : MovieClip;
		public var navBase_mc : MovieClip;
		public var actual_mc : MovieClip;
		public var playerControls_mc : PlayerNav;
		public var seekControls_mc : SeekBarNav;
	
		public var playhead : PlayHead;
		//
		protected var m_isLoaded:Boolean = false;
		protected var m_isReady:Boolean = false;
		public var m_hasStarted : Boolean = false;
		public var m_hasFinished : Boolean = false;
		public var m_almostFinished : Boolean = false;
	
		public var playState : String = "loading";
		public var playerFPS : Number = 24;
		public var FPS : Number = 24;
	
		public var autoStart : Boolean = true;
		public var autoRewind : Boolean = true;
		
		public var previewMode : Boolean = false;
		public var almostFinishedFrames : Number = 12;
		protected var intV : Number = null;// setInterval(_mc, "__mxpPollStatus", 1000/24);
		protected var pintV : Number = -1;
	
		public var isSubordinateContent : Boolean = false;
	
		protected var exposedExternalInterfaceCallbacks : Boolean;
		public var cleanAllOnUnload:Boolean = false;
	
		/*****************************************************
		 *  Constructor
		 */
	
		public function MixinPlayer(aMovieClip : MovieClip, parentClip : MovieClip, aIsSubordinateContent:Boolean) {
			super(null, "MixinPlayer", false);
			hsmName = "MixinPlayer";
			trace("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
			trace("MMMMMMMMMMMMMMMMMMMMMMMM MixinPlayer MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
			trace("MMMMMMMMMMMMMMM aMovieClip " + aMovieClip + " MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
			trace("MMMMMMMMMMMMMMM parentClip " + parentClip + " MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
			trace("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
			trace("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
	
			base_mc = aMovieClip;
			navBase_mc = parentClip;
			playhead = new PlayHead();
			//////////////Activate the statemachine ///////////
			if(aMovieClip != null){
				//init();
			} else {
				trace("*** WARNING **** MixinPlayer passed in a null value"); 
			}
			this.isSubordinateContent = (aIsSubordinateContent == null || aIsSubordinateContent == false)?false:true;
			if(!this.isSubordinateContent){
				trace("ERROR exposing ExternalInterfaces");
				exposeExternalInterfaceCallbacks();
			}else{
					trace("ERROR not exposing ExternalInterfaces");
			}
		}
	
		public function exposeExternalInterfaceCallbacks():void{
			ExternalInterface.addCallback("startPlayback", this, this.play);
			ExternalInterface.addCallback("pausePlayback", this, this.stop);
			ExternalInterface.addCallback("rewindAndStopPlayback", this, this.rewindAndStop);
			ExternalInterface.addCallback("rewindAndPlayback", this, this.rewindAndPlay);
			ExternalInterface.addCallback("removeExternalInterfaceCallbacks", this, this.removeExternalInterfaceCallbacks);
			ExternalInterface.call("onExternalInterfaceChanged", true);
			this.exposedExternalInterfaceCallbacks = true;		
		}
		public function removeExternalInterfaceCallbacks():void{
			ExternalInterface.addCallback("startPlayback", this,emptyFunction );
			ExternalInterface.addCallback("pausePlayback",  this, emptyFunction);
			ExternalInterface.addCallback("rewindAndStopPlayback",  this, emptyFunction);
			ExternalInterface.addCallback("rewindAndPlayback",  this, emptyFunction);
			ExternalInterface.call("onExternalInterfaceChanged", false);
			this.exposedExternalInterfaceCallbacks = false;
		}
		public function emptyFunction():void{
		}
		public function registerPlayerControls(nav : PlayerNav) : void{
			if(nav == null) return;
	
			trace("000000000000000000000000000000000000000000000000000000");
			trace("000000000000000000000000000000000000000000000000000000");
			trace("000000000000000000000000 registerPlayerControls " + this+ " 000000000000000000000000000000");
			trace("0000000000000000000000000 " + nav + " 00000000000000000000000000000");
			trace("00000000000000000000000000 " + stackOpts +" 0000000000000000000000000000");
			trace("00000000000000000000000nav.Q_dispatch0000000 " + nav.Q_dispatch +" 000000000000000000000000");
			var f : Function = nav.createCallback(STATE_CHANGED_EVT);
			addEventListener(EVTD_INT_STATE_CHANGED, f);
			nav.onPlayerStateChanged(stackOpts);
			////////////////////////////////////////
		//	nav.playClipBtn_mc.addEventListener(MCButton.EVTD_CLICK, actual_mc, actual_mc.__mxpPlay);
			nav.playClipBtn_mc.addEventListener(MCButton.EVTD_CLICK, this, this.createCallback(PLAY_EVT));
			nav.pauseClipBtn_mc.addEventListener(MCButton.EVTD_CLICK, this, this.createCallback(STOP_EVT));
			playerControls_mc = nav;
		}
		public function unRegisterPlayerControls():void{
			playerControls_mc.playClipBtn_mc.removeEventListener(MCButton.EVTD_CLICK, this);
			playerControls_mc.pauseClipBtn_mc.removeEventListener(MCButton.EVTD_CLICK, this);
			playerControls_mc = null;
		}
		public function registerSeekControls(seeknav : SeekBarNav) : void{
			if(seeknav == null) return;
			trace("000000000000000000000000000000000000000000000000000000");
			trace("000000000000000000000000000000000000000000000000000000");
			trace("000000000000000000000000registerSeekControls " + this+ " 000000000000000000000000000000");
			trace("0000000000000000000000000 " + seeknav + " 00000000000000000000000000000");
			seekControls_mc = seeknav;
		/*	var f:Function = seeknav.createCallback(STATE_CHANGED_EVT);
			addEventListener(EVT_INT_STATE_CHANGED, f);
			nav.onPlayerStateChanged(stackOpts);
			////////////////////////////////////////
			nav.playClipBtn_mc.addEventListener(MCButton.EVTD_CLICK, this.createCallback(PLAY_EVT));
			nav.pauseClipBtn_mc.addEventListener(MCButton.EVTD_CLICK, this.createCallback(STOP_EVT));*/
		}
	
		///////////////////// INBOUND COMMANDS //////////////////////////////////////////
		public function play() : void{
			trace("MixinPlayer.play");
			Q_dispatch(PLAY_EVT);
		}
		public function stop() : void{
					trace("ERROR MXP. stop");
			//this.actual_mc.__mxpStopPlaying();
			Q_dispatch(STOP_EVT);
		}
		public function rewindAndStop():void{
			Q_dispatch(REWIND_AND_STOP_EVT);
		}
		public function rewindAndPlay():void{
			Q_dispatch(REWIND_AND_PLAY_EVT);
		}
		/////////////////////// PROPERTIES ///////////////////////////////////////////////////////
		public function get hasStarted() : Boolean{
			return m_hasStarted;
		}
		
		public function set hasStarted(aHasStarted:Boolean) : void{
			if(m_hasStarted != aHasStarted){
				 m_hasStarted = aHasStarted;
				 fscommand("ktmoviestart");
				 ExternalInterface.call ("contentHasStarted", "ID:"+actual_mc._url, m_hasStarted);
			}
		}
		public function get hasAlmostFinished() : Boolean{
			return m_almostFinished;
		}
		
		public function set hasAlmostFinished(aHasAlmostFinished:Boolean) : void{
			if(m_almostFinished != aHasAlmostFinished){
				 m_almostFinished = aHasAlmostFinished;
				 fscommand("ktmoviealmostfinished");
				 
				 ExternalInterface.call ("contentIsAlmostFinished", "ID:"+actual_mc._url, m_almostFinished); 
			}
		}
	
		public function get hasFinished() : Boolean{
			return m_hasFinished;
		}
		public function set hasFinished(finished: Boolean):void {
			if(m_hasFinished != finished){
				 m_hasFinished = finished;
				 fscommand("ktmoviefinished");
				 
				 ExternalInterface.call ("contentIsFinished", "ID:"+actual_mc._url, m_hasFinished); 
			}
		}
		public function unloadMovie() : void{
			this.actual_mc.unloadMovie();
		}
		public function set isLoaded(loaded:Boolean):void{
			if(m_isLoaded != loaded){
				m_isLoaded = loaded;
				if(m_isLoaded){
				fscommand("ktmovieloaded");
				}
				
				ExternalInterface.call ("contentIsLoaded", "ID:"+actual_mc._url, m_isLoaded);
			}
		}
		public function get isLoaded():Boolean{
				return m_isLoaded;
	
		}
		public function set isReady(ready:Boolean):void{
			if(m_isReady != ready){
				m_isReady = ready;
				ExternalInterface.call ("contentIsReady", "ID:"+actual_mc._url, m_isLoaded);
			}
		}
		public function get isReady():Boolean{
				return m_isReady;
		}
		//////////////////// OUTBOUND ////////////////////////////////////////////////
		public function onPlaybackStateChanged():void{
			dispatchEvent({type:EVTD_PLAYBACK_STATE_CHANGED, id:actual_mc._url, playState:playState, opts:__cStateOpts});
			if(!this.isSubordinateContent){
				ExternalInterface.call ("onPlaybackStateChanged", "ID:"+actual_mc._url, playState, __cStateOpts);
			//	fscommand(playState);
			}
			playerControls_mc.onPlayerStateChanged(__cStateOpts);
		}
		public function onProgressChanged():void{
			trace("Progress " + actual_mc.currentFrame + "/" + actual_mc.totalFrames);
			seekControls_mc.setPlayedProgress(actual_mc.currentFrame / actual_mc.totalFrames);
			seekControls_mc.setLoadedProgress(actual_mc.getBytesLoaded() / actual_mc.getBytesTotal());
			var eT : Number = actual_mc.currentFrame / FPS;
			var tT : Number = actual_mc.totalFrames / FPS;
			//	trace("ProgressN " + eT + " " + tT);
			var feT : TimeDateUtil = TimeDateUtil.formatDateTime(eT*1000);
			var ftT : TimeDateUtil = TimeDateUtil.formatDateTime(tT*1000);
			var t : String = feT.a_minute+":"+feT.a_seconds+" / " + ftT.a_minute + ":" + ftT.a_seconds;
			//	trace("ProgressT " + t + " " );
			playerControls_mc.display_txt.text =t;
			dispatchEvent({type:EVTD_PROGRESS_CHANGED, id:actual_mc._url, curFrame:actual_mc.currentFrame, totFrames:actual_mc.totalFrames, elapsedTime:feT.a_minute+":"+TimeDateUtil.padTo(feT.a_seconds,2,"0"), totalTime:ftT.a_minute + ":" + TimeDateUtil.padTo(ftT.a_seconds,2,"0"), bytesLoaded:actual_mc.getBytesLoaded(), bytesTotal:actual_mc.getBytesTotal()});
			if(!this.isSubordinateContent){
				ExternalInterface.call ("onProgressChanged","ID:"+actual_mc._url, actual_mc.currentFrame, actual_mc.totalFrames, feT.a_minute+":"+TimeDateUtil.padTo(feT.a_seconds,2,"0"), ftT.a_minute + ":" + TimeDateUtil.padTo(ftT.a_seconds,2,"0"), actual_mc.getBytesLoaded(), actual_mc.getBytesTotal());
			}
		//	playerControls_mc.onProgressChanged(__cStateOpts);
		}
		///////////////////////////////////////////////////////////////
		public function onLoad():void{
			super.onLoad(false);
		}
	
		//////////////////////// LEVEL 0 STATES////////////////////////////
		/*.................................................................*/
		public function s0_viewAssetsUnLoaded(e : AEvent) : Function
		{
			trace("s0_viewAssetsUnLoaded");
			this.onFunctionEnter ("s0_viewAssetsUnLoaded-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					playState = "loading";
					startPulse(1000/30);
					return null;
				}
				case EXIT_EVT :
				{
					stopPulse();
					return null;
				}
				case PULSE_EVT:{
	
					trace("MixinPlayer.LoadCheck  " + base_mc.getBytesLoaded()+ " / "+ base_mc.getBytesTotal());
					if(actual_mc == null){
						actual_mc = scanClip(base_mc);
						if(actual_mc.onUnload != null){
							actual_mc.mxpOnOnload =actual_mc.onUnload;
							 
						}
						actual_mc.onUnload  =TProxy.create(this, this.onActualClipUnload);
						if(actual_mc != null){
							Q_TRAN(s2_stoppedAtBeginning);
	//						MixinPlayer.createMovieTracker(actual_mc);
						}			
					}
	
					return null;
				}
				case INIT_EVT :
				{
					return null;
				}
			}
			return s_top;
		}
		/*.................................................................*/
		public function s0_viewAssetsLoaded(e : AEvent) : Function
		{
	
			this.onFunctionEnter ("s0_viewAssetsLoaded-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					trace("s0_viewAssetsLoaded.onEnter --- " );
					registerPlayerControls(navBase_mc.PlayerNavButtonBar_mc);
	
					registerSeekControls(navBase_mc.PlayerNavButtonBar_mc.seekControls_mc);
					hasStarted = false;
					playState = "initializing";
					m_hasFinished = false;
					m_almostFinished = false;
					almostFinishedFrames = 24;
					isLoaded = true;
					onProgressChanged();
	
					return null;
				}
				case EXIT_EVT :
				{
					return null;
				}
				case INIT_EVT :
				{
					Q_TRAN(s2_stoppedAtBeginning);
					return null;
				}
				case PLAY_EVT:
				{
					Q_TRAN(s1_playing);
					return null;
				}
				case STOP_EVT:
				{
					Q_TRAN(s1_stopped);
					return null;
				}
				case REWIND_AND_STOP_EVT:
				{
					trace("HIGHLIGHTb REWIND_AND_STOP");
					actual_mc.gotoAndStop(1);
					m_almostFinished = false;
					m_hasFinished = false;
					Q_TRAN(s2_stoppedAtBeginning);
					return null;
				}
				case REWIND_AND_PLAY_EVT:
				{
					actual_mc.gotoAndPlay(1);
					m_almostFinished = false;
					m_hasFinished = false;
					Q_TRAN(s1_playing);
					return null;
				}
				case GETOPTS_EVT:
				{	
				//	playhead.Q_dispatch(GETOPTS_EVT);
					trace("MIXING PLAYER GET OPTIONS XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
				//	trace("My Options are: " + stackOpts);
					trace("Clip Options are: " + actual_mc.stackOpts);
					trace("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
				
				//	var opts:ArrayX = stackOpts.concat(actual_mc.stackOpts.concat());
				//	__cStateOpts = opts;
					__cStateOpts=new ArrayX("ID:"+actual_mc._url,"REPLAY_CLIP");
					//playerControls_mc.onPlayerStateChanged(ArrayX(__cStateOpts));
					return null;
				}
	
			}
			return s_top;
		}
		//========================== LEVEL 1 ===============================/
		/*.................................................................*/
	
		public function s0_viewAssetsDestroyed(e : AEvent) : Function
	
		{
			trace("s0_viewAssetsDestroyed");
			this.onFunctionEnter ("s0_viewAssetsDestroyed-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					playState = "unloaded";
					_root.status_txt.text += "s0_viewAssetsDestroyed";
					if(this.exposedExternalInterfaceCallbacks){
						unRegisterPlayerControls();
						removeExternalInterfaceCallbacks();
						delete(this);
					}
					if(cleanAllOnUnload){
						_global.cleanAllOnUnload();
					}
					return null;
				}
				case INIT_EVT :
				{
					return null;
				}
			}
			return s_top;
		}
		//========================== LEVEL 1 ===============================/
		/*.................................................................*/
		public function s1_stopped(e : AEvent) : Function
		{
			this.onFunctionEnter ("s1_stopped-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					trace("HIGHLIGHTs1 stopped.Enter");
				//	trace("s1 stopped.Enter");
					//this.actual_mc.__mxpStopPlaying();
					trace(actual_mc.name +".MTstop " + actual_mc.currentFrame + " / "  + actual_mc.totalFrames);
					actual_mc.stop();
					for(var i in actual_mc){
						//stop all nested clips ///////
				
						if(actual_mc[i].stop !=null && actual_mc[i].currentFrame > 1 ){
							actual_mc[i].__mxpStopped = true;
							trace("stopping " + actual_mc[i] + " "  + actual_mc[i].currentFrame + " / "  + actual_mc[i].totalFrames);
							actual_mc[i].stop();
						}
					}
					onProgressChanged();
					isReady = true;
					return null;
				}
				case EXIT_EVT :
				{
					return null;
				}
				case INIT_EVT :
				{
					trace("s1 stopped.INIT_EVT");
					if(actual_mc.currentFrame == 1){
						trace("-> stopped at beginning");
						Q_TRAN(s2_stoppedAtBeginning);
					}else if(actual_mc.currentFrame == actual_mc.totalFrames){
						trace("-> stopped at end");
						Q_TRAN( s2_stoppedAtEnd);
					}else{
						trace("-> stopped in middle");
						Q_TRAN(s2_stoppedInMiddle);
					}
	
					return null;
				}
				case GETOPTS_EVT:{
					trace("s1_stopped GETOPTS_EVTGETOPTS_EVTGETOPTS_EVTGETOPTS_EVTGETOPTS_EVTGETOPTS_EVTGETOPTS_EVTGETOPTS_EVT");
					var opts:ArrayX =new ArrayX("ID:"+actual_mc._url,"PLAY_CLIP", "REWIND_AND_STOP", "FASTFORWARD_PLAY", "SEEK_TO", "FULLSCREEN_CLIP"); 
					__cStateOpts= opts;
					onPlaybackStateChanged();
					return null;
		
				}
			}
			return this.s0_viewAssetsLoaded;
		}
	
		/*.................................................................*/
		public function s1_playing(e : AEvent) : Function
		{
			this.onFunctionEnter ("s1_stopped-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					trace(actual_mc.name +"MT.starting Playing()");
					if(this.previewMode){
						actual_mc.gotoAndPlay(actual_mc.totalFrames - (this.almostFinishedFrames -1));
					}else if(this.FPS == this.playerFPS){
						actual_mc.play();
						for(var i in actual_mc){
							if(actual_mc[i].__mxpStopped){
								actual_mc[i].play();
							}
						}
					}else{
						this.pintV = setInterval(createCallback(INCREMENT_FRAME_EVT), 1000/FPS);
					}
					this.playState = "playing";
					isReady = true;
					startPulse(1000/36);
					return null;
				}
				case PULSE_EVT:
				{
					onProgressChanged();
					if((actual_mc.totalFrames  >almostFinishedFrames)  && actual_mc.currentFrame == (actual_mc.totalFrames - almostFinishedFrames) || actual_mc.almostFinished){
						Q_TRAN(s2_almostFinishedPlaying);
					}
					if(actual_mc.currentFrame == actual_mc.totalFrames || actual_mc.hasFinished){
						Q_TRAN(s2_stoppedAtEnd);
					}
					return null;
				}
				case DECREMENT_FRAME_EVT:
				{
	
					actual_mc.prevFrame();
					return null;
				}
				case INCREMENT_FRAME_EVT:
				{
	
					actual_mc.nextFrame();
					return null;
				}
				case EXIT_EVT :
				{
					clearInterval(pintV);
					stopPulse();
					return null;
				}
				case INIT_EVT :
				{
	
					return null;
				}
				case GETOPTS_EVT:{
					trace("GETOPTS_EVTGETOPTS_EVTGETOPTS_EVTGETOPTS_EVTGETOPTS_EVTGETOPTS_EVTGETOPTS_EVTGETOPTS_EVT");
					__cStateOpts= new ArrayX("ID:"+actual_mc._url,"PAUSE_CLIP", "REWIND_AND_STOP", "RESTART", "REWIND_PLAY", "FASTFORWARD_PLAY","SEEK_TO", "FULLSCREEN_CLIP");
					onPlaybackStateChanged();
					return null;
	
					
	
				}
				case PULSE_EVT:
				{
					trace("Progress " + actual_mc.currentFrame + "/" + actual_mc.totalFrames);
					seekControls_mc.setPlayedProgress(actual_mc.currentFrame / actual_mc.totalFrames);
					seekControls_mc.setLoadedProgress(actual_mc.getBytesLoaded() / actual_mc.getBytesTotal());
					var eT : Number = actual_mc.currentFrame / FPS;
					var tT : Number = actual_mc.totalFrames / FPS;
				//	trace("ProgressN " + eT + " " + tT);
					var feT : TimeDateUtil = TimeDateUtil.formatDateTime(eT*1000);
					var ftT : TimeDateUtil = TimeDateUtil.formatDateTime(tT*1000);
					var t : String = feT.a_minute+":"+feT.a_seconds+" / " + ftT.a_minute + ":" + ftT.a_seconds;
				//	trace("ProgressT " + t + " " );
					playerControls_mc.display_txt.text =t;
					if((actual_mc.totalFrames  >almostFinishedFrames)  && actual_mc.currentFrame == (actual_mc.totalFrames - almostFinishedFrames) || actual_mc.almostFinished){
						Q_TRAN(s2_almostFinishedPlaying);
					}
					if(actual_mc.currentFrame == actual_mc.totalFrames || actual_mc.hasFinished){
						Q_TRAN(s2_stoppedAtEnd);
					}
					return null;
				}
				case DECREMENT_FRAME_EVT:
				{
	
					actual_mc.prevFrame();
					return null;
				}
				case INCREMENT_FRAME_EVT:
				{
	
					actual_mc.nextFrame();
					return null;
				}
				case EXIT_EVT :
				{
					clearInterval(pintV);
					stopPulse();
					return null;
				}
				case INIT_EVT :
				{
					return null;
				}
				case GETOPTS_EVT:{
					trace("GETOPTS_EVTGETOPTS_EVTGETOPTS_EVTGETOPTS_EVTGETOPTS_EVTGETOPTS_EVTGETOPTS_EVTGETOPTS_EVT");
					__cStateOpts= new ArrayX("ID"+actual_mc._url,"PAUSE_CLIP", "REWIND_AND_STOP", "RESTART", "REWIND_PLAY", "FASTFORWARD_PLAY","SEEK_TO", "FULLSCREEN_CLIP");
									playerControls_mc.onPlayerStateChanged(ArrayX(__cStateOpts));
					
				}
			}
			return this.s0_viewAssetsLoaded;
		}
		//========================== LEVEL 2 ===============================/
		/*.................................................................*/
		public function s2_stoppedAtBeginning(e : AEvent) : Function
		{
			this.onFunctionEnter ("s2_stoppedAtBeginning-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					this.playState = "stopped";
					trace("HIGHLIGHT s2_stopped at beginning" + actual_mc.currentFrame);
					if(actual_mc.currentFrame >2){
						actual_mc.gotoAndStop(1);
					
					}
					onProgressChanged();
					m_almostFinished = false;
					m_hasFinished = false;
					callbackIn(1);
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
				case CALLBACK_EVT:{
					trace("HIGHLIGHT callback");
					if(autoStart){
						play();
						autoStart = false;
					}
					
					return null;
				}
				case GETOPTS_EVT:{
					trace("s1_stopped GETOPTS_EVTGETOPTS_EVTGETOPTS_EVTGETOPTS_EVTGETOPTS_EVTGETOPTS_EVTGETOPTS_EVTGETOPTS_EVT");
					var opts:ArrayX =new ArrayX("ID:"+actual_mc._url,"PLAY_CLIP","FASTFORWARD_PLAY", "SEEK_TO", "FULLSCREEN_CLIP"); 
					__cStateOpts= opts;
					onPlaybackStateChanged();
					return null;
				}
	
			}
			return this.s1_stopped;
		}
		/*.................................................................*/
		public function s2_stoppedInMiddle(e : AEvent) : Function
		{
			this.onFunctionEnter ("s2_stoppedInMiddle-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					playState = "paused";
					onProgressChanged();
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
			}
			return this.s1_stopped;
		}
		/*.................................................................*/
		public function s2_stoppedAtEnd(e : AEvent) : Function
		{
			this.onFunctionEnter ("s2_stoppedAtEnd-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					this.playState = "stopped";
					startPulse(1000);
					return null;
				}
				case EXIT_EVT :
				{
					stopPulse();
					return null;
				}
				case INIT_EVT :
				{
					return null;
				}
				case PULSE_EVT:{
					Q_TRAN(s2_finishedPlaying);
					return null;
				}
				case GETOPTS_EVT:{
					trace("s1_stopped GETOPTS_EVTGETOPTS_EVTGETOPTS_EVTGETOPTS_EVTGETOPTS_EVTGETOPTS_EVTGETOPTS_EVTGETOPTS_EVT");
					var opts:ArrayX =new ArrayX("ID:"+actual_mc._url,"REWIND_AND_STOP", "SEEK_TO", "FULLSCREEN_CLIP"); 
					__cStateOpts= opts;
					onPlaybackStateChanged();
					return null;
				}
			}
			return this.s1_stopped;
		}
			/*.................................................................*/
		public function s2_almostFinishedPlaying(e : AEvent) : Function
		{
			this.onFunctionEnter ("s2_almostFinishedPlaying-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					hasAlmostFinished = true;
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
			}
			return this.s1_playing;
		}
		/*.................................................................*/
		public function s2_finishedPlaying(e : AEvent) : Function
		{
			this.onFunctionEnter ("s2_finishedPlaying-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					this.playState = "finished";
					hasFinished = true;
					callbackIn(0);
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
				case CALLBACK_EVT:
				{
					if(autoRewind){
						Q_TRAN(s2_stoppedAtBeginning);
					}
				}
			}
			return this.s1_stopped;
		}
	
		/***************************************************************************
		 * Once a movie is loaded, scan the various heirarchy for the longest content
		 * 
		 */
	
		public static function scanClip(_mc : MovieClip) : MovieClip {
			trace("SCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCAN");
			trace("SCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCAN");
			trace("SCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCAN");
			trace("SCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCAN");
			trace("SCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCAN");
			trace("MixinPlayer.scanCLip " + _mc + " " + _mc.totalFrames);
			trace(" _mc  " + _mc._url);
			trace("SCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCAN");
			trace("SCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCAN");
			trace("SCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCAN");
			trace("SCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCAN");
			trace("SCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCANSCAN");
	
			var foundMC : MovieClip;
			var largestFra : Number = 2;
			if(_mc.totalFrames >= 2){
				foundMC = _mc;
				largestFra = _mc.totalFrames;
				trace("HIGHLIGHTp v:'"+_mc+"'"+_mc.currentFrame+"/"+_mc.totalFrames);
				_mc.__mxpStopped = true;
				_mc.gotoAndStop(1);
			}
			for (var i in _mc) {
				var o : Object = _mc[i];
				if (typeof (o) == "movieclip") {
					var v : MovieClip = MovieClip(o);
					trace("scan? " + v.name);
					if(v.name == "content_mc"){
						foundMC = v;
						break;
					}
					if (v.totalFrames>largestFra) {
						largestFra = v.totalFrames;
						foundMC = v;
					}
					if(v.totalFrames > 1){
						trace("attempting to stop " + v);
						v.__mxpStopped = true;
						v.gotoAndStop(1);
					}
					trace("HIGHLIGHTb k:'"+i+"' = v:'"+v+"'"+v.currentFrame+"/"+v.totalFrames);
				}
			}
			if (foundMC != null) {
				trace("_______________scanClip FOUND MC-------------" + foundMC);
			} else {
				trace("HIGHLIGHT...still waiting for clip to load");
			}
			return foundMC;
		}
		/* called when the clip is unloaded */
		protected function onActualClipUnload() : void {
			_root.status_txt.text = "onActualClipUnload";
			Q_TRAN(s0_viewAssetsDestroyed);
		}
	
	}
}