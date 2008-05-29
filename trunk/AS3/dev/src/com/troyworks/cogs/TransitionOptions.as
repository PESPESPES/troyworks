/**
* This class represents the various options available to a
* a transition request. Things such as if the init actions past the target state should
* be discovered.
* 
* @author Troy Gardner 
* @version 0.1
*/

package com.troyworks.cogs {

	
	public class TransitionOptions {
		
		/* wether or not to use the already cached transition path
		 * if already discovered, not that some state transitions
		 * are dynamic, meaning upon init, they will go to different
		 * states based on extended state variables, here these dynamic
		 * transition chains should be rediscovered */
		public var useCachedRouting:Boolean = true;
		public var doInitDiscovery:Boolean = true;	
		/* reserved for future use */
		public var exitSelf:Boolean = true;
		public var reenterActiveStates:Boolean = true;
		/* once we have the command list prune from the log any thing that's
		 * not actually called during the execution to save time*/
		public var pruneUnusedEvents:Boolean = true;
//		public var pruneCommon:Boolean = true;
		public static const  DEFAULT:TransitionOptions = new TransitionOptions();
	}
	
}
