/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.core.cogs {

	public class QueuedTransitionRequest {
		 //////////////////////////////////////////////////////////////////
		public var trg:Function;
		public var opts:TransitionOptions;
		public var crossAction:Function;
		//public var doInitDiscovery:Boolean = false;
		
		function QueuedTransitionRequest(targetState:Function, transOptions:TransitionOptions = null, crossLCAAction:Function= null){
			trg = targetState;
			opts = (transOptions == null)?TransitionOptions.DEFAULT:transOptions;
			crossAction = crossLCAAction;			
		}
	
	}
	
}
