package com.troyworks.statemachine { 
	public class TransitionLink extends com.troyworks.datastructures.graph.MicroLink {
		public var className:String = "com.troyworks.statemachine.TransitionLink";
		public var core:StateCore;
		public function TransitionLink(id:Number,  name:String, Type:String){
			super(id, name, Type);
		}
		public function toString():String{
			return "transition link is " + this.name;
		}
		/////////////////////statemangement stuff ////////////////////////
		public function fire():void {
			var fN:IState = IState(this._fromNode);
			//if from isn't active ignore it,
			if(fN.getIsActive() == StateNode.ACTIVE){
				traceMe("firing mlink: " + this.name + " internal? " + (this._toNode === this._fromNode.parent) , 9);
				traceMe("topmost on stack ?" + fN.getIsFrontMost(),7);
				//to from
				traceMe("\t " + this._toNode.name + " " + this._fromNode.name  , 8);
				traceMe("\t " + this._toNode.parent.name + " " + this._fromNode.parent.name  , 8);
	
				if(this._toNode.parent != this._fromNode ){
			//	   this.core.leavingNodes.push(this._fromNode);
			//	   this.core.internalActionNodes.push({target:this._fromNode.parent, event:"internalTransition", name:this.name});
				}else {
			//	   this.core.internalActionNodes.push({target:this._fromNode, event:"internalTransition", name:this.name});
		//
				}
				//if this isn't the frontmost node, then get the path from
				var res = null;
				if(fN.getIsFrontMost()){
					res =this.core.findHeirachicalPath(this._fromNode, this._toNode);
				}else{
					var frontMost:Array = this.core.getFrontMostNodes();
					if(frontMost.length> 0){
					//TODO add merge for paths when frontmost nodes is greater than 1
						res =this.core.findHeirachicalPath(frontMost[0], this._toNode);
	
					}else {
						traceMe("TransitionLink.invalid state ");
						return;
					}
				}
				//if(res.direction <0){
					//if direction is down it's the right way for an exit.
					var _array = res.exitList;
					var L = _array.length;
					var evt = new Object();
					evt.sig = "LEAVE";
					traceMe("adding LEAVE events: " + L,4);
					for (var j = 0; j<L; j++) {
						var evtRes = new SimpleEventResponse();
						traceMe(" adding exit event for " + _array[j].name);
						_array[j].handleEvent(evt, evtRes);
						//this.core.addEventToList(evt);
					}
					_array = res.tranList;
					L = _array.length;
					 evt = new Object();
					evt.sig= "CROSS";
					traceMe("adding CROSS events: " + L,4);
					for (var i = 0; i<L; i++) {
						var evtRes = new SimpleEventResponse();
						_array[i].handleEvent(evt, evtRes);
							traceMe(" adding cross event for " + _array[i].name);
						//this.core.addEventToList(evt);
					}
					 _array = res.enterList;
					 L = _array.length;
					 evt = new Object();
					evt.sig = "ENTER";
					traceMe("adding ENTER events: " + L,4);
					if(L > 1){
						//keep root nodes from fireing on multi level transitions.
						evt.multi = true;
					}
					for (var i = 0; i<L; i++) {
						if(i== L -1){
							evt.multi = false;
						}
						var evtRes = new SimpleEventResponse();
						_array[i].handleEvent(evt, evtRes);
							traceMe(" adding enter event for " + _array[i].name, 6);
						//this.core.addEventToList(evt);
					}
	//				this.core.handleEvent(evt);
					//	this.core.firingLinks.push(this);
					//	this.core.enteringNodes.push(this._toNode);
					//	this.core.onPerformActions();
				//}
			}else {
				traceMe("can't fire, invalid transition: from state " + this._fromNode.name +  "  isn't active!");
			}
	
		}
		public function onCross():void {
			traceMe("crossing " + this.name, 8);
		}
		public function onFired():void {
			traceMe("onFired " + this.name, 8);
		}
	}
}