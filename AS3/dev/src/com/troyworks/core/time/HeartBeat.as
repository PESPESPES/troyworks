package com.troyworks.core.time {
	import flash.events.TimerEvent;	
	import flash.utils.Timer;	
	
	/**
	 * HeartBeat
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Nov 7, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class HeartBeat {
		
			private const BASE_INTERVAL:Number = 1000;
			private var _creepingTimer:Timer = new Timer(BASE_INTERVAL);
			private var _steadyTimer:Timer = new Timer(BASE_INTERVAL);
			private var _startTime:Date;
 			public static const LOGMSG:String = "\r{0}";
 			
 			public var creepingLog:Array = new Array();
 			public var steadyLog:Array = new Array();
 			
 			public function HeartBeat() {
 				
 			}
			private function init() : void
			{
				_creepingTimer.addEventListener(TimerEvent.TIMER, onCreepingTimer);
				_creepingTimer.start();
				_steadyTimer.addEventListener(TimerEvent.TIMER, onSteadyTimer);
				_steadyTimer.start();
				_startTime = new Date();
			}
 
			private function onCreepingTimer(e:TimerEvent) : void
			{
				var now:Date = new Date();
				var deltaMS:int = now.time - _startTime.time;
				creepingLog.text += LOGMSG.replace("{0}", deltaMS); 
			}
 
			private function onSteadyTimer(e:TimerEvent) : void
			{
				var now:Date = new Date();
				var deltaMS:int = now.time - _startTime.time;
				steadyLog.text += LOGMSG.replace("{0}", deltaMS);
				var offset:int = deltaMS % BASE_INTERVAL;
				_steadyTimer.delay = offset < 500 ? BASE_INTERVAL - offset : BASE_INTERVAL;
			}
 
		
	}
}
