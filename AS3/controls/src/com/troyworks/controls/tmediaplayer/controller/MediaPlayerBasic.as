package com.troyworks.controls.tmediaplayer.controller { 

	//http://livedocs.macromedia.com/flex/1/asdocs/mx/controls/MediaDisplay.html

	//TEMP
	
	import com.troyworks.util.SWFUtil;	
	import com.troyworks.core.cogs.CogEvent;	
	import com.troyworks.controls.tmediaplayer.ui.MediaDisplayWrapper;	
	import com.troyworks.util.director.DirectorUtils;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.media.Sound;
	import flash.media.Video;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	
	public class MediaPlayerBasic extends com.troyworks.controls.tmediaplayer.AMediaPlayer
	{
		//These elements are on stage and help determine which media types this player supports.
		public var mediaDisplayWrapper : MediaDisplayWrapper;
		public var swfDisplay : SWFandImagePlayer;
		public var sndPlayer : SoundPlayer;
		public var autoPlay : Boolean = true;
		//	public var __cname:String = "MPB";
		public function MediaPlayerBasic ()
		{
			super ("onInit", "MPB");
			////this.my_video = video;
			trace ("AAAAAAAAAAAAAAAA MEDIA PLAYER BASIC ");
		}
		public function setMedia (path : String) : void
		{
			trace (" __________MPB.setMedia " + path);
			this.mediaDisplayWrapper.setMedia (path);
			this.swfDisplay.setMedia (path);
			this.sndPlayer.setMedia (path);
		}
		public function move (x : Number, y : Number) : void {
			trace ("__________MPB.move " + x + " y " + y);
			//	this.mediaDisplayWrapper.move (x, y);
			//	this.swfDisplay.move (x, y);
		//	this.x = x	;
		//	this.y = y;
		}
		public function onLoad () : void {
		}
		public function setSize (w : Number, h : Number) : void {
			trace ("__________MPB.setSize " + w + " h " + h);
			this.mediaDisplayWrapper.setSize (w, h);
			this.swfDisplay.setSize (w, h);
		}
		public function dispatch (e:CogEvent):Function
		{
			trace ("media player.dispatch " + e);
			var path : String = "";
			var request:URLRequest = new URLRequest(leaned ();
						if (DirectorUtils.instance.isDirectorShell)
						{
							path =SWFUtil.getParentPath (SWFUtil.getParentPath (p))+ "data\\";
						} else
						{
							path = SWFUtil.getParentPath (SWFUtil.getParentPath (p)) + "data\\";
						}
					//TODO	_global.log.debug(" path  " + path);
						switch (e.sig)
						{
							case SIG_PLAYFLV :
							{
								this.swfDisplay.visible = false;
								this.swfDisplay.dispatchEvent(GOTOANDSTOP_EVT);
								this.mediaDisplayWrapper.setMedia (path + "testvideo0.flv", "FLV");
								this.mediaDisplayWrapper.visible = true;
								this.sndPlayer.dispatchEvent (GOTOANDSTOP_EVT);
								return null;
							}
							case SIG_PLAYMP3 :
							{
								this.swfDisplay.visible = false;
								this.swfDisplay.dispatchEvent (GOTOANDSTOP_EVT);
								this.mediaDisplayWrapper.dispatchEvent (GOTOANDSTOP_EVT);
								this.mediaDisplayWrapper.visible = false;
								this.sndPlayer.setMedia (path + "cello.mp3", "FLV");
								return null;
							}
							case SIG_PLAYIMAGE :
							{
								this.swfDisplay.setMedia(path+ "2125_180x270.jpg");
								this.swfDisplay.visible = true;
								this.mediaDisplayWrapper.dispatchEvent (GOTOANDSTOP_EVT);
								this.mediaDisplayWrapper.visible = false;
								this.sndPlayer.dispatchEvent (GOTOANDSTOP_EVT);
								return null;
							}
							case SIG_PLAYSWF :
							{
								this.swfDisplay.setMedia(path + "SWF Media.swf");
								this.swfDisplay.visible = true;
								this.mediaDisplayWrapper.dispatchEvent (GOTOANDSTOP_EVT);
								this.mediaDisplayWrapper.visible = false;
								this.sndPlayer.dispatchEvent (GOTOANDSTOP_EVT);
								return null;
							}
							default :
							{
								trace ("MediaPlayerBasic.dispatch " + e);
								this.swfDisplay.dispatchEvent (e);
								this.mediaDisplayWrapper.dispatchEvent (e);
								this.sndPlayer.dispatchEvent (e);
								super.dispatchEvent (e);
							}
						}
					}
					/*.................................................................*/
					public function onInit (e : CogEvent) : void {
						trace ("MediaPlayerBasic.onInitXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
						// Create a NetConnection object
						//	this.netConn = new NetConnection ();
						// Create a local streaming connection
						//	this.netConn.connect (null);
						// Create a NetStream object and define an onStatus() function
						//this.netStream = new NetStream (this.netConn);
						//this.netStream = netStream;
						///this.netStream.onStatus = Delegate.create (this, this.onNetStreamStatus);
						// Attach the NetStream video feed to the Video object
						///this.canvas.my_video.attachVideo (netStream);
						// Set the buffer time
						//this.netStream.setBufferTime (5);.
						//this.handleEvent = this.pausedAtBeginningHandler;
						this.Q_INIT (s1_active );
					}
					function s1_active (e : CogEvent) : Function
					{
						this.onFunctionEnter ("s1_active-", e, []);
						switch (e.sig)
						{
							case SIG_ENTRY :
							{
								//	this.swf.ui_preload.visible = false;
								//	this.skin_mc.visible = true;
								//	this.skin_mc.gotoAndPlay ("active");
								return null;
							}
							case SIG_EXIT :
							{
								return null;
							}
							case SIG_INIT :
							{
								//	this.modalDialogC_mc = this.skin_mc.modalDialogC_mc;
								//	this.modalShield_mc = this.skin_mc.modalShield_mc;
								//	this.scanForm (this.background_mc);
								var highBandwidth : Boolean = true;
								//this.my_video.autoSize = false;
								////this.my_video.aspectRatio = false;
								if (highBandwidth)
								{
									//this.my_video.setMedia ("testvideo0.flv", "FLV");
									trace ("highBandwidth= " + highBandwidth);
								} else
								{
									//this.my_video.setMedia ("testvideo0.flv", "FLV");
									trace ("lowbandwidth = " + highBandwidth);
								}
								if (this.autoPlay)
								{
									//	var media = "alexander.flv";
									trace ("******AUTOPLAY****** ");
									// + //this.my_video + " " + //this.my_video.visible );
									// + media);
									//this.netStream.play (media);
									this.tran1_playing);
								} else
								{
									trace ("*****awaiting key stroke*******");
									this.Q_INIT (this.s10_pausedAtBeginning);
								}
								return null;
							}
							case SIG_PLAYFLV :
							{
								this.swfDisplay.visible = false;
								this.mediaDisplayWrapper.visible = true;
								return null;
							}
							case SIG_PLAYMP3 :
							{
								this.swfDisplay.visible = false;
								this.mediaDisplayWrapper.visible = false;
								return null;
							}
							case SIG_PLAYIMAGE :
							{
								this.swfDisplay.visible = true;
								this.mediaDisplayWrapper.visible = false;
								return null;
							}
							case SIG_PLAYSWF :
							{
								this.swfDisplay.visible = true;
								this.mediaDisplayWrapper.visible = false;
								return null;
							}
						}
						return s_root;
					}
					function s10_pausedAtBeginning (e : CogEvent) : Function
					{
						this.onFunctionEnter ("s10_pausedAtBeginning-", e, []);
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
							case PLAY_EVT :
							{
								//this.my_video.play ();
								this.trtrtran11_playing);
								return null;
							}
							//	case SIG_INIT :
							//	{
							//		return new Function();
							//}
						}
						return this.s1_active ;
					}
					function s11_playing (e : CogEvent) : Function
					{
						this.onFunctionEnter ("s11_playing-", e, []);
						switch (e.sig)
						{
							case SIG_ENTRY :
							{
								//this.my_video.play ();
								return null;
							}
							case SIG_EXIT :
							{
								return null;
							}
							case STOP_EVT :
							{
								//this.my_video.pause ();
								this.trantrantranausedInMiddle);
								return null;
							}
							case GOTOANDSTOP_EVT :
							{
								this.tran (tran10trandAtBeginning);
								return null;
							}
							//	case SIG_INIT :
							//	{
							//		return null;
							//	}
						}
						return this.s1_active ;
					}
					function s12_stopped (e : CogEvent) : Function
					{
						this.onFunctionEnter ("s12_stopped-", e, []);
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
							case STOP_EVT :
							{
								//this.my_video.play (0);
								//this.my_video.stop ();
								this.tran (thtran_pautraneginning);
								return null;
							}
							case PLAY_EVT :
							{
								//this.my_video.play ();
								this.tran (thistranlayingtran					return null;
							}
							//	case SIG_INIT :
							//	{
							//		return null;
							//	}
						}
						return this.s1_active ;
					}
					function s13_pausedInMiddle (e : CogEvent) : Function
					{
						this.onFunctionEnter ("s13_pausedInMiddle-", e, []);
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
							case STOP_EVT :
							{
								//this.my_video.play (0);
								//this.my_video.stop ();
								this.tran (this.stransedAtBegtran);
								return null;
							}
							case PLAY_EVT :
							{
								//this.my_video.play ();
								this.tran (this.s11tranng);
					tranurn null;
							}
							//	case SIG_INIT :
							//	{
							//		return new Function();
							//}
						}
						return this.s1_active ;
					}
				});
			navigateToURL(request);
			
			if (DirectorUtils.instance.isDirectorShell)
			{
				path =SWFUtil.getParentPath (SWFUtil.getParentPath (p))+ "data\\";
			} else
			{
				path = SWFUtil.getParentPath (SWFUtil.getParentPath (p)) + "data\\";
			}
			_global.log.debug(" path  " + path);
			switch (e.sig)
			{
				case SIG_PLAYFLV :
				{
					this.swfDisplay.visible = false;
					this.swfDisplay.dispatchEvent(GOTOANDSTOP_EVT);
					this.mediaDisplayWrapper.setMedia (path + "testvideo0.flv", "FLV");
					this.mediaDisplayWrapper.visible = true;
					this.sndPlayer.dispatchEvent (GOTOANDSTOP_EVT);
					return null;
				}
				case SIG_PLAYMP3 :
				{
					this.swfDisplay.visible = false;
					this.swfDisplay.dispatchEvent (GOTOANDSTOP_EVT);
					this.mediaDisplayWrapper.dispatchEvent (GOTOANDSTOP_EVT);
					this.mediaDisplayWrapper.visible = false;
					this.sndPlayer.setMedia (path + "cello.mp3", "FLV");
					return null;
				}
				case SIG_PLAYIMAGE :
				{
					this.swfDisplay.setMedia(path+ "2125_180x270.jpg");
					this.swfDisplay.visible = true;
					this.mediaDisplayWrapper.dispatchEvent (GOTOANDSTOP_EVT);
					this.mediaDisplayWrapper.visible = false;
					this.sndPlayer.dispatchEvent (GOTOANDSTOP_EVT);
					return null;
				}
				case SIG_PLAYSWF :
				{
					this.swfDisplay.setMedia(path + "SWF Media.swf");
					this.swfDisplay.visible = true;
					this.mediaDisplayWrapper.dispatchEvent (GOTOANDSTOP_EVT);
					this.mediaDisplayWrapper.visible = false;
					this.sndPlayer.dispatchEvent (GOTOANDSTOP_EVT);
					return null;
				}
				default :
				{
					trace ("MediaPlayerBasic.dispatch " + e);
					this.swfDisplay.dispatchEvent (e);
					this.mediaDisplayWrapper.dispatchEvent (e);
					this.sndPlayer.dispatchEvent (e);
					super.dispatchEvent (e);
				}
			}
		}
