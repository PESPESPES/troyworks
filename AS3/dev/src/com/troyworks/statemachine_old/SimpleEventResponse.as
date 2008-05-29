package com.troyworks.statemachine { 
	import flash.utils.getTimer;
	public class SimpleEventResponse {
		public var stime:Number;
		public var duration:Number;
		public var stackID:Number;
		public var handledEvent:Boolean;
		public var parent:IState;
		public function SimpleEventResponse(stackID:Number){
			this.stackID = stackID;
			this.handledEvent = false;
			this.parent = null;
			this.stime = getTimer();
			this.duration = 0;
		}
		public function startResponse(childState:IState) : void {
			this.parent = childState.getParent();
		}
		///consume this event
		public function handledEventCompletely() : void {
			this.handledEvent = true;
			this.parent = null;
		}
		//extend parent
		public function handToParentState(childState:IState) : void {
			this.parent = childState.getParent();
		}
	
		public function calcDuration():void{
			this.duration = (getTimer()-this.stime);
		}
		public function toString():String{
			return "\rSimpleEventResponse:" +this.stime + " handled " + this.handledEvent;
		}
	}
}