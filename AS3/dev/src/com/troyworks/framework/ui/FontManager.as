package com.troyworks.framework.ui { 
	import com.troyworks.data.ArrayX;
	/**
	 * FontManager is a utility class to help deal with the 
	 * somewhat complicated nature of runtime dynamic font loading in flash
	 * basically it's a hack of sorts but it works and it's valueable,
	 * especially as one gets into lots of fonts, used by lots of files, 
	 * and international characters sets (600K+!)
	 * 
	 * The Basic Structure is
	 *  (1) FontWhatever.swf - contains the actual font outlines embedded (shared for runtime use) (nothing on stage)
	 *  (2) FontWhateverProxy.swf - uses the shardlibrary aspect of FontWhatever (ref from FontWhatever's Library on stage)
	 *  (3) FontWhateverUser.swf - 'borrows' from FontWhateverProxies access to FontWhatever, loads FontWhateverProxy into itself.
	 *  
	 *  Note there are some gotchas to this, this is ONLY used for Dynamic Fonts
	 *  where there are no other TextFields on stage using 
	 *  e.g. Static TextFields on stage with the same font name (embedded by default)
	 *  will overshadow this.
	 *  
	 * (2)PROXY CLIPS 
	 *    need something like this
	 * CODE: onFrame1
	     var isReady= true;
	     parent.parent.onAssetLoaded(["Futura:Font"], this);
	
	 *  
	 * (3) USER CLIP need something like this
	 * CODE: on Frame1
	 
	   //testFontLinkageId = "Futura";
	   var font_mc:MovieClip = FontManager.loadDynamicFont("Futura_BasicProxy.swf", this);
	   var loadCheck_ary:Array = new Array();
	   loadCheck_ary.push(font_mc);
	   ////////////////PRELOADER ///////////////////
	   function onAssetLoaded(linkageIds, font_mc){
		  trace("onAssetLoaded("+linkageIds+")");
		  FontManager.getInstance().registerFont(linkageIds,  font_mc);
		  var isFinished:Boolean = true;
		  for(var i in loadCheck_ary){
			trace("checking " + i);
			var o:MovieClip = loadCheck_ary[i];
			trace(util.Trace.me(o, "LoadCheck", true));
			if(!o.isReady){
				isFinished = false;
				break;
			}
		}
		if(isFinished){
			trace("is Finished");
			FontManager.getInstance().demoFonts(this);
		}
	   }
	   stop();
	
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	public class FontManager{
		public var fontsAvailable : ArrayX;
		protected static var instance : FontManager;
		public static var DEBUG:Boolean = false;
		protected static var count : Number = 0;
		public static var default_fmt : TextFormat;

		protected function FontManager() {
			fontsAvailable = new ArrayX();	
		}
			
		/**
		 * @return singleton instance of FontManager
		 */
		public static function getInstance() : FontManager {
			if (instance == null){
				instance = new FontManager();
			}
			return instance;
		}
		public function styleMe(clip:MovieClip, label_txt:TextField):void{
			label_txt.setTextFormat(default_fmt);
			label_txt.defaultTextFormat = default_fmt;
		//	label_txt.input = true;
			label_txt.embedFonts = true;
			if(DEBUG){
			label_txt.border = true;
			}
		}
		/***********************************
		 * Using the FontManager, who has loaded
		 * up fonts dynamically
		 * get the appropriate style
		 */
		public function styleTextFields(_mc:MovieClip) : void{
			for (var i : String in _mc) {
			//	trace(i + " " + _mc[i]);
				var o:Object = _mc[i];
				if(o is TextField){
					var tf:TextField = TextField(o);
					//trace("FOund a TextField");
					styleMe(_mc,tf);
				}
				
			}
		}
		public function registerFont(fontLnkStr:String,  font_mc:MovieClip):void{
			trace("___________________________________________________________");
			trace("FontManager.registerFont " + fontLnkStr + " " + util.Trace.me(font_mc, "fonts_mc", true));
			var _ary:Array =  String(fontLnkStr).split(":");
			trace("aray " + _ary.join("\r"));
			var font_linkageID:String =_ary[0];
			trace("fontLInkage " + font_linkageID);
			fontsAvailable.push(font_linkageID);
		}
		public static function loadDynamicFont(pathURL:String, base_mc:MovieClip):MovieClip{
			var dynfonts_mc:MovieClip  = getFontHolderClip(base_mc);
			var A:Number = pathURL.lastIndexOf("/");
			var A1:Number = pathURL.lastIndexOf("\\");
			var B:Number = pathURL.lastIndexOf(".");
			var A2 = Math.max(A+1, Math.max(A1,0));
			var name:String = pathURL.substr(A2, B);
			trace("pathName " + name);
				var nextFont_mc =  dynfonts_mc.createEmptyMovieClip(name +"_mc", dynfonts_mc.getNextHighestDepth());
			nextFont_mc.loadMovie(pathURL);
			return nextFont_mc;
		}
		public static function getFontHolderClip(base_mc:MovieClip):MovieClip{
			var dynfonts_mc:MovieClip = null; 
			if(base_mc.dynamicFontAsset_mc == null){
				dynfonts_mc = base_mc.createEmptyMovieClip("dynamicFontAsset_mc", base_mc.getNextHighestDepth());
			}else{
				dynfonts_mc = base_mc.dynamicFontAsset_mc;
			}	
			if(!DEBUG){
			dynfonts_mc.visible = false;
			dynfonts_mc.x = base_mc.stage.stageWidth;
			}
			return dynfonts_mc;
		}
		public  function demoFonts(_mc:MovieClip):void{
			for(var i:Number = 0; i < fontsAvailable.length; i++){
				trace("testing Font " + fontsAvailable[i]);
				testRuntimeFontUse(fontsAvailable[i], _mc);
			}
		}
		public static function testRuntimeFontUse(fontLinkageID : String,  _mc:MovieClip) : void{
			
			//////////////////////////////////
	// Create the text fields
			var _ary:Array = new Array();
			_ary.push(_mc.testNormal_txt = new TextField();
			_ary.push(_mc.addChildAt(_ary.push(_mc.testNormal_txt, _mc.getNextHighestDepth());
			_ary.push(_mc.testNormal_txt.x = 110;
			_ary.push(_mc.testNormal_txt.y = 20 * ++count;
			_ary.push(_mc.testNormal_txt.width = 600;
			_ary.push(_mc.testNormal_txt.height = 20));
						_ary.push;
			_ary.push(_mc.testBold_txt = new TextField();
			_ary.push(_mc.addChildAt(_ary.push(_mc.testBold_txt, _mc.getNextHighestDepth());
			_ary.push(_mc.testBold_txt.x = 110;
			_ary.push(_mc.testBold_txt.y = 20 * ++count;
			_ary.push(_mc.testBold_txt.width = 600;
			_ary.push(_mc.testBold_txt.height = 20));
						_ary.push(_mc.testItalic_txt = new TextField();
						_ary.push(_mc.addChildAt(_ary.push(_mc.testItalic_txt, _mc.getNextHighestDepth());
						_ary.push(_mc.testItalic_txt.x = 110;
						_ary.push(_mc.testItalic_txt.y = 20 * ++count;
						_ary.push(_mc.testItalicBold_txt = new TextField();
						_ary.push(_mc.addChildAt(_ary.push(_mc.testItalicBold_txt, _mc.getNextHighestDepth());
						_ary.push(_mc.testItalicBold_txt.x = 110;
						_ary.push(_mc.testItalicBold_txt.y = 20 * ++count;
						_ary.push(_mc.testItalicBold_txt.width = 600;
						_ary.push(_mc.testItalicBold_txt.height = 20));
									for;
						
				var style : String = "";
				switch(i){
					case 0:
						break;
					case 1:
						style = " bold";
						break;
					case 2:
						style = " italic";
						break;
					case 3:
						style = " bold italic";
						break;
				}
			//////////////////////////////////
			//populate it with text: 
			// NOTE: Including some symbols not 
			// embedded to demonstrate how they appear (or rather are hidden).
			if(true){
				_txt.html = true;
				_txt.type = "input";
				_txt.htmlText = "<font color='#FF0000'><b>"+fontLinkageID + style+"</b></font> !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~�������������������";
			}else{
				_txt.text = fontLinkageID + style+"!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~�������������������";
			}
			////////////////////////////////////////
			// Use the FONT name, not the linkage id.
				var format1_fmt : TextFormat = new TextFormat();
				format1_fmt.font = fontLinkageID;
				switch(i){
					case 0:
						break;
					case 1:
						format1_fmt.bold = true;
						break;
					case 2:
						format1_fmt.italic= true;
	
						break;
					case 3:
						format1_fmt.italic= true;
						format1_fmt.bold= true;
	
						break;
				}
				_txt.autoSize = true;
				_txt.setTextFormat(format1_fmt);
				_txt.embedFonts = true;
			}
		}
	}
}