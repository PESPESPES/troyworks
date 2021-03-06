package com.troyworks.framework.model {
	import com.troyworks.core.Signals; 

	/**
	 * @author Troy Gardner
	 */
	public class ModelChangedEvent extends ModelEvent{
		public static var CREATED:Number = 0;
		public static var READ:Number = 2;
		public static var UPDATE:Number = 1;
		public static var DELETED:Number = -1;
		public var crud:Number;
		
		public function ModelChangedEvent(type:String, sig : Signals) {
			super(null, sig);
		}
	}
}