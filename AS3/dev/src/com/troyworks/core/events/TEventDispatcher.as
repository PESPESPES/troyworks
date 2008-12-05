package com.troyworks.core.events {
	import com.troyworks.util.Trace; 

	//!-- UTF8
	/***********************************************************
	* A specific event Broadcaster  e.g "myEvent" args
	*
	*  this.eb = new MultipleEventBroadcaster();
	*  this.eb.addListener("loadEventString", Listener1, Listener1.onLoadHandler);
	*
	* used for things like e.g.
	* Me.addListener("loadEvent", Listener1, Listener1.onLoadHandler);
	* Me.addListener("loadEvent", Listener2, Listener2.onLoadHandler);
	* Me.addListener("saveEvent", Listener2, Listener2.onSaveHandler);
	* Me.notifyListeners("loadEvent") ->*broadcast*
	*  *Listener1.onLoadHandler called!*
	*  *Listener2.onLoadHandler called!*;
	* Me.notifyListeners("saveEvent") -> *broadcast*
	*  *Listener2.onSaveHandler called!*;
	*  *
	*  *
	*  *    public var $tevD:TEventDispatcher;
			public var dispatchEvent:Function;
	//			public var eventListenerExists:Function;
				public var addEventListener:Function;
				public var removeEventListener:Function;
				public var removeAllEventListeners:Function;
	*
	***********************************************************/
	public class TEventDispatcher {
			protected var ents:Object;
			public var stripEventLabel:Boolean;
			public static var CLASSNAME:String = "com.troyworks.events.TEventDispatcher";
			public var className:String = CLASSNAME;
			public static var DEBUG_TRACES_ON:Boolean = false;
			public var debugTracesOn:Boolean =DEBUG_TRACES_ON; 
			public static var IDz:Number = 0;
			public var id:Number = 0;
			/*********************************************************
			 * Constructor for TEventDispatcher
			 */
			public function TEventDispatcher(stripEventLabel:Boolean = true){
				this.stripEventLabel =stripEventLabel;// (stripEventLabel == null) ? true : stripEventLabel;
				//TDispatcher.initialize(this);
				this.ents = new Object();
				id = IDz++;
			}
			static public function initialize(p_obj:Object):Boolean {
				var ted:TEventDispatcher = new TEventDispatcher();
				p_obj.$tevD = ted;
				p_obj.dispatchEvent = TProxy.create(ted, ted.dispatchEvent);
	//			p_obj.eventListenerExists = TProxy.create(ted, ted.eventListenerExists);
				p_obj.addEventListener = TProxy.create(ted, ted.addEventListener);
				p_obj.removeEventListener =TProxy.create(ted, ted.removeEventListener);
				p_obj.removeAllEventListeners = TProxy.create(ted, ted.removeAllEventListeners);
			//	_global.ASSetPropFlags (p_obj, "$tevD", 1);
			//	_global.ASSetPropFlags (p_obj, "dispatchEvent", 1);
		//		_global.ASSetPropFlags (p_obj, "eventListenerExists", 1);
			//	_global.ASSetPropFlags (p_obj, "addEventListener", 1);
			//	_global.ASSetPropFlags (p_obj, "removeEventListener", 1);
			//	_global.ASSetPropFlags (p_obj, "removeAllEventListeners", 1);
				return true;
			}
			public function addEventListener (event:String, obj:Object, fn:Object) :void{
				if(DEBUG_TRACES_ON ||debugTracesOn){
		  			 trace("HIGHLIGHTy TEventDispatcher" + id+".addListener   for " + event + " obj: " + obj + " fn(): " + fn);
				}
				//displayObj(args);
				var td:TDispatcher = TDispatcher(this.ents[event]);
				if (td== null) {
					td= new TDispatcher();
					this.ents[event] = td;
				}
				//remove event
				arguments.shift();
	
				td.addListener.apply(td, arguments);
			};
			/////////////////////////////////////////////////
			// turns off the safety feature on a given event
			// that checks to make sure a listener isn't added twice
			// useful for increaseing performance
			// on adding many listeners because the checking is intensive
			public function setDuplicateCheck(event:String, duplicateCheck:Boolean):void{
				if (this.ents[event] == null) {
					this.ents[event] = new TDispatcher();
				}
				TDispatcher(this.ents[event]).duplicateCheck = duplicateCheck;
			};
			public function removeEventListener (event:String, obj:Object, fn:Object):void {
				//trace("MultipleEventBroadcaster.removeListener " + event + " obj: " + object + " fn(): " + fn);
				 var td:TDispatcher = TDispatcher(this.ents[event]);
				//remove event
				arguments.shift();
				td.removeListener.apply(td, arguments);
				if (td.listeners.length == 0) {
					//trace("no more listeners for event "+event);
					delete (this.ents[event]);
				}
			};
			public function removeAllEventListeners(event:String):void{
				if(event == null){
					///delete ALL events listeners for every event
					for(var i:String in this.ents){
						var td:TDispatcher =TDispatcher( this.ents[i]);
						td.removeAllListeners();
						//delete (this.ents[event]);
					}
					delete(this.ents);
					this.ents = new Object();
				}else if (this.ents[event] != null) {
					trace("removing ALL listeners for event "+event);
					TDispatcher(this.ents[event]).removeAllListeners();
					delete (this.ents[event]);
				}
			};
			public function dispatchEvent (event:Object):void {
				
				var td:TDispatcher =TDispatcher(this.ents[event.type]);
				if(DEBUG_TRACES_ON ||debugTracesOn || event.debug == true){
					trace("HIGHLIGHTO TEventDispatcher" + id+" notify " + td.listeners.length + " Listeners of event "+event.type+"----------------" + Trace.me(arguments, "arguments", true));
				}
				td.notifyListeners.apply(td, arguments);
			};
	}
}