package com.troyworks.framework.controller { 
	import com.troyworks.framework.BaseStatefulObject;
	
	/**
	 * @author Troy Gardner
	 */
	public class BaseController extends BaseStatefulObject {
		
		public function BaseController(initialState:String = "s_initial", hsmfName:String = "BaseController", aInit:Boolean = true) {
			super(initialState, hsmfName,aInit);
		}
	
	}
}