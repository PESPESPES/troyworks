package com.troyworks.io.airlib
{
	public class DispatcherProxy
	{
		protected var dstDispatcher:Object;
		
		public function DispatcherProxy(dstDispatcher:Object)
		{
			this.dstDispatcher = dstDispatcher;
		}
		
		public function onEvent(ev:*):void
		{
			this.dstDispatcher.dispatchEvent(ev);
		}
	}
}