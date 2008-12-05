package com.troyworks.controls.tmediaplayer.model {
	import com.troyworks.core.cogs.CogSignal;	
	import com.troyworks.core.cogs.CogEvent;	
	import com.troyworks.core.cogs.Hsm; 

	/**
	 * @author Troy Gardner
	 */
	public class PlayHead extends Hsm {
		public static var ACTIVATE_PLAYHEAD_EVT : CogSignal =CogSignal.getNextSignal("ACTIVATE_PLAYHEAD_EVT");
//		public static var PLAYHEAD_PLAY : CogEvent = CogEvent.getNext("PLAYHEAD_PLAY");
		//"PAUSE", "REWIND_AND_STOP", "RESTART", "REWIND_PLAY", "FASTFORWARD_PLAY","SEEK_TO
//		public static var PLAYHEAD_PAUSE : CogEvent = CogEvent.getNext("PLAYHEAD_PAUSE");
		
		//think of a needle on a record, if the head is moving but not actually on the surface
		public var isEngaged : Boolean = false;
		
		public function PlayHead() {
			super("s0_inactive", "MediaPlayer.PlayHead", true);
		}
		/*.................................................................*/
		public function s0_inactive(e : CogEvent) : Function
		{
			//this.onFunctionEnter ("s0_inactive-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY:
				{
					return null;
				}
				case SIG_EXIT :
				{
					return null;
				}
				case SIG_INIT :
				{
					return null;
				}
				case ACTIVATE_PLAYHEAD_EVT:
				{
					//trantive);
					return null;
				}
			}
			return s_root;
		}
		}
}