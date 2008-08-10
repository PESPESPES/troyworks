package com.troyworks.io.airlib
{
	import flash.net.FileReference;
	import flash.filesystem.File;
	import flash.errors.IllegalOperationError;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.FileListEvent;
	import com.troyworks.io.airlib.IFileTimer;	
	
	public class IFile extends Proxy implements IEventDispatcher
	{
		// flash.filesystem.File properties for wrapping into IFile
		protected static var _applicationDirectory:IFile;
		protected static var _applicationStorageDirectory:IFile;
		protected static var _desktopDirectory:IFile;
		protected static var _documentsDirectory:IFile;
		protected static var _userDirectory:IFile;
		
		// Custom properties		
		protected var synchronousError:String = "Synchronous operations are not available in this implementation. Please use [method]Async() version instead."
		public var file:File;
		protected var eventDispatcher:EventDispatcher = new EventDispatcher(this as IEventDispatcher);
		
		// Event constants
		public static const STATUS = 'fileStatus';
		
		public function IFile(path:String, fsCallback:Function = null)
		{
			this.file = new File(path);
			if (fsCallback != null) {
				this.eventDispatcher.addEventListener(IFile.STATUS, fsCallback);
			}
		}
		
		public static function get applicationDirectory():IFile
		{
			if (IFile._applicationDirectory == null) {
				IFile._applicationDirectory = new IFile(File.applicationDirectory.url);
			}			
			return IFile._applicationDirectory;
		}
		
		public static function get applicationStorageDirectory():IFile
		{
			if (IFile._applicationStorageDirectory == null) {
				IFile._applicationStorageDirectory = new IFile(File.applicationStorageDirectory.url);
			}			
			return IFile._applicationStorageDirectory;
		}
		
		public static function get desktopDirectory():IFile
		{
			if (IFile._desktopDirectory == null) {
				IFile._desktopDirectory = new IFile(File.desktopDirectory.url);
			}			
			return IFile._desktopDirectory;
		}
		
		public static function get documentsDirectory():IFile
		{
			if (IFile._documentsDirectory == null) {
				IFile._documentsDirectory = new IFile(File.documentsDirectory.url);
			}			
			return IFile._documentsDirectory;
		}
		
		public static function get userDirectory():IFile
		{
			if (IFile._userDirectory == null) {
				IFile._userDirectory = new IFile(File.userDirectory.url);
			}			
			return IFile._userDirectory;
		}
		
		public static function get lineEnding():String
		{
			return File.lineEnding;
		}
		
		public static function get separator():String
		{
			return File.systemCharset;
		}
		
		public static function get systemCharset():String
		{
			return File.systemCharset;
		}		

		public function resolvePath(path:String):IFile
		{
			var rfile:File = this.file.resolvePath(path);
			return new IFile(rfile.url);
		}
		
		public static function createTempDirectoryAsync():IFile
		{
			var theDir:IFile = new IFile(File.createTempDirectory().url);			
			
			// This will fire off a delayed COMPLETE event on theDir
			new IFileTimer(theDir);
			
			return theDir;
		}
		
		public static function createTempFileAsync():IFile
		{
			var theFile:IFile = new IFile(File.createTempFile().url);

			// This will fire off a delayed COMPLETE event on theDir
			new IFileTimer(theFile);

			return theFile;
		}
		
		public function createDirectoryAsync():void
		{
			this.file.createDirectory();			
			this.eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function getDirectoryListingAsync():void
		{			
			this.file.getDirectoryListingAsync();
			this.file.addEventListener(FileListEvent.DIRECTORY_LISTING, onDirectoryListing);
		}
		
		protected function onDirectoryListing(ev:FileListEvent):void
		{
			// Dispatch an DIRECTORY_LISTING FileListEvent
			var fle:IFileListEvent = new IFileListEvent(IFileListEvent.DIRECTORY_LISTING);
			fle.files = ev.files;
			this.dispatchEvent(fle);
		}
		
		public static function getRootDirectories():Array
		{
			return File.getRootDirectories();
		}
		
		public function copyToAsync(newLocation:IFile, overwrite:Boolean = false):void
		{
			this.file.copyToAsync(newLocation.file, overwrite);			
			this.file.addEventListener(Event.COMPLETE, eventRepeater);
		}
		
		public function moveToAsync(newLocation:IFile, overwrite:Boolean = false):void
		{
			this.file.moveToAsync(newLocation.file, overwrite);
			this.file.addEventListener(Event.COMPLETE, eventRepeater);
		}
		
		override flash_proxy function getProperty(name:*):*
		{
			if (name == 'parent') {
				return new IFile(this.file.parent.url);
			}			
			return this.file[name];
	    }
		
		override flash_proxy function callProperty(methodName:*, ... args):*
		{
        	switch (methodName.toString())
			{
				// Block synchronous functions
            	case 'copyTo':
				case 'deleteDirectory':
				case 'deleteFile':
				case 'getDirectoryListing':
				case 'moveTo':
				case 'moveToTrash':
				case 'createTempDirectory':
				case 'createTempFile':
				case 'createDirectory':
					throw new IllegalOperationError(this.synchronousError);
				
				default:
					return this.file[methodName.toString()].apply(this.file, args);
	        }
	    }
		
		/*
		 * Event Dispatcher interface
		 */
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			this.eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);

			// Intercept IFile.STATUS and dispatch event
			if (type == IFile.STATUS) {
				this.eventDispatcher.dispatchEvent(new Event(IFile.STATUS));
			}			
		}
		
		public function dispatchEvent(evt:Event):Boolean
		{
    	    return this.eventDispatcher.dispatchEvent(evt);
	    }
		
		public function hasEventListener(type:String):Boolean 
		{
			return this.eventDispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			return this.eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return this.eventDispatcher.willTrigger(type);
		}
		
		protected function eventRepeater(ev:Event):void
		{
			this.dispatchEvent(new Event(ev.type));
		}
	}
}