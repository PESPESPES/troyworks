package com.troyworks.metrics { 
	import com.troyworks.framework.model.BaseModelObject;
	
	/**
	 * @author Troy Gardner
	 */
	public class BaseMetric extends BaseModelObject {
		
		public var cnt:Number = null;
		public var evt:Object = null;
		public var timeDateStamp = null;
		public function BaseMetric() {
			super();
			
		}
	
	}
}