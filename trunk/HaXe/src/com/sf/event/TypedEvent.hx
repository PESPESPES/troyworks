package com.sf.event;
import flash.events.Event;

class TypedEvent<T> extends flash.events.Event{
	public var isHandled 			: Bool;
	public var continuePropogation 	: Bool;

	var data 						: T;

	public function new(type,data:T,bubbles = false,cancelable = false){
		super(type, bubbles, cancelable);
		this.data 			= data;
		isHandled 			= false;
		continuePropogation = true;
	}
	public function resolve(s:String):Dynamic{
		return Reflect.field( this, s );
	}
	override public function clone() : Event {
		return new TypedEvent(data,type, bubbles, cancelable);
	}

}