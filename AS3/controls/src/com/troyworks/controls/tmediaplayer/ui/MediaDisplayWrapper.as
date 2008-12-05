package com.troyworks.controls.tmediaplayer.ui { 

	//http://livedocs.macromedia.com/flex/1/asdocs/mx/controls/MediaDisplay.html
	
	import com.troyworks.core.cogs.CogEvent;	
	
	import flash.display.MovieClip;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	//import flash.media.Video;
	public class MediaDisplayWrapper extends com.troyworks.controls.tmediaplayer.AMediaPlayer {
		//public static var PLAY_SIG : Signal = new Signal (USER_SIG.value + 0, "PLAY_SIG");
		//public static var PAUSE_SIG : Signal = new Signal (USER_SIG.value + 1, "PAUSE_SIG");
		//public static var STOP_SIG : Signal = new Signal (USER_SIG.value + 2, "STOP_SIG");
		//public static var NEXTCLIP_SIG : Signal = new Signal (USER_SIG.value + 3, "NEXTCLIP_SIG");
		//public static var PREVCLIP_SIG : Signal = new Signal (USER_SIG.value + 4, "PREVCLIP_SIG");
		////Static Events
		//public static var PLAY_EVT : Event = new Event (PLAY_SIG);
		//public static var PAUSE_EVT : Event = new Event (PAUSE_SIG);
		//public static var SIG_STOP : Event = new Event (STOP_SIG);
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
			super ("s_initial","MDW");
			trace ("AAAAAAAAAAAAAAAA MediaDisplayWrapper " + 	mediaDisplay);
//TODO			 hAlign = false;
		}
		public function onLoad() : void {
			//super.onLoad();
			trace ("BBBBBBBBBBBBBBBBBBBBB MediaDisplayWrapper.onLoad");
			initStateMachine();
		}
		public function onNetStreamStatus (infoObject : Object) : void
		{
			trace (" onNetStreamStatus " + infoObject.level + " " + infoObject.code);
			trace (util.Trace.me (infoObject, "infoObject", true));
			//canvas.debug_mc.status_txt.text += "Status (NetStream)"+newline;
			//canvas.debug_mc.status_txt.text += "Level: "+infoObject.level+newline;
			//canvas.debug_mc.status_txt.text += "Code: "+infoObject.code+newline;
			if (infoObject.level == "status")
			{
				switch (infoObject.code)
				{
					case "NetStream.Play.Start" :
					{
						requestTran(s11_playing);
						//currentMediaItem.updateCurrentTimeSegment (netStream.time);
	
					}
					break;
					case "NetStream.Play.Stop" :
					{
						//ui_state = "STOPPED";
						requestTran (s12_stopped);
						//	handleEvent = playing_Handler;
						//	currentMediaItem.updateCurrentTimeSegment (netStream.time);
	
					}
					break;
					case "NetStream.Buffer.Full" :
					{
						//handleEvent = playing_Handler;
						requestTran (s11_playing);
						//	currentMediaItem.updateCurrentTimeSegment (netStream.time);
						//	canvas.debug_mc.status_txt.text = "finished";
	
					}
					break;
				}
			}
		};
		public function setMedia(path:String):void{
			mediaDisplay.setMedia(path, "FLV");
			requestTran (s1_active);
		}
		public function move(x:Number, y:Number) : void {
		//	mediaDisplay.move(x,y);
		}
	
		public function setSize(w:Number, h:Number) : void {
			trace ("__________MDW.setSize " + w + " h " + h + " " + background_mc);
	       mediaDisplay.setSize(w,h);
		   background_mc.height = h;
		   background_mc.width = w;
		}
	
		/*.................................................................*/
		function s_initial (e : CogEvent) : Function {
			trace ("MediaDisplayWrapper.onInitXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			// Create a NetConnection object
			//	netConn = new NetConnection ();
			// Create a local streaming connection
			//	netConn.connect (null);
			// Create a NetStream object and define an onStatus() function
			//netStream = new NetStream (netConn);
			//netStream = netStream;
			///netStream.onStatus = Delegate.create (this, onNetStreamStatus);
			// Attach the NetStream video feed to the Video object
			///canvas.mediaDisplay.attachVideo (netStream);
			// Set the buffer time
			//netStream.setBufferTime (5);.
			//handleEvent = pausedAtBeginningHandler;
			//Q_INIT (s1_active );
			return s1_active;
		}
		function s1_active (e : CogEvent) : Function
		{
			//onFunctionEnter ("s1_active-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					//	swf.ui_preload.visible = false;
					//	skin_mc.visible = true;
					//	skin_mc.gotoAndPlay ("active");
					return null;
				}
				case SIG_EXIT :
				{
					return null;
				}
				case SIG_INIT :
				{
					//	modalDialogC_mc = skin_mc.modalDialogC_mc;
					//	modalShield_mc = skin_mc.modalShield_mc;
					//	scanForm (background_mc);
						var highBandwidth : Boolean = true;
						mediaDisplay.autoSize = false;
						//mediaDisplay.aspectRatio = false;
						if (highBandwidth)
						{
						//	mediaDisplay.setMedia ("testvideo0.flv", "FLV");
							trace ("highBandwidth= " + highBandwidth);
						} else
						{
						//	mediaDisplay.setMedia ("testvideo0.flv", "FLV");
							trace ("lowbandwidth = " + highBandwidth);
						}
					if (autoPlay)
					{
						//	var media = "alexander.flv";
						trace ("******MediaDisplayWrapper.AUTOPLAY****** " + mediaDisplay + " " + mediaDisplay.visible );
						// + media);
						//netStream.play (media);
	
						requestTran (s11_playing);
					} else
					{
						trace ("*****awaiting key stroke*******");
						requestTran (s10_pausedAtBeginning);
					}
					return null;
				}
			}
			return s_root;
		}
		function s10_pausedAtBeginning (e : CogEvent) : Function
		{
			//onFunctionEnter ("s10_pausedAtBeginning-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					return null;
				}
				case SIG_EXIT :
				{
					return null;
				}
				case SIG_PLAY :
				{
					mediaDisplay.play ();
					requestTran (s11_playing);
					return null;
				}
				//	case SIG_INIT :
				//	{
				//		return new Function();
				//}
	
			}
			return s1_active ;
		}
		function s11_playing (e : CogEvent) : Function
		{
		//	onFunctionEnter ("s11_playing-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					mediaDisplay.play ();
					return null;
				}
				case SIG_EXIT :
				{
					return null;
				}
				case SIG_GOTOANDSTOP :
				{
						mediaDisplay.gotoAndPlay(1);
					mediaDisplay.stop ();
					requestTran (s10_pausedAtBeginning);
					return null;
				}
				case SIG_STOP :
				{
					mediaDisplay.pause ();
					requestTran (s13_pausedInMiddle);
					return null;
				}
				//	case SIG_INIT :
				//	{
				//		return null;
				//	}
	
			}
			return s1_active ;
		}
		function s12_stopped (e : CogEvent) : Function
		{
		//	onFunctionEnter ("s12_stopped-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					return null;
				}
				case SIG_EXIT :
				{
					return null;
				}
				case SIG_STOP :
				{
					mediaDisplay.gotoAndPlay(1);
					mediaDisplay.stop ();
					requestTran (s10_pausedAtBeginning);
					return null;
				}
				case SIG_GOTOANDSTOP :
				{
					mediaDisplay.gotoAndPlay(1);
					mediaDisplay.stop ();
					requestTran (s10_pausedAtBeginning);
					return null;
				}
				case SIG_PLAY :
				{
					mediaDisplay.play ();
					requestTran (s11_playing);
					return null;
				}

	
			}
			return s1_active ;
		}
		function s13_pausedInMiddle (e : CogEvent) : Function
		{
			//onFunctionEnter ("s13_pausedInMiddle-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					return null;
				}
				case SIG_EXIT :
				{
					return null;
				}
				case SIG_STOP :
				{
						mediaDisplay.gotoAndPlay(1);
					mediaDisplay.stop ();
					requestTran (s10_pausedAtBeginning);
					return null;
				}
				case SIG_GOTOANDSTOP :
					{
						mediaDisplay.gotoAndPlay(1);
					mediaDisplay.stop ();
					requestTran (s10_pausedAtBeginning);
					return null;
				}
				case SIG_PLAY :
				{
					mediaDisplay.play ();
					requestTran (s11_playing);
					return null;
				}
				//	case SIG_INIT :
				//	{
				//		return new Function();
				//}
	
			}
			return s1_active ;
		}
	}
	
}