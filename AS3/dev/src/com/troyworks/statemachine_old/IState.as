package  { 
	//import com.troyworks.datastructures.Dictionary
	//import com.troyworks.datastructures.graph.*;
	import com.troyworks.statemachine.*;
	interface com.troyworks.statemachine.IState  {
			/*
		public  var INACTIVE:Number = 0;
		public  var ACTIVATING:Number =1;
		public  var DEACTIVATING:Number = 2;
		public  var ACTIVE:Number = 4;
		public var isActive:Number;
		public var isFrontMost:Boolean = false;
		public var frontMostEntryNodes:Array;
		public var core:StateCore;
		*/
		/////////////////////State Machine Related/////////////////////////////////
		public function tranTo(toState:IState):Object;
		public function tranFrom(fromState:IState):Object;
		public function addToFrontMostEntryNodes(node:IState):Boolean;
	   ////////////////////////////////////////////////////////////////////
	   // removes the state from the front most list
	   // TODO: should be replaced with a better algorithm.
	   public function removeFromFrontMostEntryNodes(node:IState, swapParent:Boolean):Boolean;
		public function handleEvent(evt:Event, evtRes:EventResponse):Object;
		public function getIsFrontMost():Boolean;
		public function setIsFrontMost(boo:Boolean):void;
		public function getIsActive():Number;
		public function getParent():IState;
		public function getName():String;
		public function startPulse(milli:Number):Boolean;
		public function stopPulse():Boolean;
		//public function enter():void;
		//public function internalEvent():void{
		//	this.onInternalEvent();
		//}
		//public function pulse():void {
		//	trace(this.name + "_node.pulse ");
		//	this.onPulse();
		//}
		//public function leave():void;
		///////////////////////////////////////////////
		// these are for the state unique actions
		// that need to be performed, typically
		// overridden in a subsclass.
	
		public function onEnter():void;
		public function onInternalEvent(evt:Event):void;
		public function onPulse():void;
		public function onLeave():void;
	
	}
}