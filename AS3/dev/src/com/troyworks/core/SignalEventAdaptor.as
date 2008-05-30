/**
* This adapts events to other events, pushing unique event generation closer to the broadcaster, and 
* relieving the listener class from having to adapt the events internally.
* 
* UI.addEventDispatcher(MouseEvent.CLICK, new SignalEventAdaptor(cntrl.dispatchEvent, Signals.UNDO));
* @author Default
* @version 0.1
*/

package com.troyworks.core {
	import com.troyworks.core.cogs.CogEvent;
	import com.troyworks.core.cogs.CogSignal;
	import flash.events.Event;

	public class SignalEventAdaptor {
		
		private var _fn:Function;
		private var _sig:CogSignal;	
		private var _evntGen:Function;	
		public static const STANDARD:String = "standard";
		
		public static const PRIVATE:String = "private";
		public static const PROTECTED:String = "protected";
		public static const PUBLIC:String = "public";
				
		public function SignalEventAdaptor(functionToCall:Function, sig:CogSignal, scope:String = "protected") {
			_fn = functionToCall;
			_sig =sig;
			switch(scope){
				case STANDARD:
					_evntGen = _sig.createStandardEvent;
					break;
				case PRIVATE:
					_evntGen = _sig.createPrivateEvent;
					break;
				case PROTECTED:
				default:
					_evntGen = _sig.createProtectedEvent;
					break;
			}

		}
		public function relayEvent(evt:Event):void{
			
			var cevt:Event =  _evntGen();
			if(cevt is CogEvent){
				CogEvent(cevt).origEvent = evt;
			}
			trace("relayEvent " + cevt + " " +cevt.type);
			trace("fn " + _fn);
			_fn(cevt);
		}
		
	}
	
}
