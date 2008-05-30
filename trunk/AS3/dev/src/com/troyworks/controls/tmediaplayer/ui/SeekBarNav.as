package com.troyworks.mediaplayer.ui { 
	import com.troyworks.framework.ui.BaseComponent;
	
	/**
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;
	public class SeekBarNav extends BaseComponent {
		
		public var seekbutton_mc:MovieClip;
		public var loaded_mc:MovieClip;
		public var played_mc:MovieClip;
		public function SeekBarNav() {
			super();
			
		}
		public function onLoad() : void{
			super.onLoad();
			trace("SeekBarNav.onLoad");
		//	visible = true;
			//Q_dispatch(ASSETS_LOADED_EVT);
		
		}	
		public function setPlayedProgress(percent : Number) : void {
			trace("SeekBarNav.setPlayedProgress " + percent);
			seekbutton_mc.x= _owidth * percent;
			played_mc.width = _owidth * percent;
		}
	
		public function setLoadedProgress(percent : Number) : void {
			loaded_mc.width = _owidth * percent;
		}
	
	}
}