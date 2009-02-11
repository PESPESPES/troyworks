/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.dayinlife {
	import com.troyworks.core.cogs.*;
	public class AtWork extends Fsm {
		
		public function AtWork(initState:String = null) {
			super();
			_initState=(initState  == null)? s_initial:null;
			trace("new AtWork");
		}
		////////////////// STATES /////////////////////////////
		public function s_initial(event:CogEvent):void {
			trace(getStateMachineName()+":AtWork.s_initialState XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			tran(s_InCubicle);
			fsm_hasInited = true;
		}
		public function s_InCubicle(event:CogEvent):void {
			trace(getStateMachineName()+":AtWork.s_InCubicle " + event);
			switch(event.sig){
				case SIG_ENTRY:
				trace("NOW IN CUBICLE");
				break;
				case SIG_EXIT:
				trace("NOW LEAVING CUBICLE");
				break;

			}

		}
		public function s_InBathroom(event:CogEvent):void {
			trace(getStateMachineName()+":AtWork.s_InBathroom " + event);
			switch(event.sig){
				case SIG_ENTRY:
				trace("NOW IN BATHROOM");
				break;
				case SIG_EXIT:
				trace("NOW LEAVING BATHROOM");
				break;
			}
		}
		
	}
	
}
