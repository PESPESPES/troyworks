package com.troyworks.framework.loader {
	import com.troyworks.core.cogs.CogEvent; 
	import com.troyworks.data.ArrayX;
	import com.troyworks.hsmf.CogEvent;
	import com.troyworks.events.TEventDispatcher;
	/**************************
	 * @author Troy Gardner
	 */
	import flash.utils.getTimer;
	public class Loader extends MCLoader implements ILoader{
	
		public static var SEQUENTIAL_MODE:Boolean = true;
		public static var PARALLEL_MODE:Boolean = false;
		
		protected var totalSize : Number;
		protected var totalLoaded : Number;
	
		public var children : Array = null;
		protected var loaded : Array = null;
		protected var toLoad : Array = null;
		protected var loading : ArrayX; 
	
		protected var mode:Boolean = SEQUENTIAL_MODE;
		public var checkInterval:Number = 1000/12;
	
		public function Loader(aMode:Boolean) {
			super();
			 mode = (aMode == null)?mode:aMode;
			hsmName = (mode == SEQUENTIAL_MODE)?"SequentialLoader": "ParallelLoader";
			trace("new  " + hsmName);  
			loading = new ArrayX();	
			children  = new Array();
		 	loaded  = new Array();
			trace("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" + loading + " " + children.length);
	
		}
		public function getAmountLoaded() : Number{
			return totalLoaded;
		}
		function getTotalSize() : Number{
	
			return totalSize;
		}
		function calcStats() : void{
			totalLoaded = 0;
			totalSize = 0;
			for(public var i:String in children){
				public var c : ILoader = ILoader(children[i]);
				totalSize += c.getAmountLoaded();
				totalLoaded += c.getTotalSize();		
			}
		}
		function addChild(c : ILoader) : void {
			children.push(c);
			TEventDispatcher(c).addEventListener(EVT_FINISHED_LOADING, createCallback(SIG_PULSE));
			calcStats();
		}
		public function startLoading(path : String) : void{
			trace(hsmName+ " ****** SetLoader START LOADING " +mode);
			if(toLoad==  null && children.length >0){
				toLoad = children.concat();
			}else{
				///nothing to load!//////////////
				trace("WARNING startLoading() called with nothing to load");
				Q_TRAN(s0_isCompletelyLoaded);
			}
			if(mode == PARALLEL_MODE){
				//PARALLEL
				while(toLoad.length >0){
					var c : ILoader = ILoader(toLoad.shift());
					c.startLoading();
					loading.push(c);
				}
			}else{
				//SEQUENTIAL
				trace("[[[[[[[loading sequentially---------" + toLoad.length);
				public var c : ILoader = ILoader(toLoad.shift());
				c.startLoading();
				loading.push(c);
				if(!pulseHasStarted()){
					Q_dispatch(SIG_ENTRY);
				}
			}
		}
			/*.................................................................*/
		function s0_notLoaded(e : CogEvent) : Function
		{
		//	this.onFunctionEnter ("[[[[s_notLoaded-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					trace("NOT LOADED[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[");
					startPulse(1000/3);
					return null;
				}
				case SIG_EXIT :
				{
					stopPulse();
					return null;
				}
				case SIG_INIT :
				{
					return null;
				}
				case SIG_PULSE:
				{
					trace("[[[[ -- pulse ---]]");
					calcStats();
					if(totalSize!= null && totalLoaded > 0){
						trace("target.totalFrames " + totalLoaded);
						dispatchEvent("STARTED_GETTING_DATA");
	
						requestTran(s0_isPartiallyLoaded);
					}else {
						trace("target.totalFrames " + totalLoaded);
					}
					return null;
				}
			}
			return s_root;
		}
		
		/*.................................................................*/
		override function s0_isPartiallyLoaded(e : CogEvent) : Function
		{
	
			//this.onFunctionEnter ("[[[[s0_isPartiallyLoaded-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					trace("[[[[[[[Partial enter\\\\\\\\\\\\\\\\\\");
					gotoAndPlay("loading");
					startPulse(1000/12);
					return null;
				}
				case SIG_EXIT :
				{
					trace("[[[[[[[Partial exit////////////////////");
					stopPulse();
					return null;
				}
				case SIG_INIT :
				{
					trace("[[[[[[[Partial init|||||||||||||||||");
					return null;
				}
				case SIG_PULSE:
				{
					trace("[[[[[[[----pulse-----");
					calcStats();
					trace("[[[[[[[loaded " + totalLoaded + " /  " + totalSize);
					if(totalLoaded >= totalSize){
						trace("[[[[[[[finished Loading child------ LOADING " + loading.length + " LEFT " + toLoad.length );
						loading.removeAll();
						if(loading.length == 0 && toLoad.length == 0){
							//FINISHED LOADING LIST
							requestTran(s0_isCompletelyLoaded);
						}else if (toLoad.length >= 0){
							//FINISHED LOADING A CHILD
							startLoading();
						}
					}
					return null;
				}
			}
			return s_root;
		}
			/*.................................................................*/
		override function s0_isCompletelyLoaded (e : CogEvent) : Function
		{
			//this.onFunctionEnter ("s0_isCompletelyLoaded-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
							trace("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
			trace("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
			trace("bbbbbbbbbbbbbbbbbbbbbbs Loader 0_isCompletelyLoadedbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
			trace("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
			trace("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
			trace("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
					endLoadTime = getTimer();
					calcBandwidth();
					gotoAndPlay("loaded");
					dispatchEvent({type:EVT_FINISHED_LOADING});
					return null;
				}
				case SIG_EXIT :
				{
					return null;
				}
				case SIG_INIT :
				{
					return null;
				}
			}
			return s_root;
		}
	}
}