/**
	//Prevayler(TM) - The Free-Software Prevalence Layer.
	//Copyright (C) 2001-2003 Klaus Wuestefeld
	// converted to AS3 by Troy Gardner (troy@troyworks.com)
	//This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

* @author Default
* @version 0.1
*/

package com.troyworks.prevayler {


	/** Tells the time.
	 * @see Prevayler
	 */
	public interface Clock {

		/** Tells the time.
		 * @return A Date greater or equal to the one returned by the last call to this method. If the time is the same as the last call, the SAME Date object is returned rather than a new, equal one.
		 */
		public function time():Date;

	}

	
	
}
