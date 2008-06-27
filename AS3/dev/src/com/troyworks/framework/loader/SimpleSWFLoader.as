package com.troyworks.framework.loader {
	import flash.display.Sprite;	
	import flash.events.Event;	
	import flash.net.URLRequest;	
	import flash.display.Loader;	
	
	import com.troyworks.framework.loader.LoaderUtil;

	/**
	 * SWFLoader
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Jun 7, 2008
	 * DESCRIPTION ::
	 * A basic example of loading a SWF in AS3 with bandwidth detection
	 * and non visible preloading
	 *
	 *
	 *loadSWF();
	 */
	public class SimpleSWFLoader extends Sprite{

		private var s_loader : Loader;
		private var s_loaderUtil : LoaderUtil;
		public var mediaURL : String = "B.swf"; //	//"TroyWorks-80x80.jpg"; //
		public var targetClip:Sprite;
		
		public function loadSWF() :void{

			/////////////////////////////////////
			s_loader = new Loader();
			s_loaderUtil = new LoaderUtil(s_loader.contentLoaderInfo);
		
			s_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeSWFLoadHandler);
			var request : URLRequest = new URLRequest(mediaURL);
			s_loader.load(request);

			// addChild(_loader);
		}

		
		public function completeSWFLoadHandler(event : Event) : void {
			trace("completeHandler: " + event);
			var clip : Sprite = Sprite(Loader(event.target.loader).content);
			targetClip.addChild(clip);
			dispatchEvent(event);
		}

	}
}
