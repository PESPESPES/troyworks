/**

 * GenericEvent - extends the Event with a generic argument holder, that is shared

 * across all events that recieve this.

 * @author Troy Gardner

 * AUTHOR :: Troy Gardner

 * AUTHOR SITE :: http://www.troyworks.com/

 * CREATED :: Jul 5, 2008

 * DESCRIPTION ::

 *

 */
package com.troyworks.events;

import flash.events.Event;
using com.sf.Tools;

class EventWithArgs<T> extends Event {

	public var args : T;
	public function new(type : String, bubbles : Bool = false, cancelable : Bool = false) {
		super(type, bubbles, cancelable);
	}

	// override clone so the event can be redispatched
	override public function clone() : Event {
		var res : EventWithArgs = new EventWithArgs(type, bubbles, cancelable);
		res.args = args.copy();
		return res;
	}

}

