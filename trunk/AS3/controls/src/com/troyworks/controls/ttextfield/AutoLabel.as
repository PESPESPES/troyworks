package com.troyworks.controls.ttextfield { 
	/**
	 * Automatically styles a textfield (useful for when inside buttons and components).
	 * @author Troy Gardner
	 */
	import com.troyworks.framework.ui.FontManager;	
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	public class AutoLabel extends MovieClip{
		public var label_txt:TextField;
		public var isLoaded : Boolean;
		public var isReady : Boolean;
		public function AutoLabel() {
			super();
		}
		public function onLoad():void{
			if(parent.label != null){
				label_txt.htmlText = parent.label;
				FontManager.getInstance().styleMe(parent, label_txt);
			}else{
				FontManager.getInstance().styleMe(parent, label_txt);
			}
			isLoaded = true;
			isReady = true;
		}
	}
}