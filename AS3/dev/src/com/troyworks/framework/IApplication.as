package  { 
	import com.troyworks.hsmf.AEvent;
	import flash.display.MovieClip;
	import com.troyworks.framework.model.AssetLibrary;
	interface com.troyworks.framework.IApplication {
	  //  public function getInstance(swf:MovieClip):IApplication;
	  // the first thing to call by the enclosing/swf or application.
	  public function activate():void;
	  //typically inherited from hsmf.HsmfE (the statemachine engine)
	  public function Q_dispatch (e : AEvent) : void;
	  public function registerAssetLibrary(astLib:AssetLibrary):void;
	}
	
	
}