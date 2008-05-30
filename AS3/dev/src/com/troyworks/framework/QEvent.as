/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.framework {
	import com.troyworks.core.cogs.CogEvent;
	import com.troyworks.core.cogs.CogSignal;
	import com.troyworks.framework.QSignal;
	
	public class QEvent extends CogEvent{
		public function QEvent(signal:CogSignal,bubbles:Boolean=false, cancelable:Boolean=false) {
			super(signal.name, signal, bubbles, cancelable);
		}
	}
	
}
