package com.troyworks.statemachine { 
	import flash.utils.getTimer;
	public class EventResponse {
		//for performance metrics.
		public var stime:Number;
		public var etime:Number;
		public var duration:Number;
		//for event propogation
		public var handledEvent:Boolean = false;
		public var parent:Object;
	
		public function EventResponse(){
	
		}
		public function startResponse() :void{
			if(this.stime == -1){
				this.stime = getTimer();
				this.duration = 0;
			}
		}
		public function handledAndConsumed():EventResponse{
			if(this.handledEvent != true){
		     this.handledEvent = true;
	
			 this.etime = getTimer();
			}
			//don't pass onto parent
			this.parent = null;
			 return this;
		}
		public function handledAndForward():EventResponse{
		     this.handledEvent = true;
			  this.etime = getTimer();
			 //do pass on to parent.
			 return this;
		}
		public function toString():String{
			return "\rEventResponse:" +this.stime + " handled " + this.handledEvent;
		}
		public function calcDuration() : Number {
			duration =  this.etime - this.stime;
			return duration;
		}
	
	}
}