﻿﻿package com.troyworks.core.cogs.proxies {

	import flash.net.URLLoader;
	import com.troyworks.core.cogs.CogSignal;
	import com.troyworks.core.cogs.CogEvent;
	import flash.events.EventDispatcher;
	import com.troyworks.core.cogs.IStateMachine;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.SecurityErrorEvent;
	/*
	 * Translate URLLoader events in to CogEvents for state transitions.
	
			public static const SIG_URLLOADER_IO_ERROR : CogSignal = URLLoaderProxy.SIG_URLLOADER_IO_ERROR;
		public static const SIG_URLLOADER_HTTP_STATUS : CogSignal = URLLoaderProxy.SIG_URLLOADER_HTTP_STATUS;
		public static const SIG_URLLOADER_SECURITY_ERROR : CogSignal = URLLoaderProxy.SIG_URLLOADER_SECURITY_ERROR;
		public static const SIG_URLLOADER_COMPLETE : CogSignal = URLLoaderProxy.SIG_URLLOADER_COMPLETE;
	*/	
	public class URLLoaderProxy  {
		private var ldr:URLLoader;
		private var sm:IStateMachine;
		
		public static const SIG_URLLOADER_IO_ERROR:CogSignal = CogSignal.getNextSignal("URLLOADER_IO_ERROR");
		public static const SIG_URLLOADER_HTTP_STATUS:CogSignal = CogSignal.getNextSignal("URLLOADER_HTTP_STATUS");
		public static const SIG_URLLOADER_SECURITY_ERROR:CogSignal = CogSignal.getNextSignal("SIG_URLLOADER_SECURITY_ERROR");
		public static const SIG_URLLOADER_COMPLETE:CogSignal = CogSignal.getNextSignal("SIG_URLLOADER_COMPLETE");
		
		public function URLLoaderProxy(loader:URLLoader, stateMachine:IStateMachine){
			super();
			ldr = loader;
			sm = stateMachine;
			ldr.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
		  	ldr.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHttpStatus);
		  	ldr.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
		  	ldr.addEventListener(Event.COMPLETE, handleComplete);	
		}
		public function handleIOError(event:IOErrorEvent):void{
			trace("Load failed: IO Error" + event.text);		
			var evt:CogEvent = new CogEvent(CogEvent.EVTD_COG_PUBLIC_EVENT, SIG_URLLOADER_IO_ERROR);
			sm.dispatchEvent(evt);

		}
		public function handleHttpStatus(event:HTTPStatusEvent):void{
			trace("Load failed: Http Status" + event.status);		
			var evt:CogEvent = new CogEvent(CogEvent.EVTD_COG_PUBLIC_EVENT, SIG_URLLOADER_HTTP_STATUS);
			sm.dispatchEvent(evt);

		}
		public function handleSecurityError(event:IOErrorEvent):void{
			trace("Load failed: Security Error" + event.text);		
			var evt:CogEvent = new CogEvent(CogEvent.EVTD_COG_PUBLIC_EVENT, SIG_URLLOADER_SECURITY_ERROR);
			sm.dispatchEvent(evt);

		}
		public function handleComplete(event:Event):void{
			trace("XXXXXXXXXXLOAD LOAD XXXXXXXXXXXXXX");
			trace("Load completed: " + event);				
			var evt:CogEvent = new CogEvent(CogEvent.EVTD_COG_PUBLIC_EVENT, SIG_URLLOADER_COMPLETE);
			sm.dispatchEvent(evt);
		}
	}
}