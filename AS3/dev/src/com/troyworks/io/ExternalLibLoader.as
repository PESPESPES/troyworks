/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.io {

    import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.system.LoaderContext;
	import flash.display.MovieClip;
    import flash.display.Sprite;
	import flash.display.Sprite;
    import flash.events.*;
    import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.display.DisplayObject;
	import flash.system.ApplicationDomain;

    public class ExternalLibLoader extends Sprite {
        private var url:String = "AirLib.swf";
		protected var _loader:Loader;
		public var loadedClip:DisplayObject;

        public function ExternalLibLoader() {

			/////////////////////////////////////
			_loader = new Loader();
			 var ldrContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
            
            
            configureListeners(_loader.contentLoaderInfo);
            _loader.addEventListener(MouseEvent.CLICK, clickHandler);
            var request:URLRequest = new URLRequest(url);
            _loader.load(request, ldrContext);
			
           // addChild(loader);
        }

        private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(Event.INIT, initHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            dispatcher.addEventListener(Event.OPEN, openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(Event.UNLOAD, unLoadHandler);
        }

        private function completeHandler(event:Event):void {
            trace("completeHandler: " + event);
			loadedClip = DisplayObject(LoaderInfo(event.target).content);
		//	clip.width = lt_mc.width;
		//	clip.height = lt_mc.height;
		//	lt_mc.addChild(clip);
			dispatchEvent(event);
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void {
            trace("httpStatusHandler: " + event);
        }

        private function initHandler(event:Event):void {
            trace("initHandler: " + event);
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
            trace("ioErrorHandler: " + event);
        }

        private function openHandler(event:Event):void {
            trace("openHandler: " + event);
        }

        private function progressHandler(event:ProgressEvent):void {
            trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
        }

        private function unLoadHandler(event:Event):void {
            trace("unLoadHandler: " + event);
        }

        private function clickHandler(event:MouseEvent):void {
            trace("clickHandler: " + event);
            var loader:Loader = Loader(event.target);
            loader.unload();
        }
    }
}