package com.troyworks.framework.bootstrapper { 
	import com.troyworks.framework.BaseObject;
	/**
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;
	public class ScriptConfig extends BaseObject {
		public var bootS:BootStrapper;
		public var script_mc:MovieClip;
		//Script Implementer
		public var scriptI:Object;
	
		public var skinSwfURL:String = "script.swf";
		public var skinSwfLoadTarget:String = "_level0";
	
		///////////////////////////////////
		// Called automatically by the BootStrapper
		public function loadSkinSWF():void{
			//NOTICE OVERWRITES THIS MOVIE, but leaves _global script alone
			log("ScriptConfig.loadSkinSWF: " + skinSwfURL + " into " + skinSwfLoadTarget);
			bootS.loadMC(skinSwfURL, skinSwfLoadTarget);
		}
		public function onAllLoaded() : void {
		    log("Script.onAllLoaded");
			scriptI.run(null);	
			
		}
		public function register():void{
			bootS.registerScript(this);
		}
	
		public function toString():String{
			return "ScriptConfig:" + bootS.appname;
		}
	
	}
}