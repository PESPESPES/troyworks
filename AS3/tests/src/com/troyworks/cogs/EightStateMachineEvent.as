package com.troyworks.cogs
{	import com.troyworks.cogs.CogEvent;
	import com.troyworks.cogs.CogSignal;
	import com.troyworks.cogs.Hsm;
	import com.troyworks.cogs.EightStateMachineSignal;
	/*****************************************
	 * The primary events that navigate around the topology
	 * Events are immutable, single use
	 *************************************** */
	public class EightStateMachineEvent extends CogEvent{
		
		
		/* these are more of a convenience to the possible events used for autocomplete*/
		public static  const SELF:EightStateMachineSignal = EightStateMachineSignal.SELF;
		public static  const SELF2:EightStateMachineSignal = EightStateMachineSignal.SELF2;
		public static  const PARENT:EightStateMachineSignal = EightStateMachineSignal.PARENT;
		public static  const GRANDPARENT:EightStateMachineSignal = EightStateMachineSignal.GRANDPARENT;
		public static  const CHILD_INACTIVE:EightStateMachineSignal = EightStateMachineSignal.CHILD_INACTIVE;
		public static  const CHILD_ACTIVE:EightStateMachineSignal = EightStateMachineSignal.CHILD_ACTIVE;
		public static  const GRANDCHILD_INACTIVE:EightStateMachineSignal = EightStateMachineSignal.GRANDCHILD_INACTIVE;
		public static  const GRANDCHILD_ACTIVE:EightStateMachineSignal = EightStateMachineSignal.GRANDCHILD_ACTIVE;
		public static  const GRANDCHILD_INACTIVE2:EightStateMachineSignal = EightStateMachineSignal.GRANDCHILD_INACTIVE2;

		public static  const SIBLING:EightStateMachineSignal = EightStateMachineSignal.SIBLING;
		public static  const UNCLE:EightStateMachineSignal = EightStateMachineSignal.UNCLE;
		
		public static  const GREAT_UNCLE:EightStateMachineSignal = EightStateMachineSignal.GREAT_UNCLE;
		public static  const GREAT_NEPHEW:EightStateMachineSignal = EightStateMachineSignal.GREAT_NEPHEW;
		public static  const FIRST_COUSIN_REMOVED:EightStateMachineSignal = EightStateMachineSignal.FIRST_COUSIN_REMOVED;
		public static  const MIRRORDEPTH_ON_OTHER_STACK:EightStateMachineSignal = EightStateMachineSignal.MIRRORDEPTH_ON_OTHER_STACK;

		public function EightStateMachineEvent(sig:EightStateMachineSignal){
			super(sig.name, sig);
		}
		override public function toString():String{
			return "EightStateMachine " + sig.name;
		}
	}
}