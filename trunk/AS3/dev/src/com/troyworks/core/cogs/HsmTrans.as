package com.troyworks.core.cogs {
	import com.troyworks.core.cogs.Hsm;
	import com.troyworks.core.cogs.CogEvent;
	import com.troyworks.util.DesignByContract;
	import com.troyworks.util.DesignByContractEvent;

	public class HsmTrans extends Fsm {

		var hsm : Hsm;
		///////////////////////////
		//s= state
		var s : Function;
		//t = state
		var t : Function;
		var lca : Number;
		var cont : Number;
		var e : Number = 0;
		var f : Number = 0;
		///////////////////
		var lastState : Function;

		var targetState : Function;
		var mySource : Function;
		var myTopState : Function;

		//an empty array with nulls as placeholders
		protected var entry : Array = [null, null, null, null, null, null, null, null, null, null, null];
		protected var exitry : Array = [null, null, null, null, null, null, null, null, null, null, null];

		public function HsmTrans(hsm : Hsm, startFromState : Function, destinationState : Function) {
			super();
			DesignByContract.initialize(this);
			_initState = s_unRouted;
			mySource = startFromState;
			targetState = destinationState;
		}

		/////////////////////////////////////
		function s_unRouted(event : CogEvent) : void {
		}

		function s_discoveringRoute(event : CogEvent) : void {
			if(targetState != hsm.s_root) {
				return;
			}
			//TODO move this over from HSM
		}

		function s_performingExit(event : CogEvent) : void {
			/* now we have the list of operations for this transition  proceed through the chain and exit each one
			 * [0] child
			 * [1] parent
			 * [2] grandparent
			 */
			if (f > 0) {
				while ((s = Function(exitry[ --f ])) != null) {
					//	trace ("Exiting " + s.call (this, TRACE_EVT))
					/* retrace exot
					 * path in reverse order */
					//_global.outText ("preExit4");
					s.call(this, CogEvent.getExitEvent());
					//_global.outText ("postExit4");
					/* enter */
				}
			}
		}

		function s_performingEnter(event : CogEvent) : void {
			/* now we are in the LCA of source__ and target, proceed through the chain and enter each one  in
			 * [0] target
			 * [1] target's parent
			 * [2] targets's grandparent
			 */
			if (e > 0) {
				while ((s = Function(entry[ --e])) != null) {
					/* retrace entry path in reverse order */
					//_global.outText ("preEnter4");
					s.call(this, CogEvent.getEnterEvent());
					//_global.outText ("postEnter4");
					/* enter */
				}
			}
			//Once we've reached this point we've already entered the target state specified by the
			//transition , but may have substate transitions to attend to, not specified by the
			// requested transition, this should not be more than one level deep.
			// currentState == result  and null = consumed the event
			//
			//myCurState = targ;
		}

		/******************************************
		 * This is the workhorse of the statemachine, processing the
		 * transitions between various states to other states. It's command is the state(function)
		 * to transition to from the current state(function)
		 *
		 * it ensure that actions are performed in the right direction, handling parents appropriately
		 * generally it's Exit actions, Transition Actions (if any), Enter Actions and then possibly
		 * INIT actions. Enter and Exit actions are not allowed to fire off any state transitions of their own
		 * but can update state variables (e.g. visible = true).
		 *
		 * Transitions (not the exit and enter actions) are supposed to be take zero time, meaning all the work is associated with the Enter and Exit actions
		 * and inbetween the Exit and Enter states, when technically it's an undefined state, no work is performed.
		 * if you need work performed between states you should introduce a new state, e.g.
		 *   - OFF->Dimming Up->OnFull
		 *   - Stopped->AnimatedTransitionPlay->Playing
		 *            <-AnimatedTransitionToStop<-
		 */
		override public function tran(targetState : Function, transOptions : TransitionOptions = null, crossAction : Function = null) : * {
			//use namespace  COG;
			//REQUIRE(targetState != null, "***ERROR*** %1.tran, passed null state function" ,  toStringShort ());
			REQUIRE(targetState != s_root, "cannot transition to root state!");
			//	REQUIRE(targetState is Function, "***ERROR*** %1.QTRAN, passed invalid state function:  %2", toStringShort (),(targetState is Function));
			if(transOptions == null) {
				transOptions = TransitionOptions.DEFAULT;
			}
			////////////For Debugging Purposes/////////////////
			transitionLog = new Array();
			var curName : String = getStateName(_myCurState);
			var sourceName : String = getStateName(mySource);
			var requestedName : String = getStateName(targetState);
			trace("HIGHLIGHTB Q_Tran>>>>>>>>>>>>>>>>>>>>>>>>>>>>> " + curName + ".. " + sourceName + " to " + requestedName + "");
			var key : String = curName + "->" + requestedName;
	
			///////////////////////////
			//tmp state variables
			var s : Function;
			var t : Function;
			// Capture the target, source and current state for synchronization
			// reason
			var tS : Function = targetState;
			var sS : Function = mySource;
			var cS : Function = _myCurState;
			// target parent and source parent state
			var tp : Function;
			var sp : Function;

			var lca : uint;
			var cont : uint;
			var e : uint = 0;
			var f : uint = 0;
			// reset the action lists
			var preExit : Array = new Array();
			entry = new Array();
			exitry = new Array();
			var postEnter : Array = new Array();
			/////////////////////////////////////////////////////////////////
			//
			// PHASE1: UNWIND From currentState to the source of the transition
			// 
			/////////////////////////////////////////////////////////////////
			if(sS != cS) {
				//trace"UNWINDING-----------------" + getStateName(cS) + "  sS" + getStateName(sS));
				s = cS;
				while (true) {
					sp = s.call(this, EVT_EMPTY);
					//trace" - sp " + getStateName(sp) + " s " + getStateName(s));
					if (sp == null) {
						// arrived at target state or root
						//trace" arrived at root");
						break;
					}else if(sp == sS) {	
						// else haven't arrived at source state yet, keep going
						//trace"arrived unwinding " + getStateName(s));
						preExit.push(s);
						//	f= 1;
						break;
					} else {
						// else haven't arrived at source state yet, keep going
						//trace" unwinding " + getStateName(s));
						preExit.push(s);
						//	f= 1;
						s = sp;
					}
				}
			}
			//trace"preExit " + preExit.length);
			//targetState is parent and it's already active.
			var tIsPA : Boolean = false;
			var skipPrune : Boolean = false;
			var reentrant : Boolean = false;
			var LCA : Function = null;

			//Store this for posterity/history/undo
			lastState = _myCurState;
			if (transOptions.useCachedRouting && tran_Idx[key] != null) {
				//Found an existing routing
				//trace"existing routing");
				var routing : Array = tran_Idx[key];
				entry = routing[0];
				exitry = routing[1];
			} else {
				//discover route
				//trace"discovering routing ");
				///////////////////////////////////////////////////////////////////
				//
				// ROUTE   , find the path from the source
				// of the transition to the target state
				// start recording transition chain, if not a dynamic
				// 
				////////////////////////////////////////////////////////////////////
				//trace"ROUTING----------");
				if (sS == tS) {
					////////////////////////////////////////////////////////////
					//  Self Transitions, no extended discovery needed.
					// Fig 4.7(a) 
					////////////////////////////////////////////////////////////
					//trace"(a) - self transition");
					entry[e++] = tS;
					exitry[f++] = sS;
					skipPrune = true;
					reentrant = true;
				} else {
					//trace"source != target");
					//target's parent state
					tp = tS.call(this, EVT_EMPTY);
					//source's parent state
					sp = sS.call(this, EVT_EMPTY);
					//if (cS == sS) {
					//	//trace"single level");
					////////////////////////////////////////////////////////////
					//  Single Level Transitions, no extended discovery needed.
					////////////////////////////////////////////////////////////
					if (sS == tp) {
						// CHILD
						//trace"*Fig 4.7 (b)* -  transition to first child - ENTER only");
						//		if(tS != cS){
						entry[e++] = tS;
						//	}else {
						//		//trace" already active");
								//reentrant = true;
								//return;
								//break;
				//	}
					} else if (sp == tp) {
						// SIBLING
						//trace"*Fig 4.7 (c) (sp == tp)* -  transition to sibling via parent EXIT and ENTER chain ");
						entry[e++] = tS;
						exitry[f++] = sS;
					} else if (sp == tS) {
						// PARENT
						//trace"*Fig 4.7 (d)* -  transition to first parent EXIT only");
						exitry[f++] = sS;
						tIsPA = true;
					} else {
						//////////////////////////////////////////////////////////////
						// Multi Level Transitions, extended discovery needed
						/////////////////////////////////////////////////////////////
						//trace"multi level");
						//trace ("*Fig 4.7 (e),(f), (g), (h) (sp.. == tp..)* -  transition to sibling(s) EXIT and ENTER chain  ");
						//ENTER LIST from target
						for (s = tS;s != null && s != s_root;s = s.call(this, EVT_EMPTY)) {
							//trace ("checking enter list from targets's parent"  + s.call (this, TRACE_EVT));
							if (s == sS ) {
								//found it, target is GRANDCHILD
								//trace"e 4.7 (e)  found LCA! " + e);
								LCA = s;
								break;
							} else {
								// add to entry list keep going,
								entry[e++] = s;
							}
						}
						entry.reverse();
						if(LCA == null) {
							LCA = entry[0];
						}
						//EXIT LIST from source
						for (s = sS;s != null && s != s_root;s = s.call(this, EVT_EMPTY)) {
							//trace ("checking exit list from activestate/source " + s.call (this, TRACE_EVT));
							if (s == tS || s == LCA) {
								//found it, target is GRANDPARENT
								//trace"x 4.7 (h) found LCA ! " + f);
								break;
							} else {
								// add to exit list keep going,
								exitry[f++] = s;
							}
						}
						//
						//trace"\r\r");
						//traceEnterExitList(f, e, "after normal routing");
						//trace"\r\r");
						//PRUNE LIST for any unecessary LCA/root state's
						if (e > 0 && f > 0) {
							//if we are here we didn't find the LCA *Fig 4.7 (g)
							//trace"----performing LCA extended discovery pruning---------");
							var ee : uint = e;
							var ff : uint = f;
							while (entry[( --ee )] == exitry[( --ff)]) {
								e--;
								f--;
								//trace ("discarding " + entry [(e )].call (this, TRACE_EVT) + " " + exitry [(f )].call (this, TRACE_EVT));
							}
						}

						//trace"\r\r");
						//traceEnterExitList(f, e, "after LCA discovery");
						//trace"\r\r");
					}
				}
				if(exitry.length == 0) {
					reentrant = true;
				}
				////////////////////////////////////////////////////////////////////
				//
				// ROUTE B, find path from target state to topmost init,
				//
				////////////////////////////////////////////////////////////////////
				if(transOptions.doInitDiscovery) {
					//traceace("INIT ROUTING----------------");
					if ( !tIsPA) {
						s = tS;
						tp = s.call(this, EVT_EMPTY);
						while (true) {
							t = s.call(this, EVT_INIT);
							if(t == null) {
								throw new Error("error in statemachine topology, EVT_INIT " + getStateName(s) + " returned null");
							}else if (t == tp || t == s_root) {
								//reached destination, no init state to process
								break;
							} else {
								//trace"  init " + getStateName(s) + " ++> " + getStateName(t));
		
								//found a new state to enter, add to list and keep climbing
								postEnter.unshift(t);
								tp = s;
								s = t;
							}
						}
					}
					postEnter.reverse(); //for multi level init
				} else {
					trace("SKIP INIT ROUTING");
				}
				//CAPTURE List and save it for later
				tran_Idx[key] = [entry.concat(),exitry.concat()];
			}
			///////////////////////////////////////////////////////////////////
			// MERGE the preExit and postEnter lists
			//////////////////////////////////////////////////////////////////
			//	trace("\r\r");

			exitry = preExit.concat(exitry);
			entry = entry.concat(postEnter);
			//trace("MERGED ");
			traceEnterExitList(f, e, "after MERGE discovery");
			//trace("\r\r");


			////////////////////////////////////////////////////////////////////
			// 
			//  DONE FINDING ROUTE, perform actual transition, process events
			//
			/////////////////////////////////////////////////////////////////////
			/* now we have the list of operations for this transition  proceed through the chain and exit each one
			 * [0] child
			 * [1] parent
			 * [2] grandparent
			 */

			ASSERT(transLock == false, "Error in HSM Illegal Transition detected in " + toStringShort() + "trannnot perform another trtrtranSIG_EXIT or ENTER_EVT (use SIG_INIT instead) ");
			transLock = true;
			//trace_smName + " TRANSITIONING===================");
			var i : uint;
			var finalState : Function;
		
			var msg : String;
			var handled : Object = null;
			if (f > 0 || preExit.length > 0) {
				for (i = 0;i < exitry.length;i++) {
					s = exitry[i];
					/* retrace exit path in reverse order */
					msg = "EXITING " + getStateName(s);
					//tracemsg);
					handled = s.call(this, CogEvent.getExitEvent());
					if(handled == null) {
						transitionLog.push(msg + " HANDLED");
					} else {
						transitionLog.push(msg + " NOT HANDLED");
					}
					finalState = s.call(this, EVT_EMPTY);
				}
			}
			/*
			 *  Perform any between state 'cross' transitions, these should be synchronous, else one should
			 * use a dedicated state to represent.
			 * TODO: Not implemented yet.
			 */
			if(crossAction != null) {
				crossAction();
			}
			/* now we are in the LCA of source__ and target, proceed through the chain and enter each one  in
			 * [0] target
			 * [1] target's parent
			 * [2] targets's grandparent
			 */
			if (e > 0 || postEnter.length > 0) {
				/* retrace entry path in reverse order */
				for (i = 0;i < entry.length;i++) {
					s = entry[i];
					

					if(!isInState(s) || reentrant) {
						// if we are going from a child to an already active parent //
						msg = "ENTERING " + getStateName(s);
						//tracemsg);

						handled = s.call(this, CogEvent.getEnterEvent());
						if(handled == null) {
							transitionLog.push(msg + " HANDLED");
						} else {
							transitionLog.push(msg + " NOT HANDLED");
						}
					}

					finalState = s;
				}
			}
			transLock = false;
			////////////////////////////////////////////////////////////////////////////
			//
			//  FINISHED with the transition, set the current state to the last entered
			//  and proceed to notify the world
			//
			/////////////////////////////////////////////////////////////////////////////
			if(finalState != null) {
				myCurState = finalState;
				dispatchEvent(SIG_GETOPTS.createPrivateEvent());
				onInternalStateChanged();
			} else {
				trace("WARNING, no statetransition performed");
			}
			///// Check if there are additional transitions to peform, that might have 
			// been generated in the process of this last transition.
			//if(!pendingTranList.length > 0){
			//	transitionCallBackTimer.start();				
			//}
			return handled;
		}
	}
}