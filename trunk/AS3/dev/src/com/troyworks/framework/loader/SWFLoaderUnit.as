package com.troyworks.framework.loader {
	import flash.utils.getQualifiedClassName;
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

		//	//"TroyWorks-80x80.jpg"; //
		public var targetClip : Sprite;
		public  var clip : DisplayObject;
		public var nameForLoadedClip : String = null;
		public var wrapClip:Boolean = false;
		public var wrapBitmap : Boolean = false;
		public var initParams : Object = new Object();
		public var lastBytesTotal:Number = NaN;
		public var lastBytesLoaded:Number = NaN;
		public var hasRecievedComplete:Boolean = false;
		public var onRecievedManifestCallback:Function;
		
		public function SWFLoaderUnit(initState : String = "s__haventStarted", aMode : Boolean = SEQUENTIAL_MODE) {
			super(initState, aMode);
			setStateMachineName("SWFLoaderUnit");
		}

		private var _mediaURL : String;

		public function set mediaURL( value : String ) : void {
			var li1 : int = value.lastIndexOf("/");
			var li2 : int = value.lastIndexOf("\\");
			var li : int = Math.max(li1, Math.max(li2, 0));
			_smName = value.substring(li, value.length);
			_mediaURL = value;
		}

		public function get mediaURL( ) : String {
			return _mediaURL;
		}

		
		
		
		override public function getWorkPerformed() : Number {
			//	trace2("SWFLoaderUnit.getWorkPerformed");
			try {
				if(s_loader == null || s_loader.contentLoaderInfo == null || hasRecievedComplete) {
				
				//		trace2("getWorkPerformed1 NaN");
					return lastBytesLoaded;
				} else {
					lastBytesLoaded  =s_loader.contentLoaderInfo.bytesLoaded;
					//	trace2("getWorkPerformed2 " + s_loader.contentLoaderInfo.bytesLoaded );
					return s_loader.contentLoaderInfo.bytesLoaded;
				}
			}catch(e : Error) {
				//will throw error if not enough bytes have loaded!!!
			}
			return NaN;
		}

		override public function getTotalWorkToPerform() : Number {
			try {
				if(s_loader == null || s_loader.contentLoaderInfo == null|| hasRecievedComplete) {
					return lastBytesTotal;
				} else {
					lastBytesTotal  =s_loader.contentLoaderInfo.bytesTotal;
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
					s_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIO_ERROR);
					s_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeSWFLoadHandler);
					var request : URLRequest = new URLRequest(mediaURL);
					
					trace2(_smName + "#" + _smID + ".starting to load SWF/IMG '" + mediaURL + "'");
					
					var loaderContext : LoaderContext = new LoaderContext();
					loaderContext.applicationDomain = ApplicationDomain.currentDomain; 
					s_loader.load(request, loaderContext);
					break;	
			}
			return super.s__doing(e);
		}	

		public function onIO_ERROR(evt : IOErrorEvent) : void {
			trace2("SWFLoader.onIO_ERROR" + evt.toString());
			onChildErrored(evt);	
		}

		
		
		public function completeSWFLoadHandler(event : Event) : void {
			trace2(_smName + "#" + _smID + ".completeSWFLoadHandler: " + event);
			
			
			getWorkPerformed();
			getTotalWorkToPerform();
			hasRecievedComplete = true;			
			trace2(getWorkPerformed() + " / " + getTotalWorkToPerform());
			clip = DisplayObject(Loader(event.target.loader).content);
			var str : String = getQualifiedClassName(s_loader.content);
			if(clip is Bitmap && wrapBitmap  || wrapClip) {
				var wrapper : Sprite = new Sprite();
				wrapper.addChild(clip);
				wrapper.name = "bitmapwrapper";
				clip = wrapper;
			}
			if(nameForLoadedClip) {
				clip.name = nameForLoadedClip; 
			}
			////////// TODO LAYOUT //////////////////
			for (var e : String in initParams) {
				trace2("SWFLoaderUnit.initParm " + e + " " + initParams[e]);
				clip[e] = initParams[e];
			}

			if(clip.hasOwnProperty("manifest")){
				trace2("SWFLoaderUnit. clip has manifest");
				//clip["initObject"](onAddedCallback);
				if(onRecievedManifestCallback!=null){
					onRecievedManifestCallback(clip["manifest"]);
				}
			}else{
				trace2("SWFLoaderUnit. clip has NO manifest");
			}
			/*if(clip.hasOwnProperty("onFirstFrameLoaded") && onAddedCallback != null){
				trace2("SWFLoaderUnit. clip has onFirstFrameLoaded");
				clip["onFirstFrameLoaded"](onAddedCallback);
			}else{
				trace2("SWFLoaderUnit. clip has NO onFirstFrameLoaded");
			}*/
			//clip.x = Math.random() * 50;
			//clip.y = Math.random() * 50;
			//clip.alpha = .3;
			if(clip is MovieClip) {
				(clip as MovieClip).stop();
			}
			
			if(str == "flash.display::AVM1Movie") {
				s_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeSWFLoadHandler);
				targetClip.addChild(s_loader);
			} else {
				if(targetClip != null) {
					trace2(_smName +":SWFLoaderUnit, targetClip " + targetClip.name);
					targetClip.addChild(clip);
				} else {
					trace2(_smName +":SWFLoaderUnit, no targetClip");
				}
				s_loader.unload();
			}
			trace2(_smName + "#" + _smID + ".requestingDone: " + event);
			
			requestTran(s_done);
			//dispatchEvent(new PlayheadEvent(EVT_COMPLETE));
			//dispatchEvent(event);
		}
		
	}
}
