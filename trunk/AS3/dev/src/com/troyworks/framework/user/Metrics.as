package com.troyworks.framework.user { 
	import com.troyworks.framework.model.BaseModelObject;
	import com.troyworks.datastructures.Array2;
	
	/**
	 * @author Troy Gardner
	 */
	public class Metrics extends BaseModelObject {
		
		//
		public var totalViews:Number;
		public var history:Array2;
		
		
		public function Metrics() {
			super();
		}
	
	}
}