package com.troyworks.controls.tloadingIndicator { 
	/**
	 * When used in conjunction with the MixinPlayer and MCLoader
	 * provides a visual status of the load state.
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;

	public class MCLoadingPercentIndicator extends MovieClip {

		public var error_mc : MovieClip;
		public var percent_loaded_mc : MovieClip;
		public var percent_total_mc : MovieClip;

		public function onLoad() : void {
			error_mc.visible = false;
			percent_loaded_mc.visible = false;
			//percent_total_mc.visible = false;
			stop();
		}

		public function gotoLoadingPercent(p : Number) : void {
			trace("***********************************");
			trace("************** LOADING P " + p + " *********************");
			trace("***********************************");
			trace("***********************************");
			if(p == -1) {
				error_mc.visible = true;
			}else if(p >= 100) {
				gotoAndPlay("loadingComplete");
			}else {
				percent_loaded_mc.visible = true;
				percent_total_mc.visible = true;
				percent_loaded_mc.width = p;
			}
		}
	}
}