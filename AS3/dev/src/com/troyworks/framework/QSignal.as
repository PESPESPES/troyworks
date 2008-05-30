/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.framework {
	import com.troyworks.core.cogs.CogSignal;

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
