/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.dayinlife {
	import com.troyworks.core.cogs.*;

	public class AtHome extends Fsm {
		
		public function AtHome(initState:String = null) {
			super();
			_initState=(initState  == null)? s_initial:null;
			trace("new AtHome");
		}
		////////////////// STATES /////////////////////////////
		public function s_initial(event:CogEvent):void {
			trace(getStateMachineName()+":AtHome.s_initialStateXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			tran(s_InBedroom);
			fsm_hasInited = true;
		}
		public function s_InBedroom(event:CogEvent):void {
			trace(getStateMachineName()+":AtHome.s_InBedroom " + event);
			switch(event.sig){
				case SIG_ENTRY:
				trace("NOW IN BEDROOM");
				break;
				case SIG_EXIT:
				trace("NOW LEAVING BEDROOM");
				break;

			}

		}
		public function s_InBathroom(event:CogEvent):void {
			trace(getStateMachineName()+":AtHome.s_InBathroom " + event);
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
