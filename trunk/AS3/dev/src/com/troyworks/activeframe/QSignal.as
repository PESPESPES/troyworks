/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.activeframe {
	import com.troyworks.cogs.CogSignal;

	public class QSignal extends CogSignal{
		public function QSignal(val : int, name : String){
			super(val, name);
		}
		public static function getNextSignal(name:String):QSignal{
			var s:QSignal = new QSignal(CogSignal.SignalUserIDz++, name);
			return s;
		}
	}
	
}
