package com.troyworks.util.codeGen { 
	import com.troyworks.hsmf.Hsmf;
	import com.troyworks.framework.logging.SOSLogger;
	import com.troyworks.events.TProxy;
	import com.troyworks.hsmf.AEvent;
	import com.troyworks.framework.ui.FontManager;
	/**
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;
	import flash.text.TextFormat;
	public class CodeGenBootStrapper extends Hsmf {
	
		protected var container_mc : MovieClip;
		protected var loadTarget_mc : MovieClip;
		protected static var _b : Function = SOSLogger;
	
		protected var loadCheck_ary : Array = new Array();
			/**************************************************
		 * Called by the MTASC compiler with the '-main' flag
		 * set.
		 * 
		 */
		 	/*****************************************************
		 *  Constructor
		 */
		public function CodeGenBootStrapper(aContainer : MovieClip) {
			super(s_initial, "CodeGenBootStrapper", false);
			REQUIRE(aContainer != null, "KTClientBootStrapper( aContainer ) can't be null!");
			container_mc = aContainer;
			trace("KTClientBootStrapper main called" + container_mc);
			loadTarget_mc = (container_mc == _root || container_mc == _level1)?container_mc:container_mc.parent;
			trace("DEBUG AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" + this + " al " + onAssetLoaded);
			loadTarget_mc.onAssetLoaded = TProxy.create(this, onAssetLoaded);
			
			trace("DEBUG BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");
			init();
		}
			/**************************************************
		 * Called by the MTASC compiler with the '-main' flag
		 * set.
		 * 
		 */
		public static function main(container : MovieClip) : void {
			trace("InfoDotsBootStrapper.mainXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			var bs : CodeGenBootStrapper = new  CodeGenBootStrapper(container);
		}
		
	
		///////////////// Commands ////////////////////////////////
		public function onAssetLoaded(asset : MovieClip) : void{
			trace("HIGHLIGHT0 " + util.Trace.me(asset, asset.name + " onASSETLOADED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!", true));
	    //  if(asset == dot_style_mc){
	       //	trace("AAAAAAAAAAAAA");
	     //  	  parseMiniDotLibraryConfig(dot_style_mc);
	      // }
		}
		/*..PSEUDOSTATE...............................................................*/
		public function s_initial(e : AEvent) : void
		{
			trace("************************* s_initial " + util.Trace.me(e)+" ******************");
			onFunctionEnter ("s_initial-", e, []);
			if(e.sig != Q_TRACE_SIG){
				Q_INIT(s0_loadingConfig);
			}
		}
		/*.................................................................*/
		public function s0_loadingConfig(e : AEvent) : Function
		{
			trace("************************* " + hsmName + ".s0_loadingConfig " + e.sig.name+" ******************");
			this.onFunctionEnter ("s0_loadingConfig-", e, []);
			switch (e.sig)
			{
				case Q_ENTRY_SIG :
				{
					_global.SCRIPT_LOADED= this;
	
					return null;
				}
				case Q_EXIT_SIG :
				{
					return null;
				}
				case Q_INIT_SIG :
				{
					trace("lading attep 'creating callback" + callbackIn);
					callbackIn();
					return null;
				}
				case Q_CALLBACK_SIG:
				{
					Q_TRAN(s0_registeringObjects);
					return null;
				}
			}
			return s_top;
		}
		/*.................................................................*/
		public function s0_registeringObjects(e : AEvent) : Function
		{
			trace("************************ " + hsmName + ".s0_registeringObjects " + e.sig.name+" ******************");
	
			this.onFunctionEnter ("s0_registeringObjects-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
		//1) Register any MovieClip views in the Skin.swf library
			// with the associated ActionScript Classes (must be linked/referenced
			// to this class)
			
			///////////////////REGISTRATION PAGES ////////////////////////////////////
					//Object.registerClass("CodeGen",CCodeTranslator);
					Object.registerClass("CodeGen",As2CodeHelper);
					callbackIn();
					return null;
				}
				case EXIT_EVT :
				{
					return null;
				}
				case INIT_EVT :
				{
					return null;
				}
				case CALLBACK_EVT:
				{
					Q_TRAN(s0_cleaningUp);
					return null;
				}
			}
			return s_top;
		}
		/*.................................................................*/
		public function s0_cleaningUp(e : AEvent) : Function
		{
			this.onFunctionEnter ("s0_cleaningUp-", e, []);
			trace("______________________________________ s0_cleaningUp UP ________________________");
			switch (e)
			{
				case ENTRY_EVT :
				{
					trace("loadTarget " +loadTarget_mc);
					//////////////////////SETUP and LOAD FONTS ///////////////////////////////////////
					var default_fmt : TextFormat = new TextFormat();
					default_fmt.font = "Futura Com Medium";
				//	default_fmt.bold = true;
					_global.default_fmt = default_fmt;
					FontManager.getInstance();
					var font_mc : MovieClip = FontManager.loadDynamicFont("Futura_BasicProxy.swf", loadTarget_mc);
					var font2_mc : MovieClip = FontManager.loadDynamicFont("FuturaMediumCompressedProxy.swf", loadTarget_mc);
					loadCheck_ary.push(font_mc);
					loadCheck_ary.push(font2_mc);
	
					startPulse();
					return null;
				}
				case PULSE_EVT:
				{
					var isFinished : Boolean = true;
					for(var i:String in loadCheck_ary){
						trace("checking " + i);
						var o : MovieClip = loadCheck_ary[i];
						trace(util.Trace.me(o, "LoadCheck", true));
						if(!o.isReady && o.name != null){
							isFinished = false;
							break;
						}
					}
					if(isFinished){
						stopPulse();
						trace("is Finished");
						FontManager.getInstance().demoFonts(this);
						callbackIn();
					}
					return null;
				}
				case EXIT_EVT :
				{
					/*if (_global.styles.Tree == undefined) {
						_global.styles.Tree = new CSSStyleDeclaration();
	}
	
					_global.styles.Tree.setStyle("themeColor", "haloOrange");
	//_global.styles.Tree.setStyle("backgroundColor", 0xFF00AA);
					_global.styles.Tree.setStyle("fontFamily", "Futura Com Medium");
					_global.styles.Tree.setStyle("embedFonts", true);
					_global.styles.Tree.setStyle("rollOverColor", 0xFFFF9C);
					_global.styles.Tree.setStyle("selectionColor", 0xF8CE1C);*/
					/////////////Resume playing the timeline///////////////////////
					loadTarget_mc.nextFrame();
					return null;
				}
				case INIT_EVT :
				{
					return null;
				}
				case CALLBACK_EVT:
				{
					Q_TRAN(s0_finishedBootStrapping);
					return null;
				}
			}
			return s_top;
		}
		/*.................................................................*/
		public function s0_finishedBootStrapping(e : AEvent) : Function
		{
			this.onFunctionEnter ("s0_finishedBootStrapping-", e, []);
			trace("______________________________________ s0_finishedBootStrapping UP ________________________");
			switch (e)
			{
				case ENTRY_EVT :
				{
					return null;
				}
				case EXIT_EVT :
				{
					return null;
				}
				case INIT_EVT :
				{
					return null;
				}
			}
			return s_top;
		}
	
	}
}