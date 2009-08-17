package com.troyworks.mediaplayer.controller { 
	 //import util.SWFUtilBasic;
	//import util.BasicLoader;
	
	import com.troyworks.core.cogs.CogEvent;	
	import com.troyworks.hsmf.CogEventntntnt;
	import com.troyworks.hsmf.Signal;
	import com.troyworks.hsmf.Hsmf;
	import com.troyworks.events.TProxy;
	import flash.media.Sound;
	public class SoundPlayer extends com.troyworks.mediaplayer.AMediaPlayer
	{
		public var snd : Sound;
		public var secondOffset : Number = 0;
		public var autoPlay : Boolean = true;
		//	public var __cname:String = "MPB";
		public function SoundPlayer ()
		{
			super (s0_init, "SND_P");
			trace ("AAAAAAAAAAAAAAAA SoundPlayer ");
			this.hAlign = false;
		}
		public function setMedia (path : String) : void
		{
			trace ("SoundPlayer.loadMedia " + path);
			var isStreaming : Boolean = false;
			this.snd = new Sound (this);
			this.snd.onSoundComplete = TProxy.create (this, this.onSoundComplete);
			this.snd.onLoad = TProxy.create (this, this.soundOnLoad);
			this.snd.onID3 = TProxy.create (this, this.soundOnID3);
			this.snd.loadSound (path, isStreaming);
			//this.snd.start (0);
			this.secondOffset = 0;
		}
		public function onLoad () : void {
			super.onLoad ();
			this.init ();
			trace ("BBBBBBBBBBBBBBBBBBBBB SoundPlayer.onLoad");
		}
		/////////////////////////TProxyd Function from the Sound Calls //////////////////
		function onSoundComplete () : void {
			trace ("XXXXXXXXXXXXXSound Completed PlayingXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
		}
		function soundOnLoad (success:Boolean) : void{
			trace ("XXXXXXXXXXXXXSound Loaded " + success + " XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			this.tran (s1_active);
		}
		function soundOnID3 () : void{
			trace ("XXXXXXXXXXXXXSound onID3XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
		}
		/*.................................................................*/
		function s0_init(evt:CogEvent) : void {
			trace ("SoundPlayer.onInitXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			this.Q_INIT (s1_active );
		}
		function s1_active(e:CogEvent) : Function
		{
			this.onFunctionEnter ("s1_active-", e, []);
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
				case SIG_INIT :
				{
					if (this.autoPlay)
					{
						trace ("******AUTOPLAY****** ");
						this.tran (s11_playing);
					} else
					{
						trace ("*****awaiting key stroke*******");
						this.Q_INIT (this.s10_pausedAtBeginning);
					}
					return null;
				}
			}
			return s_root;
		}
		function s10_pause(e:CogEvent) : Function
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
					this.tran (this.s11_playing);
					return null;
				}
				case GOTOANDSTOP_EVT:
				{
					return null;
				}
	
	
			}
			return this.s1_active ;
		}
		function s11_playing(e: CogEvent) : Function
		{
			this.onFunctionEnter ("s11_playing-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					this.snd.start (this.secondOffset);
					return null;
				}
				case SIG_EXIT :
				{
					return null;
				}
				case GOTOANDSTOP_EVT :
				{
					this.secondOffset = 0;
					this.snd.stop ();
					this.tran (this.s10_pausedAtBeginning);
					return null;
				}
				case STOP_EVT :
				{
					this.secondOffset = this.snd.position / 1000;
					this.snd.stop ();
					this.tran (this.s13_pausedInMiddle);
					return null;
				}
				//	case SIG_INIT :
				//	{
				//		return null;
				//	}
	
			}
			return this.s1_active ;
		function s12_stopped(e : CogEvent) : Function
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
					this.secondOffset = 0;
					this.snd.stop ();
					this.tran (this.s10_pausedAtBeginning);
					return null;
				}
				case PLAY_EVT :
				{
					this.snd.start (this.secondOffset);
					this.tran (this.s11_playing);
					return null;
				}
				case GOTOANDSTOP_EVT :
				{
					this.secondOffset = 0;
					this.snd.stop ();
					this.tran (this.s10_pausedAtBeginning);
					return null;
				}
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
					this.secondOffset = 0;
					this.snd.stop ();
					this.tran (this.s10_pausedAtBeginning);
					return null;
				}
				case PLAY_EVT :
				{
					this.snd.start (this.secondOffset);
					this.tran (this.s11_playing);
					return null;
				}
				case GOTOANDSTOP_EVT :
				{
					this.secondOffset = 0;
					this.snd.stop ();
					this.tran (this.s10_pausedAtBeginning);
					return null;
				}
			}
			return this.s1_active ;
		}
	}
	
}