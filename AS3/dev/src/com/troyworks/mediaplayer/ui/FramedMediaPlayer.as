package com.troyworks.mediaplayer.ui { 
	import com.troyworks.framework.ui.BaseComponent;
	import com.troyworks.framework.ui.FontManager;
	import com.troyworks.ui.menus.Table3DRotaryCarouselMenuItem;
	import com.troyworks.framework.ui.IHaveChildrenComponents;
	
	/**
	 * This UI element is a box that have a viewport/MediaWindow and a label
	 * beneath it, similar in appearance to a slide.
	 * 
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;
	import flash.text.TextField;
	public class FramedMediaPlayer extends com.troyworks.ui.menus.Table3DRotaryCarouselMenuItem implements IHaveChildrenComponents {
		public var label_txt : TextField;
		public var user : Object;
		public var mmw_mc : MultiMediaWindow;
		public var width : Number;
		public var height : Number;
		public var contentURL : String;
	
		protected var m_label : String;
	
		public var data : Object;
		/*****************************************
		 * Constructor
		 */
		public function FramedMediaPlayer() {
			super();
			hsmName = "FramedMediaPlayer";
	
			trace("FRAME MEDIA PLAYER " + this.name);
		}
		public function onLoad() : void{
	
			REQUIRE(mmw_mc != null, " MultiMediaWindow cannot be null");
			mmw_mc.owner = this;
	
			trace("FramedMediaPlayer onLoad aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa HIGHLIGHTP");
			trace("FramedMediaPlayer----" +this.user);
			label_txt.text =(label == null)? this.user.userHandle:label;
			trace(" mmw_mc " + mmw_mc + " " + mmw_mc.width);
			trace("setting label to " + label);
			FontManager.getInstance().styleMe(this, this.label_txt);
			stop();
			
		}
		public function set label(str:String):void{
			m_label = str;
			label_txt.htmlText = str;
		}
		public function get label():String{
			return m_label;
		}
		public function onChildClipLoad(_mc : MovieClip) : void{
			trace("FramedMediaPlayer.onChildClipLoad bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb HIGHLIGHTB");
			if(_mc == mmw_mc){
				//mmw_mc.setMaskTo();
				//mmw_mc.setCoverTo(0xffffff, 100);
			//capture the original height and width 
			// as the mask returns the value of the loaded
			// content
				width = this.width;
				height = this.height;
				//mxP.setContentTo(0x00FF00);
				mmw_mc.setLoadingProgressIndicatorTo("LoadingProgressIndicator");
				mmw_mc.setContentTo(contentURL);
				//mmw_mc.setContentTo("users/icon1.PNG");
				//mmw_mc.setBackgroundTo(0xaaaaaa);
				this.cacheAsBitmap = true;
						super.onLoad();
			}
		}
	}
}