package com.troyworks.framework { 
	import com.troyworks.framework.model.AssetLibrary;
	import com.troyworks.hsmf.Hsmf;
	
	
	
	/**
	 *
	 * @author Troy Gardner
	 * @version
	 * parent chain: HsmfE (statemachine + events)->MovieClip->Object
	 **/
	
	import flash.display.MovieClip;
	public class Application extends Hsmf  {
		public static var LOADING1_SWF_LEVEL:Number = 9999;
		public static var SCRIPT_SWF_LEVEL:Number = 9800;
		public static var APP:Object;
		protected static var nextScriptLevel:Number = SCRIPT_SWF_LEVEL;
	
		//FONTS, SHARED LIBRARIES, MODAL DIALOGS
		//public static var LOADING1_SWF_LEVEL:Number = 9999;
		public function Application(initState : Function, pathPrefix:String){
		//	super(initialState, name,);
	
			trace("new Application");
		}
		public static function getNextScriptLevel():Number{
			return  nextScriptLevel++;
		}
		public function registerAssetLibrary(astLib:AssetLibrary):void{
			trace("DDDDDDDDDDDDDregisterAssetLibrary " + astLib + " DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD");
		}
	
		public static function registerClasses():void{
			
		}
		public static function registerApp(clas:Object):Object{
			return clas;
		}
	
	}
}