package com.troyworks.hsmf.patterns { 
	import com.troyworks.hsmf.FSM;
	import com.troyworks.hsmf.Signal;
	
	/**
	 * @author Troy Gardner
	 */
	public class FSMDiamond extends FSM {
		public static var Q_ACTIVATE : Signal = Signal.getNext("Q_ACTIVATE");
		public static var Q_ACTIVATED : Signal = Signal.getNext("Q_ACTIVATED");
		public static var Q_DEACTIVATE : Signal = Signal.getNext("Q_DEACTIVATE");
		public static var Q_DEACTIVATED : Signal = Signal.getNext("Q_DEACTIVATED");
	
		public function FSMDiamond(initalState : Function, name : String, aInit : Boolean) {
			super(initalState, name, aInit);
		}
		public function s_inactive(sig : Signal) : void{
			switch(sig){
				case Q_ACTIVATE:
					Q_TRAN(s_activating);
					break;
			}
		}
		public function s_activating(sig : Signal) : void{
			switch(sig){
				case Q_ACTIVATED:
					Q_TRAN(s_activating);
					break;
			}
			
		}
		public function s_active(sig : Signal) : void{
			switch(sig){
				case Q_DEACTIVATE:
					Q_TRAN(s_activating);
					break;
			}
			
		}
		public function s_deactivating(sig : Signal) : void{
			switch(sig){
				case Q_DEACTIVATED:
					Q_TRAN(s_activating);
					break;
			}
			
		}
		
	}
}