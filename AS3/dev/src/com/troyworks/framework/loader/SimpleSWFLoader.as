package com.troyworks.framework.loader {
	import flash.events.IOErrorEvent;	

	import com.troyworks.ui.LoaderXtraParams;	

	import flash.display.DisplayObject;	
	import flash.display.DisplayObjectContainer;	
	import flash.display.Sprite;	
	import flash.events.Event;	
	import flash.net.URLRequest;	
	import flash.display.Loader;	

	import com.troyworks.framework.loader.LoaderUtil;

	import flash.utils.getQualifiedClassName;	

	/**
	 * SWFLoader
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Jun 7, 2008
	 * DESCRIPTION ::
	 * A basic example of loading a SWF in AS3 with bandwidth detection
	 * and non visible preloading, and reuseable.
	 *
	 *
	 *loadSWF();
	 */
	public class SimpleSWFLoader extends Sprite {

		public var s_loader : LoaderXtraParams;
		private var s_loaderUtil : LoaderUtil;
		public var mediaURL : String = "B.swf"; 
		//	//"TroyWorks-80x80.jpg"; //
		public var targetClip : DisplayObjectContainer;
		private var _exists : Boolean = false;
		public var callback : Function;


		public function SimpleSWFLoader() {
			super();
			setupLoader(); 	
		}

		public function setupLoader() : void {
			/////////////////////////////////////
			s_loader = new LoaderXtraParams();
			s_loaderUtil = new LoaderUtil(s_loader.contentLoaderInfo);
			s_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onChildErrored);
			s_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeSWFLoadHandler);
		}

		public function onChildErrored(evt : Event = null) : void {
			_exists = false;
			if(callback != null) {
				callback(mediaURL, _exists);
			}
		}

		public function exists() : Boolean {
			return _exists;
		}

		public function loadMovie(mediaURL : String, targetMC : DisplayObjectContainer = null) : void {
			targetClip = targetMC;
			this.mediaURL = mediaURL;
			trace("loadMovie '" + this.mediaURL + "'");
			var request : URLRequest = new URLRequest(this.mediaURL);
			
			s_loader.load(request);
			

			// addChild(_loader);
		}

		
		public function completeSWFLoadHandler(event : Event) : void {
			var str : String = getQualifiedClassName(s_loader.content);
			trace("completeHandler: " + event + " " + str);
			//	var clip : Sprite = Sprite();
			//	s_loader.removeChild(s_loader.content);

			//	
			_exists = true;
			
			if(targetClip != null) {
				targetClip.addChild(s_loader.content);
			}
			try {
				if(str == "flash.display::AVM1Movie") {
					s_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeSWFLoadHandler);
					setupLoader();
				}else {
					s_loader.unload();
				}
			}catch(er : Error) {
				trace("Couldn't unload " + er);
			}
			if(callback != null) {
				callback(mediaURL, _exists);
			}
			
			dispatchEvent(event);
		}
	}
}
