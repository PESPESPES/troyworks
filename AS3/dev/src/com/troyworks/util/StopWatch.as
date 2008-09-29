package com.troyworks.util { 
	//////////////////////////////////////////////////////////////
	//Generic stopwatch class used for evaluating performance
	// used like
	// this.watch = new StopWatch();
	// //in some method...e.g. on sendData
	// this.watch.start(); // or reset();
	// //in the same or some other method e.g. OnData
	// this.watch.stop();
	// trace("duration " + this.watch.getSeconds());
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
			this.zero();
			this.persistent = persist;
		}
		public function start():void {
			if(!this.persistent){
				this.endTime = null;
				this.startTime =  new Date();
			}
		}
		
		public function stop():void  {
			this.endTime = new Date();
			this.elapsedTime = this.endTime.getTime()-this.startTime.getTime();
		}
		public function zero():void  {
			this.startTime = null;
			this.endTime = null;
			this.elapsedTime = 0;
		}
		public function reset():void  {
			this.startTime =  new Date();
			this.endTime = new Date();
			this.elapsedTime = 0;
		}
		//this updates the elapsed time
		public function getElapsedTime():Number{
			//if stopped
			//if running
			if(this.startTime != null){
				if(this.endTime != null){
					this.elapsedTime = this.endTime.getTime() - this.startTime.getTime();
				}else{
					this.elapsedTime =  new Date().getTime() - this.startTime.getTime();
				}
			}
			return this.elapsedTime;
		}
	
		public function getSeconds():String {
			var secs = this.elapsedTime/1000;
			return secs+" Seconds";
		}
		
		public function toString():String{
			var res:String = "";
			return "StopWatch " + this.getElapsedTime();
		}
	}
	
}