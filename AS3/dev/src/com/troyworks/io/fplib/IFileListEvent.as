package com.troyworks.io.fplib
{
	import flash.events.Event;
	
	public class IFileListEvent extends Event
	{
		public var files:Array = new Array;
		
		public static const DIRECTORY_LISTING:String = 'directoryListing';
		public static const SELECT_MULTIPLE:String = 'selectMultiple';
		
		public function IFileListEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, files:Array = null)
		{
			super(type, bubbles, cancelable);
		}
	}
}