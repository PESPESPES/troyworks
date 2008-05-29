package com.troyworks.mediaplayer { 
	import com.troyworks.mediaplayer.model.Track;
	
	/**
	 * @author Troy Gardner
	 */
	public class ASynchronizedMediaPlayer extends AMediaPlayer {
		public var trk:Track;
		public function ASynchronizedMediaPlayer(initialState : Function, hsmfName : String, aInit : Boolean) {
			super(initialState, hsmfName, aInit);
		}
	
	}
}