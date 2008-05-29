package com.troyworks.framework.controller { 
	import com.troyworks.hsmf.Hsmf;
	import com.troyworks.framework.BaseStatefulObject;
	
	/**
	 * @author Troy Gardner
	 */
	public class BaseController extends BaseStatefulObject {
		
		public function BaseController(initialState:Function, hsmfName:String, aInit:Boolean) {
			super(initialState, (hsmfName== null)?"BaseController":hsmfName,aInit);
		}
	
	}
}