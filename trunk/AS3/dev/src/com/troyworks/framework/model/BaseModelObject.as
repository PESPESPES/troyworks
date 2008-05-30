package com.troyworks.framework.model { 
	import com.troyworks.framework.BaseObject;
	
	/**
	 * Model Objects are designed to be data only with getters and setter
	 * Use BaseController for collection managers 
	 * 
	 * @author Troy Gardner
	 */
	public class BaseModelObject extends BaseObject {
		public var _id_:Number =NaN;
		public static var IDz:Number = 0;
		public var _extendedToString:Boolean = false;
		protected static var _className : String = "com.troyworks.framework.model.BaseModelObject";
		public static var EVTD_MODEL_CHANGED:String = "EVTD_MODEL_CHANGED";
		
		public function BaseModelObject() {
			super();
			_id_ = BaseModelObject.IDz++;
			
		}
		public function toString():String{
			
			var res:String = null;
			//util.Trace.engageLoopCheck();
			if(_extendedToString){
				res =util.Trace.me(this, _className);
			}else{
				res = ("BaseModelObject _id_ " + _id_);
			}
			//util.Trace.disEngageLoopCheck();
			return res;
		}
	}
}