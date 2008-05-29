package com.troyworks.framework.assets { 
	/**
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;
	import flash.text.TextField;
	public class AssetLibrary {
		public static function initialize(_mc:MovieClip) : void {
			var s = "$$$$$$$$$$$$$$$$$$$$$$ ASSET LIBRARY LOADED " +  _mc._url +" into " +  _mc.parent.name + " url " + _mc.parent._url;
			_global.log(s);
			trace(s);
			if(_global.DEBUG || _mc._url == _root._url){
			trace("initializing " +_mc  +" as AssetLibrary");
			_mc.loadLbl_txt = new TextField();
			_mc.addChild(_mc.loadLbl_txt);
			_mc.loadLbl_txt.x = 5;
			_mc.loadLbl_txt.y = 5;
			_mc.loadLbl_txt.width = 200;
			_mc.loadLbl_txt.height = 20;
			
			_mc.loadLbl_txt.text = "loaded AssetLibrary " + _mc._url;
			_mc.loadLbl_txt.autoSize = true;
			}
			_global.oracle.registerAsset(_mc);
				
	
		}
			
	
	}
}