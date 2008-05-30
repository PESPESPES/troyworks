package com.troyworks.mediaplayer.ui { 
	 //import util.SWFUtilBasic;
	//import util.BasicLoader;
	import com.troyworks.hsmf.AEvent;
	import com.troyworks.hsmf.Signal;
	import com.troyworks.hsmf.Hsmf;
	//import com.troyworks.spring.Factory;
	//import com.troyworks.framework.IApplication;
	//import util.TEventDispatcher.troyworks.framework.ui.BaseComponent ;
	//import com.kidthing. *;
	//import com.troyworks.util.director.DirectorUtils;
	//http://livedocs.macromedia.com/flex/1/asdocs/mx/controls/MediaDisplay.html
	import flash.display.MovieClip;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.media.Video;
	public class MediaDisplayWrapper extends com.troyworks.mediaplayer.AMediaPlayer {
		//public static var PLAY_SIG : Signal = new Signal (USER_SIG.value + 0, "PLAY_SIG");
		//public static var PAUSE_SIG : Signal = new Signal (USER_SIG.value + 1, "PAUSE_SIG");
		//public static var STOP_SIG : Signal = new Signal (USER_SIG.value + 2, "STOP_SIG");
		//public static var NEXTCLIP_SIG : Signal = new Signal (USER_SIG.value + 3, "NEXTCLIP_SIG");
		//public static var PREVCLIP_SIG : Signal = new Signal (USER_SIG.value + 4, "PREVCLIP_SIG");
		////Static Events
		//public static var PLAY_EVT : Event = new Event (PLAY_SIG);
		//public static var PAUSE_EVT : Event = new Event (PAUSE_SIG);
		//public static var STOP_EVT : Event = new Event (STOP_SIG);
		//public static var NEXTCLIP_EVT : Event = new Event (NEXTCLIP_SIG);
		//public static var PREVCLIP_EVT : Event = new Event (PREVCLIP_SIG);
		public var netConn : NetConnection;
		public var netStream : NetStream;
		public var mediaDisplay : MovieClip;
		public var background_mc:MovieClip;
		public var autoPlay : Boolean = true;
		//	public var __cname:String = "MPB";
		public function MediaDisplayWrapper ()
		{
			super (s_initial,"MDW");
			trace ("AAAAAAAAAAAAAAAA MediaDisplayWrapper " + 	this.mediaDisplay);
			 this.hAlign = false;
		}
		public function onLoad() : void {
			super.onLoad();
			trace ("BBBBBBBBBBBBBBBBBBBBB MediaDisplayWrapper.onLoad");
			this.init();
		}
		public function onNetStreamStatus (infoObject : Object) : void
		{
			trace (" onNetStreamStatus " + infoObject.level + " " + infoObject.code);
			trace (util.Trace.me (infoObject, "infoObject", true));
			//this.canvas.debug_mc.status_txt.text += "Status (NetStream)"+newline;
			//this.canvas.debug_mc.status_txt.text += "Level: "+infoObject.level+newline;
			//this.canvas.debug_mc.status_txt.text += "Code: "+infoObject.code+newline;
			if (infoObject.level == "status")
			{
				switch (infoObject.code)
				{
					case "NetStream.Play.Start" :
					{
						this.Q_TRAN (this.s11_playing);
						//this.currentMediaItem.updateCurrentTimeSegment (this.netStream.time);
	
					}
					break;
					case "NetStream.Play.Stop" :
					{
						//this.ui_state = "STOPPED";
						this.Q_TRAN (this.s12_stopped);
						//	this.handleEvent = this.playing_Handler;
						//	this.currentMediaItem.updateCurrentTimeSegment (this.netStream.time);
	
					}
					break;
					case "NetStream.Buffer.Full" :
					{
						//this.handleEvent = this.playing_Handler;
						this.Q_TRAN (this.s11_playing);
						//	this.currentMediaItem.updateCurrentTimeSegment (this.netStream.time);
						//	this.canvas.debug_mc.status_txt.text = "finished";
	
					}
					break;
				}
			}
		};
		public function setMedia(path:String):void{
			this.mediaDisplay.setMedia(path, "FLV");
			this.Q_TRAN (s1_active);
		}
		public function move(x:Number, y:Number) : void {
		//	this.mediaDisplay.move(x,y);
		}
	
		public function setSize(w:Number, h:Number) : void {
			trace ("__________MDW.setSize " + w + " h " + h + " " + this.background_mc);
	       this.mediaDisplay.setSize(w,h);
		   this.background_mc.height = h;
		   this.background_mc.width = w;
		}
	
		/*.................................................................*/
		function s_initial (e : AEvent) : void {
			trace ("MediaDisplayWrapper.onInitXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			// Create a NetConnection object
			//	this.netConn = new NetConnection ();
			// Create a local streaming connection
			//	this.netConn.connect (null);
			// Create a NetStream object and define an onStatus() function
			//this.netStream = new NetStream (this.netConn);
			//this.netStream = netStream;
			///this.netStream.onStatus = Delegate.create (this, this.onNetStreamStatus);
			// Attach the NetStream video feed to the Video object
			///this.canvas.mediaDisplay.attachVideo (netStream);
			// Set the buffer time
			//this.netStream.setBufferTime (5);.
			//this.handleEvent = this.pausedAtBeginningHandler;
			this.Q_INIT (s1_active );
		}
		function s1_active (e : AEvent) : Function
		{
			this.onFunctionEnter ("s1_active-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					//	this.swf.ui_preload.visible = false;
					//	this.skin_mc.visible = true;
					//	this.skin_mc.gotoAndPlay ("active");
					return null;
				}
				case EXIT_EVT :
				{
					return null;
				}
				case INIT_EVT :
				{
					//	this.modalDialogC_mc = this.skin_mc.modalDialogC_mc;
					//	this.modalShield_mc = this.skin_mc.modalShield_mc;
					//	this.scanForm (this.background_mc);
						var highBandwidth : Boolean = true;
						this.mediaDisplay.autoSize = false;
						//this.mediaDisplay.aspectRatio = false;
						if (highBandwidth)
						{
						//	this.mediaDisplay.setMedia ("testvideo0.flv", "FLV");
							trace ("highBandwidth= " + highBandwidth);
						} else
						{
						//	this.mediaDisplay.setMedia ("testvideo0.flv", "FLV");
							trace ("lowbandwidth = " + highBandwidth);
						}
					if (this.autoPlay)
					{
						//	var media = "alexander.flv";
						trace ("******MediaDisplayWrapper.AUTOPLAY****** " + this.mediaDisplay + " " + this.mediaDisplay.visible );
						// + media);
						//this.netStream.play (media);
	
						this.Q_TRAN (s11_playing);
					} else
					{
						trace ("*****awaiting key stroke*******");
						this.Q_INIT (this.s10_pausedAtBeginning);
					}
					return null;
				}
			}
			return s_top;
		}
		function s10_pausedAtBeginning (e : AEvent) : Function
		{
			this.onFunctionEnter ("s10_pausedAtBeginning-", e, []);
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
				case PLAY_EVT :
				{
					this.mediaDisplay.play ();
					this.Q_TRAN (this.s11_playing);
					return null;
				}
				//	case INIT_EVT :
				//	{
				//		return new Function();
				//}
	
			}
			return this.s1_active ;
		}
		function s11_playing (e : AEvent) : Function
		{
			this.onFunctionEnter ("s11_playing-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					this.mediaDisplay.play ();
					return null;
				}
				case EXIT_EVT :
				{
					return null;
				}
				case GOTOANDSTOP_EVT :
				{
					this.mediaDisplay.play (0);
					this.mediaDisplay.stop ();
					this.Q_TRAN (this.s10_pausedAtBeginning);
					return null;
				}
				case STOP_EVT :
				{
					this.mediaDisplay.pause ();
					this.Q_TRAN (this.s13_pausedInMiddle);
					return null;
				}
				//	case INIT_EVT :
				//	{
				//		return null;
				//	}
	
			}
			return this.s1_active ;
		}
		function s12_stopped (e : AEvent) : Function
		{
			this.onFunctionEnter ("s12_stopped-", e, []);
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
				case STOP_EVT :
				{
					this.mediaDisplay.play (0);
					this.mediaDisplay.stop ();
					this.Q_TRAN (this.s10_pausedAtBeginning);
					return null;
				}
				case GOTOANDSTOP_EVT :
				{
					this.mediaDisplay.play (0);
					this.mediaDisplay.stop ();
					this.Q_TRAN (this.s10_pausedAtBeginning);
					return null;
				}
				case PLAY_EVT :
				{
					this.mediaDisplay.play ();
					this.Q_TRAN (this.s11_playing);
					return null;
				}
					case GOTOANDSTOP_EVT:
				{
					return null;
				}
	
			}
			return this.s1_active ;
		}
		function s13_pausedInMiddle (e : AEvent) : Function
		{
			this.onFunctionEnter ("s13_pausedInMiddle-", e, []);
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
				case STOP_EVT :
				{
					this.mediaDisplay.play (0);
					this.mediaDisplay.stop ();
					this.Q_TRAN (this.s10_pausedAtBeginning);
					return null;
				}
				case GOTOANDSTOP_EVT :
				{
					this.mediaDisplay.play (0);
					this.mediaDisplay.stop ();
					this.Q_TRAN (this.s10_pausedAtBeginning);
					return null;
				}
				case PLAY_EVT :
				{
					this.mediaDisplay.play ();
					this.Q_TRAN (this.s11_playing);
					return null;
				}
				//	case INIT_EVT :
				//	{
				//		return new Function();
				//}
	
			}
			return this.s1_active ;
		}
	}
	
}