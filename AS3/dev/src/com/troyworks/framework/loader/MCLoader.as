package com.troyworks.framework.loader { 
	import com.troyworks.hsmf.Hsmf;
	import com.troyworks.hsmf.AEvent;
	import flash.display.BitmapData;
	import com.troyworks.controls.tloadingIndicator.MCLoadingProgressIndicator;
	/**
	 * @author Troy Gardner
	 * hasStarted
	 * notLoaded (normal, errorInLoading) startedLoading,
	 * loadingSuccesfully, finishingLoading isLoaded;
	 * loadedSuccessfully.
	 * loadingCompleted
	 * 
	 * TODO: unloading
	 * 
	 * This allows loaders to be chained
	 * This is extended by sequential loaders e.g A->B->C->D->E
	 *  and parrallel loaders.  A->{B,C,D}->E
	 *  
	 *  Concrete Users adjust the api to the particular media type 
	 *   (XMLDocument,
	 *    Sound,
	 *    Text,
	 *    Font,
	 *    Image
	 *    MovieClip}
	 *    
	 *    This particular loader offers support for SWF, JPG, GIF, PNG.
	 *    it differs from MovieClipLoader, as with smoothing on it uses the
	 *    flash 8 hack, and with with container, it also hides the visibility of hte
	 *    image/swf until desired. 
	 */
	import flash.utils.getTimer;
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.xml.XMLDocument;
	public class MCLoader extends Hsmf implements ILoader {
		public var hasStarted : Boolean;
		public var target : MovieClip;
		public var target_loadTarget : MovieClip;
		public var loadingProgress_mc : MCLoadingProgressIndicator;
		public var actTarget : MovieClip;
	
		public static var EVT_DATA_LOADED : String = "DATA_LOADED";
		public static var EVT_FINISHED_LOADING : String = "FINISHED_LOADING";
		public static var EVT_STARTED_LOADING : String = "STARTED_LOADING";
		public static var EVT_ERROR_LOADING : String = "ERROR_LOADING";
		protected var URL : String;
		public var smooth : Boolean = false;
		public var useContainer : Boolean = false;
		public static var TIME_OUT : Number = 10000;
		protected var errorTime : Number;
		protected var startLoadTime : Number;
		protected var startRecieveTime:Number;
		protected var endLoadTime : Number;
		protected var resultantBandwidth : Number;
		//since the parent polls, and there is some cleanup after the image is loaded,
		// add a buffer.
		protected var completelyLoadedOffset : Number = 0;
		protected var defaultCompletelyLoadedOffset : Number = 5;
	//	public var parentLoader:Loader = null;
		protected var invalidLoadInfo : Boolean = false;
	
		public 	var isJPEG : Boolean = false;
		public 	var isPNG : Boolean = false;
		public 	var isGIF : Boolean = false;
		public 	var isIMAGE : Boolean = false;
		public 	var isSWF : Boolean = false;
		/* notify loaded content it's subordinate */
		public var isSubordinateContent : Boolean = false;
	
	/* latency  */
		public var latencyMS : Number = 0;
	/* kiloBytes per second */
		public var KBps : Number;
	/* Bytes per second */
		public var Bps : Number;
		/* kilobits per second */
		public var Kbps : Number;
	
		public var detectedConnectionSpeed : String;
	
		public var loadedInMS : Number;
	
		public static var MODEM_SPEED : String = "MODEM_SPEED";
	
		public static var LOW_SPEED : String = "LOW_SPEED";
	
		public static var MEDIUM_SPEED : String = "MEDIUM_SPEED";
	
		public static var HIGH_SPEED : String = "HIGH_SPEED";
	
		public function MCLoader(aURL : String, aTarget : MovieClip)
		{
			super (s_initial, "MCLoader", true);
			trace("new MCLoader" + hsmID+" for " + aURL + "  " + aTarget);
			if(aURL == null || aURL == ""){
				var s : String = "***ERROR*** MCLoader's url to load cannot be blank";
				trace(s);
				invalidLoadInfo = true;
				//throw new Error(s);
			}
			if(aTarget == null){
				var s : String = "***ERROR*** MCLoader's target_mc to load into cannot be blank";
				trace(s);
				invalidLoadInfo = true;
				//throw new Error(s);
			}
			URL = aURL;
			var sl : String = aURL.toLowerCase();
			isJPEG  = sl.indexOf(".jpg") >0 || sl.indexOf(".jpeg")>0;
			isPNG = sl.indexOf(".png") >0;
			isGIF = sl.indexOf(".gif") >0;
			isSWF  = sl.indexOf(".swf") >0;
			if(isPNG || isJPEG || isGIF){
				isIMAGE = true;
				smooth = true;
			}
			target = aTarget;
		}
	
		public function onLoad() : void{
			trace("-------onLOAD------------------");
			Q_TRAN(s0_isPartiallyLoaded);
		}
		function onUnload() : void{
			Q_TRAN(s0_notLoaded);
		}
		/////////////////////////////////////////////////////////
		function calcStats() : void{
		}
		protected function calcBandwidth() : Number {
			loadedInMS = endLoadTime -  startRecieveTime;//startLoadTime;//
	
			public var sec : Number = (loadedInMS/1000);
			public var bytes:Number = getTotalSize(); 
			public var bps:Number = int((bytes*8/ sec)*100)/100;
			Bps = int((bytes/ sec)*100)/100;
			//data transfer rates are 1000 to 1, not  datastorage rate which is 1024:1
			Kbps = int((bytes* 8/ 1000/sec)*100)/100;
			KBps = int((bytes/1000/sec)*100)/100;
			///////////////////////////////////
			public var SKBps:Number = int((bytes/ 1024/sec)*100)/100;
			
			detectedConnectionSpeed = getBandwidthDescription(Kbps);
			trace("HIGHLIGHT ############################################ CALC BANDWIDTH #################################################################");
			trace("HIGHLIGHT Tot Size " + bytes + " bytes in " + sec + " sec"); 
			trace("HIGHLIGHT " + bps +" bps"); 
			trace("HIGHLIGHT "+ Kbps +" Kbps " +detectedConnectionSpeed + " ");
			trace("HIGHLIGHT " + Bps +" Bps"); 
			trace("HIGHLIGHT "+ KBps + " KBps ");
			trace("storage " + SKBps + " sKBps ");
			
			trace("HIGHLIGHT #############################################################################################################");
	
			return Bps;
		}
		public static function getBandwidthDescription(Kbps:Number):String{
			public var detectedConnectionSpeed:String = null;
			if(Kbps > 480){
				detectedConnectionSpeed = HIGH_SPEED;
			}else if(Kbps> 240){
				detectedConnectionSpeed = MEDIUM_SPEED;
			}else if(Kbps> 120){
				//128K t1
				detectedConnectionSpeed = LOW_SPEED;
			}else {
				//99.6kbps top of the line modem
				detectedConnectionSpeed = MODEM_SPEED;
			}
			return detectedConnectionSpeed;
		}
		function getAmountLoaded() : Number{
			return (smooth)?actTarget.getBytesLoaded()+ completelyLoadedOffset:actTarget.getBytesLoaded() + completelyLoadedOffset;
		}
		function getTotalSize() : Number{
			return (smooth)?actTarget.getBytesTotal()+ defaultCompletelyLoadedOffset:actTarget.getBytesTotal()+ defaultCompletelyLoadedOffset;
		}
		public function startLoading(path : String) : void{
			startLoadTime = getTimer();
			if(invalidLoadInfo){
				trace("**********Loader ignoring start there's nothing to load");
				return;
			}
			trace("****Loader.startLoading("+ URL + " ->" + target + " @ " + startLoadTime);
			trace("target " + target._url + " " + target.name + " " + (typeof(target)== "movieclip"));
			errorTime = startLoadTime + TIME_OUT;
			if(smooth || useContainer){
				trace("startLoading with Placeholder");
				//load into a placeholder
				// create mc to load bitmap in
				target_loadTarget = target.createEmptyMovieClip("container_mc", target.getNextHighestDepth());
				actTarget = target_loadTarget;
			}else{
				//Load into the target
				actTarget =  target;
			}
			target.visible = false;
			if(actTarget == null){
				Q_TRAN(s1_errorInLoading);
			}
			// start loader
			actTarget.loadMovie(URL);
			//
			if(hasInited == INIT_NOT_INITED){
				init();
			}else {
				Q_TRAN(s0_notLoaded);
			}
			//	dispatchEvent("STARTED_LOADING");
		}
					/*..PSEUDOSTATE...............................................................*/
		function s_initial(e : AEvent) : void
		{
			//trace("************************* s_initial " + util.Trace.me(e)+" ******************");
			onFunctionEnter ("s_initial-", e, []);
			if(e.sig != Q_TRACE_SIG){
				Q_INIT(s0_notLoaded);
			}
		}
		/*.................................................................*/
		function s0_notLoaded(e : AEvent) : Function
		{
			this.onFunctionEnter ("s_notLoaded-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					trace("Start Pulse ENTRY_EVT");
					startPulse(1000/24);
					return null;
				}
				case EXIT_EVT :
				{
					stopPulse();
					return null;
				}
				case PULSE_EVT:
				{
					if(actTarget.totalFrames != null && actTarget.getBytesTotal()>0 ){
						trace("Loader.actTarget.totalFrames " + actTarget.totalFrames + " " + actTarget.getBytesTotal());
						//dispatchEvent("STARTED_GETTING_DATA");
						actTarget.isSubordinateContent = isSubordinateContent;
						startRecieveTime = getTimer();
						latencyMS = startRecieveTime - startLoadTime;
						Q_TRAN(s0_isPartiallyLoaded);
					}else if(errorTime < getTimer() ){
						Q_TRAN(s1_errorInLoading);
					}else {
						trace("Loader.actTarget _url " + actTarget._url + "actTarget.name " + actTarget.name+ " totalFrames " + actTarget.totalFrames + " bytesTot: " + actTarget.getBytesTotal()+ " time " +getTimer() + " " + errorTime);
					}
					return null;
				}
			}
			return s_top;
		}
	
		/*.................................................................*/
		function s0_isPartiallyLoaded(e : AEvent) : Function
		{
	
			this.onFunctionEnter ("s0_isPartiallyLoaded-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					trace("Partial enter\\\\\\\\\\\\\\\\\\"+ loadingProgress_mc + " " + loadingProgress_mc.gotoLoadingPercent);
					//gotoAndPlay("loading");
					loadingProgress_mc.gotoLoadingPercent(1);
			///		actTarget.alpha = 30;
				
					trace("HIGHLIGHT Network/Server roundtrip is " +latencyMS + " MS");
					startPulse(1000/24);
	
					return null;
				}
				case EXIT_EVT :
				{
					trace("Partial exit////////////////////");
					stopPulse();
					return null;
				}
				case PULSE_EVT:
				{
					trace("----MCL pulse-----"  + loadingProgress_mc + " func: " + util.Trace.me(loadingProgress_mc.gotoLoadingPercent, " looking for func", true));
					var l : Number = getAmountLoaded();
					var tot : Number = getTotalSize();
					var percent : Number = Math.round(l/tot*100);
					trace("loaded " + l + " /  " + tot + " =  " + percent + " %");
				
					if(tot > 0 && l >= (tot - defaultCompletelyLoadedOffset) ){
						loadingProgress_mc.gotoLoadingPercent(99);
						trace("finished Loading------");
						Q_TRAN(s0_positionAndAlign);
					}else{
						loadingProgress_mc.gotoLoadingPercent(percent);
					}
					return null;
				}
			}
			return s_top;
		}
		/*.................................................................*/
		function s0_positionAndAlign(e : AEvent) : Function
		{
	
			this.onFunctionEnter ("s0_positionAndAlign-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					startPulse(1000/12);
					return null;
				}
				case EXIT_EVT :
				{
					dispatchEvent({type:EVT_DATA_LOADED});
					target.visible = true;
	
					stopPulse();
					return null;
				}
				case PULSE_EVT:
				{
					Q_TRAN(s0_isCompletelyLoaded);
					return null;
				}
			}
			return s_top;
		}
		
		/*.................................................................*/
		function s0_isCompletelyLoaded(e : AEvent) : Function
		{
			this.onFunctionEnter ("s0_isCompletelyLoaded-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					trace("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
					trace("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
					trace("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
					trace("aaaaaaaaaaaaaaaaaaaa MCLoader."+ URL+" completely loaded aaaaaaaaaaaaaaaaaaaaaaaaaaaa");
					trace("aaaaaaaaaaaaaaaaaaaaaaaaa smooth? " + smooth + " aaaaaaaaaaaaaaaaaaaaaaa");
					trace("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
					trace("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
					endLoadTime = getTimer();
					calcBandwidth();
					if(smooth){
						trace("SMOOTHING ..................");
							// create new BitMap data object and		
							// draw the loaded bitmap in new bitmap
						var bitmap : BitmapData = new BitmapData(target_loadTarget.width,target_loadTarget.height, true, 0x000000);
						bitmap.draw(target_loadTarget);
							
							// create a new movieclip to display the bitmap with
	//						var img:MovieClip = target_loadTarget.createEmptyMovieClip("smoothed_mc", target_loadTarget.getNextHighestDepth());
	
							// remove original bitmap
						target_loadTarget.unloadMovie();
						target_loadTarget.removeMovieClip();
							// draw BitMap in new clip, using the 'smoothing' flag
						target.addChildAt(bitmap, target.getNextHighestDepth(),"auto", true);
					}
					gotoAndPlay("loaded");
					trace("attemping to dispatch EVTFINISHEDLOADING " + dispatchEvent);
					dispatchEvent({type:EVT_FINISHED_LOADING});
					loadingProgress_mc.gotoLoadingPercent(101);
					completelyLoadedOffset = 0;//defaultCompletelyLoadedOffset;
					return null;
				}
			}
			return s_top;
		}
		/*.................................................................*/
		function s1_errorInLoading(e : AEvent) : Function
		{
			this.onFunctionEnter ("s1_errorInLoading-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					stopPulse();
					trace("!!!!!!!!!!!!!!!!!!!!!!! ERROR IN Loader " + hsmID + " LOADING "+ URL +" !!!!!!!!!!!!!!!!!!!!!!!!!!");
					for(var i:String in target){
						trace(" + " + i + " " + target[i]);
					}
					loadingProgress_mc.gotoLoadingPercent(-1);
					dispatchEvent(EVT_ERROR_LOADING);
					return null;
				}
			}
			return this.s0_notLoaded;
		}
	
	
	}
}