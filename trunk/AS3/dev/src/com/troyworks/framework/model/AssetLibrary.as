package com.troyworks.framework.model { 
	/**
	 * @author Troy Gardner
	 * This class is used instead of polling for a movie clips load, the onLoad
	 * event to indicate the asset is loaded.
	 * do something like
	 * 
	 * FLA
	 *  [1]
	 *  Object.registerClass("readySymbol");
	 *  [2]
	 *   all assets on stage in a hidden movie clip that need to be loaded completel
	 *  [3]
	 *   the call to the finished loading with the register ID.
	 */
	 import  com.troyworks.spring.Factory;
	 import com.troyworks.framework.IApplication;
	import flash.display.MovieClip;
	import flash.media.Sound;
	public class AssetLibrary extends MovieClip {
		public var app:IApplication;
		public function AssetLibrary(){
			trace("new AssetLibrary");
		}
		public function onLoad():void{
			trace("asset library onload id:" + this.parent.name);
			this.visible = false;
					// create a new sound object
			trace("importing Sound");
			var MySound = new Sound();
			trace(MySound + " sound");
			// attach the sound
			MySound.attachSound("CircleChoice");
			trace("importing start");	
			// start the sound playing
			MySound.start();
			this.app = IApplication(Factory.getImplementor(""));
			this.app.registerAssetLibrary(this);
	
		}
	}
}