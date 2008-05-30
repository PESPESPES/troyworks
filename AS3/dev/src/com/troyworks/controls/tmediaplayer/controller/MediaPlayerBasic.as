package com.troyworks.mediaplayer.controller { 
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
	import com.troyworks.mediaplayer.ui.MediaDisplayWrapper;
	import util.SWFUtil;
	//TEMP
	import com.troyworks.util.director.DirectorUtils;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.media.Sound;
	import flash.media.Video;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	public class MediaPlayerBasic extends com.troyworks.mediaplayer.AMediaPlayer
	{
		//These elements are on stage and help determine which media types this player supports.
		public var mediaDisplayWrapper : MediaDisplayWrapper;
		public var swfDisplay : SWFandImagePlayer;
		public var sndPlayer : SoundPlayer;
		public var autoPlay : Boolean = true;
		//	public var __cname:String = "MPB";
		public function MediaPlayerBasic ()
		{
			super (onInit, "MPB");
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
			this.x = x	;
			this.y = y;
		}
		public function onLoad () : void {
		}
		public function setSize (w : Number, h : Number) : void {
			trace ("__________MPB.setSize " + w + " h " + h);
			this.mediaDisplayWrapper.setSize (w, h);
			this.swfDisplay.setSize (w, h);
		}
		public function dispatch (e:AEvent):Function
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
						_global.log.debug(" path  " + path);
						switch (e)
						{
							case PLAYFLV_EVT :
							{
								this.swfDisplay.visible = false;
								this.swfDisplay.Q_dispatch(GOTOANDSTOP_EVT);
								this.mediaDisplayWrapper.setMedia (path + "testvideo0.flv", "FLV");
								this.mediaDisplayWrapper.visible = true;
								this.sndPlayer.Q_dispatch (GOTOANDSTOP_EVT);
								return null;
							}
							case PLAYMP3_EVT :
							{
								this.swfDisplay.visible = false;
								this.swfDisplay.Q_dispatch (GOTOANDSTOP_EVT);
								this.mediaDisplayWrapper.Q_dispatch (GOTOANDSTOP_EVT);
								this.mediaDisplayWrapper.visible = false;
								this.sndPlayer.setMedia (path + "cello.mp3", "FLV");
								return null;
							}
							case PLAYIMAGE_EVT :
							{
								this.swfDisplay.setMedia(path+ "2125_180x270.jpg");
								this.swfDisplay.visible = true;
								this.mediaDisplayWrapper.Q_dispatch (GOTOANDSTOP_EVT);
								this.mediaDisplayWrapper.visible = false;
								this.sndPlayer.Q_dispatch (GOTOANDSTOP_EVT);
								return null;
							}
							case PLAYSWF_EVT :
							{
								this.swfDisplay.setMedia(path + "SWF Media.swf");
								this.swfDisplay.visible = true;
								this.mediaDisplayWrapper.Q_dispatch (GOTOANDSTOP_EVT);
								this.mediaDisplayWrapper.visible = false;
								this.sndPlayer.Q_dispatch (GOTOANDSTOP_EVT);
								return null;
							}
							default :
							{
								trace ("MediaPlayerBasic.dispatch " + e);
								this.swfDisplay.Q_dispatch (e);
								this.mediaDisplayWrapper.Q_dispatch (e);
								this.sndPlayer.Q_dispatch (e);
								super.Q_dispatch (e);
							}
						}
					}
					/*.................................................................*/
					public function onInit (e : AEvent) : void {
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
									this.Q_TRAN (s11_playing);
								} else
								{
									trace ("*****awaiting key stroke*******");
									this.Q_INIT (this.s10_pausedAtBeginning);
								}
								return null;
							}
							case PLAYFLV_EVT :
							{
								this.swfDisplay.visible = false;
								this.mediaDisplayWrapper.visible = true;
								return null;
							}
							case PLAYMP3_EVT :
							{
								this.swfDisplay.visible = false;
								this.mediaDisplayWrapper.visible = false;
								return null;
							}
							case PLAYIMAGE_EVT :
							{
								this.swfDisplay.visible = true;
								this.mediaDisplayWrapper.visible = false;
								return null;
							}
							case PLAYSWF_EVT :
							{
								this.swfDisplay.visible = true;
								this.mediaDisplayWrapper.visible = false;
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
								//this.my_video.play ();
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
								//this.my_video.play ();
								return null;
							}
							case EXIT_EVT :
							{
								return null;
							}
							case STOP_EVT :
							{
								//this.my_video.pause ();
								this.Q_TRAN (this.s13_pausedInMiddle);
								return null;
							}
							case GOTOANDSTOP_EVT :
							{
								this.Q_TRAN (this.s10_pausedAtBeginning);
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
								//this.my_video.play (0);
								//this.my_video.stop ();
								this.Q_TRAN (this.s10_pausedAtBeginning);
								return null;
							}
							case PLAY_EVT :
							{
								//this.my_video.play ();
								this.Q_TRAN (this.s11_playing);
								return null;
							}
							//	case INIT_EVT :
							//	{
							//		return null;
							//	}
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
								//this.my_video.play (0);
								//this.my_video.stop ();
								this.Q_TRAN (this.s10_pausedAtBeginning);
								return null;
							}
							case PLAY_EVT :
							{
								//this.my_video.play ();
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
			switch (e)
			{
				case PLAYFLV_EVT :
				{
					this.swfDisplay.visible = false;
					this.swfDisplay.Q_dispatch(GOTOANDSTOP_EVT);
					this.mediaDisplayWrapper.setMedia (path + "testvideo0.flv", "FLV");
					this.mediaDisplayWrapper.visible = true;
					this.sndPlayer.Q_dispatch (GOTOANDSTOP_EVT);
					return null;
				}
				case PLAYMP3_EVT :
				{
					this.swfDisplay.visible = false;
					this.swfDisplay.Q_dispatch (GOTOANDSTOP_EVT);
					this.mediaDisplayWrapper.Q_dispatch (GOTOANDSTOP_EVT);
					this.mediaDisplayWrapper.visible = false;
					this.sndPlayer.setMedia (path + "cello.mp3", "FLV");
					return null;
				}
				case PLAYIMAGE_EVT :
				{
					this.swfDisplay.setMedia(path+ "2125_180x270.jpg");
					this.swfDisplay.visible = true;
					this.mediaDisplayWrapper.Q_dispatch (GOTOANDSTOP_EVT);
					this.mediaDisplayWrapper.visible = false;
					this.sndPlayer.Q_dispatch (GOTOANDSTOP_EVT);
					return null;
				}
				case PLAYSWF_EVT :
				{
					this.swfDisplay.setMedia(path + "SWF Media.swf");
					this.swfDisplay.visible = true;
					this.mediaDisplayWrapper.Q_dispatch (GOTOANDSTOP_EVT);
					this.mediaDisplayWrapper.visible = false;
					this.sndPlayer.Q_dispatch (GOTOANDSTOP_EVT);
					return null;
				}
				default :
				{
					trace ("MediaPlayerBasic.dispatch " + e);
					this.swfDisplay.Q_dispatch (e);
					this.mediaDisplayWrapper.Q_dispatch (e);
					this.sndPlayer.Q_dispatch (e);
					super.Q_dispatch (e);
				}
			}
		}
		/*.................................................................*/
		public function onInit (e : AEvent) : void {
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
						this.Q_TRAN (s11_playing);
					} else
					{
						trace ("*****awaiting key stroke*******");
						this.Q_INIT (this.s10_pausedAtBeginning);
					}
					return null;
				}
				case PLAYFLV_EVT :
				{
					this.swfDisplay.visible = false;
					this.mediaDisplayWrapper.visible = true;
					return null;
				}
				case PLAYMP3_EVT :
				{
					this.swfDisplay.visible = false;
					this.mediaDisplayWrapper.visible = false;
					return null;
				}
				case PLAYIMAGE_EVT :
				{
					this.swfDisplay.visible = true;
					this.mediaDisplayWrapper.visible = false;
					return null;
				}
				case PLAYSWF_EVT :
				{
					this.swfDisplay.visible = true;
					this.mediaDisplayWrapper.visible = false;
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
					//this.my_video.play ();
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
					//this.my_video.play ();
					return null;
				}
				case EXIT_EVT :
				{
					return null;
				}
				case STOP_EVT :
				{
					//this.my_video.pause ();
					this.Q_TRAN (this.s13_pausedInMiddle);
					return null;
				}
				case GOTOANDSTOP_EVT :
				{
					this.Q_TRAN (this.s10_pausedAtBeginning);
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
					//this.my_video.play (0);
					//this.my_video.stop ();
					this.Q_TRAN (this.s10_pausedAtBeginning);
					return null;
				}
				case PLAY_EVT :
				{
					//this.my_video.play ();
					this.Q_TRAN (this.s11_playing);
					return null;
				}
				//	case INIT_EVT :
				//	{
				//		return null;
				//	}
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
					//this.my_video.play (0);
					//this.my_video.stop ();
					this.Q_TRAN (this.s10_pausedAtBeginning);
					return null;
				}
				case PLAY_EVT :
				{
					//this.my_video.play ();
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