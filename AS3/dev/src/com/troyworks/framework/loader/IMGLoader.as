package com.troyworks.framework.loader {
	import flash.display.Sprite;	
	import flash.display.Bitmap;	
	import flash.net.URLRequest;	
	import flash.events.Event;	
	import flash.display.Loader;

	/**
	 * IMGLoader
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Jun 7, 2008
	 * DESCRIPTION ::  A simple 
	 *
	 *loadImage();

	 */
	public class IMGLoader {
		var _loader : Loader;
		var sizeToImage_mc:Sprite;
		var target_mc:Sprite;
		function loadImage():void {

			/////////////////////////////////////
			_loader = new Loader();
			var jpg : String = "image.jpg";
			//"TroyWorks-80x80.jpg"; //
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeImageLoadHandler);
			var request : URLRequest = new URLRequest(jpg);
			_loader.load(request);

	// addChild(_loader);
		}

		
		function completeImageLoadHandler(event : Event) : void {
			trace("completeHandler: " + event);
			var clip : Bitmap = Bitmap(Loader(event.target.loader).content);
			
			clip.width = sizeToImage_mc.width;
			clip.height = sizeToImage_mc.height;
			//sizeToImage_mc.alpha = .6;
			target_mc.addChild(clip);
		}
	}
}
