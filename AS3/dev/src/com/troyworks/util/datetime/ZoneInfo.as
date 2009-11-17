package com.troyworks.util.datetime {
		import flash.events.*;
		import flash.net.URLStream;
		import flash.net.URLRequest;
		import flash.utils.ByteArray;
		import flash.utils.Dictionary;

		public class ZoneInfo extends EventDispatcher{
		
		
		private var loader:URLStream;
		private var zones:Dictionary;	
		private var Rules:Array;
		
		public static var LOADED:String = "LOADED";
		public static var IOERROR:String = "IOERROR";
		
		public function ZoneInfo (filename:String){
			zones = new Dictionary();
			readContent(filename);
		}
		
		private function readContent (filename:String):void{
			loader= new URLStream();
			loader.addEventListener(Event.COMPLETE, process);
			loader.load(new URLRequest(filename)); 
			loader.addEventListener(IOErrorEvent.IO_ERROR , errorHandler);
		}
		
		private function errorHandler (e:Event){
			dispatchEvent(new Event(ZoneInfo.IOERROR));
		}
		private function process (event:Event){
			//trace(event.target.data);
			var beta:ByteArray = new ByteArray();
			loader.readBytes(beta,0,loader.bytesAvailable);		
			var tZones:Array = beta.readObject();
			Rules = beta.readObject();
			
			loadDic (tZones);
		}
		private function getClearParts(array:Array){
			var toR = new Array();
			for (var i = 0; i<array.length; i++){
				if (array[i]!="")
					toR.push(array[i]);
			}
			return toR;
		}
		
		private function makeStandard (zone:String):String{
			var parts = getClearParts(zone.split("/"));
			if (parts.length > 1){
				return parts[0]+", "+parts[1].replace("_"," ");
			}
			return zone;
		}
		
		private function loadDic (array:Array):void{
			for (var i:int=0; i<array.length; i++){
				zones[makeStandard(array[i][0])] = array[i];
			}
			dispatchEvent(new Event(ZoneInfo.LOADED));
		}
		
		public function list ():void{
			for (var that in zones){
				trace(that+" : "+zones[that]);
			}			
		}	
		
		public function getZones ():Dictionary{
			return zones;
		}
		
		public function getDayLightSavingRules ():Array{
			return Rules;
		}
	}
}