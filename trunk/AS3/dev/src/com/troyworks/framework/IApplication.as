package com.troyworks.framework {
	import com.troyworks.core.cogs.CogEvent; 

	import flash.display.MovieClip;

//	import com.troyworks.framework.model.AssetLibrary;

	interface IApplication {
		//  public function getInstance(swf:MovieClip):IApplication;
		// the first thing to call by the enclosing/swf or application.
		function activate() : void;

		//typically inherited from hsmf.HsmfE (the statemachine engine)
		function dispatchEventententent(e : CogEvent) : void;

	//	function registerAssetLibrary(astLib : AssetLibrary) : void;
	}
}