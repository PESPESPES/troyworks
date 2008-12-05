package com.troyworks.framework {
	import com.troyworks.core.cogs.CogEvent;
	import com.troyworks.core.cogs.Hsm;
	import com.troyworks.framework.model.BaseModelObject;
	import com.troyworks.util.Trace;		

	/**
	 * @author Troy Gardner
	 */

	
	public class BaseStatefulObject extends Hsm {
		
		
		public var _id_ : Number = NaN;
		public var _extendedToString : Boolean = false;
		protected static var _className : String = "com.troyworks.framework.model.BaseModelObject";
	
		public function BaseStatefulObject(initState:String = "s_initial", hsmfName:String = "BaseStatefulObject",aInit:Boolean = true) {
			super(initState,hsmfName,aInit);
			_id_ = BaseModelObject.IDz++;
		}
		public function toString() : String{
	
			var res : String = null;
			//util.Trace.engageLoopCheck();
			if(_extendedToString){
				res =Trace.me(this, _className);
			}else{
				res = ("BaseStatefulObject _id_ " + _id_);
			}
			//util.Trace.disEngageLoopCheck();
			return res;
		}
		public function toXML(tree : XML) : XML {
			if (tree == null) {
				tree = new XML();
			}
			//XXX TODO
			var n : XML = tree.createElement("BaseStatefulObject");
			n.attributes.label = "BaseStatefulObject";
			return n;
			
		}
		
		
		/*..PSEUDOSTATE...............................................................*/
		public function s_initial(e : CogEvent) :  Function
		{
			//trace("************************* s_initial " + util.Trace.me(e)+" ******************");
			//onFunctionEnter ("s_initial-", e, []);
			if(e.sig != SIG_TRACE) {
				return s_active;
			}
		}
		/*.................................................................*/
		public function s_active(e : CogEvent) : Function
		{
			//onFunctionEnter ("s_begin-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
					{
	
					return null;
				}
	
				case SIG_TERMINATE:
					{
					tran(s_final);
					return null;
				}
			}
			return s_root;
		}
		/*..PSEUDOSTATE...............................................................*/
		public function s_final(e : CogEvent) : void
		{
			//this.onFunctionEnter ("s_final-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					return;
				}
			}
		}
		
	
	}
}