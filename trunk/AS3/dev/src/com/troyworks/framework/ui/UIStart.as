/**
* This is part of the App Framework
* 
* Start, is typically the match that ignites the sequence of UI/Engine/Asset loading.
* 

DEMO CODE:

package com.project.content.framework {
	import com.troyworks.framework.ui.Start;
	import Namespace;

	public dynamic class UIStart extends com.troyworks.framework.ui.Start{
		
		//private var ps:Namespace = new Namespace("com.kidthing.content.framework");
		public function UIStart() {
			
			super();
			trace("UIStart");
			UI_config.gameNumber = 1;
			UI_config.configURL="assets/config.xml";
			UI_config.lang="EN";
		
		 //////// frame1 IS NAMESPACED TO THE SWF ///////////
		 // so this must be called in the same namespace
		 // to work properly.
			try{
				if(this["frame1"] != null ){
					//call up whatever config
					this["frame1"] ();
				}else{
					trace(" using defaults");
				}
			}catch(er:Error){
				trace("couldn't init frame1");
			}
		}
		
	}
	
}
* 
* @author Troy Gardner
* @version 0.1
*/

package com.troyworks.framework.ui {
	import com.troyworks.ui.LoaderXtraParams;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.*;
	import flash.net.URLRequest;
	import flash.display.LoaderInfo;
	
	public dynamic class UIStart extends MovieClip{
		/////////////////////////////////////
		public var UI_URL:String = "UI.swf";
		public var UI_config:Object = new Object();

		
		protected var UI_ldr:LoaderXtraParams = new LoaderXtraParams();
		
		public function UIStart() {
			super();
			trace("UIStart....");

			UI_ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleted);
			UI_ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onFailed);
			addChild(UI_ldr);
			try{
				if(this["frame1"] != null ){
					//call up whatever config
					this["frame1"] ();
				}else{
					trace(" using defaults");
				}
			}catch(er:Error){
				trace("couldn't init frame1");
			}
			addFrameScript(0, onFrame1);
		}
		function onFrame1():void{
			trace("UIStart.onFrame1");

			var hit:Boolean = false;
			for(var i in UI_config){
				trace("  UI_config " + i + " " + UI_config[i]);
				hit = true;
			}
			if(!hit){
				trace("no UI params");
			}
			if(UI_config.autoStart == null){
				startLoading();
			}
			stop();
		}
		function startLoading():void{
			trace("startLoading");
			//UI_ldr.xtraVars.gameNumber=4;
			//UI_ldr.xtraVars.configURL="assets/config.xml";
			//UI_ldr.xtraVars.lang="EN";
			///////////////////////////////
			var urlR:URLRequest = new URLRequest(UI_URL);
			UI_ldr.load(urlR);
		}
		function onCompleted(evt:Event):void{
			trace("UI loaded");
			var lInf:LoaderInfo = LoaderInfo(evt.target);
			addChild(lInf.content);
			removeChild(UI_ldr);
		}
		function onFailed(evt:Event):void{
			var str:String = "ERROR\r failed to load \r" + UI_URL + " " + evt.toString();
			trace(str);
			var txt:TextField = new TextField();
			var tf:TextFormat = new TextFormat();
			tf.align = TextFormatAlign.CENTER;
			tf.size = 20;
			txt.defaultTextFormat = tf;
			txt.x = stage.stageWidth/2- txt.width;
			txt.y = stage.stageHeight/2- txt.height;
			txt.autoSize = TextFieldAutoSize.CENTER;
			txt.text = str;

			addChild(txt);
			
		}	
	}
	
}
