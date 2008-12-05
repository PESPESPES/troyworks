package com.troyworks.data.graph { 
	//import com.troyworks.data.Dictionary
	
	public class MicroLink {
		public var className:String = "com.troyworks.data.graph.MicroLink";
		public var _fromNode:MicroNode;
		public var _fromNodeID:Number;
		public var _toNode:MicroNode;
		public var _toNodeID:Number;
	
		public var data:Object;
		public var core:MicroCore;
		public var nType:String;
		public var id:Number;
		public var name:String;
		public var weight:Number = 1;
	
	
		public function MicroLink(id:Number = NaN,  name:String = "unnamedLink", nType:String ="", weight:Number= 0.0){
			trace("creating new link " + id + " name " + name + " type "  + nType + " weight " + weight);
			//this.core = core;
			this._fromNode = undefined;
			this._fromNodeID = undefined;
			this._toNode = undefined;
			this._toNodeID = undefined;
			this.data = new Object();
			this.nType = (nType ==null)?"_": nType;
			this.id = id;
			this.name = name;
			this.weight = (nType ==null)?weight:1;
		}
		public function setNode(isFromNode:Boolean, node:MicroNode):void{
			if(isFromNode){
				this._fromNode = node;
				this._fromNodeID = node.id;
			} else {
				this._toNode = node;
				this._toNodeID = node.id;
			}
		}
		public function getNode(incoming:Boolean):MicroNode{
			if(incoming){
				return this._fromNode;
			} else {
				return this._toNode;
			}
		}
		public function getToNode():MicroNode{
				return this._toNode;
		}
		public function getFromNode():MicroNode{
				return this._fromNode;
		}
		public function removeNode(incoming:Boolean, link:MicroLink):void{
			if(incoming){
				this._fromNode = null;
				this._fromNodeID = NaN;
			} else {
				this._toNode = null;
				this._toNodeID = NaN;
			}
		}
		public function traceMe (str : String, lvl : Number) : void
		{
			if (MicroNode.debugLevel == - 1)
			{
				return;
			} else if (lvl == null || lvl >= MicroNode.debugLevel){
			trace (str);
			}
		}
		public function toString():String{
			return "link " + this.name + " " + this._fromNode.name + " -> " + this._toNode.name;
		}
	
	}
}