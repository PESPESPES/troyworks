package com.troyworks.util { 
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
	
	public class StopWatch {
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
			}
		}
		
		public function stop():void  {
			endTime = new Date();
			elapsedTime = endTime.getTime()-startTime.getTime();
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
		
		public function toString():String{
			var res:String = "StopWatch " + getElapsedTime();
			return res;
		}
	}
	
}