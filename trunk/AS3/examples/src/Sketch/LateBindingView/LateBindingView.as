package {
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import ILateBindingController;
	import flash.display.MovieClip;

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
	}
}