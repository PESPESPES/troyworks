package com.troyworks.framework.ui { 
	import com.troyworks.spring.Factory;
	import com.troyworks.framework.bootstrapper.BootStrapper;
	import com.troyworks.framework.bootstrapper.SkinConfig;
	import com.troyworks.framework.bootstrapper.ScriptConfig;
	import com.troyworks.framework.events.DummyEventDispatcher;
	
	/**
	 * This has a 1-to-1 relationship with a SWF file, and is used 
	 * for setting up the entry point to the bootstrapper
	 * 
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;
	import flash.xml.XMLDocument;
	public class SWFController  {
	
	    /*==========================STATIC FUNCTIONS================================
	     * this area is basically tied to the swf while the non static deals with a 
	     * particular instance of the game on stage (usually via _root.CircleTown_mc)
	     */
	     public var appname:String;
	     public var scriptI:Object;
	     public var LOGGER:String = "Logger";
	     public var ORACLE:String = "Oracle";
	     public var SKIN_SWF:String = "Skin.swf";
	     
	     public static var className:String = "com.troyworks.framework.ui.SWFController";
	     
	    protected static var _a:Function = DummyEventDispatcher;
		protected static var _b:Function = com.troyworks.framework.logging.SOSLogger;
		protected static var instance:SWFController;
		
		public static function getInstance():SWFController{
			if(SWFController.instance == null){
				SWFController.instance = new SWFController();
			}
			return SWFController.instance;
		}
		/***************************************************************************
		 * Required by BootStrapper to kick off the process.
		 * 
		 * During this classes static initialization phase, the SET_MAIN_ENTRY_POINT calls
		 * the BootStrapper, which deals with the various entry points and fires them off 
		 *  
		 * MTASC calls
		 * the goal of main() is to load the appropriate first tier of script and skin
		 * which will turn the various clips in the skin.swf intos components, and
		 * via their onLoad event work appropriately.
		 */
	/*	public function run(container : MovieClip) : void {
			//registers the script, and the bootstrapper waits for the skin to load
			//or performs the inialization past that.		
			trace(this.appname + "_SWFCONTROLLER.run()AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA ");
			//////////////////////////////////
			// NOTE: remember to put variables to the classes you want accessible to the fla
			// here, inside the class definition!!!!!!!!!
			trace("got factory? " + Factory.className);
		
			/////////////////////////////////
			//Configure the Generic Factory
			trace("Configuring Factory " + Factory); 
			Factory.registerImplementers(this.getFactoryConfiguration());
			var bootS:BootStrapper = BootStrapper.getInstance(this.appname);
			var SKIN_Loaded:Boolean = bootS.hasLoadedSkin();
			var SCRIPT_Loaded:Boolean = bootS.hasLoadedScript();
			//////Determin which course to take
			if (!SKIN_Loaded && !SCRIPT_Loaded) {
				//NOTHING Loaded prior Since the Script loaded first, load the skin. `
				trace("ShapeTown.run() BBB SCRIPT Loaded First-----------------------------");
				// a default loading animation and fades in/outs, tossed into a higher level. 
				var skin:SkinConfig = bootS.getSkinConfig();
				skin.loadLoadingShield();
				//Load (default) skin
				var scrptCfg:ScriptConfig =  bootS.getScriptConfig();
				scrptCfg.skinSwfURL= this.SKIN_SWF;
				scrptCfg.script_mc = container;
				//pass a reference to this class for callback, which will call back this same
				//function (and this 'run' function will route appropriately
				scrptCfg.scriptI = this.scriptI;
				scrptCfg.register();
				
			} else if(!SKIN_Loaded && SCRIPT_Loaded) {
				//We should never hit this.
			} else if(SKIN_Loaded && !SCRIPT_Loaded) {
				//Since the skin is loaded, just need to initialize the script at a very
				//basic level
				var scrptCfg:ScriptConfig = bootS.getScriptConfig(); 
				bootS.registerScript(scrptCfg);
			} else if(SKIN_Loaded && SCRIPT_Loaded) {
				//ALL DONE: Both skin and script are loaded, being called back to 
				// bind the skin.swf's linkageID's with the script.swf's classes.
				this.onScriptAndSkinLoaded();
			}
		}*/
		public function getDefaultFactoryConfiguration():Object{
				//////////////////////////////////
			// setup the class mappings for the Spring style injection,
			// these might be passed in from global variables, or loaded in from 
			// loadVars, XMLDocument etc.,
			var obj:Object = new Object();
			obj["Logger"] = "com.troyworks.framework.logging.SOSLogger";
			obj["Oracle"] = "com.troyworks.framework.events.DummyEventDispatcher";
			return obj;
		}
		//////////////////////////////////
		// setup the class mappings for the Spring style injection,
		// these might be passed in from global variables, or loaded in from 
		// loadVars, XMLDocument etc.,	
		public function getFactoryConfiguration():Object{
			return getDefaultFactoryConfiguration();
		}
		public function onScriptAndSkinLoaded():void{
			trace("finished loading SKIN and SCRIPT");
			
		}
	}
}