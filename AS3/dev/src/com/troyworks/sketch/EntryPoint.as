package com.troyworks.sketch
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.display.MovieClip;

	/********************************************
	 * Entry points are designed to be affiliated with the
	 * swf that actually are the first to be clicked on or run
	 * thier primary responsibility is to load the firestarted
	 * bootstrapper and wait for it to take control
	 * 
	 * it should not have or extend anything in the sketch libraries
	 * as it is compiled independently, to avoid class conflicts 
	 * when loaded together.
	 * **********************************************/
	public dynamic class EntryPoint extends MovieClip
	{
		public var config:Object;
		public static var loader:Loader;

		public function EntryPoint() {
			trace("EntryPoint()");
			super();
			visible = false;
			addEventListener(Event.RENDER, onRender);
			if (stage!=null) {
				stage.invalidate();
			}
		}
		/*Called when this movie clip gets added to the display list */
		function onRender(event:Event):void {
			//visible = false;
			stop();
			trace("============= ColoringBookPageMovieClip.onRender ================");
			if (config == null) {
				trace("!!!!!!!!!!!!!!!! NO INIT OBJ !!!!!!!!!!!!!!!!!");
			} else {
				trace("!!!!!!!!!!!!!!!! SETTING INIT OBJ !!!!!!!!!!!!!!!!!");
				for (var i:String in config) {
					trace(i  +  " : " + config[i]);
				}
			}
			removeEventListener(Event.RENDER, onRender);
			///////////// now that clip is loaded see if there is a script ///////////
			trace("root " + root + " parent " + parent + " "  + parent.parent);
			//root [object ColoringBookPageMovieClip] parent [object Stage] null
			trace((root == this) + " " + (parent == stage));
			trace("boostrapperSwfURL " + getBootStrapperSWF_URL());
			if(loader == null){
				trace("need to load bootstrapper");
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, controllerLoadedCompleteHandler);
				loader.load(new URLRequest(getBootStrapperSWF_URL()));
			}else{
				trace("we've likely already gotten our script associations");
			}
		}
		public function getBootStrapperSWF_URL():String{
			return "Engine.swf";
		}

		function controllerLoadedCompleteHandler(event:Event):void {
			trace("engine/controller loaded");
			try {
				var fn:Object = loader.content["setView"];
				if(loader.content != null &&  fn!= null){
					trace("valid bootstrapper");
					//loader.content["setView"](this);
					fn(this);
				}
			} catch (e:Error) {
	
			}
		}
	}
}