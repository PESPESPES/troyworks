/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.activeframe {
	import com.troyworks.cogs.CogEvent;
	import com.troyworks.cogs.CogSignal;
	import com.troyworks.activeframe.QSignal;
	
	public class QEvent extends CogEvent{
		public function QEvent(signal:CogSignal,bubbles:Boolean=false, cancelable:Boolean=false) {
			super(signal.name, signal, bubbles, cancelable);
		}
	}
	
}
