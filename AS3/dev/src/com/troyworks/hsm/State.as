package com.troyworks.hsm { 
	
	public class State{
		//this is the initialization state
		public static var INACTIVE : Number = 0;
		public static var ACTIVATING : Number = 1;
		public static var DEACTIVATING : Number = 2;
		public static var ACTIVE : Number = 4;
		public var isActive : Number = undefined;
		//
	
	
		public var top:State = null;
		public var curState:State = null;
		//for the transition
		public var curTran:Transition = null;
		public var fromState:State = null;
		public var toState:State = null;
		public var handleEvent:Function;
		//public var
		public function State(id : Number, name : String, nType : String)
		{
			super (id, name, nType);
		//	traceMe ("StateNode", 3);
			this.isActive = State.INACTIVE;
			this.handleEvent = this.inactive_handleEvent;
		}
		public function init(evt:HSMEvent):void{
			var s:State = null;
			if(this.curState == this.top && curTran == null){
				s = this.curState;
			}else {
			  throw new Error("Hstate already initialized");
			}
			this.handleEvent = this.active_handleEvent;
		}
		protected function inactive_enter() : void {
			trace("inactive_handleEvent");
		}
	
	
		protected function inactive_handleEvent() : void {
			trace("inactive_handleEvent");
		}
		protected function active_handleEvent() : void {
	
		}
	}
	
}