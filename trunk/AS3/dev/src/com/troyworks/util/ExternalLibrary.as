package com.troyworks.util
{
    import flash.display.Loader;
    import flash.net.URLRequest;
    import flash.events.Event;
    import flash.display.LoaderInfo;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;

	public class ExternalLibrary
	{
		private var url:String;
		private var callback:Function;
		private static var library:String;
		
		public function setUrl(url:String):void
		{
			this.url = url;
		}
		
		public function setCallback(callback:Function):void
		{
			this.callback = callback;
		}
		
		private function load():void
		{
			// child SWF adds its unique definitions to
			// parent SWF; both SWFs share the same domain
			// child SWFs definitions do not overwrite parents
			var addedDefinitions:LoaderContext = new LoaderContext();
			addedDefinitions.applicationDomain = ApplicationDomain.currentDomain;
			
            var loader:Loader = new Loader();
            if (this.callback != null) {
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.callback);
			}            
			loader.load(new URLRequest(this.url), addedDefinitions);
		}
		
		private static function load(url:String, callback:Function = null):void
		{
			var el = new ExternalLibrary;
			el.setUrl(url);
			el.setCallback(callback);
			el.load();
		}
		
		public static function loadAirLib(callback:Function = null)
		{
			ExternalLibrary.library = 'airlib';
			ExternalLibrary.load('air-lib.swf', callback);
		}
		
		public static function loadPlayerLib(callback:Function = null)
		{
			ExternalLibrary.library = 'fplib';
			ExternalLibrary.load('fp-lib.swf', callback);
		}
		
		public static function create(className:String, params:* = null):Object
		{
			var fullClassName:String = 'com.troyworks.io.' + ExternalLibrary.library + '.' + className;
			var clazz:Class = Class(ApplicationDomain.currentDomain.getDefinition(fullClassName));
			if (params) {
				return new clazz(params);				
			} else {
				return new clazz();
			}
		}
		
		public static function static(className:String):Class
		{
			var fullClassName:String = 'com.troyworks.io.' + ExternalLibrary.library + '.' + className;
			trace(fullClassName);
			return Class(ApplicationDomain.currentDomain.getDefinition(fullClassName));
		}
	}
}