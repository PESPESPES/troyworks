/**
 * TEventDispatcher
 * @author Troy Gardner
 * AUTHOR :: Troy Gardner
 * AUTHOR SITE :: http://www.troyworks.com/
 * CREATED :: Dec 3, 2008
 * DESCRIPTION ::
 *
 */
package com.troyworks.events;

import flash.events.IEventDispatcher;
import flash.events.EventDispatcher;

class TEventDispatcher extends EventDispatcher {

	public function new(target : IEventDispatcher = null) {
		super(target);
	}

	public function addSingleTimeEventListener() : Void {
		//For single use Complete type, I wonder if you could have a separate class with reference to
		//the event that automatically removes the listener
	}

}

