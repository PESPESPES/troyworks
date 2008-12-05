package com.troyworks.ui {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;		

	/*
	 */

	/**
	 * @author Troy Gardner
	 */
	public class StandalonePreloader extends MovieClip {
		//public var loading_mc : MovieClip;
		public var loading_txt : TextField;
		public var loading_mc : MovieClip;
		//public var bottomNav_txt:TextField;
	//	public var ctx : SWFContextUtil;
		public var step : int = 0;

		//	public var loadingTny : Tny;

		public function StandalonePreloader() {
			super();
			addEventListener(Event.ADDED_TO_STAGE, onFrame1);
//			addFrameScript(0, onFrame1);
		}

		public function onFrame1(evt : Event = null) : void {
		
			trace("stage " + stage);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP;
//			ctx = new SWFContextUtil(this);
			//TODO get ip/cookie.
			
			//TODO clickity

			var loader : Loader = new Loader();  
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, drawText);     
			loader.load(new URLRequest("fonts/MyriadProRegMinLib.swf"));   
			addEventListener(Event.ENTER_FRAME, enterFrame);
			
			stop();
		}

		public function enterFrame(e : Event) : void {
			var bl : int = loaderInfo.bytesLoaded;
			var bt : int = loaderInfo.bytesTotal;
			trace(bl + " / " + bt);
			if (bl && bt && bl == bt) {
				removeEventListener(Event.ENTER_FRAME, enterFrame);
				//play();
			} else if (loading_mc != null && loading_mc.bar_mc) {
			//	loading_mc.bar_mc.scaleX = bl / bt;
			
			}else if(loading_txt != null) {
				loading_txt.text = String(Math.round((bl / bt) * 100)) + "%";
			}
		}



		public function drawText(evt : Event = null) : void {  
			trace("drawText");
			var tf : TextField = new TextField();  
			tf.defaultTextFormat = new TextFormat("Myriad Pro", 16, 0);  
			tf.embedFonts = true;  
			tf.antiAliasType = AntiAliasType.ADVANCED;  
			tf.autoSize = TextFieldAutoSize.LEFT;  
			//tf.border = true;  
			tf.text = "Loading...";  
			//tf.rotation = 15;
			tf.x = stage.stageWidth / 2;
			tf.y = stage.stageHeight / 2;
			tf.alpha = 0;
			loading_txt = tf;
			addChild(tf);
			addEventListener(Event.ENTER_FRAME, animateIn);
			setTimeout(animateEllipsis, 333); 


//		swapClip(bottomNav_txt);
			
		//	HTMLUtil.swapClip(bottomNav_txt);

			/////////////// LOAD SITE CONTROLLER //////////////////			
			trace("loading Site Controller");
			var loader : Loader = new Loader();  
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadedSiteController);  
			loader.load(new URLRequest("sitecontroller.swf"));
			addChild(loader);  
		}  

		public function animateEllipsis(evt : Event = null) : void {
			var e : String;
			switch(step++ ) {
				case 0:
					e = "";
					break;
				case 1:
					e = "..";
					break;
				case 2:
					e = "...";
					step = 0;
					break;
			}
			loading_txt.text = "Loading" + e;
			setTimeout(animateEllipsis, 666);
		}

		public function animateIn(evt : Event = null) : void {
		//	trace("animateIn");

			loading_txt.alpha += 1 / (1.5 * 24);
			if(loading_txt.alpha == 1) {
				removeEventListener(Event.ENTER_FRAME, animateIn);
			}
		}	

		private function loadedSiteController(evt : Event = null) : void {
			trace("loaded Site Controller");
			var dO : DisplayObject = DisplayObject(Loader(evt.target.loader).content);		
			parent.addChild(dO);
			//addChild(dO);
		}
	}
}
