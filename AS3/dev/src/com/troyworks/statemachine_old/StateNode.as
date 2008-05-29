package com.troyworks.statemachine { 
	//import com.troyworks.datastructures.Dictionary
	import com.troyworks.datastructures.graph. *;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	public class StateNode extends com.troyworks.datastructures.graph.MicroNode implements com.troyworks.statemachine.IState
	{
		//public var className : String = "com.troyworks.statemachine.StateNode";
		public static var INACTIVE : Number = 0;
		public static var ACTIVATING : Number = 1;
		public static var DEACTIVATING : Number = 2;
		public static var ACTIVE : Number = 4;
		public var isActive : Number;
		public var extendedEnter : Boolean = false;
		//used for tracking pulse activity.
		protected var intV : Number = - 1;
		//determines whether or not this is an entry point into the stategraph for propogating signals across
		// e.g.
		// background (root)
		//   +-window
		//      +-window2 <-FrontMost
		//       ^ VIEWER and EVENTs ^
		// events would bubble 'up' the heirarchy from window2, window, background
		public var isFrontMost : Boolean = false;
		public var frontMostEntryNodes : Array;
		public var activeNodes : Array;
		public var core : StateCore;
		public var parent : IState;
		public var curEvent : Event;
		public function StateNode (id : Number, name : String, nType : String)
		{
			super (id, name, nType);
			traceMe ("StateNode", 3);
			this.isActive = INACTIVE;
		}
		/////////////////////State Machine Related/////////////////////////////////
		public function tranTo (toState : IState) : Object
		{
			var res = this.core.findHeirachicalPath (MicroNode (this) , MicroNode (toState));
			traceMe ("tranTo found path " + res, 4);
			return res;
		}
		public function tranFrom (fromState : IState) : Object
		{
			var res = this.core.findHeirachicalPath (MicroNode (fromState) , MicroNode (this));
			traceMe ("tranFrom found path " + res, 4);
			return res;
		}
		/////////////////////////////////////////////////////////////////
		// these deal with propogation of events from the bottom most child
		// who should have the right to override or extend the functionality
		// of the parent in response to events.
		// when a new substate becomes active it replaces it's parent
		// on the frontmostlist list, and when removed from active it removes itself
		// and puts the parent on the frontmostlist
		// returns if the nodes was added or not.
		public function addToFrontMostEntryNodes (node : IState) : Boolean
		{
			//in the case it's already added
			return this.core.addToFrontMostEntryNodes (node);
		}
		////////////////////////////////////////////////////////////////////
		// removes the state from the front most list
		// TODO: should be replaced with a better algorithm.
		public function removeFromFrontMostEntryNodes (node : IState, swapParent : Boolean) : Boolean
		{
			return this.core.removeFromFrontMostEntryNodes (node, true);
		}
		public function getIsFrontMost () : Boolean
		{
			return this.isFrontMost;
		}
		public function getIsActive () : Number
		{
			return this.isActive;
		}
		public function setIsFrontMost (boo : Boolean) : void
		{
			this.isFrontMost = boo;
		}
		public function getParent () : IState
		{
			return this.parent;
		}
		public function getName () : String
		{
			return this.name;
		}
		public function startPulse (milli : Number) : Boolean
		{
			if (this.intV == - 1)
			{
				this.intV = setInterval (this, "onPulse", ((milli == null) ?200 : milli));
				return true;
			}else
			{
				return false;
			}
		}
		public function stopPulse () : Boolean
		{
			if (this.intV > - 1)
			{
				clearInterval (this.intV);
				this.intV = - 1;
				return true;
			}else
			{
				return false;
			}
		}
		public function handleEvent (evt:Event, evtRes:EventResponse) : Object
		{
			evtRes.startResponse (this);
			var handledEvent:Boolean = false;
			traceMe ("\t" + this.name + ".handleEvent " + evt.sig, 5);
			if (this.isActive == ACTIVE)
			{
				//////////events that map to internal actions
				/////////events that map to guarded transitions -do the check if passes then fire
				/////////events that map to ungarded transitions -automatically fire
				switch (evt.sig)
				{
					case "ENTER" :
					traceMe ("\t" + "ignored already active", 6);
					handledEvent = true;
					break;
					case "LEAVE" :
					this.onLeave ();
					this.core.removeFromActiveNodes (this);
					this.removeFromFrontMostEntryNodes (this);
					this.isActive = INACTIVE;
				/*XXX TODO	implement if (evt.History)
					{
						//swap this immediately with parent onto active stack
						//start deconstructing.
	
					} else
					{
						//swap this immediately with parent onto active stack
						//and place this on the history stack
	
					}*/
					handledEvent = true;
					break;
					case "OVERRIDE_PARENT" :
					traceMe ("\t" + this.name + " doing something", 6);
					handledEvent = true;
					break;
					case "EXTEND_PARENT" :
					traceMe ("\t" + this.name + " doing something",6);
					//if (this.parent != null) {
					//	this.parent.handleEvent(evt, evtRes);
					//}
					evtRes.parent = this.parent;
					handledEvent = true;
					break;
					default :
					//traceMe("\t" + this.name+" no internal actions");
					var _array = this._outLinks.getAllItems ("GUARDED");
					var i = _array.length;
					//				traceMe("found " + i + "gaurded outlinks");
					while (i --)
					{
						var l : TransitionLink = TransitionLink (_array [i]);
						traceMe (evt.sig + "  comparing: in: " + l.name + " " + l._toNode.name + " out: " + l._fromNode.name, 6 );
						if (evt.sig == l.name)
						{
							traceMe ("found gaurded transition", 5);
							l.fire ();
							handledEvent = true;
							break;
						}
					}
					_array = this._outLinks.getAllItems ("UNGUARDED");
					i = _array.length;
					//					traceMe("found " + i + "ungaurded outlinks", 2);
					while (i --)
					{
						var l : TransitionLink = TransitionLink (_array [i]);
						traceMe (evt.sig + "  comparing: in: " + l.name + " " + l._toNode.name + " out: " + l._fromNode.name , 6);
						if (evt.sig == l.name)
						{
							traceMe ("found ungaurded transition", 5);
							l.fire ();
							handledEvent = true;
							break;
						}
					}
					/*	if (this.gTrans[evt.sig] != null) {
					//for each gaurded event check the conditional
					//break;
					traceMe("\t"+"firing gaurded transitions");
					handledEvent = true;
					//break;
					}
					if (this.uTrans[evt.sig] != null) {
					traceMe("\t"+"firing ungaurded transitions");
					handledEvent = true;
					//break;
					}*/
					//unhandled
					if (handledEvent)
					{
						traceMe ("\t ... event consumed", 5);
					} else if ( ! handledEvent && this.parent != null)
					{
						traceMe ("\t  sending to parent: " + this.parent.getName (), 6);
						//handledEvent = this.parent.handleEvent(evt);
						evtRes.parent = this.parent;
						//handledEvent = false;
	
					} else
					{
						traceMe ("  " + evt.sig + " event not handled!!", 6);
						//handledEvent = false;
	
					}
				}
			} else
			{
				switch (evt.sig)
				{
					case "ENTER" :
					//this can only be called by parent, if it's not parent choose request enter
					//if not initialized, store event and init: notInitialized/deconstructed, initializing, initialized, deconstructing
					//once inited perform enter actions
					//inactive means only responsd to enter (from parent) or request for enter (from anywhere) and blocks/ignores everything else
					//activating means queus events recieved and performs them sequentially after full inited
					//active means perform actions as normal
					//deactivating,  blocks/ignores everything.
					//active inacative, activating, active, deactivating
					//once active swap out with parent on the activestack;
					this.core.addToActiveNodes (this);
					this.addToFrontMostEntryNodes (this);
					if ( ! this.extendedEnter)
					{
						this.onEnter ();
					}
					this.isActive = ACTIVE;
					//parent.handleEvent("enter");
					handledEvent = true;
					break;
					case "REQUEST_ENTER" :
					//see if there's a path from the currently active state to this
					// and if so, fire the associated transitions.
					handledEvent = true;
					break;
				}
			}
			evtRes.calcDuration ();
			evtRes.handledEvent = handledEvent;
			traceMe ("  sn.handledevent?: " + evtRes.handledEvent + " in " + evtRes.duration, 3);
			return evtRes;
		}
		public function enter () : void
		{
			if (this.isActive == INACTIVE )
			{
				this.isActive = ACTIVATING;
				if (arguments.caller == this.parent)
				{
					//getting called by a controlling class.
	
				} else
				{
					//called from an external source,
					//set the active chain to this.
					//propogate along the parent chain to make
					//sure all the parents are activated.
					// this.parent.enter();
	
				}
				traceMe (this.name + "_stnode.enter " + arguments.caller, 8);
				this.onEnter ();
				// this.core.addNodeToActive(this);
				this.isActive = ACTIVE;
			}else
			{
				traceMe ("mnode already active ignoring enter",8);
			}
		}
		//public function internalEvent():void{
		//	this.onInternalEvent();
		//}
		//public function pulse():void {
		//	trace(this.name + "_stnode.pulse ");
		//	this.onPulse();
		//}
		public function leave () : void
		{
			if (this.isActive == ACTIVE )
			{
				this.isActive = DEACTIVATING;
				traceMe (this.name + "_stnode.leave ", 8);
				//deactivate all children then leave.
				//but since this is a root node we have no children
				this.onLeave ();
				//this.core.removeNodeFromActive(this);
				this.isActive = INACTIVE;
			}
		}
		///////////////////////////////////////////////
		// these are for the state unique actions
		// that need to be performed, typically
		// overridden in a subsclass.
		public function onEnter () : void
		{
			traceMe (this.name + "_stnode.onEnter ", 8);
		}
		public function onInternalEvent (evt:Object) : void
		{
			traceMe (this.name + "_stnode.onInternalEvent " + evt.target + " " + evt.name + " " + evt.event,8);
		}
		public function onPulse () : void
		{
			traceMe (this.name + "_stnode.onPulse ",8);
		}
		public function onLeave () : void
		{
			traceMe (this.name + "_stnode.onLeave ",8);
		}
		/////////////////////////////////////////////////////
		public function toString () : String
		{
			return " node " + this.name;
		}
	}
	
}