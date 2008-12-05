package com.troyworks.mediaplayer.controller { 
	 //import util.SWFUtilBasic;
	//import util.BasicLoader;
	import com.troyworks.hsmf.CogEventntntnt;
	import com.troyworks.hsmf.Hsmf;
	import com.troyworks.events.TProxy;
	///////////////////////////
	// the goal of this class is to serve as a better wrapper/proxy for streams and the correspecing
	// user interface. There are a series of events that the Netconnection and the NetStream generate
	// that indicate the stream is in some state that is frequently non-intuitive.
	//
	// This player is designed to play either streaming mp3 or FLV's. Coming off of FlashCom media server
	// or Red5 media server.
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.display.MovieClip;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.setInterval;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.media.Video;
	public class StreamPlayerBackup extends com.troyworks.mediaplayer.ASynchronizedMediaPlayer
	{
			public static var NC_CONNECT_SUCCESS_CogEventvenCogEventgEventgEventgEvent.getNext("NetConnection.Connect.Success_SIG");
		public static var NC_CONCogEventCogECogEventgECogEventgECogEvent  CogEvent.getNext( "NetConnection.Connect.Failed_SIG");
		public static varCogEventAY_CogEvententOTFCogEvententT :CogEventent = CogEvent.getNext("NetStream.Play.StreamNotFound_SIG");CogEventlic CogEventgEvent NS_CogEventgEventL_EVCogEventgEvent =  CogEvent.getNext("NetStream.Buffer.CogEventIG")CogEventblCogEventtic CogEvent_BCogEventEMPTCogEvent: CogEvent =  CogEvent.getNext("NetStrCogEventfferCogEvent_SIG")CogEventblicCogEventc var CogEventFER_CogEventEVT : CogEvent =  CogEvent.getCogEventNetSCogEventBuffer.FluCogEvent");
CogEventic static CogEvent_PAUCogEventIFY_EVT : CogEvent =CogEventventCogEventxt("NetStream.CogEventNotiCogEvent");
		public sCogEventvar CogEventY_START_EVCogEventgEveCogEventCogEvent.getNext("CogEventeam.CogEventtart_SIG");
		publCogEventtic CogEvent_CogEventESECogEvent: CogEvent =  CogEvent.CogEventt("CogEventeam.Play.Reset_SIG");
	CogEventc sCogEvenCogEventS_PLCogEventP_EVT : CogEvent = CogEvenCogEventext(CogEventream.Play.Stop_SIG");
		puCogEventtatiCogEventCogEventNECCogEventCTED_EVT : CogEvent =  CogEventCogEventxt(CogEventnnection.Connect.Rejected_SIG")CogEveCogEventogEvCogEventvar NC_CONNECT_CLOSED_EVT : CogEveCogEventogEvCogEventtNext("NetConnection.Connect.CloseCogEvent);
	CogEventc static var NS_SEEK_NOTIFY_EVT : CogEvent =  CogEvent.getNext("NetStream.Seek.Notify_SIG");
		public var nc : NetConnection;
		public var ns : NetStream;
		public var autoPlay : Boolean = false;
		public var autoRewind : Boolean = false;
		public var soundControl : Sound;
		public var volume : Number = 100;
		public var mediaPath : String = "unknown";
		public var ncon : String = "";
		public var streamName : String = "";
		public var clipDuration : Number = 0;
		protected var playIntV : Number = - 1;
		protected var checkTime : Number = - 1;
		public var hasConnection : Boolean = false;
		public var recievedMetaData : Boolean = false;
		//
		public var connect_mc : MovieClip;
		public var stream_mc : MovieClip;
		public var error_mc : MovieClip;
		public var loadingP_mc : MovieClip;
		public var playingP_mc : MovieClip;
		public var remdownloadtime_mc : MovieClip;
		public var downloadtime_mc : MovieClip;
		public var duration_mc : MovieClip;
		public var minsafebufferlength_mc : MovieClip;
		public var buffersize_mc : MovieClip;
		public var inbufferlength_mc : MovieClip;
		public var playstate_mc : MovieClip;
		public var name_txt : TextField;
		public var video : Video;
		public var dvideo : Video;
		//where to parse the connection from the stream name;
		public var connectionStreamSplit : String;
		//	public var __cname:String = "MPB";
		protected var ns_pause : Boolean = false;
		protected var seekTime : Number = - 1;
		/*
		*  Area dealing with buffer /preload optimization
		*/
		public var startPreloadAtClockTime : Number = - 1;
		public var minimumBufferLengthToNotRebuffer : Number = - 1;
		// the passed in bandwidth detected from the player.
		public var bandwidth : Number = 100;
		// calculated buffer
		public var cbufferTime : Number = 2;
		protected var bufferBandwidth : Number = 0;
		protected var startBufferLength : Number = 0;
		protected var lastBufferLength : Number = 0;
		protected var startBufferFillTime : Number = 0;
		protected var endBufferFilledTime : Number = 0;
		protected var calculatedBufferFillRate : Number = 0;
		public var streamBitRatePerSec : Number = 0;
		public var percentBufferFilled : Number = 0;
		public static var connections : Object;
		public static var listeners : Array;
		public function StreamPlayerBackup ()
		{
			super (s0_awaitingUILoad,"SRM_P");
			trace ("AAAAAAAAAAAAAAAA StreamPlayer ");
			this.hAlign = false;
			if (StreamPlayerBackup.connections == null)
			{
				//
				//per http://www.adobe.com/cfusion/knowledgebase/index.cfm?id=tn_16441
				// there should only be one NetConnection per movie (at least if connecting to the same server)
				StreamPlayerBackup.connections = new Object ();
				StreamPlayerBackup.listeners = new Array ();
			}
		}
		////////////////
		// this is called when an  movie clip that is  Object.registerClass  with,
		// is attached to stage ,  There are many
		// debugging user interface elements when this performs stop/visible on to
		//
		public function onLoad () : void {
			//initialize the movie clip and related components
			super.onLoad ();
			//initialize the statemachine logic.
			this.init ();
			trace ("BBBBBBBBBBBBBBBBBBBBB StreamPlayer.onLoad " + this.mediaPath + " duration " + this.clipDuration + " " + this.trk);
			this.tran(this.s1_active);
		}
		////////////////////////////////////////////////////////////
		//this sets the path to the media on the streaming server,
		// and establishes a connection to the media, as well as
		//setup the netconnection and netstream. but doesn't yet start the
		// playback for that see startMedia
		// this may be called before  the setBandwidth as a connection test
		//or after
		function connectToServer (path : String) : void
		{
			path = (path == null) ? this.mediaPath : path;
			//trace ("StreamPlayer.setMedia " + path + " " + this.volume);
			public var vA : Boolean = path.toLowerCase ().indexOf (".mp3") > - 1;
			public var vB : Boolean = path.toLowerCase ().indexOf (".flv") > - 1;
			if (path != "SILENCE" && (vA || vB))
			{
				var c = path.lastIndexOf("/");
				this.hsmName = path.substring(c, path.length) ;
				this.error_mc.visible = false;
				var k = this.connectionStreamSplit;
				var a = path.indexOf (k) + k.length - 1;
				var con = path.substring (0, a);
				var b = path.indexOf (".mp3");
				var media = "";
				if (b > - 1)
				{
					media = path.substring (a + 1, b);
					this.streamName = "mp3:" + media;
				} else
				{
					b = path.indexOf (".flv");
					media = path.substring (a + 1, b);
					this.streamName = media;
				}
				trace ("Connection " + con + " StreamName: " + this.streamName + " mediaPath " + this.mediaPath );
				
				var isStreaming : Boolean = false;
				//since there's only supposed to be one NetConnection retrieve it or create it
				if (StreamPlayerBackup.connections [con] == null)
				{
					trace (" CREATING NEW CONNECTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% " );
					var nc = new NetConnection ();
					nc.onStatus = TProxy.create (StreamPlayerBackup, StreamPlayerBackup.onNCStatusDispatch);
					StreamPlayerBackup.connections [con] = nc;
					StreamPlayerBackup.listeners.push (this);
					this.nc = nc;
					// establish a connection if necessary
					//////////////////////////////////////////
					// per the documentation this connection barely means anything, you have
					// to really ping the connection with a ns.play to get the correct connection
					// deterministic.
					if ( ! this.nc.isConnected)
					{
						var stat = this.nc.connect (con);
						trace ("NetCon0nect status " + stat + "___________________________");
						if ( ! stat)
						{
							//but if it fails (say due to security restrictions toss up an error anyway)
							this.tran (this.s14_NCerror);
						} else
						{
							//this.hasConnection = true;
							//	this.dispatch (NC_CONNECT_SUCCESS_EVT);
						}
					}
				} else
				{
					trace (" REUSING EXISTING CONNECTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% " );
					this.nc = StreamPlayerBackup.connections [con];
					StreamPlayerBackup.listeners.push (this);
				}
				this.connect_mc.visible = true;
				this.connect_mc.gotoAndPlay ("yellow");
				//	this.connectToMediaStream()
				
			} else
			{
				this.error_mc.visible = true;
			}
		}
		public function connectToMediaStream () : void
		{
			trace ("CONNECTING TO MEDIA STREAM");
			//////--setup the stream object
			this.ns = new NetStream (this.nc);
			this.ns.onStatus = TProxy.create (this, this.onNSStatus);
		//	this.ns.onPlayStatus = TProxy.create (this, this.onNSPlayStatus);
			this.ns.onMetaData = TProxy.create (this, this.onNSMetaData);
			this.ns.setBufferTime (this.clipDuration);
			trace (" 0000000000000000000000 STE BUFFER TIME " + this.clipDuration + " " + this.ns.bufferTime);
			//	this.ns.play (this.streamName);
			//this.setBandwidthAndBufferTime (this.bandwidth, true);
			//this.ns.setBufferTime (this.cbufferTime);
			//this.ns.onCuePoint = TProxy.create (this, this.onNSCuePoint);
			//	this.nc.call ("getLength",
			//	{
			//		onResult : TProxy.create (this, setDuration)
			//	}, this.streamName );
			this.attachAudio (this.ns);
			this.soundControl = new Sound (this);
			this.soundControl.setVolume (this.volume);
			//this.playIntV = setInterval (this, "updateNSStats", 1000 / 48);
			// http://livedocs.macromedia.com/flashcom/mx2004/main/wwhelp/wwhimpl/common/html/wwhelp.htm?context=Flash_Communication_Server&file=00000388.html
			//trace (this.ns + "calling NS.play()$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
			//we are going to call play here, to establish the filename with the NetStream and also
			// get a real connection determinisitc, sadly we can't actually preload the buffer this way
			// as that requires hitting play with the intent to show something.
			this.ns.play (this.streamName, 0);
			//this is the debug video player, not the visible one (typically), useful for seeing what's going on.
			this.video.attachVideo (this.ns);
			//, 0); // the parameter 0 will tell the server to play a recorded stream
			// , 0, 6, true
			//trace ("calling NS.seek ()$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
			//this.ns.seek (0);
			//trace (this.ns + "calling NS.pause()$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
			this.seekTime = 0;
			this.duration_mc.width = this.clipDuration * 10;
			//pause the stream as we didn't really want it to start playing just establish a real connection.
			//	this.nsPauseStream ();
			//this.nsResumePlay();
			//this.tran (this.s1a_preloading);
			//}
			
		}
		public function startPreload () : void
		{
			trace ("STARTING PRELOAD XXXXXXXXXXXXXXXXXXXXXXXX " + this.ns);
			//this.ns.play(this.streamName);
			//this.connectToServer();
			this.connectToMediaStream ();
			this.ns.receiveAudio();
			this.ns.receiveVideo();
			//this.nsResumePlay(true);
			this.tran (this.s1a_preloading);
		}
		function startBandwidthTestFromBuffer () : void
		{
			this.startBufferLength = this.ns.bufferLength;
			this.startBufferFillTime = - 1;
			// note set to -1 as reset after the buffer is detected to be filling.
			trace (" >> this.startBufferLength " + this.startBufferLength + " this.startBufferFillTime " + this.startBufferFillTime);
		}
		/*
		* This is used to calculate the effective bandwidth available to this clip based on how fast the buffer is filling
		* note this is different than the FCS detected bandwidth as there many be other clips competeing for the same bandwidth
		*/
		function calcBandwidthFromBufferFillRate () : Number
		{
			this.endBufferFilledTime = getTimer ();
			public var dur = (this.endBufferFilledTime - this.startBufferFillTime) / 1000;
			public var changeInBuffer = (this.ns.bufferLength - this.startBufferLength );
			public var changeInBuffer2 = (this.ns.bufferLength - this.lastBufferLength);
			this.lastBufferLength = this.ns.bufferLength;
			if (changeInBuffer > 0)
			{
				if (changeInBuffer2 > 0)
				{
					if (this.startBufferFillTime == - 1)
					{
						trace ("starting buffer bandwith check");
						this.startBufferLength = this.ns.bufferLength;
						this.startBufferFillTime = getTimer ();
					}
					var bnd:Number = ((this.ns.bufferLength - this.startBufferLength ) * this.streamBitRatePerSec) / dur;
					this.bufferBandwidth = bnd;
					trace (this.hsmName + ".calcBandwidth = "  + Math.round (bnd) + " bits/sec bufferLenInSec: " + this.ns.bufferLength );
					return bnd;
				} else
				{
					return this.bufferBandwidth;
				}
			} else
			{
				trace ("buffer not filling " + dur + " " + changeInBuffer);
				return 0;
			}
		}
		/*
		* This is used to calculate the max download left time left, if we opted to download the whole thing and not stream anything.
		*/
		function calcRemainingDownloadTime (bandwidth : Number) : Number
		{
			if (bandwidth > 0)
			{
				//trace ("this.clipSize " + this.clipSize + " duration " + this.clipDuration + " currentPos " + this.ns.time + " availableBandwidth " + this.bandwidth + " streamBitRatePerSec " + streamBitRatePerSec);
				var playheadAtTimeInSec : Number = ((isNaN (this.ns.time)) ?0 : this.ns.time);
				//	trace (" playheadAtTimeInSec " + playheadAtTimeInSec + " ns.time " + this.ns.time);
				var remainingPlayTimeInSec : Number = this.clipDuration - playheadAtTimeInSec;
				var bufferedLen : Number = (this.ns == null) ?0 : this.ns.bufferLength;
				var remainingBytes : Number = ((remainingPlayTimeInSec - bufferedLen) * this.streamBitRatePerSec);
				trace ("remainingPlayTimeInSec " + Math.round (remainingPlayTimeInSec) + " remainingBytes " + Math.round (remainingBytes));
				var ideal_download_time : Number = Math.round (remainingBytes / (bandwidth ));
				this.downloadtime_mc.width = ideal_download_time * 10;
				this.downloadtime_mc.visible = true;
				trace ("at " + bandwidth + " estimated Ideal download time " + ideal_download_time);
				return ideal_download_time;
			} else
			{
				return Number.POSITIVE_INFINITY;
			}
		}
		function calcPreloadTime(bandwidth:Number):Number{
				// example 126282 on wireless/DSL
		// 1434 on cellphone.
		//5120 on NetLimiter
		 //50K .
		 //10K      .
		 //0K                .
		//---- 1..10...20...30...40
		        if(bandwidth > 50000){
					return 1;
				}  if(bandwidth > 20000){
					return 3;
				}else if(bandwidth> 12000){
					return 5;
				}else if(bandwidth >10000){
					return 12;
				}else if (bandwidth > 5000){
					return 30;
				} else {
					return 40;
				}
		}
		/*
		* This is used to calculate the first buffer time to play the clip as soon as possible
		* without rebuffering (provided that the network connection is stable, as if the network connection
		* fluctuates down, it will still run into issues)
		*
		* this is called usually after the buffer has already
		* started filling a bit (getting some more reaslisitic bandwidth numbers)
		* but hasn't started taking from the buffer to play.
		*
		* safety:Number is the a factor greater than 1 typically one wants the bufferlenght to be expanded by
		* (e.g. 1.1 for 10% above the min buffer that this calculates to play without prebuffering).
		*/
		function calcFirstBufferTime (bandwidth : Number, safety : Number) : Number
		{
			//this will always be a postiive value given it's impossible to have more in the buffer than we are playing
			public var res : Number = 2;
			public var whatsLeftToDownload : Number = Math.round (this.clipSize - (this.ns.bufferLength * this.streamBitRatePerSec));
			if (whatsLeftToDownload > 0)
			{
				var playheadAtTimeInSec : Number = ((isNaN (this.ns.time)) ?0 : this.ns.time);
				var remainingPlayTimeInSec : Number = this.clipDuration - playheadAtTimeInSec;
				if (bandwidth == 0)
				{
					//at first set it to not stream anything (bufferLength = clipDuration)
					trace ("calcFirstBufferTime NO STREAM");
					res = this.clipDuration;
							this.minsafebufferlength_mc.x = this.inbufferlength_mc.x + (res * 10);
			this.minsafebufferlength_mc.visible = true;
					//this.ns.setBufferTime (this.clipDuration);
				} else
				{
					var thatWhichWeCanDownloadWhilePlaying : Number = Math.round (remainingPlayTimeInSec * bandwidth);
				//	trace (this.__cname + " bandwidth " + Math.round (bandwidth) + " thatWhichWeCanDownloadWhilePlaying " + thatWhichWeCanDownloadWhilePlaying );
					var thatToPreload : Number = Math.round (whatsLeftToDownload - (thatWhichWeCanDownloadWhilePlaying ));
					if (thatToPreload > 0)
					{
						trace ("  thatToPreload " + thatToPreload + " whatsLeftToDownload " + whatsLeftToDownload );
						//
						var secondsToDownloadPreload = thatToPreload / bandwidth;
						trace ("  secondsToDownload " + secondsToDownloadPreload);
						this.remdownloadtime_mc.width = secondsToDownloadPreload * 10;
						var minSafeBuffer = (thatToPreload * safety)/this.streamBitRatePerSec;
						var totalBuffer = this.ns.bufferLength + minSafeBuffer;
						//return totalBuffer;
						trace ("  calcFirstBufferTime LOW SPEED " + totalBuffer);
						res = Math.min (totalBuffer, this.clipDuration);
								this.minsafebufferlength_mc.x = this.inbufferlength_mc.x + (minSafeBuffer * 10);
			this.minsafebufferlength_mc.visible = true;
						//this.ns.setBufferTime ();
					} else
					{
						//shorten the buffer to start playing ASAP (so whatever is in the buffer)
						trace ("  calcFirstBufferTime HIGH SPEED to NOW");
						//this.ns.setBufferTime ();
						//this.ns.receiveAudio (false);
						res = Math.max (2, this.ns.bufferLength);
								this.minsafebufferlength_mc.x = this.inbufferlength_mc.x + (res * 10);
			this.minsafebufferlength_mc.visible = true;
					}
				}
			}
	
			return res;
		}
		//this adjusts the buffer based on the bandwidth
		// note this may be called when the stream is playing
		function setBandwidthAndBufferTime (bandwidth : Number, bypass : Boolean) : void
		{
			trace ("\r\r\rXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace ("setBandwidthAndBufferTime " + this.mediaPath + " " + bandwidth);
			/////////////////////////////////////////////////////////////////
			// ALL CALCULATIONS DONE IN SECONDS!
			/////////////////////////////////////////////////////////////////
			this.bandwidth = bandwidth;
			public var myFudgeFactor : Number = 5;
			public var bufferTime = 2;
			//if (!isStopped) {
			if (this.clipSize == 0 || this.bandwidth == 0)
			{
				//set to default cbuffer
				var actual_download_time = this.calcRemainingDownloadTime (this.bandwidth);
				this.cbufferTime = Math.max (actual_download_time, bufferTime) / 10;
			} else
			{
			}
			//	if (hardDebug == true) {
			this.cbufferTime = 2;
			trace (this.mediaPath + " myBufferTime: " + this.cbufferTime);
			//		}
			//this.ns.setBufferTime (this.cbufferTime);
			//in seconds
			//this.trk.A.position -= this.cbufferTime;
			trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace ("setBandwidthAndBufferTime " + this.mediaPath + " TRACK " + this.trk + " " + this.trk.A.position);
		}
		/*
		* this is called during the various states to update the information for the playhead, loader and buffer based on
		* the NetStream playhead position and buffer.
		*/
		function updateNSStats (firstRun : Boolean) : void
		{
			if (this.ns != null)
			{
				//	trace ("updateNSStats " + this.ns.bytesLoaded + " " + this.ns.bytesTotal );
				var l = this.ns.bytesLoaded / this.ns.bytesTotal * 100;
				//	trace ("ns loaded " + l);
				var s = this.soundControl.getBytesLoaded () / this.soundControl.getBytesTotal () * 100;
				//	trace ("snd loaded " + s);
				var p = this.ns.time / this.clipDuration * 100;
				//trace ("played " + this.ns.time + " / " + this.clipDuration + " " + p + "%");
				this.playingP_mc.width = this.ns.time * 10;
				var b = this.ns.bufferLength / this.ns.bufferTime;
				this.percentBufferFilled = b * 100;
				if (0 < b && firstRun)
				{
					if (false && .8 < b && b < 1)
					{
						trace ("nearing fill of buffer " + b);
						//since we are within close distance to filling the buffer and the start of playing
						//expand buffer to stabilize the clip over the duration of playing
						var bnd = this.calcBandwidthFromBufferFillRate ();
						this.calcFirstBufferTime (bnd);
						//this.setBandwidthAndBufferTime (bnd, true);
					} else if (b >= 1)
					{
						var bnd = this.calcBandwidthFromBufferFillRate ();
						var t = this.calcFirstBufferTime (bnd, 1.1);
						var dur = (this.endBufferFilledTime - this.startBufferFillTime) / 1000;
						var d = this.clipSize / dur;
						trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  " + d);
						trace (this.ns.bufferTime + " buffering Full " + b + " " + bnd + " bits/sec estimate " + t + " filled in: " + dur);
					} else
					{
						//still filling the buffer, adjust for soonest possible playing.
						var bnd = this.calcBandwidthFromBufferFillRate ();
						this.calcFirstBufferTime (bnd, 1);
						this.calcRemainingDownloadTime (bnd);
						trace ("buffering " + Math.round ((b * 100)) + "%  of " + this.ns.bufferTime + " sec");
						//					var tt = this.clipSize / bnd;
						//			trace ("buffering " + b + " " + bnd + " bits/sec estimate " + t + " estimated total download time " + tt);
						//				var bufT = Math.min(t, this.clipDuration);
						//				this.ns.setBufferTime(bufT);
						
					}
				}
				//the requested minimum time in buffer in seconds
				this.buffersize_mc.width = this.ns.bufferTime * 10;
				//length of stream in buffer in seconds
				this.inbufferlength_mc.width = this.ns.bufferLength * 10;
			}
		}
		//To Be Called when the media is desired to start playing, note that it will buffer prior to actually
		// begining visible playback.
		function setVideo (vid : Video) : void
		{
			if (vid == null)
			{
				this.video = this.dvideo;
			} else
			{
				this.video = vid;
			}
			this.video.attachVideo (this.ns);
			this.video.smoothing = true;
		}
		//These are are all utility methods when interfacing with the netstream object
		// as once set we can't tell what we asked for, so when
		// we are called back to take the appropriate action
		function nsPauseStream () : void
		{
			trace (this.mediaPath + ".nsPauseStream");
			this.ns_pause = true;
			this.ns.pause (this.ns_pause);
		}
		function nsResumePlay (bySeek:Boolean) : void
		{
			trace (this.mediaPath + ".nsResumePlay");
			this.ns_pause = false;
			if (bySeek)
			{
				this.ns.play (this.streamName, this.seekTime + 1);
			} else
			{
				this.ns.pause (this.ns_pause);
			}
		}
		function nsIsPaused () : Boolean
		{
			trace (this.mediaPath + ".nsIsPaused");
			return this.ns_pause == true;
		}
		function nsIsPlaying () : Boolean
		{
			trace (this.mediaPath + ".nsIsPlaying");
			return this.ns_pause == false;
		}
		function nsSeek (time : Number) : void
		{
			trace (this.mediaPath + ".nsSeek");
			this.seekTime = time;
			this.ns.pause (true);
			this.ns.seek (this.seekTime);
		}
		//display the duration of the MP3 file (seconds) this relies upon the presence of a
		// main.asc file on the server to return th duration.
		function setDuration (nLength : Number) : void
		{
			trace ("cccccccccccccccccccccccccccccccccccccccccccccc");
			trace ("cccccccccccccccccccccccccccccccccccccccccccccc");
			trace ("cccccccccccccccccccccccccccccccccccccccccccccc");
			trace ("ccccccccccccc " + this.mediaPath + " setclipDurationclipDuration " + nLength + " ccccccccccccccccccccccccccccccccc");
			trace ("cccccccccccccccccccccccccccccccccccccccccccccc");
			trace ("cccccccccccccccccccccccccccccccccccccccccccccc");
			this.clipDuration = nLength;
		}
		/////////////////////////TProxyd Function //////////////////
		// A centralized NetConnection status dispatcher as multiple
		// stream player reuse the same NetConnection object with
		// different NetStreams.
		public static function onNCStatusDispatch (oInfo : Object) : void
		{
			trace ("CCCC> ncStatic Status  > " + oInfo.code);
			trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			for (public var i in StreamPlayerBackup.listeners)
			{
				StreamPlayerBackup.listeners [i].onNCStatus (oInfo);
			}
		}
		public function onNSPlayStatus (infoObject : Object) : void
		{
			trace ("NetStream.onPlayStatus called: (" + getTimer () + " ms)");
			trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			for (public var prop in infoObject)
			{
				trace ("\t" + prop + ":\t" + infoObject [prop]);
			}
			trace ("");
		}
		//
		public function onNCStatus (oInfo : Object) : void
		{
			trace ("CCCC> ncStatus " + this.streamName + "  > " + oInfo.code);
			trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			switch (oInfo.code)
			{
				case "NetConnection.Connect.Success" :
				this.connect_mc.gotoAndStop ("green");
				this.dispatchEvent (NC_CONNECT_SUCCESS_EVT);
				break;
				case "NetConnection.Connect.Failed" :
				this.connect_mc.gotoAndStop ("red");
				this.dispatchEvent (NC_CONNECT_FAILED_EVT);
				break;
				case "NetConnection.Connect.Closed" :
				this.connect_mc.gotoAndStop ("red");
				this.dispatchEvent (NC_CONNECT_CLOSED_EVT);
				break;
				case "NetConnection.Connect.Rejected" :
				this.connect_mc.gotoAndStop ("red");
				this.dispatchEvent (NC_CONNECT_REJECTED_EVT);
				break;
			}
		}
		// These are a collection of events from teh NetStream Object
		//http://livedocs.macromedia.com/fms/2/docs/wwhelp/wwhimpl/common/html/wwhelp.htm?context=LiveDocs_Parts&file=00000628.html
		function onNSStatus (oInfo : Object) : void
		{
			trace ("SSS> nsStatus" + this.streamName + " status > " + oInfo.code);
			trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			switch (oInfo.code)
			{
				case "NetStream.Play.Failed" :
				case "NetStream.Play.StreamNotFound" :
				//The FLV passed to the play() method can't be found.
				this.stream_mc.gotoAndStop ("red");
				this.dispatchEvent (NS_PLAY_STREAMNOTFOUND_EVT);
				break;
				case "NetStream.Buffer.Full" :
				{
					this.dispatchEvent (NS_BUFFER_FULL_EVT);
				}
				break;
				case "NetStream.Buffer.Empty" :
				{
					//Data is not being received quickly enough to fill the buffer. Data flow will be interrupted until the buffer refills, at which time a NetStream.Buffer.Full message will be sent and the stream will begin playing again.
					//				trace (" narration/music finished");
					//	_root.onEnterFrame = fadeVolume;
					this.stream_mc.gotoAndStop ("yellow");
					this.startBandwidthTestFromBuffer ();
					this.dispatchEvent (NS_BUFFER_EMPTY_EVT);
				}
				break;
				case "NetStream.Buffer.Flush" :
				this.stream_mc.gotoAndStop ("gray");
				//Data has finished streaming, and the remaining buffer will be emptied.
				this.dispatchEvent (NS_BUFFER_FLUSH_EVT);
				break;
				case "NetStream.Pause.Notify" :
				//"The seek operation is complete."
				this.dispatchEvent (NS_PAUSE_NOTIFY_EVT);
				break;
				case "NetStream.Play.Start" :
				{
					//Playback/BUffering has started.
					this.startBandwidthTestFromBuffer ();
					this.dispatchEvent (NS_PLAY_START_EVT);
				}
				break;
				case "NetStream.Play.Reset" :
				this.dispatchEvent (NS_PLAY_RESET_EVT);
				break;
				case "NetStream.Play.Stop" :
				//Playback has stopped.
				this.dispatchEvent (NS_PLAY_STOP_EVT);
				break;
				case "NetStream.Seek.Notify" :
				this.dispatchEvent (NS_SEEK_NOTIFY_EVT);
				break;
				case " NetStream.Unpause.Notify" :
				default :
				trace ("no local event");
				break;
			}
		}
		function onNSMetaData (oInfo : Object) : void
		{
			trace ("> ns " + this.streamName + ".onNSMetaData > " + util.Trace.me (oInfo));
			trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			this.endBufferFilledTime = getTimer ();
			public var dur = (this.endBufferFilledTime - this.startBufferFillTime) / 1000;
			public var bnd = ((this.ns.bufferLength - this.startBufferLength ) * this.streamBitRatePerSec) / dur;
			trace ("Filled buffer in " + dur + " sec " + bnd + " bits/sec bufferLenInSec: " + this.ns.bufferLength );
			//The buffer is full and the stream will begin playing.
			//this.nsPauseStream();
			//this.ns.seek(this.ns.time);
			this.recievedMetaData = true;
			if (this.ns.bufferTime < 3)
			{
				//this.ns.setBufferTime (15);
				
			}
		}
		function onNSCuePoint (oInfo : Object) : void
		{
			trace ("> nc " + this.streamName + "cuePoint > " + util.Trace.me (oInfo));
			trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
		}
		function fadeVolume () : void
		{
			public var vol = this.soundControl.getVolume ();
			trace ("fadeVolume " + vol);
			if (vol <= 0)
			{
				//Finished Fading out.
				//			delete (this.onEnterFrame);
				this.nsPauseStream ();
			} else
	CogEvent		this.soundControl.setVolume (vol - 4);
			}
		CogEvent................................................CogEvent...........*/
		function s0_awaitingUILoad (e : CogEvent) : Function
		{
			this.onFunctionEnter ("s0_awaitingUILoad-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				return null;
				case SIG_EXIT :
				{
					this.streamBitRatePerSec = this.clipSize / this.clipDuration;
					//this.name_txt.text = this.mediaPath;
					this.error_mc.stop ();
					this.error_mc.visible = false;
					this.stream_mc.stop ();
					this.stream_mc.visible = false;
					this.connect_mc.stop ();
					this.downloadtime_mc.visible = false;
					this.minsafebufferlength_mc.visible = false;
					//this.connect_mc.visible = false;
					this.connect_mc.visible = true;
					this.connect_mc.gotoAndPlay ("gray");
					this.loadingP_mc.width = 0;
					this.playingP_mc.width = 0;
					this.buffersize_mc.width = 0;
					this.inbufferlength_mc.width = 0;
					this.playstate_mc.gotoAndStop ("blank");
					this.dvideo = this.video;
					//worst case lets only fully preload 75% of the whole thing, hopefully this will
					// give the multiple competing clips all enough time to start the minimim buffer.
					this.startPreloadAtClockTime = this.trk.A.position - (this.calcPreloadTime (this.bandwidth) );
					//this.startPreloadAtClockTime = this.trk.A.posiCogEvent (this.calcRemainingDownloadTime (this.bandwidth) CogEvent
					this.connectToServer ();
				}
				return nuCogEvent	}
			return s_root;
		}
		function s1_active (e : CogEvent) : Function
		{
			this.onFunctionEnter ("s1_active-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				// this.calcFirstBufferTime(this.bandwidth, 1.1);
				// this.cbufferTime = this.ns.bufferTime;
				//this.trk.A.position -= this.ns.bufferTime;
				// trace(">>>>>>>>>>>>>>> CALC START TIME >>>>>>>>>>>>>>" + this.trk.A.position);
				return null;
				case SIG_EXIT :
				return null;
				case SIG_INIT :
				/*		if (this.autoPlay)
				{
				trace ("******AUTOPLAY****** ");
				this.tran (s11_playing);
				} else
				{
				trace ("*****awaiting key stroke*******");
				this.tran (this.s10_pausedAtBeginning);
				}*/
				return null;
				case NC_CONNECT_SUCCESS_EVT :
				{
					trace ("ready to play");
					this.hasConnection = true;
					this.connect_mc.visible = true;
					this.connect_mc.gotoAndStop ("green");
				}
				return null;
				case NS_PLAY_STREAMNOTFOUND_EVT :
				{
					this.tran (this.s15_NSerror);
				}
				return null;
				case NC_CONNECT_REJECTED_EVT :
				case NC_CONNECT_FAILED_EVT :
				{
					this.hasConnection = false;
					this.tran (s14_NCerror);
				}
				return null;
				case NS_PLAY_START_EVT :
				{
					this.stream_mc.gotoAndStop ("green");
					this.stream_mc.visible = true;
					this.tran (s11_playing);
				}
				return null;
				case NS_PAUSE_NOTIFY_EVT :
				{
					if (this.ns.time == 0)
					{
						this.Q_TRCogEvent0_pausedAtBeginning);
					} else
					{
						this.CogEvent (s13_pausedInMiddle);
					}
				}
				return null;CogEvent			return s_root;
		}
		function s1a_preloading (e : CogEvent) : Function
		{
			this.onFunctionEnter ("s1a_preloading-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				this.startPulse (1000 / 24);
				this.stream_mc.gotoAndStop ("yellow");
				return null;
				case SIG_EXIT :
				this.stopPulse ();
				return null;
				case SIG_INIT :
				return null;
				case SIG_PULSE :
				{
					this.updateNSStats (true);
					if (this.minimumBufferLengthToNotRebuffer > 0 && this.minimumBufferLengthToNotRebuffer < this.ns.bufferLength)
					{
						trace ("Ready to play " + this.minimumBufferLengthToNotRebuffer + " " + this.ns.bufferLength);
						this.tran (this.s1b_loadingButReadyToPlay);
					}
				}
				return null;
				case PLAY_EVT :
				//recieved a play command from the UI, since we are indirectly controlling the play of streams
				// via manipulating the minimumrequired buffer to play, set it to whatever we've downloaded so far.
				// there is a high probability of the stream buffering and getting out of synch if this occurs.
				trace ("WARNING: " + this.hsmName + " getting play called before fully loaded " + this.ns.bufferLength);
				this.ns.setBufferTime (Math.max(2,this.ns.bufferLength));
				return null;
				case NS_PLAY_START_EVT :
				case NS_PLAY_RESET_EVT :
				case NS_BUFFER_FLUSH_EVT :
				//indicate that the stream has started loading.
				return null;
				case NS_BUFFER_FULL_EVT :
				//it's hoped that we dont' ever get this while preloading.
				this.stream_mc.gotoAndStop ("green");
				this.strCogEvent.visible = true;
				this.updateNSStats ();
				this.QCogEvent(this.s11_playing);
				return null;
			}
			return thCogEventactive;
		}
		function s1b_loadingButReadyToPlay (e : CogEvent) : Function
		{
			this.onFunctionEnter ("s1b_loadingButReadyToPlay-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				this.startPulse (1000 / 24);
				this.stream_mc.gotoAndStop ("orange");
				this.stream_mc.visible = true;
				return null;
				case SIG_INIT :
				return null;
				case SIG_EXIT :
				this.stopPulse ();
				return null;
				case SIG_PULSE :
				{
					this.updateNSStats (true);
				}
				return null;
				case PLAY_EVT :
				//recieved a play command from the UI, since we are indirectly controlling the play of streams
				// via manipulating the minimumrequired buffer to play, set it to whatever we've downloaded so far.
				this.ns.setBufferTime (Math.max(2,this.ns.bufferLength));
				return null;
				case NS_BUFFER_FLUSH_EVT :
				case NS_BUFFER_FULL_EVT :
				this.stream_mc.gotoAndStop ("green");
				this.stream_mc.visible = true;
				this.updateNSStats ();
				this.tran (this.s11_playing);
				return null;
				case NS_PLAY_START_EVT :
				this.stream_mc.gotoAndStop ("green");
				this.stream_mc.visible = true;
				this.tran (s11_playing);
				return null;
				case NS_PAUSE_NOTIFY_EVT :
				this.stream_mc.gotoAndCogEvent"green");
				this.stream_mc.visible = true;
				return CogEvent				case NS_PLAY_RESET_EVT :
				return null;
			}
			reCogEventhis.s1_active;
		}
		function s11a_startingPlaying (e : CogEvent) : Function
		{
			this.onFunctionEnter ("s11a_startingPlaying-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				this.playIntV = setInterval (this, "updateNSStats", 1000);
				this.playstate_mc.gotoAndStop ("buffering");
				return null;
				case SIG_EXIT :
				clearInterval (this.playIntV);
				return null;
				case NS_PLAY_START_EVT :
				this.stream_mc.gotoAndStop ("green");
				this.stream_mc.visible = true;
				this.tran (this.s13_buffering);
				return null;
				case GOTOANDSTOP_EVT :
				//this.secondOffset = 0;
				//this.snd.stop ();
				this.tran (this.s10_pausedAtBeginning);
				return null;
				case STOP_EVT :
				//tCogEventcondOffset = this.snd.position / 1000;
				//this.snd.stopCogEvent			this.tran (this.s13_pausedInMiddle);
				return null;CogEvent			return this.s1_active;
		}
		function s11_playing (e : CogEvent) : Function
		{
			this.onFunctionEnter ("s11_playing-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				this.playIntV = setInterval (this, "updateNSStats", 1000);
				this.playstate_mc.gotoAndStop ("playing");
				//this.ns.setBufferTime(this.ns.bufferLength);
				//	this.nsPauseStream();
				return null;
				case SIG_EXIT :
				clearInterval (this.playIntV);
				return null;
				case GOTOANDSTOP_EVT :
				trace ("goto and stop event");
				this.nsSeek (0);
				this.nsPauseStream ();
				this.tran (this.s10_pausedAtBeginning);
				return null;
				case STOP_EVT :
				this.nsPauseStream ();
				this.tran (this.s13_pausedInMiddle);
				return null;
				case NS_PLAY_STOP_EVT :
				if (this.ns.time > (this.clipDuration - this.ns.bufferTime))
	CogEvent				this.tran (this.s11b_playingEndOfStream);
				}
				reCogEventull;
				case NS_PLAY_START_EVT :
				return null;
			}
			rCogEventthis.s1_active;
		}
		function s11b_playingEndOfStream (e : CogEvent) : Function
		{
			this.onFunctionEnter ("s11b_playingEndOfStream-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				//this.playIntV = setInterval (this, "updateNSStats", 1000 );
				//this.playstate_mc.gotoAndStop("playing");
				//	this.nsPauseStream();
				return null;
				case SIG_EXIT :
				//clearInterval (this.playIntV);
				return null;
				case NS_BUFFER_FLUSH_EVT :
				trace (this.streamName + ":_sp nearing end of stream");
				//this.tran (this.s13_pausedAtEnd);
				return null;
				case NS_BUFFER_EMPTY_EVT :
				if (this.ns.time > (this.clipDuration - this.ns.bufferTime))
				{
					trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
					trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
					trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
					trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
					trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
					trace (this.streamName + " reached end of stream " + this.ns.time + "  / " + this.clipDuration);
					this.tran (thCogEvent_pausedAtEnd);
				} else
				{
					trace ("!!!!!!!!!!!!!!!!!CogEventfereing!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				}
				return nulCogEvent}
			return this.s11_playing;
		}
		function s12_stopped (e : CogEvent) : Function
		{
			this.onFunctionEnter ("s12_stopped-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				this.playIntV = setInterval (this, "updateNSStats", 1000);
				this.playstate_mc.gotoAndStop ("stopped");
				return null;
				case SIG_EXIT :
				clearInterval (this.playIntV);
				return null;
				case SIG_INIT :
				return null;
				case STOP_EVT :
				this.nsSeek (0);
				this.nsPauseStream ();
				this.tran (this.s10_pausedAtBeginning);
				return null;
				case PLAY_EVT :
				this.nsResumePlay ();
				this.tran (this.s11_playing);
				return null;
	CogEvente GOTOANDSTOP_EVT :
				this.nsSeek (0);
				this.nsPauseStream CogEvent		this.tran (this.s10_pausedAtBeginning);
				return null;
			CogEventeturn this.s1_active;
		}
		function s10_pausedAtBeginning (e : CogEvent) : Function
		{
			this.onFunctionEnter ("s10_pausedAtBeginning-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				this.playIntV = setInterval (this, "updateNSStats", 1000);
				this.playstate_mc.gotoAndStop ("pausedAtBeginning");
				return null;
				case SIG_EXIT :
				clearInterval (this.playIntV);
				return null;
				case PLAY_EVT :
				this.nsResumePlay ();
				this.tran (this.s11a_startingPlaying);
				return null;
				case NS_PAUSE_NOTIFY_EVT :
				case NS_PLAY_START_EVT :
				//	this.stream_mc.gotoAndStCogEventreen");
				//	this.stream_mc.visible = true;
				//this.tran (sCogEventying);
				return null;
				case GOTOANDSTOP_EVT :
				return nullCogEvent
			return this.s1_active;
		}
		function s13_pausedInMiddle (e : CogEvent) : Function
		{
			this.onFunctionEnter ("s13_pausedInMiddle-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				this.playIntV = setInterval (this, "updateNSStats", 1000);
				this.playstate_mc.gotoAndStop ("paused");
				return null;
				case SIG_EXIT :
				clearInterval (this.playIntV);
				return null;
				case STOP_EVT :
				//	this.nsSeek (0);
				//	this.tran (this.s10_pausedAtBeginning);
				this.nsSeek (0);
				this.nsPauseStream ();
				this.tran (this.s13_seeking);
				return null;
				case PLAY_EVT :
				this.nsResumePlay ();
				this.tran (this.s11_playing);
				return null;
				case GOTOANDSTOP_EVT :
				//this.nsSeekCogEvent				//this.tran (this.s10_pausedAtBeginning);
				this.nsSeek (0);CogEventhis.nsPauseStream ();
				this.tran (this.s13_seeking);
				returnCogEvent
			}
			return this.s1_active;
		}
		function s13_pausedAtEnd (e : CogEvent) : Function
		{
			this.onFunctionEnter ("s13_pausedAtEnd-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				this.playIntV = setInterval (this, "updateNSStats", 1000);
				this.playstate_mc.gotoAndStop ("pausedAtEnd");
				if (this.autoRewind)
				{
					this.dispatchEvent (GOTOANDSTOP_EVT);
				}
				return null;
				case SIG_EXIT :
				clearInterval (this.playIntV);
				return null;
				case STOP_EVT :
				//	this.nsSeek(0);
				//	this.nsPauseStream();
				this.tran (this.s12_stopped);
				return null;
				case GOTOANDSTOP_EVT :
				this.nsSeek (0);
				this.nsPauseStream (true);
				thisCogEventN (this.s13_seeking);
				return null;
				case PLAY_EVT :
				this.nsCogEvent0);
				this.nsResumePlay ();
				this.tran (this.s13_seeking);
				CogEvent null;
			}
			return this.s1_active;
		}
		function s13_seeking (e : CogEvent) : Function
		{
			this.onFunctionEnter ("s13_seeking-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				this.playIntV = setInterval (this, "updateNSStats", 1000);
				this.playstate_mc.gotoAndStop ("seeking");
				return null;
				case SIG_EXIT :
				clearInterval (this.playIntV);
				return null;
				case GOTOANDSTOP_EVT :
				if (this.seekTime == 0)
				{
					this.ns.seek (this.seekTime);
					return null;
				} else
				{
					trace ("TODO Implment Seek to time!");
				}
				return null;
				case NS_PAUSE_NOTIFY_EVT :
				case NS_SEEK_NOTIFY_EVT :
				//reached seeking destinatino
				trace ("----------------------------------------------------------");
				trace ("seeked to " + this.ns.time + " intended " + this.seekTime);
				if (this.ns.time + 24 > this.seekTime)
				{
					this.ns.seek (this.seekTime);
				}
				if (this.nsIsPlaying ())
				{
					this.tran (this.s11_playing);
				} else
				{
					if (CogEventeekTime == 0)
					{
						this.tran (this.s10_pausedAtBeginning);
			CogEventse
					{
						this.tran (this.s13_pausedInMiddle);
					}
				}
				CogEvent null;
			}
			return this.s1_active;
		}
		function s13_buffering (e : CogEvent) : Function
		{
			this.onFunctionEnter ("s13_buffering-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				this.startPulse (1000 / 24);
				this.playstate_mc.gotoAndStop ("buffering");
				return null;
				case SIG_PULSE :
				{
					this.updateNSStats (true);
				}
				break;
				case SIG_EXIT :
				this.stopPulse ();
				return null;
				case NS_BUFFER_FULL_EVT :
				//reached seeking destinatino
				this.tran (this.s11_playing);
				return null;
				case NS_PLAY_STOP_EVT :
				if (this.ns_pause == false)
				{
					//the stream is stalling restarCogEvent					trace ("*8888888888888888888888888888888Restarting Stream************CogEvent*************************************");
					this.nsResumePlay ();
				}
CogEventturn null;
			}
			return this.s1_active;
		}
		function s14_NCerror (e : CogEvent) : Function
		{
			this.onFunctionEnter ("s14_NCerror-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				trace ("ERRROR!!!!!!!!!!!!!!!!!!!!!!!!!!");
				this.playstate_mc.gotoAndStop ("error");
				this.connect_mc.gotoAndStop ("red");
				this.connect_mc.visible = true;
				this.error_mc.visible = true;
				return null;
				case SIG_EXITCogEvent	trace ("ERRROR!!!!!!!!!!!!!!!!!!!!!!!!!!");
				this.connect_mc.gotoAndStopCogEventck");
				this.connect_mc.visible = false;
				this.error_mc.visible = falseCogEventreturn null;
			}
			return this.s1_active;
		}
		function s15_NSerror (e : CogEvent) : Function
		{
			this.onFunctionEnter ("s15_NSerror-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				trace ("ERRROR!!!!!!!!!!!!!!!!!!!!!!!!!!");
				this.playstate_mc.gotoAndStop ("error");
				this.stream_mc.gotoAndStop ("red");
				this.stream_mc.visible = true;
				this.error_mc.visible = true;
				return null;
				case SIG_EXIT :
				this.stream_mc.gotoAndStop ("black");
				this.stream_mc.visible = false;
				this.error_mc.visible = false;
				return null;
				case NS_PAUSE_NOTIFY_EVT :
				case NS_PLAY_STOP_EVT :
				return null;
			}
			return this.s1_active;
		}
	}
	
}