package com.troyworks.framework { 
	import com.troyworks.hsmf.Hsmf;
	import com.troyworks.framework.model.BaseModelObject;
	import com.troyworks.hsmf.AEvent;
	import com.troyworks.ui.tree.ITreeDataProvider;
	/**
	 * @author Troy Gardner
	 */
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	public class BaseStatefulObject extends Hsmf implements ITreeDataProvider {
		
		
		public var _id_ : Number = null;
		public var _extendedToString : Boolean = false;
		protected static var _className : String = "com.troyworks.framework.model.BaseModelObject";
	
		public function BaseStatefulObject(initialState : Function, hsmfName : String, aInit : Boolean) {
			super ((initialState == null)? s_initial :initialState, (hsmfName != null)?hsmfName:":BaseStatefulObject", aInit);
			_id_ = BaseModelObject.IDz++;
		}
		public function toString() : String{
	
			var res : String = null;
			//util.Trace.engageLoopCheck();
			if(_extendedToString){
				res =util.Trace.me(this, _className);
			}else{
				res = ("BaseStatefulObject _id_ " + _id_);
			}
			//util.Trace.disEngageLoopCheck();
			return res;
		}
		public function toXML(tree : XMLDocument) : XMLNode {
			if (tree == null) {
				tree = new XMLDocument();
			}
			var n : XMLNode = tree.createElement("BaseStatefulObject");
			n.attributes.label = "BaseStatefulObject";
			return n;
			
		}
		public function addEventListener(evt : String, arg1 : Object, arg2 : Object, arg3 : Object) : void {
			super.addEventListener.apply(this, arguments);
		}
		
		
		/*..PSEUDOSTATE...............................................................*/
		public function s_initial(e : AEvent) : void
		{
			//trace("************************* s_initial " + util.Trace.me(e)+" ******************");
			onFunctionEnter ("s_initial-", e, []);
			if(e.sig != Q_TRACE_SIG){
				Q_INIT(s_active);
			}
		}
		/*.................................................................*/
		public function s_active(e : AEvent) : Function
		{
			onFunctionEnter ("s_begin-", e, []);
			switch (e.sig)
			{
				case Q_ENTRY_SIG :
				{
	
					return null;
				}
	
				case Q_TERMINATE_SIG:
				{
					Q_TRAN(s_final);
					return null;
				}
			}
			return s_top;
		}
		/*..PSEUDOSTATE...............................................................*/
		public function s_final(e : AEvent) : void
		{
			this.onFunctionEnter ("s_final-", e, []);
			switch (e.sig)
			{
				case Q_ENTRY_SIG :
				{
					return;
				}
			}
		}
		
	
	}
}