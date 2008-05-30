/**
* This is a integration of Spring and the Quantum Framework, acting
* as a central respository for interface/implementor lookups and a message bus
* the message bus is accessible across all objects, it differs from EventDispatcher
* in that messages are in a advanced que (allowing FIFO or LIFO) and may not propogate immediately, also
* they are dispatched based on priority
* 
* there is only one of these per memory space which is why it's not a singleton. so getInstance() overhead is not required
* and extensibility is not required either
* 
* @author Troy Gardner
*  @version 0.1
*/

package com.troyworks.framework {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;

	import com.troyworks.framework.QActive;
	import com.troyworks.framework.QEvent;
	import com.troyworks.framework.QTimer;

	public class QF {
		
		private static var _evtque:Array;
		private static var _heartbeat:QTimer;
		private static var _isInited:Boolean = QF.init();
		private static var _qevd:EventDispatcher;
		private static var evd:EventDispatcher;
		private static var registry : Object = new Object ();
		private static var objCache : Object = new Object ();
		
		
		public static const VERSION:String = "1.0";
		
		/************************************************
		 * This is a callback for a asynchronous state 
		 * transitions, and queing multiple transition events
		 * **********************************************/
		public static function getHeartBeat():QTimer{
			if(_heartbeat == null){
				_heartbeat = new QTimer(0,0);
				_heartbeat.start();
			}
			return _heartbeat;
		}
		/* return pointer to current version of framework */
		public static function getVersion():String{
			return VERSION;
		}
		public static function get isInited():Boolean{
			return _isInited;
		}
		/* intialize the framework,  must only be invoked once */
		public static function init():Boolean{
		  if(!_isInited){
			  _isInited = true;
			  _qevd = new EventDispatcher();
			   evd = new EventDispatcher();
			   _evtque = new Array();
			   _heartbeat = getHeartBeat();
		  }
		   return _isInited;
		}
		///////////////////////////////////////////////
		/* initialize a pool for a given event type */
		public static function initEventPool():void{
			
		}
		
		/* process one clock tick, should be called periodically from a Timer */
		public static function tick(event:TimerEvent):void{
			
		}		 
   		public static function addEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false, p_priority:int=0, p_useWeakReference:Boolean=false):void {
			trace("QFQFQFQFQ.addEventListener");
   			evd.addEventListener(p_type, p_listener, p_useCapture, p_priority, p_useWeakReference);
  		}
   		public static function removeEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false):void {
			trace("QFQFQFQFQ.removeEventListener");
   			evd.removeEventListener(p_type, p_listener, p_useCapture);
   		}
   		public static function dispatchEvent(p_event:Event):void {
			trace("QFQFQFQFQ.dispatchEvent");
   			evd.dispatchEvent(p_event);
   		}
    		
  		// Public API that dispatches an event
  		public static function loadSomeData():void {
   			dispatchEvent(new Event(Event.COMPLETE));
   		}
		/* returns a new event out of the pool */
		public static function createEvent(sig:QSignal):QEvent{
			return null;
		}
		/* adds a listener to the message bus for the given signal*/
		public static function subscribe(sig:QSignal, activeObj:QActive):void{
				trace("QFQFQFQFQ.subscribe " + sig.name);
			_qevd.addEventListener(sig.name, activeObj.dispatchEvent);
		}
		/* removes a listener to the message bus for the given signal*/
		public static function unsubscribe(sig:QSignal, activeObj:QActive):void{
			trace("QFQFQFQFQ.unsubscribe " + sig.name);
			_qevd.addEventListener(sig.name, activeObj.dispatchEvent);
		}
		/* dispatches a signal across all registered listeners */
		public static function publish(evt:QEvent):void{
			trace("QFQFQFQFQ.publish " + evt.sig.name);
			_evtque.push(evt);
			//if already added won't duplicate
			_heartbeat.addEventListener(TimerEvent.TIMER,onTranTimer);
		}
		
		protected static function onTranTimer(event:TimerEvent):void{
			var evt:Event = Event(_evtque.pop());
			_qevd.dispatchEvent(evt);	
			if(_evtque.length == 0){
				_heartbeat.removeEventListener(TimerEvent.TIMER,onTranTimer);
			}
		}
		/* remove all memory on request*/
		public static function cleanup():void{
			
		}
		/////////////////////////////////////////////////////////////////
		//     SPRING LIKE DECOUPLING 
		/////////////////////////////////////////////////////////////////
		public static function listRegistrants():void{
			trace("Factory listing Registrants\\");
			for (var i : String in registry) {
				trace(" -  "+ i + " = " +registry[i]);
			}
			trace("Factory listing Registrants///");
			
		}
		public static function registerImplementers(obj:Object):void{
			for(var i:String in obj){
				registerImplementer(i, obj[i]);
			}
		}
		/*
		 * Serves to act as a factory for the given classes as strings.
		 */
		public static function registerImplementer (classNameKey : String, implementer : Object) : void
		{	
			trace ("SpringFactory.registerImplementer('" + classNameKey + "'" +" = " + implementer+")");
			registry [classNameKey] = implementer;
		//log("SKIN.SWF..........LOADED!");	Factory.listRegistrants();
		}
		public static function getImplementor (classNameKey : String) : Object
		{
			var cl:Class = registry [classNameKey];
		trace("class name mapping for " + classNameKey + "  is '" + cl+"'");
			if (cl == null)
			{
				trace("Factory.error! invalid concrete implementor");
				throw new Error ("com.TroyWorks.SpringFactory. invalid concrete implementor");
			}
			//trace(typeof (cl));
			var t_cl:String = typeof(cl);
			if(typeof (cl) == "function" || typeof (cl) == "movieclip" ){
				//passed in a concrete instance
		//		trace("returning concrete instance of function/movieclip");
				return cl;
			}else {
				////// if not cached ////////////
				var cf:Object = objCache[classNameKey];
			    if(cf != null){
			//		trace("Factory, cached object Factory found! ");	    	
			    	return getSingletonOrNewInstance(classNameKey, Function(cf));
			    }
			    ///// else create it ////////////
			    //XXX eval NOT Supported in Flash 9!! but can be done via other ways
			    //http://dynamicflash.com/2005/03/class-finder/
			//FIXME	var f = eval (cl);
			var f:Object;
				trace("'"+cl +"' function? " + f);
				if (typeof (f) == "function")
				{
					return getSingletonOrNewInstance(classNameKey, Function(f));
		
				} else
				{
					trace("****WARNING*****: Factory.returning null, could not find implmentor for "+classNameKey); 
					return null;
				}
			}
		}
		private static function getSingletonOrNewInstance(classNameKey:String, f:Function):Object{
			var i:Object = null;
			///Lets see if the class is a singleton or not
	/*FIXME		if(f.getInstance != null){
				 i = f.getInstance();
			}*/
			if(i != null){
			  //is actually a singleton 	
				//trace("Factory.returning Singleton " + i.toString());
				objCache[classNameKey] = f;
				return i;
			}else{
				// is a normal class, instantiate a new instance.
				var o:Object =  new f ();
				//trace("Factory.returning new instance " + o.toString());		
				return o;
			}
		}
		
		
		
		/////////////////////  PRIVATE  //////////////////////////////////
		
		/* add an active listener to this */
		private static function add(activeObj:QActive):void{
			
		}
		/* remove an active listener to this */
		private static function remove(activeObj:QActive):void{
			
		}
		
		private static function propogate(evt:QEvent):void{
			
		}
		
		private static function annihilate(evt:QEvent):void{
			
		}

	}
	
}
