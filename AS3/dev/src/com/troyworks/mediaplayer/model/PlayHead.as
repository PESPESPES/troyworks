package com.troyworks.mediaplayer.model { 
	import com.troyworks.hsmf.Hsmf;
	import com.troyworks.hsmf.AEvent;
	import com.troyworks.datastructures.Array2;
	/**
	 * @author Troy Gardner
	 */
	public class PlayHead extends Hsmf {
		public static var ACTIVATE_PLAYHEAD_EVT : AEvent = AEvent.getNext("ACTIVATE_PLAYHEAD_EVT");
		public static var PLAYHEAD_PLAY : AEvent = AEvent.getNext("PLAYHEAD_PLAY");
		//"PAUSE", "REWIND_AND_STOP", "RESTART", "REWIND_PLAY", "FASTFORWARD_PLAY","SEEK_TO
		public static var PLAYHEAD_PAUSE : AEvent = AEvent.getNext("PLAYHEAD_PAUSE");
		
		//think of a needle on a record, if the head is moving but not actually on the surface
		public var isEngaged : Boolean = false;
		public function PlayHead() {
			super(s0_inactive, "MediaPlayer.PlayHead", true);
		}
		/*.................................................................*/
		public function s0_inactive(e : AEvent) : Function
		{
			this.onFunctionEnter ("s0_inactive-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					return null;
				}
				case EXIT_EVT :
				{
					return null;
				}
				case INIT_EVT :
				{
					return null;
				}
				case ACTIVATE_PLAYHEAD_EVT:
				{
					//Q_TRAN(s0_active);
					return null;
				}
			}
			return s_top;
		}
		}
}