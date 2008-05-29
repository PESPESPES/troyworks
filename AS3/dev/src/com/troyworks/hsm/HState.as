package com.troyworks.hsm { 
	
	public class HState extends State{
	
		public var top:State = null;
		public var curState:State = null;
		//for the transition
		public var curTran:Transition = null;
		public var fromState:State = null;
		public var toState:State = null;
		//public var
		public function HState(){
			trace(this + " Event created");
		}
		public function init(evt:HSMEvent):void{
			var s:State = null;
			if(this.curState == this.top && curTran == null){
				s = this.curState;
			}else {
			  throw new Error("Hstate already initialized");
			}
	
		}
	/*	public function toString():String{
			return "\rEvent:" +this.sig + " args " + this.args;
		}*/
	}
	
}