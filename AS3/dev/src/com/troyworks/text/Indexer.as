package com.troyworks.text
{
	import  flash.net.*;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.describeType;
	import com.troyworks.util.StringUtil;
	public class Indexer
	{
		public function Indexer(){
		  var keyL:URLLoader = new URLLoader();
		  keyL.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
		  keyL.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHttpStatus);
		  keyL.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
		  keyL.addEventListener(Event.COMPLETE, handleComplete);
		  keyL.dataFormat = URLLoaderDataFormat.TEXT;
		  var path:String = "C:\\DATA_SYNC\\My Documents\\My Projects\\Muses\\dev\\Campaigns\\phonenumber411\\keywords.txt";
		  keyL.load(new URLRequest(path));
		}
		function handleIOError(event:IOErrorEvent):void{
					trace("Load failed: IO Error" + event.text);		
		}
		function handleHttpStatus(event:HTTPStatusEvent):void{
			trace("Load failed: Http Status" + event.status);		
		
		}
		function handleSecurityError(event:IOErrorEvent):void{
			trace("Load failed: Security Error" + event.text);		
		}
		function handleComplete(event:Event):void{
			trace("the data has successfully loaded");
			var loader:URLLoader = URLLoader(event.target);
			trace(loader.data + " " + describeType(loader.data));
			var lines:Array = loader.data.split("\r");
			trace("Found " + lines.length + " Raw lines");
			lines.sort();
			var prev:String ="";
			var filteredLines:Array = new Array();
			for(var i:int = 0; i < lines.length; i++){
				var cLine:String = StringUtil.trim(lines[i]);
				if(cLine != prev){
					//trace(i + ": '" + cLine+ "'");
					filteredLines.push(cLine);
				}else {
					//trace("removing Duplicates");
				}
			}
			trace("Found " + filteredLines.length + " Filtered lines");
			///////////////// BREAK INTO WORD COUNT ////////////////////
			var idx:Object = new Object();
			var dens:Array = new Array();
			for(var k:int = 0; k < filteredLines.length; k++){
				var ary:Array= filteredLines[k].split(" ");
				for(var j:int = 0; j < ary.length; j++){
					var wrd:String = ary[j];
					trace("wrd " + wrd);
					if(idx[wrd] == null){
						idx[wrd] = Number(dens.length);
						trace("new word at " + dens.length);
						var kv:Object = new Object();
						kv.key = wrd;
						kv.keyl = wrd.length;
						kv.value = 1;
						dens.push(kv);
					}else{
						var d:Number = idx[wrd];
						trace("EXISTING word at "+ d + " count " +dens[d].value);
						dens[d].value++;
					}
				}
			}
			//////////////////WORD DENSITY///////////////////////////////
			dens.sortOn("value", Array.NUMERIC);
			trace("HitCount " + dens.length);
			for(var m:int = 0;m < dens.length; m++){
				trace(m + " " + dens[m].key + "  " + dens[m].value);
			}
			//////////////////WORD LENGTH///////////////////////////////
			dens.sortOn("keyl", Array.NUMERIC);
			trace("Word Length sort " + dens.length);
			for(m = 0;m < dens.length; m++){
				trace(m + " " + dens[m].key );
			}
			
			
		}
	}
}