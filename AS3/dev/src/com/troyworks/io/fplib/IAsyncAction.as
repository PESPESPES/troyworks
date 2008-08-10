package com.troyworks.io.fplib
{
	import flash.events.Event;
	
	public class IAsyncAction
	{
		// Key from the FileStream.asyncActions array
		public var id:int;
		
		// Parent FileStream
		protected var stream:IFileStream;
		
		// Child URLLoader or URLStream
		protected var action:*;
		
		public function IAsyncAction(action:*, stream:IFileStream)
		{
			this.action = action;
			this.action.addEventListener(Event.COMPLETE, onComplete);
			this.stream = stream;
		}
		
		public function close()
		{
			this.action.close();
			this.onComplete();
		}
		
		public function onComplete(ev:Event = null)
		{
			this.stream.detachAction(this);
			delete this;
		}
	}
}