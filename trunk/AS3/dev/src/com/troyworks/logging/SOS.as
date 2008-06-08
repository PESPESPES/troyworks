package com.troyworks.logging { 
	/**
	* This is a raw interface to SOS for the various API documented here http://sos.powerflasher.de/doc/1-04/
	* Generally the SOSLogger is far more useful for
	* 
	 * @author Troy Gardner (troy@troyworks.com)
	 */

	import flash.events.IOErrorEvent;
	import flash.net.XMLSocket;
	public class SOS extends Object{
	
		protected static var _csock : XMLSocket;
		protected static var _msock : XMLSocket;
		public var id:int;
		public var isConnected:Boolean = false;
		
		protected static const clearConsoleCommand:String = "<clear/>\n";
		public static var IDz:int =0;

		public function SOS() {
			super();
			id = IDz++;
		}
		public function connect():Boolean{
			var res:Boolean = true;
			trace("SOS" +id+".connectAAAAAAAAAAAAAAAAAAAAAAAAA " + getStatus());
			if(SOS._csock == null){
                trace("SOS" +id+".creatingCommandSocket");
				SOS._csock = new XMLSocket();
				SOS._csock.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorEvent);
				SOS._csock.connect("localhost",4445);
			}else{
				trace("SOS"+id+"BBBBBBBBBBBBBBBBBBBB COMMAND SOCKET ALREADY CONNECTED BBBBBBBBBBBBBBBBBBBBBBBBB");
			
			}
			if(SOS._msock == null){
				trace("SOS" +id+".creatingMessageSocket");
				SOS._msock = new XMLSocket();
				SOS._msock.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorEvent);
				SOS._msock.connect("localhost",4444);
			}else{
				trace("SOS"+id+"BBBBBBBBBBBBBBBBBBBB MESSAGE SOCKET ALREADY CONNECTED BBBBBBBBBBBBBBBBBBBBBBBBB");				
			
			}
			isConnected = true;
			return res;
		}
		public function onIOErrorEvent(event:IOErrorEvent):void{
			trace("SOS" + id + "onIOErrorEvent" + event.text + " " + getStatus());
		}
		public function getStatus():String{
			var _csockConnected:Boolean = (_csock != null) && _csock.connected;
			var _msockConnected:Boolean = (_msock != null) && _msock.connected;
			var res:String = "csock connected:" +_csockConnected  + "  msock connected:" +_msockConnected;
			return res;
		}
		public function getCommandSocket() : XMLSocket{
			return _csock;		
		}
		public function getMessageSocket() : XMLSocket{
			return _msock;		
		}
		
		public function showMessage(key : String ="com.troyworks.logging.sos", sMessage : Object = "") : void{
			if(!isConnected){
				return;
			}
			if(sMessage.indexOf("</")>-1){
				///if xml send normal.
				_msock.send(sMessage);
			}else if((sMessage is String) &&( String(sMessage).indexOf("\r") > -1)){
			//	trace("folded");
				 ////////// Show a Folded message when caridge returnrs are detected  ///////
					var _ary : Array = String(sMessage).split("\r");
					var res:Array =new Array();
					res.push( "<showFoldMessage key='"+key+"'>");
					var keyV:String = _ary[0];
					var key:String;
					var val:String;
					var b:int = keyV.lastIndexOf(" ");
					if(b > -1){
						key = keyV.substring(0, b);
						val = keyV.substring((b+1), keyV.length);
					}else{
						key = keyV;
					}
					if(keyV.length > 1){
						res.push( "<title>"+key+"...</title>");
					}else{
						res.push( "<title>"+key+"</title>");
					}
					res.push( "<message>");
					for(var i : int = 0; i < _ary.length; i++){
						if(i ==0 && val != null){
							res.push("\t [" + i + "] = " + replaceXML(val) + "\n");
						}else{
							var s:String = "\t [" + i + "] = " + replaceXML(_ary[i]) + "\n";
							res.push(s);		
						}
					}
					res.push( "</message>");
					res.push( "</showFoldMessage>");
					res.push( "\n");						
					_csock.send(res.join(""));
				}else{
				//	trace("normal");
					//////////// Show a normal message /////////////////
					_csock.send("<showMessage key='"+key + "'>"+replaceXML(sMessage.toString())+"</showMessage>\n");
				}
		}
		public function replaceXML(s:String):String{
			//TraceAdapter.getNormalTracer()(s);
			var s2:String = s.replace("<", " { ");
			var s3:String = s2.replace(">", "}\n ");
			var s4:String = s3.replace("</", "{");
			TraceAdapter.NormalTracer(s4);
			return s4;
		}
		//////////////////////////// COMMANDS /////////////////////////////////////
		/* pops up a dialog with given title and message */
		public function createDialog(title : String="SOS.createDialog", message : String="Popup!") : void{
			if(!isConnected){
				return;
			}
	
			var command:XML =<commands><showError><title>{title}</title><message>{message}</message></showError></commands>;
			var cmd:String ="<showError><title>{title}</title><message>{message}</message></showError>";
			_csock.send(command.toString());
		}
		/* clears all the output on the console */
		public function clearConsole() : void {
			if(!isConnected){
				return;
			}
	
			_csock.send(clearConsoleCommand);
		}
	
	}
}