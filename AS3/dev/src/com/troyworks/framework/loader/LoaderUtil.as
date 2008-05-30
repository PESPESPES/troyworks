package com.troyworks.framework.loader { 
	/**
	 * This is a utility to calculate the bitrate of a downloaded file, rewritten from AS3.0
	 * to be generic for loader objects
	 * 
	 * NOTE: There are a few tricks when it comes to testing bandwidth /Latency
	 * - the polling interval (AND frame rate of the movie) has to be high in order for smaller images to 
	 * be seen accurately, 36fps is a reasonable rate especially for lower sized images.
	 * - a random parameter has to be appended to the end of every load request
	 *  to defeat the browser cache, in this case I'm using the Date timestamp + random in the case
	 *  that more than one is fired off in the same millisecond
	 *  - kilobits is 1000 bits not 1024 for data transport
	 *  - you have to unload the previous load test, and give it a delay frame or two to make sure
	 *  it's graphics.clear for the next test to run. This is especially true of larger images which take
	 *  some time to be garbage collected, else the results get skewed by super high values as it's
	 *  detected the already loaded one prior to the next one starting to get loaded.
	 *  - when using this it's important to keep the window to the load test free of competition from 
	 *  other assets, e.g. this should be used after the preloader swf has completely loaded, but before other
	 *  assets are started to fire off, as they all share the same thread.
	 *  - note that bandwidth detection is a rough guide, people's bandwidth fluctuates (both by connection on a wireless, and based on 
	 *  what other things they are downloading at the moment). 
	 *  
	 *  To use:
	 *  
	 *  var l
	 *  
	 * @author Troy Gardner troy@troyworks.com
	 */
	import flash.display.LoaderInfo;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.utils.getTimer;	

	public class LoaderUtil extends Object {

		/* kiloBytes per second */
		public var KBps : Number;
		/* Bytes per second */
		public var Bps : Number;
		/* kilobits per second */
		public var Kbps : Number;

		
		protected var sizeInBits : Number;

		protected var sizeInKBits : Number;

		
		
		protected var startLoadAtTime : Number;
		protected var startRecieveAtTime : Number;
		protected var finishedRecieveAtTime : Number;

		
		/* latency  */
		public var latencyMS : Number = 0;
		public var loadedInMS : Number;
		protected var elapsedTimeMS : Number;
		protected var elapsedTime : Number;

		public var lastBytesLoaded : Number;
		public var curBytesLoaded : Number;
		public var totalBytesToLoad : Number;
		public var bytesLoadedSinceLastCheck : Number;

		public var lastTime : Number;
		public var curTime : Number;

		public var percentLoaded : Number;
		private var _loaderInf:LoaderInfo;
		public var clearListenersOnComplete:Boolean = true;

		public static const NOT_STARTED : String = "NOT_STARTED";
		public static const NO_BYTES : String = "NO_BYTES";
		public static const BYTES_STARTED : String = "BYTES_STARTED";
		public static const FINISHED : String = "FINISHED";

		public var curstate : String = NOT_STARTED;

		public function LoaderUtil(loaderInf : LoaderInfo) {
			loaderInf.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loaderInf.addEventListener(Event.OPEN, openStreamHandler);
			_loaderInf = loaderInf;
		}

		public function getCanStartPlayingWhileStreaming(duration : Number, safety : Number) : Boolean {
			return false;
		}

		public static function getCacheBuster(useRandom : Boolean = true) : String {
			var rnd : String = "";
			//APPEND A RANDOM TO AVOID BROWSER CACHE
			if(useRandom) {
				var now : Date = new Date();
				rnd = "?" + now.getTime() + "." + Math.random() ;
			}
			return rnd;
		}

		public function openStreamHandler(evt : Event) : void {
			curTime = startLoadAtTime = getTimer();
			curBytesLoaded = NaN;
			lastBytesLoaded = NaN;
			lastTime = NaN;
			percentLoaded = 0;
			curstate = NO_BYTES;
			trace("updatePercentage****************");
		}

		public function progressHandler(evt : ProgressEvent) : void {
			//trace("checkStatus");
			lastBytesLoaded = curBytesLoaded;
			curBytesLoaded = evt.bytesLoaded;
			lastTime = curTime; 
			curTime = getTimer();
				
			trace(curstate + " progressHandler " + evt.toString());
			switch(curstate) {
				case  NOT_STARTED:
					//shouldn't hit this
					break;
				case  NO_BYTES:
					if(evt.bytesTotal > 0) {
						totalBytesToLoad =evt.bytesTotal; 
						curstate = BYTES_STARTED;
						startRecieveAtTime = getTimer();
						latencyMS = startRecieveAtTime - startLoadAtTime;
						trace("latencyMS " + latencyMS);
					}
					if(curBytesLoaded >= 0) {
						trace("updating first");
						lastBytesLoaded =0;
						updateProgress();
					}
					break;
				case BYTES_STARTED:
					updateProgress();
					break;
				case FINISHED:
					//shouldn't hit this
					break;
			}
			trace(curstate + " progressHandler2 " + Kbps);
		}

		private function updateProgress() : void {
			/////////////////////////////////////////////
			//      still loading/checking
			/////////////////////////////////////////////
			//this check is necessary as the browser delivers to the flash player
			//in buckets
			trace("curB " + curBytesLoaded + " last "+ lastBytesLoaded);
			if(curBytesLoaded > lastBytesLoaded) {
				trace("change in bytes");
				percentLoaded = curBytesLoaded / totalBytesToLoad;
				trace("updatePercentage****************");
				//TODO: notify of update to Kbps
				Kbps = getKbps(lastTime, curTime, curBytesLoaded - lastBytesLoaded);
				bytesLoadedSinceLastCheck = curBytesLoaded - lastBytesLoaded;
				if(curBytesLoaded == totalBytesToLoad) {
					//////////////////////////////////////////
					//        finished successfully         //
					//////////////////////////////////////////
					curstate = "FINISHED";
					finishedRecieveAtTime = getTimer();
					Kbps = getKbps(startLoadAtTime, finishedRecieveAtTime, totalBytesToLoad);
					trace("found " + Kbps + " Kbps");
							//onCallBack(Kbps, latencyMS);
					if(clearListenersOnComplete) {
						_loaderInf.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
						_loaderInf.removeEventListener(Event.OPEN, openStreamHandler);	
					}
				}
			}
		}

		public function getPercentLoaded() : String {
			return Math.round(percentLoaded) + "%";
		}

		/*http://www.sonify.org/home/feature/remixology/019_bandwidthdetection/page2.html
		Calculate approximate Kbps after test swf loads
		 */
		public function getKbps(startTime : Number, endTime : Number, sizeInBytes : Number) : Number {
			elapsedTimeMS = endTime - startTime; 
			// time elapsed since start loading swf
			elapsedTime = elapsedTimeMS / 1000; 
			//convert to seconds
			Bps = sizeInBytes / elapsedTime;
			sizeInBits = sizeInBytes * 8; 
			// convert Bytes to bits
			sizeInKBits = sizeInBits / 1000; 
			// convert bits to kbits NOte 1000 not 1024
			trace(" sizeInKBits " + sizeInKBits + " " + elapsedTime + " sec"); 
			Kbps = (sizeInKBits / elapsedTime) * 0.93 ; 
			// IP packet header overhead around 7%
			KBps = Kbps * 8; 
			//8 bits in a byte (B)
			return Math.floor(Kbps); // return user friendly number
		}
	}
}