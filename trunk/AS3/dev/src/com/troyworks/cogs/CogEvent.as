package com.troyworks.cogs{
	import flash.events.Event;
import flash.utils.getTimer;
	import com.troyworks.cogs.CogSignal;
	/* this mimics the general event model in Actionscript 3.0
	* events are immutable, this differs from Mirek's model
	* which are generally structs which flash doesn't have 
	*/
	public class CogEvent extends Event {
		private var _sig:CogSignal;
		private var _startTime:Number;
		private var _endTime:Number;
		private var duration:Number;
		
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
		public override function clone():Event {

			var ret:CogEvent = new CogEvent(type, _sig, bubbles, cancelable);
			return ret;

		}
		public override function toString():String{
			return "CogEvent." + _sig.toString();
		}
		///////////////// FACTORY METHODS  /////////////////////////////////
		public static function getEvent(signal:CogSignal):CogEvent {
			switch (signal) {
				default :
					{
						return new CogEvent(CogEvent.EVTD_COG_PROTECTED_EVENT,signal);

				}
			}
		};
		public static function getPulseEvent():CogEvent {
			return new CogEvent(EVTD_COG_PROTECTED_EVENT,CogSignal.PULSE);
		}
		public static function getEnterEvent():CogEvent {
			return new CogEvent(EVTD_COG_PROTECTED_EVENT,CogSignal.ENTRY);
		}
		public static function getExitEvent():CogEvent {
			return new CogEvent(EVTD_COG_PROTECTED_EVENT,CogSignal.EXIT);
		}
		public static function getCallbackEvent():CogEvent {
			return new CogEvent(EVTD_COG_PROTECTED_EVENT,CogSignal.CALLBACK);
		}
	}
}