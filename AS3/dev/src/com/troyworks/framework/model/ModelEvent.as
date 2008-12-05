package com.troyworks.framework.model {
	import com.troyworks.core.Signals;	
	import com.troyworks.core.cogs.CogEvent; 

	/**
	 * @author Troy Gardner
	 */
	public class ModelEvent extends CogEvent {
		
		public function ModelEvent(type:String, sig : Signals) {
			super(type,sig);
		}
	
	}
}