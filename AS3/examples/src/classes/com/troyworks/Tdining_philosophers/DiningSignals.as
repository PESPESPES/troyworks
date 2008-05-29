/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.Tdining_philosophers {
	import com.troyworks.activeframe.QSignal;

	public class DiningSignals extends Object{
		public static const HUNGRY:QSignal = QSignal.getNextSignal("HUNGRY");
		public static const DONE:QSignal = QSignal.getNextSignal("DONE");
		public static const EAT:QSignal = QSignal.getNextSignal("EAT");
	}
	
}
