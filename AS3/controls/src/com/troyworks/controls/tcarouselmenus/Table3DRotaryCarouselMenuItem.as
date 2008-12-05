package com.troyworks.ui.menus { 
	import com.troyworks.framework.ui.MCButton;
	import com.troyworks.mediaplayer.MixinPlayer;
	import com.troyworks.framework.ui.FontManager;
	import com.troyworks.events.TProxy;
	import com.troyworks.framework.ui.BaseComponent;
	
	/**
	 * @author Troy Gardner
	 */
	import flash.media.Sound;
	public class Table3DRotaryCarouselMenuItem  extends BaseComponent {
	
		public var contextMenu : Table3DRotaryCarouselMenu;
		public var enabled : Boolean = true;
		public var isSelected : Boolean = false;
		public var zoomCount : Number = 0;
		public static var TABLE_CAROUSEL_MODE : Number = 0;
		public static var LINEAR_CAROUSEL_MODE : Number = 1;
		public static var TV_MODE : Number = 1;
		public var mode : Number = TABLE_CAROUSEL_MODE;
		public var data:Object;
		protected var zoomme : String;
	
		protected var isToggled : Boolean;
	
		public var xPos : Number;
	
		public var yPos : Number;
	
		public var theScale : Number;
		public function Table3DRotaryCarouselMenuItem(aMode : Number) {
			//super(this, this.parent);
			super(null, "Table3DRotaryCarouselMenuItem");
			hsmName = "Table3DRotaryCarouselMenuItem";
			//init();
			this.mode = (aMode == null)?mode:aMode;
		}
		function onLoad() : void{
	
			switch(mode){
				case TABLE_CAROUSEL_MODE:
					this.onRollOver =TProxy.create(this, onRollOverHandler1);
					this.onRollOut = TProxy.create(this, onRollOutHandler1);
					this.onRelease = TProxy.create(this, onReleaseHandler1);
					break;
				case LINEAR_CAROUSEL_MODE:
					this.onRollOver =TProxy.create(this, onRollOverHandler2);
					this.onRollOut = TProxy.create(this, onRollOutHandler2);
					this.onRelease = TProxy.create(this, onReleaseHandler2);
					break;
				case TV_MODE:
				break;
			}
			super.onLoad();
		}
	
		function setEnabled(val : Boolean, bypassRollover : Boolean) : void{
			trace("111111111111111111111111111111111111111111111");
			trace("111111111111111111111111111111111111111111111");
			trace("111111111111111111111111111111111111111111111");
			trace("1111111111111111111Menu ITem setEnabled " + val + " bypassRollover" + bypassRollover + " 11111111111111111111111111");
			trace("1111111111111111 mode " + mode + " 11111111111111111111111111111");
			trace("111111111111111111111111111111111111111111111");
			enabled = val;
			if(enabled){
	
				switch(mode){
					case TABLE_CAROUSEL_MODE:
					if(!bypassRollover){
							this.onRollOver =TProxy.create(this, onRollOverHandler1);
							this.onRollOut = TProxy.create(this, onRollOutHandler1);
					}
						this.onRelease = TProxy.create(this, this.onReleaseHandler1);
						break;
					case LINEAR_CAROUSEL_MODE:
						this.onRollOver =TProxy.create(this, onRollOverHandler2);
						this.onRollOut = TProxy.create(this, onRollOutHandler2);
						this.onRelease = TProxy.create(this, onReleaseHandler2);
						break;
					case TV_MODE:
						break;
					
			}		
								
			}else{
				delete onRollOut;
				delete onRollOut;
				delete onRelease;
			}
					
		}
		//////////////////MODE 1 (inside Table Carousel //////////////////
		function onReleaseHandler1() : void {
			trace("** slide Clicked ***" + util.Trace.me(this.data));
			contextMenu.curSelectedClip = this;
			contextMenu.selectedItem = Object(this).data;
			if(isSelected){
				contextMenu.unReleased();
			}else{
				contextMenu.released();
			}
		}
		function onRollOverHandler1() : void {
			trace(" ---------OVER------------");
			//BONUS Section
			public var sou : Sound = new Sound();
			sou.attachSound("sover");
			sou.start();
			contextMenu.tooltip.tipText.html = true;
			contextMenu.tooltip.tipText.htmlText = Object(this).toolText;
			FontManager.getInstance().styleMe(contextMenu.tooltip, contextMenu.tooltip.tipText);
			contextMenu.activateToolTip(this);
		}
		protected function onRollOutHandler1() : void {
			contextMenu.releaseToolTip();
		}
		///////////////////MODE 2 (inside 1D Carosel /////////////////
		protected function onRollOutHandler2() : void {
			trace("ROLLOUT");
			this.zoomme = "DOWN";
		}
		protected function onRollOverHandler2() : void {
			trace("ROLLOVER");
			this.zoomme = "UP";
			//this.scaleX =103;
		}
		protected function onReleaseHandler2() : void {
			trace("*** CLICK *******"+this.parent+" 2 "+this.parent);
			this.parent.enterBook = !this.parent.enterBook;
		//	isToggled = !isToggled;
			if(isToggled){
			//startDrag(false);
			}else{
			//	stopDrag();
			}
			//dispatchEvent("CLICK");
			contextMenu.curSelectedClip = this;
			
			contextMenu.dispatchEventententent(CarouselMenu.SELECTED_SLIDE_EVT, this);
		}
		
	}
}