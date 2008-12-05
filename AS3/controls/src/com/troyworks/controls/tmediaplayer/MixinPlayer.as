package com.troyworks.controls.tmediaplayer {
	import com.troyworks.controls.tmediaplayer.model.PlayHead;
	import com.troyworks.controls.tmediaplayer.ui.PlayerNav;
	import com.troyworks.controls.tmediaplayer.ui.SeekBarNav;
	import com.troyworks.core.SignalEventAdaptor;
	import com.troyworks.core.Signals;
	import com.troyworks.core.cogs.CogEvent;
	import com.troyworks.core.cogs.Hsm;
	import com.troyworks.data.ArrayX;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.system.fscommand;
	import flash.utils.clearInterval;		

	/**
	 * This class is a wrapper for a given loaded swf to convert
	 * it into a suitable clip for playback in a shell at the correct frame rate
	 * 
	 * @author Troy Gardner
	 */

	
	
	
	
	public class MixinPlayer extends Hsm {

		
		///////////////////////////////////////////////

		public static const SIG_PLAY : Signals = Signals.PLAY;
		public static const SIG_PAUSE : Signals = Signals.PAUSE;
		public static const SIG_REWIND_AND_STOP : Signals = Signals.REWIND_AND_STOP;
		public static const SIG_REWIND_AND_PLAY : Signals = Signals.REWIND_AND_PLAY;
		public static const SIG_STOP : Signals = Signals.STOP;
		public static const SIG_GOTOANDSTOP : Signals = Signals.GOTOANDSTOP;
		public static const SIG_GOTOANDPLAY : Signals = Signals.GOTOANDPLAY;

		
		public static const SIG_STARTED_CLIP : Signals = Signals.STARTED;
		public static const SIG_FINISHED_CLIP : Signals = Signals.FINISHED;	
		public static const SIG_INCREMENT_FRAME : Signals = Signals.INCREMENT_FRAME;
		public static const SIG_DECREMENT_FRAME : Signals = Signals.DECREMENT_FRAME;
		//public static const SIG_PLAYBACK_STATE_CHANGED : Signals =  Signals.getNext("PLAYBACK_STATE_CHANGED");
		//public static const SIG_PROGRESS_CHANGED : Signals = Signals.getNext("PROGRESS_CHANGED");
		public static const EVTD_PLAYBACK_STATE_CHANGED : String  ="EVTD_PLAYBACK_STATE_CHANGED";
		public static const EVTD_PROGRESS_CHANGED :  String ="EVTD_PROGRESS_CHANGED";

		//
		public static const SIG_NEXTCLIP : Signals = Signals.GOTO_NEXT;
		public static const SIG_PREVCLIP : Signals = Signals.GOTO_PREVIOUS;
		//Static Events
		public static const SIG_PLAYFLV : Signals = Signals.PLAYFLV;
		public static const SIG_PLAYMP3 : Signals = Signals.PLAYMP3;
		public static const SIG_PLAYIMAGE : Signals = Signals.PLAYIMAGE;
		public static const SIG_PLAYSWF : Signals = Signals.PLAYSWF;
		public static const SIG_TRANS_IN : Signals = Signals.TRANSIN_START;
		public static const SIG_TRANS_OUT : Signals = Signals.TRANSOUT_START;
		public var __cStateOpts : ArrayX;
		//////////////////////////////////////////

		
		public var base_mc : MovieClip;
		public var navBase_mc : MovieClip;
		public var actual_mc : MovieClip;
		public var playerControls_mc : PlayerNav;
		public var seekControls_mc : SeekBarNav;

		public var playhead : PlayHead;
		//
		protected var m_isLoaded : Boolean = false;
		protected var m_isReady : Boolean = false;
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
		protected var intV : Number = NaN;
		// setInterval(_mc, "__mxpPollStatus", 1000/24);
		protected var pintV : Number = -1;

		public var isSubordinateContent : Boolean = false;

		protected var exposedExternalInterfaceCallbacks : Boolean;
		public var cleanAllOnUnload : Boolean = false;

		/*****************************************************
		 *  Constructor
		 */

		public function MixinPlayer(aMovieClip : MovieClip, parentClip : MovieClip, aIsSubordinateContent : Boolean = false) {
			super(null, "MixinPlayer", false);
			trace("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
			trace("MMMMMMMMMMMMMMMMMMMMMMMM MixinPlayer MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
			trace("MMMMMMMMMMMMMMM aMovieClip " + aMovieClip + " MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
			trace("MMMMMMMMMMMMMMM parentClip " + parentClip + " MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
			trace("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
			trace("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
	
			base_mc = aMovieClip;
			playerFPS = aMovieClip.stage.frameRate;
			navBase_mc = parentClip;
			//playhead = new PlayHead();
			//////////////Activate the statemachine ///////////
			if(aMovieClip != null){
				//init();
			} else {
				trace("*** WARNING **** MixinPlayer passed in a null value"); 
			}
			isSubordinateContent = aIsSubordinateContent;
			if(!isSubordinateContent) {
				trace("ERROR exposing ExternalInterfaces");
				exposeExternalInterfaceCallbacks();
			}else {
				trace("ERROR not exposing ExternalInterfaces");
			}
		}

		public function exposeExternalInterfaceCallbacks() : void {
			if(ExternalInterface.available) {
				ExternalInterface.addCallback("startPlayback", play);
				ExternalInterface.addCallback("pausePlayback", stop);
				ExternalInterface.addCallback("rewindAndStopPlayback", rewindAndStop);
				ExternalInterface.addCallback("rewindAndPlayback", rewindAndPlay);
				ExternalInterface.addCallback("removeExternalInterfaceCallbacks", removeExternalInterfaceCallbacks);
				ExternalInterface.call("onExternalInterfaceChanged", true);
			}
			exposedExternalInterfaceCallbacks = true;		
		}

		public function removeExternalInterfaceCallbacks() : void {
			if(ExternalInterface.available) {
				ExternalInterface.addCallback("startPlayback", emptyFunction);
				ExternalInterface.addCallback("pausePlayback", emptyFunction);
				ExternalInterface.addCallback("rewindAndStopPlayback", emptyFunction);
				ExternalInterface.addCallback("rewindAndPlayback", emptyFunction);
				ExternalInterface.call("onExternalInterfaceChanged", false);
			}
			exposedExternalInterfaceCallbacks = false;
		}

		public function emptyFunction() : void {
		}

		public function registerPlayerControls(nav : PlayerNav) : void {
			if(nav == null) return;
	
			trace("000000000000000000000000000000000000000000000000000000");
			trace("000000000000000000000000000000000000000000000000000000");
			trace("000000000000000000000000 registerPlayerControls " + this + " 000000000000000000000000000000");
			trace("0000000000000000000000000 " + nav + " 00000000000000000000000000000");
			//	trace("00000000000000000000000000 " + stackOpts +" 0000000000000000000000000000");
			//	trace("00000000000000000000000nav.requestTran0000000 " + nav.requestTran +" 000000000000000000000000");
			//var f : Function = nav.createCallback(STATE_CHANGED);
			addEventListener(SIG_STATE_CHANGED.name, nav.onPlayerStateChanged);
			//TODO nav.onPlayerStateChanged(stackOpts);
			////////////////////////////////////////
			//	nav.playClipBtn_mc.addEventListenEventEventEventEvent_CLICK, actual_mc, actual_mc.__mxpPlay);
			nav.playClipBtn_mc.addEventListener(MouseEvent.CLICK, new SignalEventAdaptor(dispatchEvent, SIG_PLAY).relayEvent);
			nav.pauseClipBtn_mc.addEventListener(MouseEvent.CLICK, new SignalEventAdaptor(dispatchEvent, SIG_STOP).relayEvent);
			playerControls_mc = nav;
		}

		public function unRegisterPlayerControls() : void {
			playerControls_mc.playClipBtn_mc.removeEventListener(MouseEvent.CLICK, dispatchEvent);
			playerControls_mc.pauseClipBtn_mc.removeEventListener(MouseEvent.CLICK, dispatchEvent);
			playerControls_mc = null;
		}

		public function registerSeekControls(seeknav : SeekBarNav) : void {
			if(seeknav == null) return;
			trace("000000000000000000000000000000000000000000000000000000");
			trace("000000000000000000000000000000000000000000000000000000");
			trace("000000000000000000000000registerSeekControls " + this + " 000000000000000000000000000000");
			trace("0000000000000000000000000 " + seeknav + " 00000000000000000000000000000");
			seekControls_mc = seeknav;
		/*	var f:Function = seeknav.createCallback(STATE_CHANGED);
			addEventListener(EVT_INT_STATE_CHANGED, f);
			nav.onPlayerStateChanged(stackOpts);
			////////////////////////////////////////
			nav.playClipBtn_mc.addEventLisEventrEventuEvent.Event_CLICK, createCallback(PLAY));
			nav.pauseClipBtn_mc.addEventEventenEventCBEventn.Event_CLICK, createCallback(STOP));*/
		}

		///////////////////// INBOUND COMMANDS //////////////////////////////////////////
		public function play() : void {
			trace("MixinPlayer.play");
			dispatchEvent(SIG_PLAY.createPrivateEvent());
		}

		public function stop() : void {
			trace("ERROR MXP. stop");
			//actual_mc.__mxpStopPlaying();
			dispatchEvent(SIG_STOP.createPrivateEvent());
		}

		public function rewindAndStop() : void {
			dispatchEvent(SIG_REWIND_AND_STOP.createPrivateEvent());
		}

		public function rewindAndPlay() : void {
			dispatchEvent(SIG_REWIND_AND_PLAY.createPrivateEvent());
		}

		/////////////////////// PROPERTIES ///////////////////////////////////////////////////////
		public function get hasStarted() : Boolean {
			return m_hasStarted;
		}

		public function set hasStarted(aHasStarted : Boolean) : void {
			if(m_hasStarted != aHasStarted) {
				m_hasStarted = aHasStarted;
				fscommand("ktmoviestart");
				ExternalInterface.call("contentHasStarted", "ID:" + actual_mc.loaderInfo.url, m_hasStarted);
			}
		}

		public function get hasAlmostFinished() : Boolean {
			return m_almostFinished;
		}

		public function set hasAlmostFinished(aHasAlmostFinished : Boolean) : void {
			if(m_almostFinished != aHasAlmostFinished) {
				m_almostFinished = aHasAlmostFinished;
				fscommand("ktmoviealmostfinished");
				 
				ExternalInterface.call("contentIsAlmostFinished", "ID:" + actual_mc.loaderInfo.url, m_almostFinished); 
			}
		}

		public function get hasFinished() : Boolean {
			return m_hasFinished;
		}

		public function set hasFinished(finished : Boolean) : void {
			if(m_hasFinished != finished) {
				m_hasFinished = finished;
				fscommand("ktmoviefinished");
				 
				ExternalInterface.call("contentIsFinished", "ID:" + actual_mc.loaderInfo.url, m_hasFinished); 
			}
		}

		public function unloadMovie() : void {
			base_mc.removeChild(actual_mc);
		}

		public function set isLoaded(loaded : Boolean) : void {
			if(m_isLoaded != loaded) {
				m_isLoaded = loaded;
				if(m_isLoaded) {
					fscommand("ktmovieloaded");
				}
				
				ExternalInterface.call("contentIsLoaded", "ID:" + actual_mc.loaderInfo.url, m_isLoaded);
			}
		}

		public function get isLoaded() : Boolean {
			return m_isLoaded;
		}

		public function set isReady(ready : Boolean) : void {
			if(m_isReady != ready) {
				m_isReady = ready;
				ExternalInterface.call("contentIsReady", "ID:" + actual_mc.loaderInfo.url, m_isLoaded);
			}
		}

		public function get isReady() : Boolean {
			return m_isReady;
		}

		//////////////////// OUTBOUND ////////////////////////////////////////////////
		public function onPlaybackStateChanged() : void {
			//TODOEventpatEvententEventpe:Event_PLAYBACK_STATE_CHANGED, id:actual_mc.loaderInfo.url, playState:playState, opts:__cStateOpts});
			if(!isSubordinateContent) {
				ExternalInterface.call("onPlaybackStateChanged", "ID:" + actual_mc.loaderInfo.url, playState, __cStateOpts);
			//	fscommand(playState);
			}
			if(playerControls_mc != null){
				playerControls_mc.onPlayerStateChanged(__cStateOpts);
			}
		}

		public function onProgressChanged() : void {
			trace("Progress " + actual_mc.currentFrame + "/" + actual_mc.totalFrames);
			if(seekControls_mc != null) {
				seekControls_mc.setPlayedProgress(actual_mc.currentFrame / actual_mc.totalFrames);
				seekControls_mc.setLoadedProgress(actual_mc.loaderInfo.bytesLoaded / actual_mc.loaderInfo.bytesTotal);
			}
			var eT : Number = actual_mc.currentFrame / FPS;
			var tT : Number = actual_mc.totalFrames / FPS;
				trace("ProgressN " + eT + " " + tT);
			//XXX var feT : TimeDateFormat = TimeDateFormat.parseRelativeTime(eT * 1000);
			//XXX var ftT : TimeDateFormat = TimeDateFormat.parseRelativeTime(tT * 1000);
			//XXX var t : String = TimeDateFormat.padTo(feT.a_minute,2,"0") + ":" + TimeDateUtil.padTo(feT.a_seconds,2,"0") + " / " + TimeDateUtil.padTo(ftT.a_minute,2,"0") + ":" + TimeDateUtil.padTo(ftT.a_seconds,2,"0");
				//trace("ProgressT " + t + " "  + FPS);
			if(playerControls_mc != null) {
			//XXX	playerControls_mc.display_txt.text = t;
			}
			//TEventdispEventEvenEventype:Event_PROGRESS_CHANGED, id:actual_mc.loaderInfo.url, curFrame:actual_mc.currentFrame, totFrames:actual_mc.totalFrames, elapsedTime:feT.a_minute+":"+TimeDateUtil.padTo(feT.a_seconds,2,"0"), totalTime:ftT.a_minute + ":" + TimeDateUtil.padTo(ftT.a_seconds,2,"0"), bytesLoaded:actual_mc.getBytesLoaded(), bytesTotal:actual_mc.getBytesTotal()});
			if(!isSubordinateContent) {
			//XXX	ExternalInterface.call("onProgressChanged", "ID:" + actual_mc.loaderInfo.url, actual_mc.currentFrame, actual_mc.totalFrames, feT.a_minute + ":" + TimeDateUtil.padTo(feT.a_seconds, 2, "0"), ftT.a_minute + ":" + TimeDateUtil.padTo(ftT.a_seconds, 2, "0"), actual_mc.loaderInfo.bytesLoaded, actual_mc.loaderInfo.bytesTotal);
			}
		//	playerControls_mc.onProgressChanged(__cStateOpts);
		}

		///////////////////////////////////////////////////////////////
		public function onLoad() : void {
		//	super.onLoad(false);
		}

		///////////////////// STATES ///////////////////////////////

		/*.................................................................*/
		public function s_initial(e : CogEvent) : Function {
			switch (e.sig) {
				case SIG_INIT :
					/* initialize extended state variable */
					//this.__foo = false;
					trace("s_initial");
					return s_viewAssetsUnLoaded;
			}
			return  s_root;
		}

		//////////////////////// LEVEL 0 STATES////////////////////////////
		/*.................................................................*/
		public function s_viewAssetsUnLoaded(e : CogEvent) : Function {
			trace("s_viewAssetsUnLoaded " + e);
			trace("s_root?:" + s_root);
			//	onFunctionEnter ("s_viewAssetsUnLoaded-", e, []);
			switch (e.sig) {
				case SIG_ENTRY :
					trace("SIG_ENTRY");
					playState = "loading";
					startPulse(1000 / 30);
					return null;
					
				case SIG_EXIT :
					trace("SIG_EXIT");		
					stopPulse();
					return null;
				
				case SIG_PULSE:
					trace("SIG_PULSE");
					trace("MixinPlayer.LoadCheck  " + base_mc.loaderInfo.bytesLoaded + " / " + base_mc.loaderInfo.bytesTotal);
					if(actual_mc == null) {
						actual_mc = scanClip(base_mc);
						if(actual_mc.onUnload != null) {
							actual_mc.mxpOnOnload = actual_mc.onUnload;
						}
						//TODO	actual_mc.onUnload  =TProxy.create( onActualClipUnload);
						if(actual_mc != null) {
							requestTran(s___stoppedAtBeginning);
	//						MixinPlayer.createMovieTracker(actual_mc);
						}			
					}
	
					return null;
			}
			return s_root;
		}

		/*.................................................................*/
		public function s_viewAssetsLoaded(e : CogEvent) : Function {
	
			//onFunctionEnter ("s_viewAssetsLoaded-", e, []);
			switch (e.sig) {
				case SIG_ENTRY :
					{
					trace("s_viewAssetsLoaded.onEnter --- ");
					if(navBase_mc != null && navBase_mc.PlayerNavButtonBar_mc != null) {
						registerPlayerControls(navBase_mc.PlayerNavButtonBar_mc);
						registerSeekControls(navBase_mc.PlayerNavButtonBar_mc.seekControls_mc);
					}
					hasStarted = false;
					playState = "initializing";
					m_hasFinished = false;
					m_almostFinished = false;
					almostFinishedFrames = 24;
					isLoaded = true;
					onProgressChanged();
	
					return null;
					}
				case SIG_INIT :
				{
					return s___stoppedAtBeginning;
				}
				case SIG_PLAY:
				{
					requestTran(s__playing);
					return null;
				}
				case SIG_STOP:
				{
					requestTran(s__stopped);
					return null;
				}
				case SIG_REWIND_AND_STOP:
				{
					trace("HIGHLIGHTb REWIND_AND_STOP");
					actual_mc.gotoAndStop(1);
					m_almostFinished = false;
					m_hasFinished = false;
					requestTran(s___stoppedAtBeginning);
					return null;
				}
				case SIG_REWIND_AND_PLAY:
				{
					actual_mc.gotoAndPlay(1);
					m_almostFinished = false;
					m_hasFinished = false;
					requestTran(s__playing);
					return null;
				}
				case SIG_GETOPTS:
				{	
				//	playhead.requestTran(GETOPTS);
					trace("MIXING PLAYER GET OPTIONS XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
				//	trace("My Options are: " + stackOpts);
					trace("Clip Options are: " + actual_mc.stackOpts);
					trace("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
				
				//	var opts:ArrayX = stackOpts.concat(actual_mc.stackOpts.concat());
				//	__cStateOpts = opts;
					__cStateOpts=new ArrayX("ID:"+actual_mc.loaderInfo.url,"REPLAY_CLIP");
					//playerControls_mc.onPlayerStateChanged(ArrayX(__cStateOpts));
					return null;
				}
			}
			return s_root;
		}
		//========================== LEVEL 1 ===============================/
		/*.................................................................*/
	
		public function s_viewAssetsDestroyed(e :CogEvent) : Function
	
		{
			trace("s_viewAssetsDestroyed");
			//onFunctionEnter ("s_viewAssetsDestroyed-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					playState = "unloaded";
				//	_root.status_txt.text += "s_viewAssetsDestroyed";
					if(exposedExternalInterfaceCallbacks){
						unRegisterPlayerControls();
						removeExternalInterfaceCallbacks();
						delete(this);
					}
					if(cleanAllOnUnload){
				//		_global.cleanAllOnUnload();
					}
					return null;
				}
	
			}
			return s_root;
		}
		//========================== LEVEL 1 ===============================/
		/*.................................................................*/
		public function s__stopped(e :CogEvent) : Function
		{
			//onFunctionEnter ("s__stopped-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					trace("HIGHLIGHTs1 stopped.Enter");
				//	trace("s1 stopped.Enter");
					//actual_mc.__mxpStopPlaying();
					trace(actual_mc.name +".MTstop " + actual_mc.currentFrame + " / "  + actual_mc.totalFrames);
					actual_mc.stop();
					for(var i:String in actual_mc){
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
				case SIG_EXIT :
				{
					return null;
				}
				case SIG_INIT :
				{
					trace("s1 stopped.INIT");
					if(actual_mc.currentFrame == 1){
						trace("-> stopped at beginning");
						return s___stoppedAtBeginning;
					}else if(actual_mc.currentFrame == actual_mc.totalFrames){
						trace("-> stopped at end");
						return s___stoppedAtEnd ;
					}else{
						trace("-> stopped in middle");
						return s___stoppedInMiddle;
					}
				}
				case SIG_GETOPTS:{
					trace("s__stopped GETOPTSGETOPTSGETOPTSGETOPTSGETOPTSGETOPTSGETOPTSGETOPTS");
					var opts:ArrayX =new ArrayX("ID:"+actual_mc.loaderInfo.url,"PLAY_CLIP", "REWIND_AND_STOP", "FASTFORWARD_PLAY", "SEEK_TO", "FULLSCREEN_CLIP"); 
					__cStateOpts= opts;
					onPlaybackStateChanged();
					return null;
		
				}
			}
			return s_viewAssetsLoaded;
		}
	
		/*.................................................................*/
		public function s__playing(e :CogEvent) : Function
		{
			//onFunctionEnter ("s__stopped-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					trace(actual_mc.name +"MT.starting Playing()");
					if(previewMode){
						actual_mc.gotoAndPlay(actual_mc.totalFrames - (almostFinishedFrames -1));
					}else if(FPS == playerFPS){
						actual_mc.play();
						for(var i:String in actual_mc){
							if(actual_mc[i].__mxpStopped){
								actual_mc[i].play();
							}
						}
					}else{
					//TODO	pintV = setInterval(createCallback(INCREMENT_FRAME), 1000/FPS);
					}
					playState = "playing";
					isReady = true;
					startPulse(1000/36);
					return null;
				}
				case SIG_PULSE:
				{
					onProgressChanged();
					if((actual_mc.totalFrames  >almostFinishedFrames)  && actual_mc.currentFrame == (actual_mc.totalFrames - almostFinishedFrames) || actual_mc.almostFinished){
						requestTran(s___almostFinishedPlaying);
					}
					if(actual_mc.currentFrame == actual_mc.totalFrames || actual_mc.hasFinished){
						requestTran(s___stoppedAtEnd);
					}
					return null;
				}
				case SIG_DECREMENT_FRAME:
				{
	
					actual_mc.prevFrame();
					return null;
				}
				case SIG_INCREMENT_FRAME:
				{
	
					actual_mc.nextFrame();
					return null;
				}
				case SIG_EXIT :
				{
					clearInterval(pintV);
					stopPulse();
					return null;
				}
				case SIG_GETOPTS:{
					trace("GETOPTSGETOPTSGETOPTSGETOPTSGETOPTSGETOPTSGETOPTSGETOPTS");
					__cStateOpts= new ArrayX("ID:"+actual_mc.loaderInfo.url,"PAUSE_CLIP", "REWIND_AND_STOP", "RESTART", "REWIND_PLAY", "FASTFORWARD_PLAY","SEEK_TO", "FULLSCREEN_CLIP");
					onPlaybackStateChanged();
					return null;
	
					
	
				}
				case SIG_PULSE:
				{
					trace("Progress " + actual_mc.currentFrame + "/" + actual_mc.totalFrames);
					seekControls_mc.setPlayedProgress(actual_mc.currentFrame / actual_mc.totalFrames);
					seekControls_mc.setLoadedProgress(actual_mc.loaderInfo.bytesLoaded / actual_mc.byteTotal);
					var eT : Number = actual_mc.currentFrame / FPS;
					var tT : Number = actual_mc.totalFrames / FPS;
				//	trace("ProgressN " + eT + " " + tT);
				//XXX	var feT : TimeDateUtil = new TimeDateUtil(eT*1000);
				//XXX		var ftT : TimeDateUtil = new TimeDateUtil(tT*1000);
			//XXX			var t : String = feT.a_minute+":"+feT.a_seconds+" / " + ftT.a_minute + ":" + ftT.a_seconds;
				//	trace("ProgressT " + t + " " );
				//XXX		playerControls_mc.display_txt.text =t;
					if((actual_mc.totalFrames  >almostFinishedFrames)  && actual_mc.currentFrame == (actual_mc.totalFrames - almostFinishedFrames) || actual_mc.almostFinished){
						requestTran(s___almostFinishedPlaying);
					}
					if(actual_mc.currentFrame == actual_mc.totalFrames || actual_mc.hasFinished){
						requestTran(s___stoppedAtEnd);
					}
					return null;
				}
				case SIG_EXIT :
				{
					clearInterval(pintV);
					stopPulse();
					return null;
				}
				case SIG_GETOPTS:{
					trace("GETOPTSGETOPTSGETOPTSGETOPTSGETOPTSGETOPTSGETOPTSGETOPTS");
					__cStateOpts= new ArrayX("ID"+actual_mc.loaderInfo.url,"PAUSE_CLIP", "REWIND_AND_STOP", "RESTART", "REWIND_PLAY", "FASTFORWARD_PLAY","SEEK_TO", "FULLSCREEN_CLIP");
									playerControls_mc.onPlayerStateChanged(ArrayX(__cStateOpts));
					
				}
			}
			return s_viewAssetsLoaded;
		}
		//========================== LEVEL 2 ===============================/
		/*.................................................................*/
		public function s___stoppedAtBeginning(e :CogEvent) : Function
		{
		//	onFunctionEnter ("s___stoppedAtBeginning-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					playState = "stopped";
					trace("HIGHLIGHT s___stopped at beginning" + actual_mc.currentFrame);
					if(actual_mc.currentFrame >2){
						actual_mc.gotoAndStop(1);
					
					}
					onProgressChanged();
					m_almostFinished = false;
					m_hasFinished = false;
					callbackIn(1);
					return null;
				}
				case SIG_CALLBACK:{
					trace("HIGHLIGHT callback");
					if(autoStart){
						play();
						autoStart = false;
					}
					
					return null;
				}
				case SIG_GETOPTS:{
					trace("s__stopped GETOPTSGETOPTSGETOPTSGETOPTSGETOPTSGETOPTSGETOPTSGETOPTS");
					var opts:ArrayX =new ArrayX("ID:"+actual_mc.loaderInfo.url,"PLAY_CLIP","FASTFORWARD_PLAY", "SEEK_TO", "FULLSCREEN_CLIP"); 
					 __cStateOpts = opts;
					onPlaybackStateChanged();
					return null;
				}
	
			}
			return s__stopped;
		}
		/*.................................................................*/
		public function s___stoppedInMiddle(e :CogEvent) : Function
		{
			//onFunctionEnter ("s___stoppedInMiddle-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					playState = "paused";
					onProgressChanged();
					return null;
				}
			}
			return s__stopped;
		}
		/*.................................................................*/
		public function s___stoppedAtEnd(e :CogEvent) : Function
		{
		//	onFunctionEnter ("s___stoppedAtEnd-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					playState = "stopped";
					startPulse(1000);
					return null;
				}
				case SIG_EXIT :
				{
					stopPulse();
					return null;
				}
				case SIG_PULSE:{
					requestTran(s___finishedPlaying);
					return null;
				}
				case SIG_GETOPTS:{
					trace("s__stopped GETOPTSGETOPTSGETOPTSGETOPTSGETOPTSGETOPTSGETOPTSGETOPTS");
					var opts:ArrayX =new ArrayX("ID:"+actual_mc.loaderInfo.url,"REWIND_AND_STOP", "SEEK_TO", "FULLSCREEN_CLIP"); 
					__cStateOpts= opts;
					onPlaybackStateChanged();
					return null;
				}
			}
			return s__stopped;
		}
			/*.................................................................*/
		public function s___almostFinishedPlaying(e :CogEvent) : Function
		{
			//onFunctionEnter ("s___almostFinishedPlaying-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					hasAlmostFinished = true;
					return null;
				}

			}
			return s__playing;
		}
		/*.................................................................*/
		public function s___finishedPlaying(e :CogEvent) : Function
		{
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					playState = "finished";
					hasFinished = true;
					callbackIn(0);
					return null;
				}
				case SIG_CALLBACK:
				{
					if(autoRewind){
						requestTran(s___stoppedAtBeginning);
					}
				}
			}
			return s__stopped;
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
			trace(" _mc  " + _mc.loaderInfo.url);
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
			//	_mc.__mxpStopped = true;
				_mc.gotoAndStop(1);
			}
			for (var i:String in _mc) {
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
			//_root.status_txt.text = "onActualClipUnload";
			requestTran(s_viewAssetsDestroyed);
		}
	}
}