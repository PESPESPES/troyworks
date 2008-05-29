package com.troyworks.events { 
	import com.troyworks.framework.logging.SOSLogger;
	
	/******************************************************
	* A generic broadcaster engine, calls all listeners
	* used for things like e.g.
	* Me.addListener(Listener1, Listener1.changeHandler);
	* Me.addListener(Listener2, Listener2.changeHandler);
	* Me.notifyListeners("loadEvent") ->
	*  Listener1.changeHandler("loadEvent");
	*  Listener2.changeHandler("loadEvent");
	* Me.notifyListeners("saveEvent") -> *broadcast*
	*  Listener1.changeHandler("saveEvent");
	*  Listener2.changeHandler("saveEvent");
	*
	*******************************************************/
	
	public class TDispatcher {
		public var listeners : Array;
		public var name : String;
		//duplicate check
		public var duplicateCheck : Boolean;
		public static var dispatchers : Number = 0;
	
		protected static var ADD : Number = 0;
		protected static var REMOVE : Number = 1;
		protected static var GET : Number = 2;
		protected static var GET_INDEX : Number = 4;
		protected static var REPLACE : Number = 8;
		
		
		public static var CLASSNAME:String = "com.troyworks.events.TDispatcher";
		public var className:String = CLASSNAME;
		public static var DEBUG_TRACES_ON:Boolean = false;
		public var debugTracesOn:Boolean =DEBUG_TRACES_ON; 
	
		public function TDispatcher() {
			this.listeners = new Array();
			//perform duplicate check
			duplicateCheck = true;
			name = "TDispatcher"+ TDispatcher.dispatchers++;
		};
		static public function initialize(p_obj : Object) : void {
			public var td:TDispatcher = new TDispatcher();
			if(td == null){
				SOSLogger.getInstance().fatal("TDispatcher.initialize can't get TD copy");
			}
			p_obj.$_td = td;
	//	   trace("initing " + td.name);
			TProxy.currentUserName = "TDispatcher.initialize";
			//TProxy.ADD_CALLEE = false;
			public var temp:Boolean =TProxy.DEBUG_TRACES_ON;
			TProxy.DEBUG_TRACES_ON = false;
			p_obj.containsListener = TProxy.create(td, td.containsListener);
			trace("td.containsListener = TProxy " + TProxy.IDz);
			p_obj.addListener = TProxy.create(td, td.addListener);
			trace("td.addListener = TProxy " + TProxy.IDz);
			
			p_obj.removeListener = TProxy.create(td, td.removeListener);
				trace("td.removeListener = TProxy " + TProxy.IDz);
			p_obj.removeAllListeners =TProxy.create(td, td.removeAllListeners);
					trace("td.removeAllListeners = TProxy " + TProxy.IDz);
			p_obj.notifyListeners = TProxy.create(td, td.notifyListeners);
						trace("td.notifyListeners = TProxy " + TProxy.IDz);
			//TProxy.ADD_CALLEE = true;
			TProxy.DEBUG_TRACES_ON = temp;
			TProxy.currentUserName = null;
		}
		public function containsListener(object : Object, fn : Object) : Boolean{
			for(public var i in this.listeners){
				public var list : Object = this.listeners[i];
				public var isSFn:Boolean= list.fn == fn;
				public var isSObj:Boolean = list.obj == object;
				if(isSFn && isSObj){
					trace("WARNING : addListener Error! listener already added");
					return true;
				}
			}
			return false;
		}
		public function indexOfListener(object : Object, fn : Object) : Array{
			var places : Array = new Array();
			for(var i:String in this.listeners){
				//actually TProxy created
				public var list : Object = this.listeners[i];
				public var isSFn:Boolean= list.fn == fn;
				public var isSObj:Boolean = list.obj == object;
				if(isSFn && isSObj){
					places.push(Number(i));
				}
			}
			return places;
		}
		protected function getIndexesOfListeners(object : Object, fn : Object, operation : Number, proxy:TProxy) : Array{
			var found : Array = new Array();
			var i : Number = this.listeners.length;
			while (i--) {
				//actually TProxy created
				public var list : Object = this.listeners[i];
				public var isSFn:Boolean= list.fn == fn || fn == null;
				public var isSObj:Boolean = list.obj == object;
				if(isSFn && isSObj){
	
					switch(operation){
						case TDispatcher.REPLACE:
							found.push(i);
							this.listeners[i] = proxy;
							break;
						case TDispatcher.REMOVE:
							found.push(i);
							this.listeners.splice(i,1);
							break;
						case TDispatcher.GET:
							found.push(this.listeners[i]);
							break;
						case TDispatcher.GET_INDEX:
							found.push(i);
							break;
							}
						}
					}
	
			return found;
		}
	
		////////////////////////////////
	// ADDLISTENER
	// case 1: 1st argument is a function ->unscoped call
	// case 2: 1st argument is an object/movieclip, 2nd argument is a function ->scoped call
	// case 3: 1st argument is an object/movieclip, 2nd argument is null -> try default handleEvent function pointer
	// case 4: 1st argument is an object/movieclip, 2nd argument is a string -> try getting function pointer
	
	// args != null, append to events sent.
		public function addListener(object : Object, fn : Object, args : Object) : void {
			//SOSLogger.getInstance().highlight(this.name + "addListener------------------------------- USR args" + arguments.join("\r"));
			
			var res : Function = null;
			if(object is Function){
				res = Function(object);
			}else{
				res = TProxy.create.apply(this, arguments);
			}
			if(res != null){
				this.listeners.push(res);
			}
	
		}
		public function removeListener(obj : Object, fn : Object) : Number {
			//object !null and function !null =>remove obj/function;
			//object !null and function =null =>remove all listeners for obj;
			//object null and function !null =>remove function;
			//object null and function null =>return;
	
			//remove interpreted function (e.g. handleRequest)
			var idxs : Array = this.getIndexesOfListeners(obj, fn, TDispatcher.REMOVE);
			return idxs.length;
		}
		public function removeAllListeners() : void {
			delete(this.listeners);
			this.listeners = new Array();
		}
		// NOTIFYLISTENERS.  Expects at least an event id and an optional values,
		public function notifyListeners() : void {
			if(debugTracesOn){
			trace(this.name + ".notifyListeners "+ util.Trace.me(arguments, "arguments", true));
			}
			//SOSLogger.getInstance().highlight(util.Trace.me(arguments, "Arguments",true));
			//Note that arguments is actually the TProxy	
			var len:Number = this.listeners.length;
			for (var i:Number = 0; i<len; i++) {
				public var li:Function = Function(this.listeners[i]);
				li.apply(li, arguments);
			}
			
		}
		public function toString(void) : String {
			var result:String = "";
			var len:Number = this.listeners.length;
			for (var i:Number = 0; i<len; i++) {
				public var name:String = ((this.listeners[i].obj != null) ? (this.listeners[i].obj.name) : ("no object"));
				public var delimiter:String = ((i<len) ? ", " : "");
				result += name+delimiter;
			}
			return result;
		}
	}
}