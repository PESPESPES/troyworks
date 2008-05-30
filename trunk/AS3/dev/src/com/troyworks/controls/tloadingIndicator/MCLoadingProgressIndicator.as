package com.troyworks.controls.tloadingIndicator { 
	import com.troyworks.events.TProxy;
	
	/**
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;
	public class MCLoadingProgressIndicator extends BaseComponent {
	
		protected var error_mc : MovieClip;
	
		protected var percent_loaded_mc : MovieClip;
	
		protected var percent_total_mc : MovieClip;
		
		public function MCLoadingProgressIndicator(clip : MovieClip) {
			super(null, "MCLoadingProgressIndicator");
					trace("new MCLoadingProgressIndicator " + clip + " " + this);
		}
		public function onLoad():void{
			trace("MCLoadingProgressIndicator.onLoad" + this + " " + this.gotoLoadingPercent);
			error_mc.visible = false;
			percent_loaded_mc.visible = false;
			percent_loaded_mc.width =1;
			stop();
		}
		public function gotoLoadingPercent(p:Number):void{
				trace("MCLoadingProgressIndicator.gotoLoadingPercent" + p + " " + percent_loaded_mc.width);
			if(p == -1){
				error_mc.visible = true;
			}else if(p>= 100){
		//		gotoAndPlay("loadingComplete");
				onEnterFrame = TProxy.create(this, onEnterFrameHandler);
			}else{
				percent_loaded_mc.visible = true;
				percent_total_mc.visible = true;
				percent_loaded_mc.width = p;
			}
		}
		public function onEnterFrameHandler() : void {
			this.alpha -= 2;
			if(this.alpha <= 0){
				delete onEnterFrame;
			}
		}
	}
}