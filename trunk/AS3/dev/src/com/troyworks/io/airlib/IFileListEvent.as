package com.troyworks.io.airlib
{
	import flash.events.Event;
	import flash.events.FileListEvent;
	
	public class IFileListEvent extends FileListEvent
	{
		public static const DIRECTORY_LISTING:String = 'directoryListing';
		public static const SELECT_MULTIPLE:String = 'selectMultiple';
		
		public function IFileListEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, files:Array = null)
		{
			super(type, bubbles, cancelable, files);
		}
	}
}