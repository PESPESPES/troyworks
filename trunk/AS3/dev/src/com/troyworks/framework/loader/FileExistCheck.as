package com.troyworks.framework.loader {
	import flash.utils.ByteArray;	
	import flash.net.URLLoaderDataFormat;	
	import flash.events.SecurityErrorEvent;	
	import flash.events.HTTPStatusEvent;	
	import flash.events.ProgressEvent;	
	import flash.events.IEventDispatcher;	
	import flash.net.URLLoader;	
	import flash.events.IOErrorEvent;	


	import flash.display.DisplayObject;	
	import flash.display.DisplayObjectContainer;	
	import flash.display.Sprite;	
	import flash.events.Event;	
	import flash.net.URLRequest;	
	import flash.display.Loader;	

	import com.troyworks.framework.loader.LoaderUtil;

	import flash.utils.getQualifiedClassName;	

	/**
	 * FileExistCheck
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Nov 8, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class FileExistCheck {

		public var s_loader : URLLoader ;
		private var s_loaderUtil : LoaderUtil;
		public var mediaURL : String = "B.swf"; 
		//	//"TroyWorks-80x80.jpg"; //
		public var targetClip : DisplayObjectContainer;
		private var _exists : Boolean = false;
		
		public var sizeInBytes:Number;
		public var callback : Function;

		public function FileExistCheck() {
			
			setupLoader(); 	
		}

		public function setupLoader() : void {
			/////////////////////////////////////
			s_loader = new URLLoader ();
			
			s_loader.dataFormat = URLLoaderDataFormat.BINARY;
			
			configureListeners(s_loader);
		}

		public function onChildErrored(evt : Event = null) :void{
			_exists = false;
			if(callback != null) {
				callback(mediaURL,_exists, NaN);
			}
		}

		public function exists() : Boolean {
			return _exists;
		}

		public function load(mediaURL : String) : void {
			this.mediaURL = mediaURL;
			trace("loadMovie '" + this.mediaURL + "'");
			var request : URLRequest = new URLRequest(this.mediaURL);
			try{
			s_loader.load(request);
			}catch(er:Error){
				onChildErrored();
			}

			// addChild(_loader);
		}
        private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(Event.OPEN, openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        }

        private function completeHandler(event:Event):void {
            sizeInBytes = (s_loader.data as ByteArray).length;
            trace("completeHandler: " + sizeInBytes);
    
          //  var vars:URLVariables = new URLVariables(loader.data);
          //  trace("The answer is " + vars.answer);
          //  		var str : String = getQualifiedClassName(s_loader.data);
			//trace("completeHandler: " + event + " " + str);
			//	var clip : Sprite = Sprite();
			//	s_loader.removeChild(s_loader.content);
		
	//		dispatchEvent(event);
			//	
			_exists = true;
			if(callback != null) {
				callback(mediaURL, _exists, sizeInBytes);
			}
        }

        private function openHandler(event:Event):void {
            trace("openHandler: " + event);
        }

        private function progressHandler(event:ProgressEvent):void {
            trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
        }

        private function securityErrorHandler(event:SecurityErrorEvent):void {
            trace("securityErrorHandler: " + event);
            onChildErrored();
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void {
            trace("httpStatusHandler: " + event);
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
            trace("ioErrorHandler: " + event);
            onChildErrored();
        }
		
	
	}
	
}
