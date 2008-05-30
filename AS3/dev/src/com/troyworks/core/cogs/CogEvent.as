package com.troyworks.core.cogs{

	import flash.events.Event;
	import flash.utils.getTimer;
	import com.troyworks.core.cogs.CogSignal;
	/* this mimics the general event model in Actionscript 3.0
	* events are immutable, this differs from Mirek's model
	* which are generally structs which flash doesn't have 
	*/
	dynamic public class CogEvent extends Event {
		private var _sig:CogSignal;
		private var _startTime:Number;
		private var _endTime:Number;
		private var duration:Number;
		public var origEvent:Event;
		private var _isHandled:Boolean = false;
		private var _continuePropogation:Boolean = true;
		
		public static  const EVTD_COG_PRIVATE_EVENT:String = "EVTD_COG_PRIVATE_EVENT";
		public static  const EVTD_COG_PROTECTED_EVENT:String = "EVTD_COG_PROTECTED_EVENT";
		public static  const EVTD_COG_PUBLIC_EVENT:String = "EVTD_COG_PUBLIC_EVENT";

 		public static const EVT_INIT:CogEvent  =  new CogEvent(EVTD_COG_PROTECTED_EVENT,CogSignal.INIT);
		public static const EVT_EMPTY:CogEvent =new CogEvent(EVTD_COG_PROTECTED_EVENT,CogSignal.EMPTY);
		
		
		
		public function CogEvent(type:String, signal:CogSignal,bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			_sig = (signal == null)?CogSignal.EMPTY:signal;
		}
		public function get sig():CogSignal {
			return _sig;
		}
		public function start():void{
			_startTime = getTimer();
		}
		public function consumed():void{
			_endTime = getTimer();			
			duration = _endTime - _startTime;
		}
		public function getProcessedInMS():Number{
			return duration;
		}
		public function get isHandled():Boolean{
			return _isHandled;
		}
		public function set isHandled(handled:Boolean):void{
			_isHandled = handled;
		}
		public function get continuePropogation():Boolean{
			return _continuePropogation;
		}
		public function set continuePropogation(continueDispatching:Boolean):void{
			_continuePropogation = continueDispatching;
		}

		public override function clone():Event {

			var ret:CogEvent = new CogEvent(type, _sig, bubbles, cancelable);
			return ret;

		}
		public override function toString():String{
			return "CogEvent." + _sig.toString();
		}
		///////////////// FACTORY METHODS  /////////////////////////////////
		public static function getEvent(signal:CogSignal, optionalArgs:Object = null):CogEvent {
			switch (signal) {
				default :
					{
						var res:CogEvent = new CogEvent(CogEvent.EVTD_COG_PROTECTED_EVENT,signal);
						if(optionalArgs != null){
							decorateEventWithOptionalArgs(res, optionalArgs);
						}
						return res;
					}
			}
		}
		public static function decorateEventWithOptionalArgs(evt:CogEvent, optionalArgs:Object):void{
			for(var i:String in optionalArgs){
				//only works if dynamic class, appends to prototype
				evt[i] = optionalArgs[i];
			}
		}

		public static function getPulseEvent(optionalArgs:Object= null):CogEvent {
			var res:CogEvent = getEvent(CogSignal.PULSE, optionalArgs);
			return res;
		}
		public static function getEnterEvent(optionalArgs:Object= null):CogEvent {
			var res:CogEvent = getEvent(CogSignal.ENTRY, optionalArgs);
			return res;
		}
		public static function getExitEvent(optionalArgs:Object= null):CogEvent {
			var res:CogEvent = getEvent(CogSignal.EXIT, optionalArgs);
			return res;
		}
		public static function getCallbackEvent(optionalArgs:Object= null):CogEvent {
			var res:CogEvent = getEvent(CogSignal.CALLBACK, optionalArgs);
			return res;
		}
	}
}