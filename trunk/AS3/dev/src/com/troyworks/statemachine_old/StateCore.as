package com.troyworks.statemachine { 
	import com.troyworks.datastructures.graph. *;
	//import com.troyworks.events.TDispatcher;
	import com.troyworks.events.TEventDispatcher;
	/*
	* 			/////////////////////////////////////
	this.rootCore = new StateCore(-1, "root");
	_global.rootCore = this.rootCore;
	*/
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	public class StateCore extends com.troyworks.datastructures.graph.MicroCore implements com.troyworks.statemachine.IState
	{
		public static var className : String = "com.troyworks.statemachine.StateCore";
		public var eb : TEventDispatcher;
		//////////common with stateNode
		public static var INACTIVE : Number = 0;
		public static var ACTIVATING : Number = 1;
		public static var DEACTIVATING : Number = 2;
		public static var ACTIVE : Number = 4;
		public var isActive : Number;
		public var extendedEnter : Boolean = false;
		protected var intV : Number = - 1;
		//determines whether or not this is an entry point into the stategraph for propogating signals across
		// e.g.
		// background (root)
		//   +-window
		//      +-window2 <-FrontMost
		//       ^ VIEWER and EVENTs ^
		// events would bubble 'up' the heirarchy from window2, window, background
		public var isFrontMost : Boolean = false;
		public var core : StateCore;
		public var parent : IState;
		public var curEvent : Event;
		/////////////unique to core
		public var internalActionNodes : Array;
		public var leavingNodes : Array;
		public var pulsingNodes : Array;
		public var activeNodes : Array;
		public var frontMostEntryNodes : Array;
		public var enteringNodes : Array;
		public var firingLinks : Array;
		public var events : Array;
		public var isBusy : Boolean;
		// used for deferred events / setinterval
		protected var ed_intV : Number;
		protected var ed_delay : Number;
		public function StateCore (id : Number, name : String, nType : String)
		{
			super (id, name, nType);
			TEventDispatcher.initialize (this.eb);
			if (id == - 1)
			{
				//traceMe("*******************SETTING AS ROOT****************");
				//creating root node
				this.frontMostEntryNodes = new Array ();
				this.addToFrontMostEntryNodes (this);
				this.activeNodes = new Array ();
				this.core = this;
				//this.depth = 0;
	
			}
			this.isActive = INACTIVE;
			this.internalActionNodes = new Array ();
			this.leavingNodes = new Array ();
			this.pulsingNodes = new Array ();
			this.firingLinks = new Array ();
			this.enteringNodes = new Array ();
			this.events = new Array ();
			this.isBusy = false;
			this.ed_intV = - 1;
		}
		public function createNode (name : String, classNameOrInstanceOfClass : Object, oType : String) : StateNode
		{
			var n : StateNode = null;
			if (classNameOrInstanceOfClass != null)
			{
				var f = classNameOrInstanceOfClass;
				// _global[classNameOrInstanceOfClass];//eval(classNameOrInstanceOfClass);
				//	traceMe( f + " " + name + " h type of "   + typeof (f) + " " + (typeof (f) == "function") + " instance of MicroCore?: " + (f is MicroCore) + " instance of Object?: " + (f is Object));
				if (f is StateNode)
				{
					traceMe (" h casting instance ");
					n = StateNode (classNameOrInstanceOfClass);
					if (n.name == null)
					{
						n.name = name;
					}
					n = StateNode (super.createNode (name, n, oType));
					if ( ! n)
					{
						traceMe ("warning casting " + name + " failed!");
					};
				} else
				{
					n = StateNode (super.createNode (name, classNameOrInstanceOfClass, oType));
				};
			} else
			{
				traceMe (" h super.createNode instance ");
				n = StateNode (super.createNode (name, classNameOrInstanceOfClass, oType));
			};
			//traceMe("StateCore.createNode " + name + " frontNodes " + this.frontMostEntryNodes);
			n.frontMostEntryNodes = this.frontMostEntryNodes;
			n.activeNodes = this.activeNodes;
			return n;
		};
		public function addNode (n : IState) : IState
		{
			super.addNode (MicroNode (n));
			var o = Object (n);
			o.frontMostEntryNodes = this.frontMostEntryNodes;
			o.activeNodes = this.activeNodes;
			return n;
		};
		public function createHeirarchicalNode (name : String, classNameOrInstanceOfClass : Object, oType : String) : StateCore
		{
			//traceMe("createHeirarchicalNode");
			var n : StateCore = null;
			if (classNameOrInstanceOfClass != null)
			{
				var f = classNameOrInstanceOfClass;
				//	traceMe( f + " " + name + " h type of "   + typeof (f) + " " + (typeof (f) == "function") + " instance of MicroCore?: " + (f is MicroCore) + " instance of Object?: " + (f is Object));
				if (f is StateCore)
				{
					//traceMe(" h casting instance ");
					n = StateCore (classNameOrInstanceOfClass);
					//add to the core
					n = StateCore (super.createHeirarchicalNode (name, n, oType));
					if ( ! n)
					{
						traceMe ("warning casting " + name + " failed!");
					};
				} else
				{
					n = StateCore (super.createHeirarchicalNode (name, classNameOrInstanceOfClass, oType));
				};
			} else
			{
				n = StateCore (super.createHeirarchicalNode (name, StateCore, oType));
			};
			//traceMe("StateCore.createHeirarchicalNode " + name + " frontNodes " + this.frontMostEntryNodes);
			n.frontMostEntryNodes = this.frontMostEntryNodes;
			n.activeNodes = this.activeNodes;
			return n;
		};
		public function createLink (name : String, classNameOrInstanceOfClass : Object, oType : String,
		fromNode : MicroNode, toNode : MicroNode) : TransitionLink
		{
			var l : TransitionLink = null;
			if (classNameOrInstanceOfClass != null)
			{
				var f = classNameOrInstanceOfClass;
				if (f is TransitionLink)
				{
					l = TransitionLink (classNameOrInstanceOfClass);
					l = TransitionLink (super.createLink (name, l, oType, fromNode, toNode));
					if ( ! l)
					{
						traceMe ("warning casting " + name + " failed!");
					}
				} else
				{
					l = TransitionLink (super.createLink (name, l, oType, fromNode, toNode));
				};
			} else
			{
				l	= TransitionLink (super.createLink (name, TransitionLink, oType, fromNode, toNode));
			};
			return l;
		};
		//////////////////
		// Create two links between the two nodes A->B and B->A
		public function createBiDLink (name : Object, classNameOrInstanceOfClass : Object, oType : String,
		fromNode : MicroNode, toNode : MicroNode) : Array
		{
			var res : Array = new Array ();
			var name1 : String = null;
			var name2 : String = null;
			var cname1 : Object = null;
			var cname2 : Object = null;
			//var class1:String = null;
			//--determine namess of events
			if (name is Array)
			{
				name1 = String (name [0]);
				name2 = String (name [1]);
			} else
			{
				//same event name e.g. loop
				name1 = String (name);
				name2 = String (name);
			}
			if (classNameOrInstanceOfClass is Array)
			{
				cname1 = classNameOrInstanceOfClass [0];
				cname2 = classNameOrInstanceOfClass [1];
			} else
			{
				//same event name e.g. loop
				cname1 = classNameOrInstanceOfClass;
				cname2 = classNameOrInstanceOfClass;
			}
			res.push (this.createLink (name1, cname1, oType, fromNode, toNode));
			res.push (this.createLink (name2, cname2, oType, toNode, fromNode));
			return res;
		};
		public function createHeirarchicalRootNode (name : String, classNameOrInstanceOfClass : Object, oType : String) : StateCore
		{
			var root : StateCore = StateCore (this.createHeirarchicalNode (name, classNameOrInstanceOfClass, oType));
			root.setAsRootNode (true);
			return root;
		};
		/////////////////////State Machine Related/////////////////////////////////
		public function tranTo (toState : IState) : Object
		{
			var res = this.core.findHeirachicalPath (MicroNode (this) , MicroNode (toState));
			//traceMe("tranTo found path " + res);
			return res;
		}
		public function tranFrom (fromState : IState) : Object
		{
			var res = this.core.findHeirachicalPath (MicroNode (fromState) , MicroNode (this));
			//traceMe("tranFrom found path " + res);
			return res;
		}
		/////////uses the depth and parent aspects to find a path between the to and from node
		public function findHeirachicalPath (fromNode : MicroNode, toNode : MicroNode) : Object
		{
			//
			if (this.isFrontMost)
			{
				//proceed normally
	
			} else
			{
				//find ftontmost to node for a given stack/columnid
	
			}
			//find path to requested node
			//find to end point (e.g. default start state)
			return super.findHeirachicalPath (fromNode, toNode);
		}
		/////////////////////////////////////
		// the workhorse routine
		public function createEvent (sig:Signal, args:Array):Event
		{
			if (sig == null)
			{
				traceMe ("WARNING  StateCore.createEvent(Sig) is NULL!!!!! ");
			}
			//traceMe("createEvent");
			var evt : Event = new Event (arguments.shift () , arguments, null);
			//this.events.push(evt);
			return evt;
		};
		/////////////////////////////////////
		// the workhorse routine
		public function addEventToList (evt:Event):void
		{
			this.events.push (evt);
		};
		/////////////////////////////////////
		// the workhorse routine for creating events
		public function createAndAddEvent (id:Object, args:Array) : Event
		{
			trace ("createAndAddEvent" + id);
			if (id is Array)
			{
				traceMe ("creating multipleEvents", 4);
				for (var i : Number = 0; i < Array(id).length; i ++)
				{
					var c = id [i];
					args = args [i];
					traceMe (i + " " + c, 4);
					var evt : Event = new Event (c , args, null);
					this.events.push (evt);
				}
			} else
			{
				var evt : Event = new Event (arguments.shift () , arguments, null);
				this.events.push (evt);
				return evt;
			}
		};
		public function hasEvents () : Boolean
		{
			if (this.events.length > 0)
			{
				for (var i in this.events)
				{
					traceMe ("hasEVENTS? " + this.events [i].sig);
					if (this.events [i].sig != "ENTER")
					{
						return true;
					}
				}
				return false;
			} else
			{
				return false;
			}
		}
		public function deferredDispatchEvent (delay : Number) : void {
			delay = (delay != null) ? delay : 5;
			if (this.ed_intV == - 1 && (this.events.length > 0))
			{
				this.ed_delay = delay;
				this.ed_intV = setInterval (this, "dispatchEvent", delay );
				traceMe ("adding deferred event------------" + this.ed_intV, 7);
			} else
			{
				traceMe ("already queing events=-=--------", 7);
			}
		}
		/////////////////////////////////////
		// the workhorse routine for dispatching events
		// to the active stack
		public function dispatchEvent () : void {
			this.isBusy = true;
			trace ("dispatchEvent @@@@@@@@@@@@ CLear I D " + this.ed_intV );
			clearInterval (this.ed_intV);
			this.ed_intV = - 1;
			if (this.events.length > 0)
			{
				trace ("send Event");
				var evt = this.events.shift ();
				this.curEvent = evt;
				traceMe ("broadcasting event '" + evt.sig + "' to " + this.frontMostEntryNodes.length + " listeners ", 8 );
				var i = this.frontMostEntryNodes.length;
				while (i --)
				{
					var statet = this.frontMostEntryNodes [i];
					//	trace(statet.name);
					var evtRes = new SimpleEventResponse (i);
					//traverse the linked list of states until it's broken/finished.
					var laststate = null;
					while (statet != null)
					{
						if (statet == laststate)
						{
							trace ("WARNING HIT CIRCULAR DEPENDENCY!");
							break;
						} else
						{
							//	traceMe("broadcasting to " + statet.name + " "  +  evt.sig);
							evtRes = statet.handleEvent (evt, evtRes);
							laststate = statet;
							statet = evtRes.parent;
						}
					}
				}
				if (this.events.length > 0)
				{
					//reenable the events
					this.deferredDispatchEvent (this.ed_delay);
				}
			} else
			{
				traceMe ("no events to dispatch", 5);
			}
			this.isBusy = false;
		};
		public function dispatchEvents () : void {
			trace ("starting dispatchEvents");
			while (this.events.length > 0)
			{
				this.dispatchEvent ();
			}
			//traceMe("active Nodes are now :", 4)
			//var i = this.frontMostEntryNodes.length;
			//while (i--)
			//{
			//	this.frontMostEntryNodes[i].name;
			//}
	
		};
		public function broadcastEvent (evt : String, args : Object) : void {
			this.core.createAndAddEvent (evt, args);
			this.core.deferredDispatchEvent ();
		}
		public function startPulse (milli : Number) : Boolean
		{
			if (this.intV == - 1)
			{
				this.intV = setInterval (this, "onPulse", ((milli == null) ?200 : milli));
				return true;
			} else
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
			} else
			{
				return false;
			}
		}
		/////////////////////////////////////
		// the workhorse routine
		public function handleEvent (evt:Object, evtRes:EventResponse) : Object
		{
			////////////EVENT VALIDATE //////////////////////////
			if (evt == null)
			{
				throw new Error ("StateCore.handleEvent() INVALID EVENT (null).");
			} else if (evt.sig == null)
			{
				if (evt.type != null)
				{
					traceMe ("handleEvent translating Event from EventDispatcher", 4);
					evt = new Event (evt.type, evt, Event.EVENT_DISPATCHER);
				} else
				{
					throw new Error ("StateCore.handleEvent() INVALID EVENT signature.");
				}
			}
			////////// VALID EVENT PROCESS IT ////////////////////////
			traceMe ("\t" + this.name + "_statecore.handleEvent '" + evt.sig + "'", 5);
			//	traceMe("this.isActive " + this.isActive);
			evtRes.startResponse (this);
			var handledEvent:Boolean = false;
			if (this.isActive == ACTIVE)
			{
				traceMe("is active");
				//////////events that map to internal actions
				/////////events that map to guarded transitions -do the check if passes then fire
				/////////events that map to ungarded transitions -automatically fire
				switch (evt.sig)
				{
					case "ENTER" :
					{
						traceMe ("\t" + "ignored already active", 9);
						handledEvent = true;
					}
					break;
					case "LEAVE" :
					if (this.isFrontMost)
					{
						this.onLeave ();
						this.core.removeFromActiveNodes (this);
						this.removeFromFrontMostEntryNodes (this);
						this.isActive = INACTIVE;
						if (evt.History)
						{
							//swap this immediately with parent onto active stack
							//start deconstructing.
	
						} else
						{
							//swap this immediately with parent onto active stack
							//and place this on the history stack
	
						}
						handledEvent = true;
					} else
					{
					}
					break;
					case "FINISHED_TRANSITION" :
					{
						traceMe ("notfy ui listeners", 8);
					}
					break;
					case "OVERRIDE_PARENT" :
					{
						//traceMe("\t"+this.name+" doing something");
						handledEvent = true;
					}
					break;
					case "EXTEND_PARENT" :
					{
						//traceMe("\t"+this.name+" doing something");
						//if (this.parent != null) {
						//	this.parent.handleEvent(evt, evtRes);
						//}
						evtRes.parent = this.parent;
						handledEvent = true;
					}
					break;
					default :
					{
						//traceMe("\t" + this.name+" no internal actions");
						var _array = this._outLinks.getAllItems ("GUARDED");
						var i = _array.length;
						//				traceMe("found " + i + "gaurded outlinks");
						while (i --)
						{
							var l : TransitionLink = TransitionLink (_array [i]);
							//traceMe(evt.sig+ "  comparing: in: " + l.name + " " + l._toNode.name + " out: " + l._fromNode.name );
							if (evt.sig == l.name)
							{
								//traceMe("found gaurded transition");
								l.fire ();
								handledEvent = true;
								break;
							}
						}
						_array = this._outLinks.getAllItems ("UNGUARDED");
						i = _array.length;
										traceMe("found " + i + "ungaurded outlinks");
						while (i --)
						{
							var l : TransitionLink = TransitionLink (_array [i]);
							traceMe(evt.sig+ "  comparing: in: " + l.name + " " + l._toNode.name + " out: " + l._fromNode.name );
							if (evt.sig == l.name)
							{
								//traceMe("found ungaurded transition");
								l.fire ();
								l.onFired ();
								handledEvent = true;
								break;
							}
						}
						//var evt = new Object();
						//traceMe("-------------------------------FINISHED TRANSITION------------------");
						//evt.sig = "FINISHED_TRANSITION";
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
							//traceMe("\t  sending to parent: "+this.parent.getName());
							//handledEvent = this.parent.handleEvent(evt);
							evtRes.parent = this.parent;
							//handledEvent = false;
	
						} else
						{
							//traceMe("  "+evt.sig+" event not handled!!");
							//handledEvent = false;
	
						}
					}
				}
			} else
			{
				traceMe ("isnt active");
				switch (evt.sig)
				{
					case "ENTER" :
					{
						trace ("REceived ENter Event");
						//this.isActive = ACTIVATING;
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
						this.onEnter ();
						if ( ! this.extendedEnter)
						{
							this.enter (null, evt.multi);
						}
						traceMe ("setting to ACTIVE!!!!!!", 6);
						this.isActive = ACTIVE;
						//parent.handleEvent("enter");
						handledEvent = true;
					}
					break;
					case "REQUEST_ENTER" :
					{
						//see if there's a path from the currently active state to this
						// and if so, fire the associated transitions.
						handledEvent = true;
					}
					break;
					default :
					{
						traceMe ("\tignored event not active", 6);
					}
					break;
				}
			}
			evtRes.calcDuration ();
			evtRes.handledEvent = handledEvent;
			traceMe ("  handledevent?: " + evtRes.handledEvent + " in " + evtRes.duration, 6);
			return evtRes;
		}
		public function addToActiveNodes (node : IState) : void
		{
			this.activeNodes.push (node);
		}
		// TODO: should be replaced with a better algorithm.
		public function removeFromActiveNodes (node : IState) : void
		{
			var i = this.activeNodes.length;
			while (i --)
			{
				var o = this.activeNodes [i];
				if (o === node)
				{
					//	traceMe("found the active node -removing" + node.getName());
					this.activeNodes.splice (i, 1);
				}
			}
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
			//traceMe("addToFrontMostEntryNodes: " + node.getName());
			//in the case it's already added
			if ( ! node.getIsFrontMost ())
			{
				//	traceMe("add to frontMost nodes: " + node.getName());
				//	   traceMe("before add: \n " +  this.frontMostEntryNodes );
				if (node.getParent ().getIsFrontMost ())
				{
					this.removeFromFrontMostEntryNodes (node.getParent () , false);
				}
				this.frontMostEntryNodes.push (node);
				//   traceMe("after add: \n\r " +  this.frontMostEntryNodes );
				node.setIsFrontMost (true);
				return true;
			} else
			{
				//	traceMe("\tnot adding to frontmost:"+  this.frontMostEntryNodes );
				return false;
			}
		}
		////////////////////////////////////////////////////////////////////
		// removes the state from the front most list
		// TODO: should be replaced with a better algorithm.
		public function removeFromFrontMostEntryNodes (node : IState, swapParent : Boolean) : Boolean
		{
			traceMe ("removeFromFrontMostEntryNodes: " + node.getName () , 4);
			var i = this.frontMostEntryNodes.length;
			while (i --)
			{
				var o = this.frontMostEntryNodes [i];
				if (o === node)
				{
					//trace("\r\nfound the frontMost node -removing :" + node.getName());
					//	   trace("\nbefore remove: \n\r " +  this.frontMostEntryNodes );
					this.frontMostEntryNodes.splice (i, 1);
					//	   trace("\nafter remove: \n\r " +  this.frontMostEntryNodes );
					node.setIsFrontMost (false);
					if (swapParent == null || (((swapParent != null) && (swapParent == true)) && ! node.getParent ().getIsFrontMost ()))
					{
						this.addToFrontMostEntryNodes (node.getParent ());
					}
					return true;
				}
			}
			return false;
		}
		public function getFrontMostNodes () : Array
		{
			return this.frontMostEntryNodes;
		}
		public function getIsFrontMost () : Boolean
		{
			return this.isFrontMost;
		}
		public function setIsFrontMost (boo : Boolean) : void
		{
			this.isFrontMost = boo;
		}
		public function getIsActive () : Number
		{
			return this.isActive;
		}
		public function getParent () : IState
		{
			return this.parent;
		}
		public function getName () : String
		{
			return this.name;
		}
		////////////////////////////////////
		// if entering from parent, propogate from children
		// if entering from user request, propogate up parents then children
		// if entering from a sibling.//useHistory:Boolean
		protected function enter (useHistory : Boolean, partOfMultiState : Boolean) : void
		{
			useHistory = false;
			traceMe (this.name + "_stcore.enter " + (this.isActive == INACTIVE) , 9);
			if (this.isActive == INACTIVE)
			{
				//---initialize the foundational super class before adding
				//super.enter();
				//traceMe(this.name + "_stcore.enter " + arguments.caller + " " + arguments.caller.name);
				//	if(arguments.caller == this.parent){
				if (true)
				{
					//traceMe("called by parent");
					//getting called by a controlling class.
					if (useHistory == null || useHistory == false && ! partOfMultiState)
					{
						activateDefaultStartStates ();
					}
				} else
				{
					//traceMe("not called by parent");
	
				}
			}
		}
		public function activateDefaultStartStates (useHistory : Boolean, partOfMultiState : Boolean) : void {
			var len : Number = this.rootNodes.length;
			//this.activeNodes = new Array(len);
			//traceMe("starting trying to add " +  len  + " root nodes: " );
			while (len --)
			{
				//traceMe("len " + len);
				var o = this.rootNodes [len];
				//traceMe("\t" + this.name  + " activating rootnode(s): " + o.name);
				o.handleEvent (
				{
					sig : "ENTER"
				});
			}
		}
		protected function pulse () : void
		{
			//super.onPulse();
			//traceMe(this.name + "_stcore.pulse ");
			var i = this.pulsingNodes.length;
			while (i --)
			{
				this.pulsingNodes [i].onPulse ();
			}
		}
		protected function leave () : void
		{
			if (this.isActive == ACTIVE)
			{
				//traceMe(this.name + "_stcore.startleave " + this.activeNodes.length);
				clearInterval (this.si);
				var a_array = this.activeNodes;
				this.activeNodes = new Array ();
				var i = a_array.length;
				while (i --)
				{
					a_array [i].leave ();
				}
				//traceMe(this.name + "_stcore.leave " + this.activeNodes.length);
				//--leave the super class after we've done everything at this level-----
			}
		}
		public function addEventsToQueue () : void {
			//super.onPulse();
			//traceMe(this.name + "_stcore.onPerformActions ");
	
		}
		public function onPerformActions () : void {
			//super.onPulse();
			//traceMe(this.name + "_stcore.onPerformActions ");
			//for all leaving nodes call onLeave
			//for all pulsing nodes call onPulse
			//for all entering nodes call onEnter
			var runOnce = false;
			while (this.leavingNodes.length > 0 || this.enteringNodes.length > 0 ||
			( ! runOnce && this.pulsingNodes.length))
			{
				var l_array = this.leavingNodes;
				var i_array = this.internalActionNodes;
				var t_array = this.firingLinks;
				var p_array = (runOnce) ?this.pulsingNodes : new Array ();
				var e_array = this.enteringNodes;
				//graphics.clear the existing array
				this.leavingNodes = new Array ();
				this.internalActionNodes = new Array ();
				this.firingLinks = new Array ();
				this.pulsingNodes = new Array ();
				this.enteringNodes = new Array ();
				var i : Number = l_array.length;
				while (i --)
				{
					var o : Object = l_array [i];
					o.leave ();
				}
				i = i_array.length;
				while (i --)
				{
					var t = i_array [i];
					t.target.onInternalEvent (t);
				}
				i = t_array.length;
				while (i --)
				{
					t_array [i].onCross ();
				}
				i = p_array.length;
				while (i --)
				{
					p_array [i].pulse ();
				}
				i = e_array.length;
				while (i --)
				{
					var o : StateNode = e_array [i];
					o.enter ();
				}
				runOnce = true;
			}
		}
		///////////////////////////////////////////////
		// these are for the state unique actions
		// that need to be performed, typically
		// overridden in a subsclass.
		public function onActivate () : void
		{
			traceMe (this.name + "_node.onActivate ", 3);
		}
		public function onDeactivate () : void
		{
			traceMe (this.name + "_node.onDeactivate ", 3);
		}
		///////common with statenode /////////
		public function onEnter () : void
		{
			traceMe (this.name + "_node.onEnter ", 4);
		}
		public function onInternalEvent (evt:Object) : void
		{
			traceMe (this.name + "_node.onInternalEvent " + evt.target + " " + evt.name + " " + evt.event, 4);
		}
		public function onPulse () : void
		{
			traceMe (this.name + "_node.onPulse ", 4);
		}
		public function onLeave () : void
		{
			traceMe (this.name + "_node.onLeave ", 4);
		}
		public function toString () : String
		{
			var str : String = "\t" + this.name + " active list:";
			var i : Number = this.activeNodes.length;
			while (i --)
			{
				var o = this.activeNodes [i];
				str += "\n\t\t - " + o.name + "[" + o.isActive + "]";
			}
			i = this.frontMostEntryNodes.length;
			str += "\n\tfrontMost list:";
			while (i --)
			{
				var o = this.frontMostEntryNodes [i];
				str += "\n\t\t - " + o.name + "[" + o.isActive + "]";
			}
			return str;
		}
	}
	
}