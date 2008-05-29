package com.troyworks.framework.loader { 
	import com.troyworks.framework.logging.SOSLogger;
	import com.troyworks.events.TProxy;
	/**
	 * 
	 * There are a few tricks when it comes to testing bandwidth /Latency
	 * - the polling interval (AND frame rate of the movie) has to be high in order for smaller images to 
	 * be seen accurately, 36fps is a reasonable rate especially for lower sized images.
	 * - a random parameter has to be appended to the end of every load request
	 *  to defeat the cash, in this case I'm using the Date timestamp + random in the case
	 *  that more than one is fired off in the same millisecond
	 *  - kilobits is 1000 bits not 1024 for data transport
	 *  - you have to unload the previous load test, and give it a delay frame or two to make sure
	 *  it's graphics.clear for the next test to run. This is especially true of larger images which take
	 *  some time to be garbage collected, else the results get skewed by super high values as it's
	 *  detected the already loaded one prior to the next one starting to get loaded.
	 *  - when using this it's important to keep the window to the load test free of competition from 
	 *  other assets, e.g. this should be used after the preloader swf has completely loaded, but before other
	 *  assets are started to fire off, as they all share the same thread.
	 *  - note that bandwidth detection is a rought guide, people's bandwidth fluctuates (both by connection on a wireless, and based on 
	 *  what other things they are downloading at the moment). 
	 *  
	 * @author Troy Gardner
	 */
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.display.MovieClip;
	import flash.utils.setInterval;
	public class BandwidthTester extends Object {
		public var targ : MovieClip;
		/* latency  */
		public var latencyMS : Number = 0;
	/* kiloBytes per second */
		public var KBps : Number;
	/* Bytes per second */
		public var Bps : Number;
		/* kilobits per second */
		public var Kbps : Number;
	
		public var loadedInMS : Number;
	
		protected var elapsedTimeMS : Number;
	
		protected var elapsedTime : Number;
	
		protected var sizeInBits : Number;
	
		protected var sizeInKBits : Number;
	
		protected var intV : Number;
		public var state : String = "NOT_STARTED";
	
		protected var startLoadAtTime : Number;
	
		protected var startRecieveAtTime : Number;
	
		protected var finishedRecieveAtTime : Number;
	
		public var lastBytesLoaded : Number;
	
		public var curBytesLoaded : Number;
	
		public var bytesLoadedSinceLastCheck : Number;
	
		protected var lastTime : Number;
	
		protected var curTime : Number;
		public function BandwidthTester(aURL : String, aTarget : MovieClip, useRandom:Boolean) {
			targ = aTarget;
			//var _s : SOSLogger = SOSLogger.getInstance();
			intV = setInterval(TProxy.create(this, this.checkStatus), 1000/48);
		//	if(aTarget.getBytesTotal() == 0){
			startLoadAtTime = getTimer();
			var rnd:String = "";
			//APPEND A RANDOM TO AVOID BROWSER CACHE
			if(useRandom == true || useRandom == null){
				var now:Date = new Date();
			 	rnd = "?"+now.getTime() + Math.random() ;
			}
			targ.loadMovie(aURL + rnd);
			trace("starting bandwidth test " + aURL + " int: " + intV + " " +  + aTarget.getBytesTotal());
			state = "NO_BYTES";
			//}else{
	//			trace("ERROR starting bandwidth test " + aURL + " target not empty!" + aTarget.getBytesTotal());
			//}
		}
		public function onCallBack(Kbps:Number, latencyMS:Number):void{
		}
		public function checkStatus() : void{
			//trace("checkStatus");
			if(state == "BYTES STARTED"){
				lastBytesLoaded = curBytesLoaded;
				lastTime = curTime;
				curBytesLoaded =  targ.getBytesLoaded(); 
				curTime = getTimer();
				bytesLoadedSinceLastCheck = curBytesLoaded - lastBytesLoaded;
				if(curBytesLoaded== targ.getBytesTotal() && targ.getBytesTotal() > 0){
					//finished
					state = "FINISHED";
					clearInterval(this.intV);
					finishedRecieveAtTime = getTimer();
					Kbps = getKbps(startLoadAtTime, finishedRecieveAtTime, targ.getBytesTotal());
					trace("found " + Kbps +" Kbps");
					onCallBack(Kbps, latencyMS);
				}else{
					///still loading/checking.
					if(curBytesLoaded > lastBytesLoaded){
						Kbps = getKbps(lastTime, curTime, curBytesLoaded- lastBytesLoaded);
					}
					
				}
			}else if(state == "NO_BYTES" && targ.getBytesTotal() > 0){
				state = "BYTES STARTED";
				startRecieveAtTime = getTimer();
				latencyMS = startRecieveAtTime - startLoadAtTime;
			}
		}
		/*http://www.sonify.org/home/feature/remixology/019_bandwidthdetection/page2.html
	Calculate approximate Kbps after test swf loads
	*/
		public function getKbps(startTime : Number, endTime:Number, sizeInBytes : Number) : Number {
			elapsedTimeMS = endTime - startTime; // time elapsed since start loading swf
			elapsedTime = elapsedTimeMS/1000; //convert to seconds
			Bps = sizeInBytes/elapsedTime;
			sizeInBits = sizeInBytes * 8; // convert Bytes to bits
			sizeInKBits = sizeInBits/1000; // convert bits to kbits NOte 1000 not 1024
			trace(" sizeInKBits " + sizeInKBits + " " + elapsedTime + " sec" ); 
			Kbps = (sizeInKBits/elapsedTime) * 0.93 ; // IP packet header overhead around 7%
			KBps = Kbps*8; //8 bits in a byte (B)
			return Math.floor(Kbps); // return user friendly number
	}
		
	}
}