package com.troyworks.io.fplib
{
	import flash.events.*;
	import flash.net.*;
	import flash.utils.ByteArray;
	import flash.errors.IllegalOperationError;
	import com.troyworks.io.fplib.IFileMode;
	import com.troyworks.io.fplib.IAsyncAction;
	
	public class IFileStream extends ByteArray implements IEventDispatcher
	{
		// Flash.filesystem.FileStraem properties
		public var readAheadSize:Number = 0;
		
		// Properties implemented by extending ByteArray
		// public var bytesAvailable:uint;
		// public var endian;
		// public var objectEncoding:uint;
		// public var position:Number = 0;
		
		// Custom properties		
		public var file:IFile;
		protected var mode:String;
		protected var stream:URLStream;
		protected var loader:URLLoader;
		protected var eventDispatcher:EventDispatcher = new EventDispatcher(this as IEventDispatcher);
		protected var isOpen:Boolean = false;
		protected var useCache:Boolean = false;
		protected var asyncActions:Array = new Array;
		protected var asyncActionSeq:uint = 0;
		public var id:uint;
		
		public function open(file:IFile, mode:String):void
		{
			throw new IllegalOperationError("Synchronous FileStreams are not available in this implementation. Please use openAsync() instead.");
		}
		
		public function openAsync(file:IFile, mode:String):void
		{
			if (this.isOpen) {
				this.onClose(false);
			}
			
			if (this.file != null && this.file != file) {
				this.file.detachStream(this);				
			}

			if (this.file == null || this.file != file) {
				this.file = file;
				this.file.attachStream(this);
			}
			
			switch (mode)
			{
				case IFileMode.READ:
					readAhead();
					break;
					
				case IFileMode.WRITE:
				case IFileMode.APPEND:
				case IFileMode.UPDATE:
					break;
					
				default:
					throw new IllegalOperationError("Invalid FileMode specified (" + mode + ")");
					break;
			}
			
			this.isOpen = true;
			this.mode = mode;
			
			eventDispatcher.dispatchEvent(new Event(Event.OPEN));
		}

		public function close():void
		{
			var eventObject:*;
			if (mode == IFileMode.READ) {
				eventObject = this.stream;
			} else {
				eventObject = this.loader;
			}
			
			if (this.isOpen && eventObject != null) {				
				// Attach to pending COMPLETE event 
				eventObject.addEventListener(Event.COMPLETE, this.onClose);
			} else {				
				// Call onClose directly since it's already after COMPLETE
				this.onClose();
			}
		}
		
		private function onClose(dispatchClose:Boolean = true):void
		{
			this.file = null;
			this.length = 0;
			this.isOpen = false;
			
			if (dispatchClose) {
				var ev:Event = new Event(Event.CLOSE);
				this.eventDispatcher.dispatchEvent(ev);
			}
		}
		
		public function cancel()
		{
			//trace(this.asyncActions);
			
			for (var i in this.asyncActions) {
				this.asyncActions[i].close();
			}
			
			// Clear the action array of references
			this.asyncActions = new Array;
		}
		
		protected function readAhead()
		{
			stream = new URLStream;
			this.attachAction(new IAsyncAction(stream, this));
			stream.addEventListener(Event.COMPLETE, completeHandler);
            stream.addEventListener(Event.OPEN, openHandler);
            stream.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            stream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            stream.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            stream.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			//trace(this.file.url);

			var url:String;
			if (this.useCache) {
				url = this.file.url;
			} else {
				url = this.file.url + '?' + Math.floor(Math.random() * 1000000);
			}			
			var request:URLRequest = new URLRequest(url);
			
			try {
				stream.load(request);				
			} catch (error:Error) {
				//Debug.log("Unable to load requested doc");
			}
		}
		
		// public function truncate():void {}		
		
		private function completeHandler(ev:Event):void
		{
			this.isOpen = false;
			
			// Clean asyncActions?
			
			this.eventDispatcher.dispatchEvent(ev);			
		}
		
		private function openHandler(ev:Event):void {
            //trace("openHandler: " + ev);
        }

        private function progressHandler(ev:ProgressEvent):void {
			var ba:ByteArray = new ByteArray;
			stream.readBytes(ba);
			var curPos:int = this.position;
			this.position = this.length;
			this.writeBytes(ba);
			this.position = curPos;
			this.eventDispatcher.dispatchEvent(ev);
        }

        private function securityErrorHandler(ev:SecurityErrorEvent):void {
			this.eventDispatcher.dispatchEvent(ev);
        }

        private function httpStatusHandler(ev:HTTPStatusEvent):void {			
			this.eventDispatcher.dispatchEvent(ev);
        }

        private function ioErrorHandler(ev:IOErrorEvent):void {
			this.eventDispatcher.dispatchEvent(ev);
		}		
		
		/*
		 * Event Dispatcher interface
		 */
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			this.eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
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
		
		//public function writeBoolean(value:Boolean):void {}
		//public function writeByte(value:int):void {}
		
		override public function writeBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0):void
		{
			if (this.mode == IFileMode.READ) {
				return super.writeBytes(bytes, offset, length);
			}
			
			loader = new URLLoader;
			this.attachAction(new IAsyncAction(loader, this));
			loader.addEventListener(Event.COMPLETE, completeHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			var request:URLRequest = new URLRequest(this.file.url + '?mode=' + this.mode + '&position=' + this.position);
			request.method = 'post';
			request.data = bytes;
			
			try {
				loader.load(request);				
			} catch (error:Error) {
				trace("Unable to load requested doc");
			}
		}
		
		//public function writeDouble(value:Number):void {}
		//public function writeFloat(value:Number):void {}
		//public function writeInt(value:int):void {}
		//public function writeMultiByte(value:String, charSet:String):void {}
		//public function writeObject(object:*):void {}
		//public function writeShort(value:int):void {}
		//public function writeUnsignedInt(value:uint):void {}
		//public function writeUTF(value:String):void {}		
		
		override public function writeUTFBytes(value:String):void
		{
			var ba:ByteArray = new ByteArray;
			ba.writeUTFBytes(value);			
			this.writeBytes(ba);
		}
		
		/*
		 * These functions should be provided by ByteArray
		 */
		 
		//public function readBoolean():Boolean {}		
		//public function readByte():int {}		
		//public function readBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0):void {}
		//public function readDouble():Number {}		
		//public function readFloat():Number {}		
		//public function readInt():int {}		
		//public function readMultiByte(length:uint, charSet:String):String {}
		//public function readObject():* {}	
		//public function readShort():int {}		
		//public function readUnsignedByte():uint {}		
		//public function readUnsignedInt():uint {}
		//public function readUnsignedShort():uint {}
		//public function readUTF():String {}
		//public function readUTFBytes(length:uint) {}
		
		protected function attachAction(action:*):void
		{
			var id:uint = ++this.asyncActionSeq;
			this.asyncActions[id] = action;
			action.id = id;
		}
		
		public function detachAction(action:*):void
		{
			this.asyncActions[action.id] = null;
		}
	}
}