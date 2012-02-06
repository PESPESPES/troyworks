/* Translates Loader events into CogEvents for use in state transitions */
package com.troyworks.core.cogs.proxies;

import flash.display.Loader;
import com.troyworks.core.cogs.CogSignal;
import com.troyworks.core.cogs.CogEvent;
import flash.events.EventDispatcher;
import com.troyworks.core.cogs.IStateMachine;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.HTTPStatusEvent;
import flash.events.SecurityErrorEvent;

class LoaderProxy {

	var ldr : Loader;
	var sm : IStateMachine;
	static public var SIG_LOADER_IO_ERROR : CogSignal = CogSignal.getNextSignal("LOADER_IO_ERROR");
	static public var SIG_LOADER_HTTP_STATUS : CogSignal = CogSignal.getNextSignal("LOADER_HTTP_STATUS");
	static public var SIG_LOADER_SECURITY_ERROR : CogSignal = CogSignal.getNextSignal("SIG_LOADER_SECURITY_ERROR");
	static public var SIG_LOADER_COMPLETE : CogSignal = CogSignal.getNextSignal("SIG_LOADER_COMPLETE");
	public function new(loader : Loader, stateMachine : IStateMachine) {
		super();
		ldr = loader;
		sm = stateMachine;
		ldr.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
		ldr.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHttpStatus);
		ldr.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
		ldr.addEventListener(Event.COMPLETE, handleComplete);
	}

	function handleIOError(event : IOErrorEvent) : Void {
		trace("Load failed: IO Error" + event.text);
		var evt : CogEvent = new CogEvent(CogEvent.EVTD_COG_PUBLIC_EVENT, SIG_LOADER_IO_ERROR);
		sm.dispatchEvent(evt);
	}

	function handleHttpStatus(event : HTTPStatusEvent) : Void {
		trace("Load failed: Http Status" + event.status);
		var evt : CogEvent = new CogEvent(CogEvent.EVTD_COG_PUBLIC_EVENT, SIG_LOADER_HTTP_STATUS);
		sm.dispatchEvent(evt);
	}

	function handleSecurityError(event : IOErrorEvent) : Void {
		trace("Load failed: Security Error" + event.text);
		var evt : CogEvent = new CogEvent(CogEvent.EVTD_COG_PUBLIC_EVENT, SIG_LOADER_SECURITY_ERROR);
		sm.dispatchEvent(evt);
	}

	function handleComplete(event : Event) : Void {
		trace("Load completed: " + event);
		var evt : CogEvent = new CogEvent(CogEvent.EVTD_COG_PUBLIC_EVENT, SIG_LOADER_COMPLETE);
		sm.dispatchEvent(evt);
	}

}
