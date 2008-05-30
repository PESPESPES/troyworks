/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.controls.tmediaplayer {
	import com.troyworks.core.cogs.CogSignal;
	import com.troyworks.framework.QSignal;
	
	public class MediaPlayerSignals extends CogSignal {
		
		public function MediaPlayerSignals(val : int, name : String){
			super(val, name);
		}
		public static function getNextSignal(name:String):MediaPlayerSignals{
			var s:MediaPlayerSignals = new MediaPlayerSignals(CogSignal.SignalUserIDz++, name);
			return s;
		}
	}
	
}
