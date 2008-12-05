package com.troyworks.io.airlib
{
	import flash.filesystem.FileStream;
	import com.troyworks.io.airlib.DispatcherProxy;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import flash.utils.getQualifiedClassName;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class IFileStream extends Proxy implements IEventDispatcher
	{
		protected var fileStream:FileStream = new FileStream;
		protected var eventDispatcher:EventDispatcher = new EventDispatcher(this as IEventDispatcher);
		protected var _file:IFile;
		
		public function get file():IFile
		{
			return this._file;
		}
		
		override flash_proxy function callProperty(methodName:*, ... args):*
		{
        	switch (methodName.toString())
			{
				// Block synchronous functions
            	case 'open':
					throw new IllegalOperationError("Synchronous operations are not available in this implementation. Please use [method]Async() version instead.");
					
				case 'openAsync':
					// Need to watch out for this reference after the stream is closed
					this._file = args[0];
				
				default:
					// Unwrap IFile into flash.filesystem.File
					var cn:String = getQualifiedClassName(args[0]);					
					if (cn.substr(cn.lastIndexOf('::') + 2) == 'IFile') {
						args[0] = args[0].file;
					}					
					return this.fileStream[methodName.toString()].apply(this.fileStream, args);
	        }
	    }
		
		override flash_proxy function getProperty(name:*):*
		{
			return this.fileStream[name];
	    }
		
		override flash_proxy function setProperty(name:*, value:*):void
		{
			this.fileStream[name] = value;
	    }
		
		/*
		 * Event Dispatcher interface
		 */
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			this.eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
			// Proxy the event
			var dp:DispatcherProxy = new DispatcherProxy(this);
			this.fileStream.addEventListener(type, dp.onEvent, useCapture, priority, useWeakReference);
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
			this.eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return this.eventDispatcher.willTrigger(type);
		}
	}
}