package com.troyworks.hsmf { 
	import com.troyworks.framework.BaseObject;
	import com.troyworks.events.TEventDispatcher;
	
	/**
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;
	public class FSM extends MovieClip {
		
		protected var _myState:Function;
		public static var evtd : TEventDispatcher;
		// EventDispatcher mixin interface
		public var addEventListener : Function;
		public var dispatchEvent : Function;
		public var removeEventListener : Function;
		public static var EVT_INT_STATE_CHANGED : String = "EVT_INT_STATE_CHANGED";
		/*****************************************************
		 *  Constructor
		 */
		public function FSM(initalState:Function, name:String, aInit:Boolean) {
			super();
			TEventDispatcher.initialize(this);
		}
		//////////////////// ACCESSORS ////////////////////////////
		public function get myState():Function{
			return _myState;
		}
		public function set myState(state:Function){
			var old:Function = _myState;
			old.call(this, QSignals.Q_EXIT_SIG);
			_myState = state;
			_myState.call(this, QSignals.Q_ENTRY_SIG);
			dispatchEvent (
			{
				type : EVT_INT_STATE_CHANGED, target : this, oldVal:old, newVal:_myState
			});
		}
		//////////////////// STATE MACHINE ////////////////////////////////////
		public function init():void{
			Q_dispatch();
		}
		public function Q_dispatch(sig:Signal):void{
			myState.call(this,sig);
		}
		public function Q_TRAN(target:Function):void{
			tran(target);
		}
		protected function tran(target:Function):void{
			myState = target;
		}
	}
}