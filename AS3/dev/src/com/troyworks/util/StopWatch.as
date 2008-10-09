package com.troyworks.util {
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
	/////////////////////////////////////////////////////////////
	
	public class StopWatch extends EventDispatcher
	{
		public static const STOP="STOP";
		public static const START="START";
		public static const RESET="RESET";
		
		public var startTime:Date;
		public var endTime:Date;
		public var elapsedTime:Number;
		public var persistent:Boolean;
		
		public function StopWatch(persist:Boolean = false) {
			trace("StopWatch");
			zero();
			persistent = persist;
		}
		public function start():void {
			if(!persistent){
				endTime = null;
				startTime =  new Date();
				dispatchEvent(new Event(START));
			}
		}
		
		public function stop():void  {
			endTime = new Date();
			elapsedTime = endTime.getTime()-startTime.getTime();
			dispatchEvent(new Event(STOP));
		}
		
		public function zero():void  {
			startTime = null;
			endTime = null;
			elapsedTime = 0;
		}
		
		public function reset():void  {
			startTime =  new Date();
			endTime = new Date();
			elapsedTime = 0;
			dispatchEvent(new Event(RESET));
		}
		//this updates the elapsed time
		public function getElapsedTime():Number{
			//if stopped
			//if running
			if(startTime != null){
				if(endTime != null){
					elapsedTime = endTime.getTime() - startTime.getTime();
				}else{
					elapsedTime =  new Date().getTime() - startTime.getTime();
				}
			}
			return elapsedTime;
		}
	
		public function getSeconds():String {
			var secs:Number = elapsedTime/1000;
			return secs+" Seconds";
		}
		
		override public function toString():String{
			var res:String = "StopWatch " + getElapsedTime();
			return res;
		}
	}
	
}