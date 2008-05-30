package com.troyworks.core.cogs
{
	import com.troyworks.core.cogs.Hsm;
	import com.troyworks.core.cogs.CogEvent;
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
			if(targetState != hsm.s_root){
				return;
			}
			//TODO move this over from HSM
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