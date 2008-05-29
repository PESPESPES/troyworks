package com.troyworks.framework.loader { 
	import com.troyworks.hsmf.Hsmf;
	import com.troyworks.hsmf.AEvent;
	import com.troyworks.hsmf.Signal;
	// import mx.utils.Delegate;
	 import ascb.util.Proxy;
	/**
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;
	import flash.media.Sound;
	public class SoundLoader extends Hsmf implements ILoader {
		public var snd : Sound;
		protected var URL : String;
		public var target:MovieClip;
		public var secondOffset : Number = 0;
		public var autoPlay:Boolean = true;
		protected static var d:Function = Proxy;
		public static var SIG_STARTLOADING:Signal = Signal.getNext("STARTLOADING");
		public static var EVT_STARTLOADING:AEvent = new AEvent(SIG_STARTLOADING);
		/////////////////////////////////////////////////////////
		public function SoundLoader (aURL:String, aTarget:MovieClip)
		{
			super (s_initial, "SoundLoader", true);
			trace("new SoundLoader  for " + aURL + "  " + aTarget);
			URL = aURL;
			target = aTarget;
		}
		public function startLoading(path:String):void{
			trace("****SoundLoader.startLoading("+ URL + " ->" + target);
			Q_dispatch(EVT_STARTLOADING);
			//	dispatchEvent("STARTED_LOADING");
		}
		public function calcStats():void{
		}
		function getAmountLoaded():Number{
			return snd.getBytesLoaded();
		}
		function getTotalSize():Number{
			return  snd.getBytesTotal();
		}
			/////////////////////////Delegated Function from the Sound Calls //////////////////
		function onSoundComplete () : void {
			trace ("XXXXXXXXXXXXXSound Completed PlayingXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			onSoundCompleteCallback();
		}
		function onSoundCompleteCallback () : void {
		}
		
		function soundOnLoad (success:Boolean) : void
		{
			trace ("XXXXXXXXXXXXXSound Loaded " + success + " XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			this.Q_TRAN (s0_isCompletelyLoaded);
		}
		function soundOnID3 () : void
		{
			trace ("XXXXXXXXXXXXXSound onID3XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
		}
			/////////////////////////////////////// STATES /////////////////////////////
		/*..PSEUDOSTATE...............................................................*/
		function s_initial(e : AEvent) : void
		{
			trace("************************* SoundLoader s_initial " + util.Trace.me(e)+" ******************");
			onFunctionEnter ("s_initial-", e, []);
			if(e.sig != Q_TRACE_SIG){
				Q_INIT(s0_notLoaded);
			}
		}	
		/*.................................................................*/
		function s0_notLoaded (e : AEvent) : Function
		{
			this.onFunctionEnter ("s_notLoaded-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{	
					startPulse(1000/3);
					return null;
				}
				case EXIT_EVT :
				{
					stopPulse();
					return null;
				}
				case INIT_EVT :
				{
					return null;
				}
				case EVT_STARTLOADING:{
					var isStreaming : Boolean = false;
					this.snd = new Sound (target);
					this.snd.onSoundComplete =Proxy.create (this, this.onSoundComplete);
					this.snd.onLoad = Proxy.create (this, this.soundOnLoad);
					this.snd.onID3 = Proxy.create (this, this.soundOnID3);
					this.snd.loadSound (URL, isStreaming);
					if(autoPlay){
						this.snd.start (0);
					}
					this.secondOffset = 0;
				}
				case PULSE_EVT:
				{
					
					if(snd.getBytesTotal() != null && snd.getBytesTotal() > 0){
						trace("snd.getBytesTotal() " + snd.getBytesTotal());
						dispatchEvent("STARTED_GETTING_DATA");
						
						Q_TRAN(s0_isPartiallyLoaded);
					}else {
						trace("snd.getBytesTotal() " +snd.getBytesTotal());
					}
					return null;
				}
			}
			return s_top;
		}
	
		/*.................................................................*/
		function s0_isPartiallyLoaded (e : AEvent) : Function
		{
		
			this.onFunctionEnter ("s0_isPartiallyLoaded-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					trace("Partial enter\\\\\\\\\\\\\\\\\\");
					gotoAndPlay("loading");
					target.alpha = 30;
					startPulse(1000/12);
					return null;
				}
				case EXIT_EVT :
				{
					trace("Partial exit////////////////////");	
					stopPulse();
					return null;
				}
				case INIT_EVT :
				{
					trace("Partial init|||||||||||||||||");
					return null;
				}
				case PULSE_EVT:
				{
					trace("----pulse-----");
					var l = getAmountLoaded();
					var tot = getTotalSize();
					trace("loaded " + l + " /  " + tot);
					if(tot > 0 && l == tot){
						trace("finished Loading------");
						Q_TRAN(s0_isCompletelyLoaded);
					}
					return null;
				}
			}
			return s_top;
		}
		/*.................................................................*/
		function s0_isCompletelyLoaded (e : AEvent) : Function
		{
			this.onFunctionEnter ("s0_isCompletelyLoaded-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					gotoAndPlay("loaded");
					dispatchEvent("FINISHED_LOADING");
					return null;
				}
				case EXIT_EVT :
				{
					return null;
				}
				case INIT_EVT :
				{
					return null;
				}
			}
			return s_top;
		}
		/*.................................................................*/
		function s1_loading (e : AEvent) : Function
		{
			this.onFunctionEnter ("s1_loading-", e, []);
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
				case INIT_EVT :
				{
					//Q_INIT(s2_parsingXML);
					return null;
				}
			}
			return s_top;
		}
		
	}
}