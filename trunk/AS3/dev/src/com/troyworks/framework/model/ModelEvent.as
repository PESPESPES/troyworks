package com.troyworks.framework.model { 
	import com.troyworks.hsmf.AEvent;
	import com.troyworks.hsmf.Signal;
	
	/**
	 * @author Troy Gardner
	 */
	public class ModelEvent extends AEvent {
		
		public function ModelEvent(sig : Signal) {
			super(sig);
		}
	
	}
}