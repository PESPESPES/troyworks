package com.troyworks.framework.ui{
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.display.MovieClip;
	import com.troyworks.framework.ui.ILateBindingController;
	import flash.events.*;
	import flash.text.TextFieldType;

	public dynamic class LateBindingView  extends MovieClip{

		public var loader:Loader;
		var key:String = "somethingneat";
		var init:Boolean;
		var lastFrameNumber:Number;
		var activeFrames:Object;

		public function LateBindingView(){
			super();
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, controllerLoadedCompleteHandler);
			loader.load(new URLRequest("LateBindingController.swf"));
			///wait for engine/controller to load
			stop();
		}
		function controllerLoadedCompleteHandler(event:Event):void {
			trace("engine/controller loaded");
			 try{
				var ctl:ILateBindingController = loader.content as ILateBindingController;
				ctl.setView(this);
			 }catch(e:Error){
			 
			 }
		}
		
		
	}
}