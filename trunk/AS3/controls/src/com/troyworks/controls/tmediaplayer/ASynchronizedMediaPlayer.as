package com.troyworks.controls.tmediaplayer {
	import com.troyworks.controls.tmediaplayer.model.Track; 

	
	/**
	 * @author Troy Gardner
	 */
	public class ASynchronizedMediaPlayer extends AMediaPlayer {
		public var trk:Track;
		public function ASynchronizedMediaPlayer(initialState : String, hsmfName : String, aInit : Boolean) {
			super(initialState, hsmfName, aInit);
		}
	
	}
}