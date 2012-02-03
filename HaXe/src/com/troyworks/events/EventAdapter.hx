/**
 * This is similar to EventProxyOptionalArgs and Delegate.
 * 
 * This class actus like a wire between an event and a myriad of other outputs, functions, events. 
 * It's a good glue for decoupling or passing additional argumenets.
 * 
 *  Event->Function
 *  Event-> new Event
 *  Event-> new scope (Event)
 *  
 * So when it recieves  an event, and converts it into either 
 * - scoped function calls with custom arguments
 * - scoped function calls passing it the original event with callback args e.g (evt, callback1, callback2)
 * - relay of event to another scope function, with optional appended arguments
 * - conversion of the event to another event (created by a class or factory function) and dispatched to a new scope.
 * 
 * * 
 * Takes an event, and calls back the with additional parameters, 
 * useful when a single loader is being
 * used for many different things and each listener needs 
 * slightly different information
 *
 * Here we have a function onSoundLoaded we are passing it the original swfURL
 * so that it can identify what has loaded, when multiple are being loaded at once.
 *   
 *   s.addEventListener(Event.COMPLETE, EventAdapter.create(onSoundLoaded, [optionalAudioSwfURL]));
 * 
 * Later:
 *   function onSoundLoaded(event:Event ):void {
				if(event is EventProxyOptionalArgs){
						var oArgs:Array = EventProxyOptionalArgs(event).args;
						trace("OptionalArgs " + oArgs.length + " " + oArgs.join());
				}
 *  }
 *  
 *  evt.target.addEventListener(MouseEvent.CLICK, EventAdapter.create(this[fnName], [arg1,arg2]));
 *   or
 *   Tny.onMethodBack =  EventAdapter.create(this.animationFinished, [nextAction,1.2])
 *   
 *   var evA:EventAdapter = new EventAdapter();
 *   evA.initAsRedispatcher(someEventDispatcher, DataChangeEvent);
 *     Tny.onMethodBack = evA.dispatchEvent; 
 * @author Troy Gardner
 * @version 0.1
 * 	 * CREATED :: Jul 5, 2008
 * DESCRIPTION ::
 */
package com.troyworks.events;

import flash.events.IEventDispatcher;
import flash.events.Event;

using com.troyworks.events.EventAdapter;



import com.sf.Methods;
import com.sf.Tuples;

class EventAdapter {

	public var id 														: String;
	/////////// function callback ///////////
	public var method (default,null) 					: Method<Dynamic,Dynamic,Dynamic>;
	/////////// event factory //////////
	public var factory(default,null) 					: Void -> Event;
	
	public function new(call:Method<Dynamic,Dynamic,Dynamic>){
		this.method = call;
	}
	public function setFactory(f:Void->Event) : EventAdapter{
		this.factory = f;
		return this;
	}
	public function execute(?args:Dynamic) {
		if (this.factory != null) {
			this.method.replaceAt(0, factory());
		}
		return this.method.execute(args);
	}
}
class EventAdapters {
	/**
	 * Creates an Event Factory with the passed in parameters.
	 * <code>
	 * 	using com.troyworks.events.EventAdapter;
	 *  ...
	 *  flash.events.Event.factory(Event.Activate);
	 * </code>
	 * @param	t
	 * @param	name
	 * @param	bubbles
	 * @param	cancelable
	 */
	public static function factory(t:Class<Event>, name, ?bubbles, ?cancelable) : Void -> Void {
		return function() { Type.createInstance(t, [name, bubbles, cancelable]); };
	}
	/**
	 * Adds an Event listener that removes itself.
	 * 
	 */
	public static function once<T>(e:IEventDispatcher, type:String, listener : T -> Void, useCapture : Bool = false, priority : Int = 0, useWeakReference : Bool = false) {
		var remove : Void -> Void = null;
		var handler = 
				function(e:T) {
					listener(e);
					remove();
				}
		remove = 
				function() {
					e.removeEventListener(type, handler, useCapture);
				}
		e.addEventListener( type, handler , useCapture , priority , useWeakReference );
	}
	public static function adaptDispatcher(v:IEventDispatcher):EventAdapter{
		var m : Method1<Event,Void> = 
		new Method1(function(e:Event):Void { v.dispatchEvent(e); } , "Dispatcher" );
		return new EventAdapter( m );
	}
	public static function adaptMethod<I,O,F>(c:Method<I,O,F>):EventAdapter{
		return new EventAdapter( c );
	}
}

