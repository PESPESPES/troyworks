package com.troyworks.io{

    import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
    import flash.events.*;
    import flash.net.URLRequest;
	import flash.display.DisplayObject;

    public class NonVisibleMCLoader extends MovieClip {
        private var url:String = "test.jpg";
        public var lt_mc:MovieClip;
		protected var _loader:Loader;


        public function NonVisibleMCLoader() {

			/////////////////////////////////////
			_loader = new Loader();
            configureListeners(_loader.contentLoaderInfo);
            _loader.addEventListener(MouseEvent.CLICK, clickHandler);
            var request:URLRequest = new URLRequest(url);
            _loader.load(request);
			
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
			var clip:DisplayObject = DisplayObject(LoaderInfo(event.target).content);
			clip.width = lt_mc.width;
			clip.height = lt_mc.height;
			lt_mc.addChild(clip);
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