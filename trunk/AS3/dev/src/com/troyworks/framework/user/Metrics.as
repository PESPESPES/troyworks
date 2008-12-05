package com.troyworks.framework.user {
	import com.troyworks.framework.model.BaseModelObject;
	import com.troyworks.data.ArrayX;
	
	/**
	 * @author Troy Gardner
	 */
	public class Metrics extends BaseModelObject {
		
		//
		public var totalViews:Number;
		public var history:ArrayX;
		
		
		public function Metrics() {
			super();
		}
	
	}
}