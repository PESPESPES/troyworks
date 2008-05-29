package com.troyworks.sketch{
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.display.MovieClip;
	import com.troyworks.sketch.ILateBindingController;

	public dynamic class LateBindingView  extends MovieClip{

		public var loader:Loader;
		var key:String = "somethingneat";

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
		public function getMouseAngle = function() :Number{
			return Math.atan2(this.parent.ymouse-this.y, this.parent.xmouse-this.x)*180/Math.PI;
		};
	}
}