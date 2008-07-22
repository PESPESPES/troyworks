package ui {
	import com.troyworks.core.cogs.CogSignal;	
	import com.troyworks.core.cogs.Hsm;
	import com.troyworks.core.cogs.CogEvent;	

	/**
	 * @author Troy Gardner
	 */
	public class UIController extends Hsm {
		
		public static const RESET:CogSignal = CogSignal.getNextSignal("RESET");
		public static const UNSELECTED_SELECTED:CogSignal = CogSignal.getNextSignal("UNSELECTED_SELECTED");
		public static const INTERACTIONNODE_SELECTED:CogSignal = CogSignal.getNextSignal("INTERACTIONNODE_SELECTED");

		
		

		public function UIController(initStateNameAct : String = null, smName : String = null, aInit : Boolean = true) {
			super(initStateNameAct, smName, aInit);
		}
		
		///////////////////// STATES ///////////////////////////////
		/*.................................................................*/
		 public function s_initial(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_INIT :
					/* initialize extended state variable */
					return s_active;
			}
			return  s_root;
		}
		/*.................................................................*/
		public function s_active(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_ENTRY :
					return null;
				case SIG_EXIT :
					return null;
				case SIG_INIT :
					return s_nothingSelected;
			}
			return  s_root;
		}
		/////////////////////////////////////////////////////////////////////////
		/*.................................................................*/
		public function s_nothingSelected(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_ENTRY :
					return null;
				case UNSELECTED_SELECTED:
					requestTran(s_secondSelected);
					return null;					
				case SIG_EXIT :
					return null;
			}
			return  s_active;
		}
		
		/*.................................................................*/
		public function s_somethingSelected(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_ENTRY :
					return null;
				case RESET:
					requestTran(s_nothingSelected);
					return null;					
				case SIG_EXIT :
					return null;
				case SIG_INIT :
					return s_firstSelected;
			}
			return  s_active;
		}
		
		/*.................................................................*/
		public function s_firstSelected(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_ENTRY :
					return null;
				case SIG_EXIT :
					return null;
			}
			return  s_somethingSelected;
		}
				/*.................................................................*/
		public function s_secondSelected(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_ENTRY :
					return null;
				case SIG_EXIT :
					return null;
			}
			return  s_firstSelected;
		}
	}
}
