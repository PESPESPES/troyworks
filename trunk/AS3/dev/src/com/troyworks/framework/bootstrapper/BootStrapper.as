package com.troyworks.framework.bootstrapper { 
	import com.troyworks.framework.logging.SOSLogger;
	import com.troyworks.framework.logging.ILogger;
	import com.troyworks.framework.events.IEventOracle;
	import com.troyworks.framework.BaseObject;
	import com.troyworks.framework.ApplicationContext;
	import com.troyworks.framework.loader.XMLLoader;
	/**
	 * DESCRIPTION:
	 * 
	 * The primary use of this class is affiliating script and skin swfs dynamically at runtime, a bit
	 * like zipper.
	 *
	 * Typically script.swf are produced by MTASC and skin.swf by Flash IDE, 
	 * by only recompling/recompressing what's changed, and swapping files, dramatic speedups in overall worflow can be on complex projects
	 * achieved, for a size of about 5kb for the basic BootStrapper and framework
	 * - ApplicationContext->SpringFactory
	 * - BaseObject providing events and logging, and Factory access to all objects.
	 * - SOSLogger and TraceLogger (for connecting to SOS and Trace/Console)
	 * - DelegateDispatcher   
	 * which are useful for other things in the code
	 * 
	 * Here's an example of a Script only swiff with only BaseObject in it.
	 * ActionScript Bytes    Location
	 *------------------    --------
	 *               79    Scene 1:Layer 1:1
	 *             5164    ActionScript 2.0 Classes
	 * A skin only swf will have ZERO ActionScrip2 2.0 Bytes.
	 * 
	 * USAGE:
	 * 
	 * Use1: Parallel Development.
	 * Facilitates team parrallel development and a clean handoff between designers and programmers
	 * typically the developer is using MTASC, and the designer the flash IDE (or SWFMILL)
	 * the 'roundabout' in this code gives them a similar easy testing experience, with linkageID and
	 * or stage instance names as the contract.
	 * 
	 * Use2: Script as Shared Libraries
	 * Making script files as an external 'Shared Library'. Say you have 10 different skin files
	 * that all use the same codebase, either the skin or script which may undergo frequent changes. 
	 * Via this approach, it's as simple as swapping out files (keeping the same names), and either the skin or the application can
	 * be the entry points, in some cases the skin being loaded first may indicate a non-standard entry point
	 * as in game development, where multiple levels share the same code but with slightly different configuration
	 * 
	 * How this class works is similar to roundabouts (http://en.wikipedia.org/wiki/Roundabout) 
	 * with 2 entrances, and one exit. It assures that regardless of which entrance is taken
	 * the appropriate loading of the two vehicles 'script' and 'skin' is done before letting them
	 * proceed with the rest of the binding (affiliating script with code) and loading sequence
	 * 
	 * IMPLEMENTATION:
	 * You'll need two files*
	 * Script.swf
	 * Skin.swf
	 * 
	 * SCRIPT.SWF CODE
	     ////////////////////////////////////////////////////////////////////////////////
	  	 // Required by MTASC to complete it's job then by BootStrapper to finish it. 
		 // the goal of main() is to load the appropriate first tier of script and skin
		 // which will turn the various clips in the skin.swf into components, and
		 // via their onLoad event work appropriately.
		 //
	import com.troyworks.framework.logging.SOSLogger;
	import GameClass;
	import SWFSiteMap;
	import com.troyworks.framework.frametracker.DoubleEventFrameTracker;
	
	class DemoSandBox extends BootStrapper {
		
		public var className:String = "DemoSandBox";
		public var appname:String = "DemoSandBox";
		public var skinswfURL:String = "demo_sandBox.swf";
		///////////////STATIC INITIALIZATION USED FOR CONFIGURATION//////////////////////////////////////
		public static var _c:Boolean = BootStrapper.setBootStrapperLinkage("DemoSandBox");
		public static var _e:Boolean = BootStrapper.setEventOracleLinkage("SWFSiteMap");
		public static var sm:SWFSiteMap = null;
		public function DemoSandBox() {
			super(this.appname);
			log("XXXXXXXXXXXXXXXXXXXXX DEMO SAND BOX BOOTSTRAPPER XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			//CREATE the object mappings so that whatever is on the stage gets intialized
			// correctly
			Object.registerClass("SandBoxApp", SWFSiteMap);
			Object.registerClass("Game1", GameClass);
			Object.registerClass("Intro", IntroView);
			//Object.registerClass("Fades",DoubleEventFrameTracker);
			Object.registerClass("Preloading",DoubleEventFrameTracker);
		}
	}
		 ////////////////////////////////////////////////////////////////////////////////
	  	//	 * Required by the bootstrapper to bind the skin.swf's linkageID's
		// with the script.swf's classes.
		//
		public static function registerClasses(){
			trace("registerClasses");
			Object.registerClass("Level3", com.kidthing.shapetown.scrolling.Main);
		}
		
	 * SKIN.SWF CODE
	 * //on frame 1 (with a small animation loading symbol
	if (!_global.BOOTSTRAPPER_PRESENT) {
		_global.BOOTSTRAPPER_PRESENT = "SKIN";
		loadMovieNum("demo_sandBox_mtasc.swf", 1);
		preloadinganimation_mc.alpha = 0;
		preloadinganimation_mc.onEnterFrame = function() {
			this.alpha += 2;
		};
		stop();
	} else {
		// give frame 2 a framelable of "script_loaded"
		log("SKIN.SWF..........LOADED!");
		gotoAndPlay("script_loaded");
	}
	//on frame 2
	import com.kidthing.content.problemgenerator.time.DaysProblemGenerator;
	import com.kidthing.content.problemgenerator.time.MonthsProblemGenerator;
	import com.kidthing.content.problemgenerator.literacy.AlphabetSequenceProblemGenerator;
	import com.kidthing.content.problemgenerator.numerics.NumericProblemGenerator;
	/**
	 * @author Troy Gardner
	 */
	 /*
	class com.kidthing.content.problemgenerator.TestSequenceGenerator extends BootStrapper {
		public var className:String = "TestSequenceGenerator";
		public var appname:String = "TestSequenceGenerator";
		public var skinswfURL:String = "demo_sandBox.swf";
		///////////////STATIC INITIALIZATION USED FOR CONFIGURATION//////////////////////////////////////
		public static var _c:Boolean = BootStrapper.setBootStrapperLinkage("com.kidthing.content.problemgenerator.TestSequenceGenerator");
		public static var _e:Boolean = BootStrapper.setEventOracleLinkage("SWFSiteMap");
	/	public function TestSequenceGenerator() {
		super(this.appname);
			log("XXXXXXXXXXXXXXXXXXXXX DEMO SAND BOX BOOTSTRAPPER XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace("running A " +testA());
			
		}
		public function testA():Boolean{
			return true;
		}
	}*/
	
	/********************************************************************** * 
	 * 
	 * @author Troy Gardner (troy@troyworks.com)
	 * @version 1.0
	 * @link http://www.troyworks.com/framework/bootstrapper/
	 */
	import flash.display.MovieClip;
	import flash.xml.XMLDocument;
	public class BootStrapper extends BaseObject {
		public var appname:String;
	    public var skinswfURL:String = "Skin.swf";
		protected var scPT:ScriptConfig;
		protected var sKn:SkinConfig;
		protected var intV:Number;
		protected static var all_strappers:Object  = new Object();
		protected static var _className:String = "com.troyworks.framework.bootstrapper.BootStrapper";
		protected static var _oracleLnkg:String;
		protected static var bootStrapLnkg:Object;
			///////////////////////////////////////////////////////////////////////
		//Called by MTASC Entry point for SCRIPT.SWF
		/////////////////////////////////////////////////////////////////////
		public static function main(container : MovieClip) : void {
			var appC:ApplicationContext = 	ApplicationContext.getInstance();
			appC.log("BootStrapper.MTASC.main(" + container  + " " + container.name +");=======================================================");
			//_global.BOOTSTRAPPER_PRESENT =true; 
			
		//	var aL:XMLLoader = new XMLLoader("config/FactoryConfig.XMLDocument", container);
		//  	aL.startLoading();
			///////////////CONFIGURE FACTORY //////////////////////////////////
			var cfg = BootStrapper.getDefaultFactoryConfiguration();
			SOSLogger.traceArray(cfg);
			ApplicationContext.registerImplementers(cfg);	
			////////////CREATE THE BOOTSTRAPPER/////////////////////		
			var b:BootStrapper = BootStrapper(ApplicationContext.getImplementor("BootStrapper"));
			if(b == null){
				trace("**ERROR** Fatal Error in Bootstrapper 'BootStrapper Cannot Be Null'");
				return;
			}
			BootStrapper.all_strappers[b.appname] = b;
			trace("SCT:_global.BOOTSTRAPPER_PRESENT  " + _global.BOOTSTRAPPER_PRESENT );		
			if(_global.BOOTSTRAPPER_PRESENT == "SKIN" ){
				appC.log("BootStrapper.main SKIN LOADED FIRST");
				var s:SkinConfig = b.getSkinConfig(_level0);
				s.register(s);
			}else {
				appC.log("BootStrapper.main SCRIPT LOADED FIRST");
				_global.BOOTSTRAPPER_PRESENT = "SCRIPT" ;
				var skin:SkinConfig = b.getSkinConfig();
				//Load (default) skin
				var scrptCfg:ScriptConfig =  b.getScriptConfig();
				scrptCfg.register();
			}
			_global.log = appC.getLoggerRef();
				
		}
		///////////////////////////////////////////////////////////////////////////////
		public static function getBootStrapperLinkage():Object{
			return BootStrapper.bootStrapLnkg;
		}
		/*********
		 * The class name (as a string) to instantiate.
		 */
		public static function setBootStrapperLinkage(cnf:String):Boolean{
		    BootStrapper.bootStrapLnkg = cnf;	
		    return true;
		}
		public static function setEventOracleLinkage(cnf:String):Boolean{
		    BootStrapper._oracleLnkg = cnf;	
		    return true;
		}
		public static function getEventOracleLinkage():String{
		    return    BootStrapper._oracleLnkg;
		}	
	/*	public static function getDefaultLogger():ILogger{
				return BootStrapper.logger;
		}*/
		public static function getDefaultFactoryConfiguration():Object{
				//////////////////////////////////
			// setup the class mappings for the Spring style injection,
			// these might be passed in from global variables, or loaded in from 
			// loadVars, XMLDocument etc.,
			var obj:Object = new Object();
			obj["Logger"] = "com.troyworks.framework.logging.SOSLogger";
			obj["Oracle"] = "com.troyworks.framework.events.DummyEventDispatcher";
			obj["BootStrapper"]= BootStrapper.getBootStrapperLinkage();
			obj["Oracle"]= BootStrapper.getEventOracleLinkage();
			return obj;
		}
		///////////////////////////////////////////////////////////////////////////
		// Entry point for the SKIN.SWF, also called by the SCRIPT via the Factory
		////////////////////////////////////////////////////////////////////////
		public static function getInstance(appname:String, user:String):BootStrapper{
			if(appname == null){
				appname = "_DEFAULT_";
			}
			var appC:ApplicationContext = 	ApplicationContext.getInstance();
			var b:BootStrapper = BootStrapper.all_strappers[appname];
			if(b == null){
				//bootstrapper doesn't exist create it
		      	appC.log("BootStrapper.getInstance().creating new bootstrapper for application " + appname + " " + user);
				b  = new BootStrapper(appname);
				BootStrapper.all_strappers[appname] = b;
			}else{
				appC.log("BootStrapper.getInstance().bootstrapper already exists for application " + appname + " " + user);
			}
			return b;
		}
	
		/****************************************************************************
		 * PER APP FUNCTIONALITY
		 ****************************************************************************/
		public function BootStrapper(a_appname:String){
			super();
			appname = a_appname;
			log("new BootStrapper() " + this.appname + " " + this.skinswfURL);
		}	
		/*
		 * Factory Returns a blank configuration, to be registered later. 
		 */
		public function getScriptConfig(script_mc : MovieClip, classI:Object):ScriptConfig{
			var scPT:ScriptConfig = new  ScriptConfig();
			scPT.bootS = this;
			scPT.script_mc = script_mc;
			scPT.scriptI = classI;
		    scPT.skinSwfURL = this.skinswfURL;
		    log("new ScriptCOnfig()");
			return scPT;
		}
		/*
		 * Factory Returns a blank configuration, to be registered later. 
		 */
		public function getSkinConfig(skin_mc:MovieClip, skin_frameLbl:String):SkinConfig{
			var sKn = new  SkinConfig();
			sKn.bootS = this;
			sKn.skin_mc = skin_mc;
			sKn.skin_frameLbl = skin_frameLbl;
			log("new SkinConfig()");
			return sKn;
		}
		
		/////////////////////////////////////////
		// Create the roundabout 
		public function registerSkin(skinCfg:SkinConfig):void{
			log("BootStrapper.registerSkin " + skinCfg);
			if(skinCfg == null){
				var str:String = "registerSkin cannot have null skin Configuration!";
				log(str);
				throw new Error(str);
			}
			skinCfg.bootS = this;
			var SKIN_Loaded:Boolean = (sKn != null);
			var SCRIPT_Loaded:Boolean = (scPT != null);
			if(true){
				//We are now finished loading.	
				scPT.onAllLoaded();
				sKn.onAllLoaded();
				onSkinAndScriptLoaded();
			}
			//////Determin which course to take
			if (!SKIN_Loaded && !SCRIPT_Loaded) {
				log("SKIN loaded first, pausing to load SCRIPT");
				sKn = skinCfg;	
				sKn.loadScriptSWF();
			} else{ 
			//if(!SKIN_Loaded && SCRIPT_Loaded) {
				log("SKIN loaded second");
				sKn = skinCfg;		
				//We are now finished loading.	
				scPT.onAllLoaded();
				sKn.onAllLoaded();
				onSkinAndScriptLoaded();
			}
	/*		} else if(SKIN_Loaded && !SCRIPT_Loaded) {
				log("ERROR! Bootstrapper SKIN already loaded");
			} else if(SKIN_Loaded && SCRIPT_Loaded) {
				log("ERROR! Bootstrapper ALL alread loaded");
			}*/
		}
		/////////////////////////////////////////
		// Create the roundabout 
		public function registerScript(scriptCfg:ScriptConfig) : void {
			log("BootStrapper.registerScript " + scriptCfg);
			if(scriptCfg == null){
				var str:String = "registerScript cannot have null script Configuration!";
				log(str);
				throw new Error(str);
			}
			
			scriptCfg.bootS = this;	
			var SKIN_Loaded:Boolean = (sKn != null);
			var SCRIPT_Loaded:Boolean = (scPT != null);
			//////Determin which course to take
			if (!SKIN_Loaded && !SCRIPT_Loaded) {
				log("SCRIPT loaded first, pausing to load SKIN");
				scPT = scriptCfg;
				scPT.loadSkinSWF();
			}else{
			//} else if(SKIN_Loaded && !SCRIPT_Loaded) {
				log("SCRIPT loaded second");
				scPT = scriptCfg;
				//We are now finished Loading 
				scPT.onAllLoaded();
				sKn.onAllLoaded();
				onSkinAndScriptLoaded();			
				
			}
	/*		} else if(!SKIN_Loaded && SCRIPT_Loaded) {
				log("ERROR! Bootstrapper SCRIPT already loaded");
			} else if(SKIN_Loaded && SCRIPT_Loaded) {
				log("ERROR! Bootstrapper ALL alread loaded");
			}*/
		}
	
		public function loadMC(clipURL:String, clipTarget:String):void{
			//MTASC hack//_root.loadMovie(clipURL);
			log(appname+ " loadMC " + clipURL + "  " +clipTarget + " ");
			public var loadMovie = eval("loadMovie");
			loadMovie(clipURL, clipTarget);
			log(loadMovie+ " loadMC " + clipURL + "  " +clipTarget);
		
		}
	
		public function toString():String{
			return appname + " " + _className +  "BootStrapper";
		}
		protected function onSkinAndScriptLoaded() : void {
			log("XXXXXXXXXXXXXXXXX on SCRIPT AND SKIN LOADED XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
		}
	
	}
}