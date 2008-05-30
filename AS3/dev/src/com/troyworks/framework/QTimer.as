/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.framework {
	import flash.utils.Timer;
	import com.troyworks.framework.QF;
	
	public class QTimer extends Timer {
		
		private var myNext:QTimer;
		private var myTimeOutEvt:QEvent;
		private var myActiveObj:QEvent;
		
		
		public function QTimer(delay:Number, repeatCount:int = 0){
			super(delay, repeatCount);
		}
	}
	
}
