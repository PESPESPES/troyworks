package com.troyworks.logging { 
	/**
	* This is a raw interface to SOS for the various API documented here http://sos.powerflasher.de/doc/1-04/
	* Generally the SOSLogger is far more useful for
	* 
	 * @author Troy Gardner (troy@troyworks.com)
	 */
	import flash.events.SecurityErrorEvent;	
	import flash.events.ProgressEvent;	
	//import flash.events.DatCogEventntntnt;	
	import flash.events.Event;	
	import flash.events.IEventDispatcher;	
	import flash.events.IOErrorEvent;
	import flash.net.XMLSocket;
	public class SOS extends Object{
	
		protected static var _csock : XMLSocket;
		protected static var _msock : XMLSocket;
		public var id:int;
		
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
				configureListeners(SOS._csock);
				
				 SOS._csock.addEventListener(Event.CONNECT, connectCommandHandler);
								
				SOS._csock.connect("localhost",4445);
			}else{
				trace("SOS"+id+"BBBBBBBBBBBBBBBBBBBB COMMAND SOCKET ALREADY CONNECTED BBBBBBBBBBBBBBBBBBBBBBBBB");
			
			}
			if(SOS._msock == null){
				trace("SOS" +id+".creatingMessageSocket");
				SOS._msock = new XMLSocket();
				 SOS._msock.addEventListener(Event.CONNECT, connectMessageHandler);
				configureListeners(SOS._msock);
				SOS._msock.connect("localhost",4444);
			}else{
				trace("SOS"+id+"BBBBBBBBBBBBBBBBBBBB MESSAGE SOCKET ALREADY CONNECTED BBBBBBBBBBBBBBBBBBBBBBBBB");				
			
			}
			
			return res;
		}
		
		 private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.CLOSE, closeHandler);
           
        //    dispatcher.addEventListenCogEventventventvent.DATA, dataHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorEvent);
       //     dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        }
		public function get isConnected():Boolean{
			return (_csock != null) && _csock.connected && (_msock != null) && _msock.connected;
		}
        private function closeHandler(event:Event):void {
            trace("closeHandler: " + event);
        }
		
        private function connectCommandHandler(event:Event):void {
            trace("connectCommandHandler: " + event);
        }
		private function connectMessageHandler(event:Event):void {
            trace("connectMessageHandler: " + event);
        }

//        private function dataHandlCogEventgEventgEventgEvent):void {
 //           trace("dataHandler: " + event);
  //      }
        private function progressHandler(event:ProgressEvent):void {
            trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
        }

        private function securityErrorHandler(event:SecurityErrorEvent):void {
            trace("securityErrorHandler: " + event);
        }
		public function onIOErrorEvent(event:IOErrorEvent):void{
			trace("ERROR SOS" + id + "onIOErrorEvent" + event.text + " " + getStatus());
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
			if(!_csock.connected && !_msock.connected){
				return;
			}
			if(sMessage.indexOf("</")>-1){
				///if xml send normal.
				if(_msock.connected){
					_msock.send(sMessage);
				}
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
					if(_csock.connected){						
						_csock.send(res.join(""));
					}
				}else{
				//	trace("normal");
					//////////// Show a normal message /////////////////
					if(_csock.connected){
					_csock.send("<showMessage key='"+key + "'>"+replaceXML(sMessage.toString())+"</showMessage>\n");
					}else{
						trace("can't send to SOS, perhaps not running? "  + sMessage.toString());
					}
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
			if(!_csock.connected && !_msock.connected){
				return;
			}
	
			var command:XML =<commands><showError><title>{title}</title><message>{message}</message></showError></commands>;
			var cmd:String ="<showError><title>{title}</title><message>{message}</message></showError>";
			_csock.send(command.toString());
		}
		/* clears all the output on the console */
		public function clearConsole() : void {
			if(!_csock.connected && !_msock.connected){
				return;
			}
	
			_csock.send(clearConsoleCommand);
		}
	
	}
}