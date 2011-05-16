package com.troyworks.framework.loader {
	import flash.display.Bitmap;
	import flash.events.ProgressEvent;	
	import flash.display.MovieClip;	
	import flash.events.IOErrorEvent;	
	import flash.errors.IOError;	
	import flash.system.ApplicationDomain;	
	import flash.system.LoaderContext;	

	import com.troyworks.core.events.PlayheadEvent;	

	import flash.display.DisplayObject;	

	import com.troyworks.core.cogs.CogEvent;	
	import com.troyworks.core.chain.UnitOfWork;

	import flash.display.Sprite;	
	import flash.events.Event;	
	import flash.net.URLRequest;	
	import flash.display.Loader;	

	import com.troyworks.framework.loader.LoaderUtil;

	/**
	 * SWFLoaderUnit
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Jun 22, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class SWFLoaderUnit extends UnitOfWork {
		private var s_loader : Loader;
		private var s_loaderUtil : LoaderUtil;
		public var mediaURL : String = "B.swf"; 
		//	//"TroyWorks-80x80.jpg"; //
		public var targetClip : Sprite;
		public  var clip : DisplayObject;
		public var nameForLoadedClip:String =null;
		public var wrapBitmap:Boolean = false;
		public var initParams:Object = new Object();
		public function SWFLoaderUnit(initState : String = "s__haventStarted", aMode : Boolean = SEQUENTIAL_MODE) {
			super(initState, aMode);
			setStateMachineName("SWFLoaderUnit");
		}

		override public function getWorkPerformed() : Number {
			//	trace("getWorkPerformed");
			try {
				if(s_loader == null || s_loader.contentLoaderInfo == null) {
				
					//	trace("getWorkPerformed1 NaN");
					return NaN;
				} else {
				
					//	trace("getWorkPerformed2 " + s_loader.contentLoaderInfo.bytesLoaded );
					return s_loader.contentLoaderInfo.bytesLoaded;
				}
			}catch(e : Error) {
				//will throw error if not enough bytes have loaded!!!
			}
			return NaN;
		}

		override public function getTotalWorkToPerform() : Number {
			try {
				if(s_loader == null || s_loader.contentLoaderInfo == null) {
					return NaN;
				} else {
					return s_loader.contentLoaderInfo.bytesTotal;
				}
			}catch(e : Error) {
				//will throw error if not enough bytes have loaded!!!
			}
			return NaN;
		}

		override public function s__doing(e : CogEvent) : Function {
			switch (e.sig) {
				//case SIG_INIT:
				//	return (totalPerformed > 0 && totalWork > 0 )? s___partiallyDone:null;
				case SIG_ENTRY :
					/////////////////////////////////////
					s_loader = new Loader();
					s_loaderUtil = new LoaderUtil(s_loader.contentLoaderInfo);
					//s_loaderUtil.addEventListener(Event.COMPLETE, completeSWFLoadHandler);
					s_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, calcStats);
					//s_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onChildErrored);
					s_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeSWFLoadHandler);
					var request : URLRequest = new URLRequest(mediaURL);
					
					trace(_smName + "#" + _smID + ".starting to load SWF/IMG '" + mediaURL + "'");
					
					var loaderContext : LoaderContext = new LoaderContext();
					loaderContext.applicationDomain = ApplicationDomain.currentDomain; 
					s_loader.load(request, loaderContext);
					break;	
			}
			return super.s__doing(e);
		}		

		
		
		public function completeSWFLoadHandler(event : Event) : void {
			trace(_smName + "#" + _smID + ".completeHandler: " + event);
			clip = DisplayObject(Loader(event.target.loader).content);
			if(clip is Bitmap && wrapBitmap){
				var wrapper:Sprite = new Sprite();
				wrapper.addChild(clip);
				clip = wrapper;
			}
			if(nameForLoadedClip){
			    clip.name =nameForLoadedClip; 
			}
			////////// TODO LAYOUT //////////////////
			for (var e : String in initParams) {
				clip[e] = initParams[e];
			}
			//clip.x = Math.random() * 50;
			//clip.y = Math.random() * 50;
			//clip.alpha = .3;
			if(clip is MovieClip) {
				(clip as MovieClip).stop();
			}
			
			if(targetClip != null) {
				targetClip.addChild(clip);
			}
			trace(_smName + "#" + _smID + ".requestingDone: " + event);
			
			requestTran(s_done);
			//dispatchEvent(new PlayheadEvent(EVT_COMPLETE));
			//dispatchEvent(event);
		}
	}
}
