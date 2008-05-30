package com.troyworks.framework.bootstrapper { 
	import com.troyworks.spring.Factory;
	import com.troyworks.framework.BaseObject;
	/**
	 * This is the configuration for the skin swf to register itself
	 * and do some basic type checking, or autocompletion to be used with the
	 * BootStrapper class
	 * 
	 * IMPLMENTATION
	 * See BootStrapper
	 * 
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;
	public class SkinConfig extends BaseObject {
		public var bootS:BootStrapper;
		public var skin_mc:MovieClip;	
		//the frame to goto on the skin_Mc when the script is finished loading.
		public var script_loadedFrameLbl:String = "script_loaded";
	    public var scriptSwfURL:String = "script.swf";
	    public var scriptSwfLoadTarget:String = "_level10";
	    
		///////////////////////////////////
		// Called automatically by the BootStrapper
		public function loadScriptSWF():void{
			log("sKn.loadScriptSWF");
			//load by level
			bootS.loadMC(scriptSwfURL, scriptSwfLoadTarget);
		 //  .skin_mc.stop();
		}	
		public function onAllLoaded() : void {
		   log("Skin.onAllLoaded " + skin_mc + " gotoAndPlay: " + script_loadedFrameLbl);
	    	skin_mc.gotoAndPlay(script_loadedFrameLbl);	
		}
		public function register():void{
			bootS.registerSkin(this);
		}
		public function toString():String{
			return "SkinConfig:" + bootS.appname;
		}
	
	}
}