import com.troyworks.core.cogs.CogEvent
;		/*.................................................................*/
		public function onInit (e : CogEvent) : void {
			trace ("MediaPlayerBasic.onInitXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			// Create a NetConnection object
			//	this.netConn = new NetConnection ();
			// Create a local streaming connection
			//	this.netConn.connect (null);
			// Create a NetStream object and define an onStatus() function
			//this.netStream = new NetStream (this.netConn);
			//this.netStream = netStream;
			///this.netStream.onStatus = Delegate.create (this, this.onNetStreamStatus);
			// Attach the NetStream video feed to the Video object
			///this.canvas.my_video.attachVideo (netStream);
			// Set the buffer time
			//this.netStream.setBufferTime (5);.
			//this.handleEvent = this.pausedAtBeginningHandler;
			this.Q_INIT (s1_active );
		}
		function s1_active (e : CogEvent) : Function
		{
			this.onFunctionEnter ("s1_active-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					//	this.swf.ui_preload.visible = false;
					//	this.skin_mc.visible = true;
					//	this.skin_mc.gotoAndPlay ("active");
					return null;
				}
				case SIG_EXIT :
				{
					return null;
				}
				case SIG_INIT :
				{
					//	this.modalDialogC_mc = this.skin_mc.modalDialogC_mc;
					//	this.modalShield_mc = this.skin_mc.modalShield_mc;
					//	this.scanForm (this.background_mc);
					var highBandwidth : Boolean = true;
					//this.my_video.autoSize = false;
					////this.my_video.aspectRatio = false;
					if (highBandwidth)
					{
						//this.my_video.setMedia ("testvideo0.flv", "FLV");
						trace ("highBandwidth= " + highBandwidth);
					} else
					{
						//this.my_video.setMedia ("testvideo0.flv", "FLV");
						trace ("lowbandwidth = " + highBandwidth);
					}
					if (this.autoPlay)
					{
						//	var media = "alexander.flv";
						trace ("******AUTOPLAY****** ");
						// + //this.my_video + " " + //this.my_video.visible );
						// + media);
						//this.netStream.play (media);
						this.tran (s11_playintran			} else
		tran					trace ("*****awaiting key stroke*******");
						this.Q_INIT (this.s10_pausedAtBeginning);
					}
					return null;
				}
				case SIG_PLAYFLV :
				{
					this.swfDisplay.visible = false;
					this.mediaDisplayWrapper.visible = true;
					return null;
				}
				case SIG_PLAYMP3 :
				{
					this.swfDisplay.visible = false;
					this.mediaDisplayWrapper.visible = false;
					return null;
				}
				case SIG_PLAYIMAGE :
				{
					this.swfDisplay.visible = true;
					this.mediaDisplayWrapper.visible = false;
					return null;
				}
				case SIG_PLAYSWF :
				{
					this.swfDisplay.visible = true;
					this.mediaDisplayWrapper.visible = false;
					return null;
				}
			}
			return s_root;
		}
		function s10_pausedAtBeginning (e : CogEvent) : Function
		{
			this.onFunctionEnter ("s10_pausedAtBeginning-", e, []);
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
				case PLAY_EVT :
				{
					//this.my_video.play ();
					this.tran (this.s11_platran
					return null;			}
				//	case SIG_INIT :
				//	{
				//		return new Function();
				//}
			}
			return this.s1_active ;
		}
		function s11_playing (e : CogEvent) : Function
		{
			this.onFunctionEnter ("s11_playing-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					//this.my_video.play ();
					return null;
				}
				case SIG_EXIT :
				{
					return null;
				}
				case STOP_EVT :
				{
					//this.my_video.pause ();
					this.tran (this.s13_pausetrandle);
					return null;
				}
				case GOTOANDSTOP_EVT :
				{
					this.tran (this.s10_pausedAtranning);
					return null;
				}
				//	case SIG_INIT :
				//	{
				//		return null;
				//	}
			}
			return this.s1_active ;
		}
		function s12_stopped (e : CogEvent) : Function
		{
			this.onFunctionEnter ("s12_stopped-", e, []);
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
				case STOP_EVT :
				{
					//this.my_video.play (0);
					//this.my_video.stop ();
					this.tran (this.s10_pausedAtBtranng);
					return nultran	}
				case PLAY_EVT :
				{
					//this.my_video.play ();
					this.tran (this.s11_playing);
	return null;
				}
				/tran SIG_INIT :
				//	{
				//		return null;
				//	}
			}
			return this.s1_active ;
		}
		function s13_pausedInMiddle (e : CogEvent) : Function
		{
			this.onFunctionEnter ("s13_pausedInMiddle-", e, []);
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
				case STOP_EVT :
				{
					//this.my_video.play (0);
					//this.my_video.stop ();
					this.tran (this.s10_pausedAtBegintran
					return null;
				}case PLAY_EVT :
				{
					//this.my_video.play ();
					this.tran (this.s11_playing);
					return null;
				}
				//	case ItranT :
				//	{
				//		return new Function();
				//}
			}
			return this.s1_active ;
		}
	}
	
}