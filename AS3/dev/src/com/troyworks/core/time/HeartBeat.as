package com.troyworks.core.time {
	import flash.utils.getTimer;	
	import flash.events.TimerEvent;	
	import flash.utils.Timer;	

	/**
	 * HeartBeat
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Nov 7, 2008
	 * DESCRIPTION ::
	 * inspired by Colleta.org's work on offsetting timers.
	 */
	public class HeartBeat {

		private var BASE_INTERVAL : Number = 1000;
		private var _creepingTimer : Timer; 
		private var _steadyTimer : Timer;
		private var _startTime : Date;
		public static const LOGMSG : String = "{0}";

		public var creepingLog : Array = new Array();
		public var steadyLog : Array = new Array();
		public var lastTime:Number;
		public function HeartBeat(baseInterval : Number = 1000) {
			BASE_INTERVAL = baseInterval;
 				
			_creepingTimer = new Timer(BASE_INTERVAL);
			_steadyTimer = new Timer(BASE_INTERVAL);
			_creepingTimer.addEventListener(TimerEvent.TIMER, onCreepingTimer);
			_steadyTimer.addEventListener(TimerEvent.TIMER, onSteadyTimer);
		}

		public function play() : void {
			_creepingTimer.start();
			_steadyTimer.start();
			_startTime = new Date();
		}

		public function stop() : void {
			_creepingTimer.start();
			_steadyTimer.start();
		}

		public function gotoAndPlay() : void {
		}

		private function onCreepingTimer(e : TimerEvent) : void {
			var now : Date = new Date();
			var deltaMS : int = now.time - _startTime.time;
			creepingLog.push(getTimer()+" "+ LOGMSG.replace("{0}", deltaMS)); 
		}

		private function onSteadyTimer(e : TimerEvent) : void {
			var now : Date = new Date();
			
			var deltaMS : int = now.time - _startTime.time;
			steadyLog.push(getTimer()+" "+ LOGMSG.replace("{0}", deltaMS) + " " + (now.time-lastTime));
			var offset : int = deltaMS % BASE_INTERVAL;
			trace("delay "+( BASE_INTERVAL - offset ));
			_steadyTimer.delay =  Math.max(1,BASE_INTERVAL - offset -2);
			lastTime = now.time;
		}
		public function toString():String{
			var res:Array = new Array();
			var i:int = 0;
			var n:int =steadyLog.length;
			res.push("BASE " + BASE_INTERVAL+ "\r");
			res.push("CREEPING=================STEADY\r");
			for (; i < n; ++i)
			{	
				 res.push(i + " " + creepingLog[i]+ " " + steadyLog[i] +"\r");
			}
			return res.join("");  
		}
	}
}
