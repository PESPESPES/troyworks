package com.troyworks.framework.loader {
	import flash.display.Bitmap;	
	import flash.events.Event;	
	
	import com.troyworks.core.cogs.CogEvent;	
	import com.troyworks.core.cogs.Hsm; 
	import flash.display.BitmapData;
//	import com.troyworks.controls.tloadingIndicator.MCLoadingProgressIndicator;
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
	public class MCLoader extends Hsm implements ILoader {
		public var hasStarted : Boolean;
		public var target : MovieClip;
		public var target_loadTarget : MovieClip;
		public var loadingProgress_mc : MovieClip;// MCLoadingProgressIndicator;
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
			super ("s_initial", "MCLoader", true);
			trace("new MCLoader" + smID+" for " + aURL + "  " + aTarget);
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
			requestTran(s0_isPartiallyLoaded);
		}
		function onUnload() : void{
			requestTran(s0_notLoaded);
		}
		/////////////////////////////////////////////////////////
		function calcStats() : void{
		}
		protected function calcBandwidth() : Number {
			loadedInMS = endLoadTime -  startRecieveTime;//startLoadTime;//
	
			var sec : Number = (loadedInMS/1000);
			var bytes:Number = getTotalSize(); 
			var bps:Number = int((bytes*8/ sec)*100)/100;
			Bps = int((bytes/ sec)*100)/100;
			//data transfer rates are 1000 to 1, not  datastorage rate which is 1024:1
			Kbps = int((bytes* 8/ 1000/sec)*100)/100;
			KBps = int((bytes/1000/sec)*100)/100;
			///////////////////////////////////
			var SKBps:Number = int((bytes/ 1024/sec)*100)/100;
			
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
			var detectedConnectionSpeed:String = null;
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
				requestTran(s1_errorInLoading);
			}
			// start loader
			actTarget.loadMovie(URL);
			//
			if(!stateMachine_hasInited){
				initStateMachine();
			}else {
				requestTran(s0_notLoaded);
			}
			//	dispatchEvent("STARTED_LOADING");
		}
					/*..PSEUDOSTATE...............................................................*/
		function s_initial(e : CogEvent) : Function
		{
			//trace("************************* s_initial " + util.Trace.me(e)+" ******************");
			//onFunctionEnter ("s_initial-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					trace("Start Pulse SIG_ENTRY");
					return s0_notLoaded;
				}
			}
			
		}
		/*.................................................................*/
		function s0_notLoaded(e : CogEvent) : Function
		{
			//this.onFunctionEnter ("s_notLoaded-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					trace("Start Pulse SIG_ENTRY");
					startPulse(1000/24);
					return null;
				}
				case SIG_EXIT :
				{
					stopPulse();
					return null;
				}
				case SIG_PULSE:
				{
					if(actTarget.totalFrames != null && actTarget.getBytesTotal()>0 ){
						trace("Loader.actTarget.totalFrames " + actTarget.totalFrames + " " + actTarget.getBytesTotal());
						//dispatchEvent("STARTED_GETTING_DATA");
						actTarget.isSubordinateContent = isSubordinateContent;
						startRecieveTime = getTimer();
						latencyMS = startRecieveTime - startLoadTime;
						requestTran(s0_isPartiallyLoaded);
					}else if(errorTime < getTimer() ){
						requestTran(s1_errorInLoading);
					}else {
						//trace("Loader.actTarget _url " + actTarget._url + "actTarget.name " + actTarget.name+ " totalFrames " + actTarget.totalFrames + " bytesTot: " + actTarget.getBytesTotal()+ " time " +getTimer() + " " + errorTime);
					}
					return null;
				}
			}
			return s_root;
		}
	
		/*.................................................................*/
		function s0_isPartiallyLoaded(e : CogEvent) : Function
		{
	
		//	this.onFunctionEnter ("s0_isPartiallyLoaded-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					trace("Partial enter\\\\\\\\\\\\\\\\\\"+ loadingProgress_mc + " " + loadingProgress_mc.gotoLoadingPercent);
					//gotoAndPlay("loading");
					loadingProgress_mc.gotoLoadingPercent(1);
			///		actTarget.alpha = 30;
				
					trace("HIGHLIGHT Network/Server roundtrip is " +latencyMS + " MS");
					startPulse(1000/24);
	
					return null;
				}
				case SIG_EXIT :
				{
					trace("Partial exit////////////////////");
					stopPulse();
					return null;
				}
				case SIG_PULSE:
				{
					//trace("----MCL pulse-----"  + loadingProgress_mc + " func: " + Trace.me(loadingProgress_mc.gotoLoadingPercent, " looking for func", true));
					var l : Number = getAmountLoaded();
					var tot : Number = getTotalSize();
					var percent : Number = Math.round(l/tot*100);
					trace("loaded " + l + " /  " + tot + " =  " + percent + " %");
				
					if(tot > 0 && l >= (tot - defaultCompletelyLoadedOffset) ){
						loadingProgress_mc.gotoLoadingPercent(99);
						trace("finished Loading------");
						requestTran(s0_positionAndAlign);
					}else{
						loadingProgress_mc.gotoLoadingPercent(percent);
					}
					return null;
				}
			}
			return s_root;
		}
		/*.................................................................*/
		function s0_positionAndAlign(e : CogEvent) : Function
		{
	
		//	this.onFunctionEnter ("s0_positionAndAlign-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					startPulse(1000/12);
					return null;
				}
				case SIG_EXIT :
				{
					dispatchEvent(new Event(EVT_DATA_LOADED));
					target.visible = true;
	
					stopPulse();
					return null;
				}
				case SIG_PULSE:
				{
					requestTran(s0_isCompletelyLoaded);
					return null;
				}
			}
			return s_root;
		}
		
		/*.................................................................*/
		function s0_isCompletelyLoaded(e : CogEvent):Function {

		//	this.onFunctionEnter ("s0_isCompletelyLoaded-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
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
						var bitmapD : BitmapData = new BitmapData(target_loadTarget.width,target_loadTarget.height, true, 0x000000);
						bitmapD.draw(target_loadTarget);
							
						var bitmap:Bitmap = new Bitmap(bitmapD);
						bitmap.smoothing = true;
						// create a new movieclip to display the bitmap with
						//var img:MovieClip = target_loadTarget.createEmptyMovieClip("smoothed_mc", target_loadTarget.getNextHighestDepth());
	
						// remove original bitmap
						//target_loadTarget.unloadMovie();
						//target_loadTarget.removeMovieClip();
						
						// draw BitMap in new clip, using the 'smoothing' flag
						target.addChildAt(bitmap, target.numChildren-1);
					}
					//gotoAndPlay("loaded");
					trace("attemping to dispatch EVTFINISHEDLOADING " + dispatchEvent);
					dispatchEvent(new Event(EVT_FINISHED_LOADING));
					loadingProgress_mc.gotoLoadingPercent(101);
					completelyLoadedOffset = 0;//defaultCompletelyLoadedOffset;
					return null;
				}
			}
			return s_root;
		}
		/*.................................................................*/
		function s1_errorInLoading(e : CogEvent) : Function
		{
		//	this.onFunctionEnter ("s1_errorInLoading-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					stopPulse();
					trace("!!!!!!!!!!!!!!!!!!!!!!! ERROR IN Loader " + smID + " LOADING "+ URL +" !!!!!!!!!!!!!!!!!!!!!!!!!!");
					for(var i:String in target){
						trace(" + " + i + " " + target[i]);
					}
					loadingProgress_mc.gotoLoadingPercent(-1);
					dispatchEvent(new Event(EVT_ERROR_LOADING));
					return null;
				}
			}
			return this.s0_notLoaded;
		}
	
	
	}
}