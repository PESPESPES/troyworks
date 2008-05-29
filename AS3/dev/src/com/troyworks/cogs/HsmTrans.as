package com.troyworks.cogs
{
	import com.troyworks.cogs.Hsm;
	import com.troyworks.cogs.CogEvent;
	import com.troyworks.util.DesignByContract;
	import com.troyworks.util.DesignByContractEvent;
	public class HsmTrans extends Fsm
	{
		
			var hsm:Hsm;
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
			var lastState:Function;
			
			var targetState:Function;
			var mySource:Function;
			var myTopState:Function;
			
			
		//an empty array with nulls as placeholders
		protected var entry : Array = [null, null, null, null, null, null, null, null, null, null, null];
		protected var exitry : Array = [null, null, null, null, null, null, null, null, null, null, null];
		public function HsmTrans(hsm:Hsm, startFromState:Function, destinationState:Function){
			super();
			DesignByContract.initialize(this);
			_initState= s_unRouted;
			mySource = startFromState;
			targetState = destinationState;
		}
		/////////////////////////////////////
		function s_unRouted(event:CogEvent):void {
			
		}
		function s_discoveringRoute(event:CogEvent):void{
			REQUIRE(targetState != hsm.top)
			//targetState is parent and it's already active.
			var tIsPA : Boolean = false;
			
			// UNWIND From currentState to the
			// source of the transition
			// 
		
			for(s = myState; s != mySource){
			  
			}
			
			lastState = mySource;
			// assume entry to targetState
			if (mySource == targetState)
			{
				// trace ("(a) - self transition");
				/* Fig 4.7(a) */
				/* source == targetState (transition to self)
				 */
				entry [e ++] = targetState;
				exitry [f ++] = mySource;
				
			} else
			{
		//		trace ("source != target");
				//target's parent state
				 var tp : Function = Function (targetState.call (this, EMPTY_EVT));
				//sources parent state
				 var sp : Function = Function (mySource (EMPTY_EVT));
				 var lcaEn : Boolean = false;
				 var lcaEx : Boolean = false;
				//Single Level Transitions, no extended discovery needed.
				if (mySource == tp && myCurState == mySource)
				{
		//			trace ("*Fig 4.7 (b)* -  transition to first child - ENTER only" );
					entry [e ++] = targetState;
				} else if (sp == tp&& myCurState == mySource)
				{
		//			trace ("*Fig 4.7 (c) (sp == tp)* -  transition to sibling via parent EXIT and ENTER chain ");
					entry [e ++] = targetState;
					exitry [f ++] = mySource;
				} else if (sp == targetState&& myCurState == mySource)
				{
		//			trace ("*Fig 4.7 (d)* -  transition to first parent EXIT only");
					exitry [f ++] = mySource;
					tIsPA = true;
				} else
				{
		//			trace ("*Fig 4.7 (e),(f), (g), (h) (sp.. == tp..)* -  transition to sibling(s) EXIT and ENTER chain  ");
					//ENTER LIST from target
					for (s = targ; s != null; s = Function (s.call (this, EMPTY_EVT)))
					{
						//trace ("checking enter list from targets's parent"  + s.call (this, TRACE_EVT));
						if (s == mySource )
						{
		//					trace ("e 4.7 (e)  found LCA! " + e);
							lcaEn = true;
							break;
						} else if (s == s_top)
						{
							break;
						}
		//				trace ("adding entry to list" + s.call (this, TRACE_EVT));
						entry [e ++] = s;
					}
					//EXIT LIST get exitter list from source
					for (s = myCurState; s != null; s = Function (s.call (this, EMPTY_EVT)))
					{
		//				trace ("checking exit list from activestate/source " + s.call (this, TRACE_EVT));
						if (s == targ )
						{
		//					trace ("x 4.7 (h) found LCA ! " + f);
							lcaEx = true;
							break;
						} else if (s == s_top)
						{
							break;
						}
		//				trace ("adding to exit list " + s.call (this, TRACE_EVT));
						exitry [f ++] = s;
					}
		//			trace ("\r\r");
		//			traceEnterExitList (f, e, "after normal routing");
		//			trace ("\r\r");
					if ((e > 0 && f > 0)) //&& ( ! lcaEn && ! lcaEx)
					{
						//if we are here we didn't find the LCA *Fig 4.7 (g)
						//	trace ("----performing LCA extended discovery pruning---------");
						var ee : Number = e;
						var ff : Number = f;
						while (entry [( -- ee )] == exitry [( -- ff)])
						{
							e --;
							f --;
							//		trace ("discarding " + entry [(e )].call (this, TRACE_EVT) + " " + exitry [(f )].call (this, TRACE_EVT));
						}
					}
		//			trace ("\r\r");
		//			traceEnterExitList (f, e, "after LCA discovery");
		//			trace ("\r\r");
				}
			}
			
			/*------------- PROCESS THE INIT_EVT --------------*/
			onInternalStateChanged ();
	
			if ( ! tIsPA)
			{
			
				/* process the init event */
				//Q_tranInit();
		
				//this will fire off a Q_TRAN inside the targ, which will update the 
				// myCurState
				// or return null if handled.
				var res = myCurState.call (this, INIT_EVT);
	
		 		if(res == null){
				//	trace(" INIT EVENT CONSUMED");
					if (myCurState === targ)
					{
						//returned itself so no INIT_EVT handler, or at least no state transition performed
					//	trace("Kept Same state");
					}
				}else{
					//returned another state of some sort.
					if (myCurState === targ)
					{
					//	trace (toStringShort ()+ " ERROR IN STATEMACHINE, INIT_EVT kept same state without consuming" + res);
					} else
					{
						myCurState.call (this, TRACE_EVT);
						var an2 = __traceN;
						targ.call (this, TRACE_EVT);
						var bn2 = __traceN;
						trace (toStringShort ()+"Q_Tran.INIT Has Another StateTransition >>>>>>>>>>>>>>>>>>>>>>>>>>>>> \r\t" + an2 + " to \r\t" + bn2 + "");
						// initial transition must go one level deep, so the empty event will return the parent which should equal the original state 
						ASSERT (targ == myCurState (EMPTY_EVT) , "3 Error in Q_TRAN " + hsmName + " " + __cStateName + ", initial transition must go one level deep");
					}				
				}
			} else
			{
				//parent state is already active no need to reinitialize, but we do need to reactivate ti.
				targ.call (this, EMPTY_EVT);
				//	onInternalStateChanged (targ);
	
			}
		}

		function s_performingExit(event:CogEvent):void{
			/* now we have the list of operations for this transition  proceed through the chain and exit each one
			* [0] child
			* [1] parent
			* [2] grandparent
			*/
			if (f > 0)
			{
				while ((s = Function (exitry [ -- f ])) != null)
				{
					//	trace ("Exiting " + s.call (this, TRACE_EVT))
					/* retrace exot
					* path in reverse order */
					//_global.outText ("preExit4");
					s.call (this, CogEvent.getExitEvent());
					//_global.outText ("postExit4");
					/* enter */
				}
			}
	
		}
		function s_performingEnter(event:CogEvent):void{
			/* now we are in the LCA of source__ and target, proceed through the chain and enter each one  in
			* [0] target
			* [1] target's parent
			* [2] targets's grandparent
			*/
			if (e > 0)
			{
				while ((s = Function (entry [ -- e])) != null)
				{
					/* retrace entry path in reverse order */
					//_global.outText ("preEnter4");
					s.call (this, CogEvent.getEnterEvent());
					//_global.outText ("postEnter4");
					/* enter */
				}
			}
			//Once we've reached this point we've already entered the target state specified by the
			//transition , but may have substate transitions to attend to, not specified by the
			// requested transition, this should not be more than one level deep.
			// currentState == result  and null = consumed the event
			//
			myCurState = targ;
	
			
		}
	}
}