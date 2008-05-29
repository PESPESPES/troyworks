package com.troyworks.cogs{
	import com.troyworks.cogs.CogEvent;
	import com.troyworks.cogs.CogSignal;
	import com.troyworks.cogs.Hsm;

	/*****************************************
	 * Signals are immutable and reused over and over again
	 *  across various CogEvents,
	 * 
	 * This collection of Signals covers the entire 'Family Tree'
	 * of Transitions that Cog Supports.
	 * 
	 * See 	//http://en.wikipedia.org/wiki/Cousin for a better understanding 
	 * of terms as used traditionally, 
	 * 
	 *************************************** */
	public class EightStateMachineSignal extends CogSignal {
		public function EightStateMachineSignal(val : uint, name : String) {
			super(val, name );
		}
		public static function getNextSignal(msg:String):EightStateMachineSignal {
			var sig:CogSignal = CogSignal.getNextSignal(msg);
			return new EightStateMachineSignal(sig.value,msg);
		}

	
		public static  const SELF : EightStateMachineSignal = EightStateMachineSignal.getNextSignal("SELF");
		public static  const SELF2 : EightStateMachineSignal = EightStateMachineSignal.getNextSignal("SELF2");
		public static  const PARENT : EightStateMachineSignal = EightStateMachineSignal.getNextSignal( "PARENT");
		public static  const GRANDPARENT : EightStateMachineSignal = EightStateMachineSignal.getNextSignal( "GRANDPARENT");
		public static  const CHILD_INACTIVE : EightStateMachineSignal = EightStateMachineSignal.getNextSignal( "CHILD_INACTIVE");
		public static  const CHILD_ACTIVE : EightStateMachineSignal = EightStateMachineSignal.getNextSignal( "CHILD_ACTIVE");
		public static  const GRANDCHILD_INACTIVE : EightStateMachineSignal = EightStateMachineSignal.getNextSignal( "GRANDCHILD_INACTIVE");
		public static  const GRANDCHILD_ACTIVE : EightStateMachineSignal = EightStateMachineSignal.getNextSignal( "GRANDCHILD_ACTIVE");
		public static  const GRANDCHILD_INACTIVE2 : EightStateMachineSignal = EightStateMachineSignal.getNextSignal( "GRANDCHILD_INACTIVE2");

		public static  const SIBLING : EightStateMachineSignal = EightStateMachineSignal.getNextSignal( "SIBLING");
		public static  const UNCLE : EightStateMachineSignal = EightStateMachineSignal.getNextSignal( "UNCLE");
		public static  const NEPHEW : EightStateMachineSignal = EightStateMachineSignal.getNextSignal( "NEPHEW");
		public static  const GREAT_UNCLE : EightStateMachineSignal = EightStateMachineSignal.getNextSignal( "GREAT_UNCLE");
		public static  const GREAT_NEPHEW : EightStateMachineSignal = EightStateMachineSignal.getNextSignal( "GREAT_NEPHEW");
		public static  const FIRST_COUSIN_REMOVED : EightStateMachineSignal = EightStateMachineSignal.getNextSignal( "FIRST_COUSIN_REMOVED");
		public static  const MIRRORDEPTH_ON_OTHER_STACK : EightStateMachineSignal = EightStateMachineSignal.getNextSignal( "MIRRORDEPTH_ON_OTHER_STACK");

	}
}