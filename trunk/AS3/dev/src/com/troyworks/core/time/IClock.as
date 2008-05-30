package com.troyworks.core.time {

/**
 *  This is a base interface to retrieve time, from the concrete clocks in the 
 * com.troyworks.core.time.* package.
 * 
 * Clocks are rather passive creatures, they do not broadcast changes in real time, but wait 
 * for other classes to call them when needed, then look to their underlying model
 * (e.g. getTimer(), Date, FLV, mp3 position) for the actual data, then if it has changed
 * since the last value, they broadcast a TimeChangedEvent.
 * 
 * They represent a point in a single dimension/axis typically representing time.
 * 
 * They are used in conjuction with a HeartBeat to poll them, typically Timer or ENTER_FRAME events.
 * 
 * 
 * This inspired by the Prevayler(TM) Copyright (C) 2001-2003 Klaus Wuestefeld
 * This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*
* @author Troy Gardner
* @version 0.1
*/
	public interface IClock {
		/* synchronized */
		/** 
		 * Tells the time in this space.
		 * @return A Date greater or equal to the one returned by the last call to this method. If the time is the same as the last call, the SAME Date object is returned rather than a new, equal one.
		 */
		function time():Date;
		/** 
		 * Get time in Millisesconds
		 * @return
		 * If a MachineTime clock,  returns the number of milliseconds since midnight January 1, 1970, universal time, for a Date object.
		 * if a PlayerTime clock  returns the number of milliseconds since the Flash Player started
		 * if a FLV Clock returns the number of milliseconds into the duration of the stream
		 * If a broken clock, returns the number of milliseconds that it's set to
		 */
		function getTime():int;
		/* synchronized */
	//	function advanceTo(newTime:Date):void;
	}
}
