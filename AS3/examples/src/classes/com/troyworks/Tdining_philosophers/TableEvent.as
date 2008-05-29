/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.Tdining_philosophers {
	import com.troyworks.activeframe.QEvent;
	import com.troyworks.activeframe.QSignal;

	public class TableEvent extends QEvent {
		public var philID:Number =-1;
		
		public function TableEvent(signal:QSignal,bubbles:Boolean=false, cancelable:Boolean=false) {
			super(signal, bubbles, cancelable);
		}
	}
	
	
}
