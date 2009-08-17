package com.troyworks.util.datetime {
	import com.troyworks.events.EventWithArgs;	

	import flash.utils.clearTimeout;	
	import flash.utils.getTimer;
	import flash.utils.setTimeout;	
	import flash.events.EventDispatcher;
	import flash.events.Event;

	//////////////////////////////////////////////////////////////
	//Generic stopwatch class used for evaluating performance
	// used like
	// watch = new StopWatch();
	// //in some method...e.g. on sendData
	// watch.start(); // or reset();
	// //in the same or some other method e.g. OnData
	// watch.stop();
	// trace("duration " + watch.getSeconds());
	// WHAT of states, e.g. stopped, started, paused etc.
	// events on state changes
	// alarm mode, timer mode, reminder mode (check againts an array of times)
	
	
	/*
	 * DEMO CODE BEGIN--------------------------------------------------- 
	 import com.troyworks.util.datetime.*;


var sp:StopWatch;




var watchMode = 4;
switch (watchMode) {

	case 1 :
		sp = new StopWatch();
		break;
	case 2 :
		sp = new StopWatch(true);
		break;
	case 3 :
		sp = new StopWatch(false, -10000);
		break;
	case 4 :
		sp = new StopWatch(true, -10000);
		break;
}

var logger:StopWatchLogger = new StopWatchLogger();
logger.addWatch(sp);

function startTheWatch():void {
	sp.start();
	setTimeout(stopTheWatch, 1000);
}


function stopTheWatch():void {
	sp.stop();
	trace("elapsed " + TimeDateFormat.toStopWatchString(sp.elapsedTime));
	startTheWatch();
}
startTheWatch();
 * 
 * /////////////// RESULTS ///////////////////////
 
	// MODE 1 COUNTUP + non-persistant 
	new StopWatch()
	StopWatch.start()
	StopWatch.stop()

	elapsed 00:01
	StopWatch.start()
	StopWatch.stop()

	elapsed 00:01
	StopWatch.start()
	StopWatch.stop()

	elapsed 00:01
	 * 
	 //MODE 1 COUNTUP + persistent
	 * new StopWatch()
	StopWatch.start()
	StopWatch.stop()

	elapsed 00:01
	StopWatch.start()
	StopWatch.stop()

	elapsed 00:02
	StopWatch.start()
	StopWatch.stop()
	elapsed 00:03
	StopWatch.start()
	StopWatch.stop()
	elapsed 00:04
	StopWatch.start()
	 *
	 *
	 *new StopWatch( persist:false durationInMS: -10000 startTimeMS NaN)
	StopWatch.start( MODE_COUNTDOWN )
	StopWatch.stop()
	elapsed 00:01
	StopWatch.start( MODE_COUNTDOWN )
	StopWatch.stop()
	elapsed 00:01
	StopWatch.start( MODE_COUNTDOWN )
	StopWatch.stop()
	elapsed 00:01
	StopWatch.start( MODE_COUNTDOWN )
	 * 
	 * 
	 * 
	 * 
	 * 
	 * new StopWatch( persist:true durationInMS: -10000 startTimeMS NaN)
	StopWatch.start( MODE_COUNTDOWN )
	StopWatch.stop()
	elapsed 00:01
	StopWatch.start( MODE_COUNTDOWN )
	StopWatch.stop()
	elapsed 00:02
	StopWatch.start( MODE_COUNTDOWN )
	StopWatch.stop()
	elapsed 00:03
	StopWatch.start( MODE_COUNTDOWN )
	StopWatch.stop()
	elapsed 00:04
	StopWatch.start( MODE_COUNTDOWN )
	StopWatch.stop()
	elapsed 00:05
	StopWatch.start( MODE_COUNTDOWN )
	StopWatch.stop()
	elapsed 00:06
	StopWatch.start( MODE_COUNTDOWN )
	StopWatch.stop()
	elapsed 00:07
	StopWatch.start( MODE_COUNTDOWN )
	StopWatch.stop()
	elapsed 00:08
	StopWatch.start( MODE_COUNTDOWN )
	StopWatch.stop()
	elapsed 00:09
	StopWatch.start( MODE_COUNTDOWN )
	StopWatch.complete()
	StopWatch.stop()
	StopWatch.stop()
	elapsed 00:10
	StopWatch.start( MODE_COUNTDOWN )
	StopWatch.stop()
	elapsed 00:11
	 *
	 *
	 *
	 *
	 *
	 * */

	
	
	
	public class StopWatch extends EventDispatcher {
		public static const STOP : String = "STOP";
		public static const START : String = "START";
		public static const RESET : String = "RESET";
		public static const COMPLETE : String = "COMPLETE";
		public static const SPLIT : String = "SPLIT";

		public var startTime : Date = null;//new Date();
		public var endTime : Date = null;//new Date();
		private var _elapsedTime : Number = 0;
		public var persistent : Boolean;

		
		private var _hasStarted : Boolean = false;
		private var _hasCompleted : Boolean = false;

		private var _isRunning : Boolean = false;

		
		public static const MODE_COUNTUP : String = "MODE_COUNTUP";
		public static const MODE_COUNTDOWN : String = "MODE_COUNTDOWN";
		private var mode : String = MODE_COUNTUP;

		/////////// COUNTDOWN /////////////////
		public var durationMS : Number = 0;
		private var _intV : Number;
		private static var _referenceDate:Date = new Date();
		public static var IDZ:int = 1; 
		public var id:Number =IDZ++;
		

		
		
		public function StopWatch(persist : Boolean = false, durationInMS : Number = 0,  startTimeMS : Number = NaN) {
			
			super();
			trace("new StopWatch( + "+ id+ " persist:" + persist + " durationInMS: " + durationInMS + " startTimeMS " + startTimeMS + ")");
			zero();
			persistent = persist;
			
			if(!isNaN(startTimeMS)) {
				startTime = new Date();
				startTime.setTime( startTimeMS);
			}
			
			if(durationInMS < 0) {
				mode = MODE_COUNTDOWN;	
				durationMS = Math.abs(durationInMS);
			}
		}

		public function start() : void {
			trace("StopWatch+"+id +".start() "+_hasCompleted);
			switch(mode) {
				case MODE_COUNTUP:
					if(!persistent) {
						endTime = null;
						startTime = getNowDate();//.time = getNow();// = (startTime == null) ? new Date() : new Date();
					}else {			  
						endTime = null;
						
						startTime = (startTime == null) ? getNowDate() : startTime;
					}
					break;
				case MODE_COUNTDOWN:
					if(!persistent) {
						
						_hasCompleted = false;
						_intV = setTimeout(complete, durationMS);
						trace("coundown mode"+ _intV);
						endTime = null;
						startTime = getNowDate();
//						startTime.setTime(getNow());// = (startTime == null) ? new Date() : new Date();
					}else {
						
						if(!_hasCompleted) {
						
							_intV = setTimeout(complete, durationMS - _elapsedTime);
							trace("coundown mode2"+ _intV);
							endTime = null;
							startTime = (startTime == null) ? getNowDate(): startTime;
						}
					}
					break;
			}
			
			trace("StopWatch.start( " + mode + " ) " + startTime);
			
			_hasStarted = true;
			_isRunning = true;
			dispatchEvent(new Event(START));
		}

		public function complete() : void {
			_hasCompleted = true;
			trace("StopWatch+"+id +".complete(" + _intV + " )");
			clearTimeout(_intV);
			stop();	
			dispatchEvent(new Event(COMPLETE));
		}

		public function stop() : void {
			trace("StopWatch.stop()");
			clearTimeout(_intV);
			endTime = getNowDate();
			_elapsedTime = endTime.getTime() - startTime.getTime();
		
			switch(mode) {
				case MODE_COUNTUP:
			  
					break;
				case MODE_COUNTDOWN:
					clearTimeout(_intV);
					// = setTimeout(complete, durationMS);
					break;
			}
			_isRunning = false;
			dispatchEvent(new Event(STOP));
		}
		public function getNow():Number{
			return _referenceDate.getTime() + getTimer();
		}
		public function getNowDate():Date{
			var res:Date = new Date(_referenceDate.getTime() + getTimer());
		//	trace("getNowDate" + res);
			return res;
		}
		public function reset() : void {
			//startTime.setTime(getNow());// = new Date();
			//endTime.setTime(getNow());
			switch(mode) {
				case MODE_COUNTUP:
			  
					break;
				case MODE_COUNTDOWN:
					clearTimeout(_intV);
				//	_intV = setTimeout(complete, durationMS);
					break;
			}
			startTime = getNowDate();
			endTime = getNowDate();
			//endTime.time = getNow();// = new Date();
			_elapsedTime = 0;
			
			_hasCompleted = false;
			dispatchEvent(new Event(RESET));
		}

		public function addSplit(logName : String) : void {
			
			var evt : EventWithArgs = new EventWithArgs(SPLIT);
			evt.args = [logName];
			dispatchEvent(evt);
		}

		public function zero() : void {
			startTime = null;
			endTime   = null;
			_elapsedTime = 0;
			
			switch(mode) {
				case MODE_COUNTUP:
			  
					break;
				case MODE_COUNTDOWN:
					clearTimeout(_intV);
					_intV = setTimeout(complete, durationMS);
					break;
			}
		}

		public function get hasStarted() : Boolean {
			return _hasStarted;
		}

		public function get isRunning() : Boolean {
			return _isRunning;
		}

		public function get timeStamp() : Date {
			var res:Date = getNowDate();
//			res.time = getNow();
			return res;
		}

		//this updates the elapsed time
		public function get elapsedTime() : Number {
			//if stopped
			//if running
			if(_hasStarted) {
				if(_isRunning) {
					//trace("getNOw" + getNow());
				//	trace("startTime " + startTime);
					_elapsedTime = getNow() - startTime.getTime();
				}else {
					_elapsedTime = endTime.getTime() - startTime.getTime();
				}
			}
			return _elapsedTime;
		}

		override public function toString() : String {
			var res : String = "StopWatch " + elapsedTime;
			return res;
		}
	}
}