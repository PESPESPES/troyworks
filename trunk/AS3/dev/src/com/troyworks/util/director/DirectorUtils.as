package com.troyworks.util.director { 
	
	import LuminicBox.Log. *;
	import com.troyworks.events.TEventDispatcher;
	import flash.utils.clearInterval;
	import flash.system.fscommand;
	import flash.utils.setInterval;
	import flash.system.System;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import com.troyworks.events.TProxy;
	public class DirectorUtils
	{
		public var addEventListener : Function;
		public var removeEventListener : Function;
		protected var dispatchEvent : Function;
		protected var __cdromDrivePath : Array;
		protected var __fileList : Array;
		protected static var inst : DirectorUtils;
		protected var __listeners : Array;
		protected var __listenerID : Number;
		protected var __dirPath : String;
		protected var __os : String;
		// responder ID is a unique id for requests
		protected var responderIDs : Number = 0;
		protected var responderStore : Object;
		// operating system string
		public var isDirectorShell : Boolean;
		public var log : Logger;
		protected var intV : Number;
		public var sayhi:String ="SAY HI";
		/*
		* Example Usage:
		function onCallBack(res){
		_root.res_txt.text += "recieved res\r\t" + res;
		}
		wheely_mc.onRelease = function() {
		_root.res_txt.text += "testing call to Director";
		DirectorUtils.instance.evalLingoAndCallback("trace('hello world')", onCallBack);
	
	
		//To test first you might use
		getURL('Lingo: trace("PING FROM DIRECTOR UTILS-----------");');
	
		//then
	
		};
		*/
		protected function DirectorUtils ()
		{
			this.init ();
			// test the logger
			this.log = new Logger ("DirectorUtils");
			this.log.addPublisher (new TracePublisher ());
			this.log.addPublisher (new ConsolePublisher ());
			this.log.info ("DirectorUtils start");
		}
		protected function init (void) : void
		{
			TEventDispatcher.initialize (this);
			this.responderStore = new Object ();
			__listeners = new Array ();
			__listenerID = 1;
			//initialize callback handler from things that use
			// DirectorUtils.sendCommand()
			_root.onDirectorEvent = function (sMethod:String, oArgs:Object) : void
			{
				//	_global.log.warn(">onDirectorEvent > " + sMethod + ", " + oArgs );
				//trace(">onDirectorEvent > " + sMethod + ", " + oArgs );
				//for(var i in oArgs){
				//trace("\t" + i + ": " + oArgs[i]);
				//}
				//_root.tDebug.text += "\ronDirectorEvent: " + sMethod + ", data: " + oArgs.data + "\r";
				DirectorUtils.instance [sMethod](oArgs);
				//if(_root.oDFData != null) _root.oDFData = null;
	
			};
			///////////////////////////////
			// this is a callback after something from lingo exectutes something from evalLingoAndCallback()
			// this is a newer way of doing it than the onDirectorEvent which is there because other methods
			// still call it.
			//
			_root.onDirectorCallback = function (callbackId:Object, oArgs:Object) : void
			{
				trace (">onDirectorCallback > " + callbackId + ", " + oArgs );
				DirectorUtils.instance.onDirectorCallback (callbackId, oArgs);
			};
			////////////////////////////////
			// A utility accessible from Director to help encode and decode String passed to it
			var request:URLRequest = new URLRequest(_root.decodeString = function (str : String) : String
						{
							var res = unescape (str);
							//_global.log.warn("decodeString "+ str + " => " + res );
							return res;
						};
						__os = getOSName ();
						this.isDirectorShell = System.capabilities.playerType == "DirectorXtra";
					}
					public function getOSName () : String
					{
						var os : String = System.capabilities.os.toLowerCase ().indexOf ("win") != - 1 ? "win" : "mac";
						if (os == "mac")
						{
							//find first number
							var operSys : String = System.capabilities.os;
							for (var i : Number = 0; i < operSys.length; i ++)
							{
								if ( ! isNaN (parseInt (operSys.substr (i, 1))))
								{
									var majorVersion : Number = Number (operSys.substring (i, operSys.indexOf (".")));
									//sendAlert("majorVersion: " + majorVersion);
									if (majorVersion >= 10)
									{
										// is os x
										os = "mac_osx";
									} else
									{
										os = "mac_os9";
									}
									break;
								}
							}
						}
						return os;
					}
					public function get pathSeparator () : String
					{
						var sSep : String;
						if (__os == "win")
						{
							sSep = "\\";
						} else
						{
							sSep = ":";
						}
						return sSep;
					}
					protected function osFileType (ext : String) : String
					{
						var isWin = (__os == "win");
						// || (__os == "mac_osx");
						var returnStr : String;
						if (isWin)
						{
							return "*." + ext.toLowerCase ();
						} else
						{
							switch (ext.toLowerCase ())
							{
								case "txt" :
								returnStr = "TEXT";
								break;
								case "xml" :
								returnStr = "TEXT";
								break;
								case "jpg" :
								returnStr = "JPEG";
								break;
								case "jpeg" :
								returnStr = "JPEG";
								break;
								case "jpe" :
								returnStr = "JPEG";
								break;
								case "tif" :
								returnStr = "TIFF";
								break;
								default :
								returnStr = "";
							}
							return returnStr;
						}
					}
					protected function cleanUpListener (id : Number) : void
					{
						for (var i = 0; i < __listeners.length; i ++)
						{
							var itm : Object = __listeners [i];
							if (itm.id == id)
							{
								//trace("\tREMOVED LISTENER");
								removeEventListener ("remoteEvent_" + id, itm.data);
								__listeners.splice (i, 1);
								break;
							}
						}
					}
					protected function createListener (resp : Object) : void
					{
						var oDelegate : Object = TProxy.create (resp, resp.onResult);
						addEventListener ("remoteEvent_" + __listenerID, oDelegate);
						__listeners.push (
						{
							id : __listenerID, data : oDelegate
						});
					}
					protected function createResponder (resp : Object) : String
					{
						var nextId = this.responderIDs ++;
						var key = String (nextId);
						this.responderStore [key] = resp;
						trace ("created responder ?" + key + " = " + this.responderStore [key]);
						return key;
					}
					public static function get instance () : DirectorUtils
					{
						if (inst == null) inst = new DirectorUtils ();
						return inst;
					}
					public function formatPath (path : String) : String
					{
						//trace("> FLASH: formatPath(" + path + ") >");
						var sLocal : String = (path.indexOf ("/") != - 1) ? searchReplace (path, "/", "\\") : path;
						if (__os != "win") sLocal = searchReplace (sLocal, "\\", ":");
						return sLocal;
					}
					public function searchReplace (sStr : String, sFind : String, sReplace : String) : String
					{
						return sStr.split (sFind).join (sReplace);
					}
					public function getCDRomDrivePath (resp : Object) : void
					{
						//trace("> FLASH: getCDRomDrivePath > ");
						createListener (resp);
						sendCommand ("lingo: getCDRomDrivePath(\"setCDRomDrivePath\"," + __listenerID + ")");
						__listenerID ++;
					}
					protected function setCDRomDrivePath (oResult : Object) : void
					{
						//trace("> FLASH: setCDRomDrivePath > ");
						//for(var i in oResult){
						///trace("\t" + i + " = " + oResult[i]);
						//}
						__cdromDrivePath = oResult.path;
						dispatchEvent (
						{
							type : "remoteEvent_" + oResult.id, target : this, data : __cdromDrivePath
						});
						cleanUpListener (oResult.id);
					}
					public function getFileList (resp : Object, path : String, filterExt : String) : void
					{
						//trace("> FLASH: getFileList > " + resp + ", " + path + ", " + filterExt);
						createListener (resp);
						path = (path == null) ? "null" : path;
						filterExt = (filterExt == null) ? "null" : filterExt;
						// "*.*" "*.JPG"
						path = formatPath (path);
						sendCommand ("lingo: getFileList(\"setFileList\"," + __listenerID + ",\"" + path + "\",\"" + filterExt + "\")");
						__listenerID ++;
					}
					protected function setFileList (oResult : Object) : void
					{
						//trace("> FLASH: setFileList > ");
						//trace("\toResult.id: " + oResult.id);
						//trace("\toResult.files: " + oResult.files);
						__fileList = oResult.fileList;
						__dirPath = oResult.dirPath;
						dispatchEvent (
						{
							type : "remoteEvent_" + oResult.id, target : this, data : oResult
						});
						cleanUpListener (oResult.id);
					}
					public function fileExists (resp : Object, path : String, fileName : String) : void
					{
						//trace("> FLASH: fileExists > " + path + ", " + fileName);
						createListener (resp);
						path = (path == null) ? "null" : path;
						fileName = (fileName == null) ? "null" : fileName;
						path = formatPath (path);
						sendCommand ("lingo: fileExists(\"setFileExists\"," + __listenerID + ",\"" + path + "\",\"" + fileName + "\")");
						__listenerID ++;
					}
					protected function setFileExists (oResult : Object) : void
					{
						//trace("> FLASH: setFileExists > ");
						//trace("\toResult.id: " + oResult.id);
						//trace("\toResult.fileExists: " + oResult.fileExists);
						var fileExists : Boolean = (oResult.fileExists == 1);
						dispatchEvent (
						{
							type : "remoteEvent_" + oResult.id, target : this, data : fileExists
						});
						cleanUpListener (oResult.id);
					}
					public function fileWrite (resp : Object, path : String, fName : String, fContent : String) : void
					{
						//trace("> FLASH: fileWrite > " );
						createListener (resp);
						sendCommand ("lingo: fileWrite(\"setFileWrite\"," + __listenerID + ",\"" + formatPath (path) + "\",\"" + fName + "\",\"" + fContent + "\")");
						__listenerID ++;
					}
					protected function setFileWrite (oResult : Object) : void
					{
						//trace("> FLASH: setFileExists > ");
						//trace("\toResult.id: " + oResult.id);
						//trace("\toResult.result: " + oResult.result);
						/* oResult.result RETURNS:
						0 OK
						3 Can't create file
						4 Can't write file
						5 Can't create folder
						9 Unknown error
						*/
						dispatchEvent (
						{
							type : "remoteEvent_" + oResult.id, target : this, data : oResult.result
						});
						cleanUpListener (oResult.id);
					}
					public function fileCopy (resp : Object, sourcePath : String, sourceFileName : String, destPath : String, destFileName : String, overWrite : String) : void
					{
						//trace("> FLASH: fileCopy > " );
						createListener (resp);
						/*
						overWrite determines how the copy is done. Can be:
						"Always" always copies the file
						"IfNewer" copies the file if SourceFile is newer than DestFile
						"IfNotExist" copies only if DestFile does not already exist
						*/
						sendCommand ("lingo: fileCopy(\"setFileCopy\"," + __listenerID + ",\"" + formatPath (sourcePath) + "\",\"" + sourceFileName + "\",\"" + formatPath (destPath) + "\",\"" + destFileName + "\",\"" + overWrite + "\")");
						__listenerID ++;
					}
					protected function setFileCopy (oResult : Object) : void
					{
						//trace("> FLASH: setFileExists > ");
						//trace("\toResult.id: " + oResult.id);
						//trace("\toResult.result: " + oResult.result);
						/* oResult.result:
						Returns 0 if the file was copied successfully, otherwise one of these:
						1 Invalid Source file name
						2 Invalid Dest file name
						3 Error reading the Source file
						4 Error writing the Dest file
						5 Couldn't create directory for Dest file
						6 Dest file exists
						7 Dest file is newer that Source file
						*/
						dispatchEvent (
						{
							type : "remoteEvent_" + oResult.id, target : this, data : oResult.result
						});
						cleanUpListener (oResult.id);
					}
					public function showFileDialog (resp : Object, op : String, startDir : String, fileName : String, filterType : String, flags : Array, instr : String, noFolders : Number, x : Number, y : Number) : void
					{
						//trace("> FLASH: showOpenFileDialog > ");
						createListener (resp);
						var isWin : Boolean = __os == "win";
						//process file types for OS
						var osFilterType = "";
						if (filterType != "" && __os != "mac_osx")
						{
							var aExt : Array = filterType.substr (filterType.indexOf ("|") + 1).split (";");
							//trace("aExt = " + aExt);
							var fileExt : String = "";
							var delimiter : String = isWin ? ";" : "|";
							for (var i : Number = 0; i < aExt.length; i ++)
							{
								var ext : String = aExt [i];
								fileExt += (i == 0 ? "" : delimiter ) + osFileType (ext);
							}
							//trace("fileExt = " + fileExt);
							if (isWin)
							{
								osFilterType += filterType.substring (0, filterType.indexOf ("|") + 1 ) + fileExt;
							} else
							{
								osFilterType += fileExt;
							}
						} else
						{
							osFilterType = "";
						}
						/*
						//process flags for OS
						for(var i:Number = 0; i < flags.length; i++){
						if((flags[i] == 524288 || flags[i] == 512 ) && !isWin){
						//remove 32-bit navigation support for Mac OS
						flags.splice(i, 1);
						}
						}
						*/
						//trace("flags = " + flags);
						// add flags in array
						var nFlags : Number = 0;
						for (var i : Number = 0; i < flags.length; i ++)
						{
							nFlags += flags [i];
						}
						//trace("nFlags = " + nFlags);
						//sendAlert("osFilterType: " + osFilterType);
						sendCommand ("lingo: getFilePath(\"setFilePath\"," + __listenerID + ", \"" + op + "\", \"" + startDir + "\", \"" + fileName + "\", \"" + osFilterType + "\", " + nFlags + ", \"" + instr + "\", " + noFolders + ", " + x + ", " + y + ")");
						__listenerID ++;
					}
					protected function setFilePath (oResult : Object) : void
					{
						//trace("> FLASH: setFilePath >");
						dispatchEvent (
						{
							type : "remoteEvent_" + oResult.id, target : this, data : oResult.filePath
						});
						cleanUpListener (oResult.id);
					}
					public function notifyPrint (resp : Object, isPrinting : Boolean) : void
					{
						//trace("> FLASH: notifyPrint > ");
						createListener (resp);
						var nPrinting : Number = isPrinting ? 1 : 0;
						sendCommand ("lingo: notifyPrint(\"notifyPrintCallBack\"," + __listenerID + ", " + nPrinting + ")");
						__listenerID ++;
					}
					protected function notifyPrintCallBack (oResult : Object) : void
					{
						//trace("> FLASH: notifyPrintCallBack >");
						dispatchEvent (
						{
							type : "remoteEvent_" + oResult.id, target : this, data : oResult
						});
						cleanUpListener (oResult.id);
					}
					public function openURL (resp : Object, sLoc : String, sMode : String) : void
					{
						trace ("> FLASH: openURL > " + sLoc);
						if (this.isDirectorShell)
						{
							createListener (resp);
							if (sMode == undefined) sMode = "";
							sendCommand ("lingo: openURL(\"openURLCallBack\"," + __listenerID + ",\"" + sLoc + "\",\"" + sMode + "\")");
							__listenerID ++;
						} else
						{
							getURL (sLoc, sMode);
							resp.onResult ();
						}
					}
					protected function openURLCallBack (oResult : Object) : void
					{
						//trace("> FLASH: openURLCallBack >");
						dispatchEvent (
						{
							type : "remoteEvent_" + oResult.id, target : this, data : oResult.data
						});
						cleanUpListener (oResult.id);
					}
					public function openFile (resp : Object, sLoc : String, sMode : String) : void
					{
						//trace("> FLASH: openFile > ");
						createListener (resp);
						if (sMode == undefined) sMode = "";
						sendCommand ("lingo: openFile(\"openFileCallBack\"," + __listenerID + ",\"" + sLoc + "\",\"" + sMode + "\")");
						__listenerID ++;
					}
					protected function openFileCallBack (oResult : Object) : void
					{
						//trace("> FLASH: openFileCallBack >");
						dispatchEvent (
						{
							type : "remoteEvent_" + oResult.id, target : this, data : oResult.data
						});
						cleanUpListener (oResult.id);
					}
					public function getPathSeparator (resp : Object) : void
					{
						//trace("> FLASH: getPathSeparator > ");
						createListener (resp);
						var sSep : String;
						if (__os == "win")
						{
							sSep = "\\";
						} else
						{
							sSep = ":";
						}
						getPathSeparatorCallBack (
						{
							data : sSep, id : __listenerID
						});
						__listenerID ++;
					}
					protected function getPathSeparatorCallBack (oResult : Object) : void
					{
						//trace("> FLASH: getPathSeparatorCallBack >");
						dispatchEvent (
						{
							type : "remoteEvent_" + oResult.id, target : this, data : oResult.data
						});
						cleanUpListener (oResult.id);
					}
					public function getExePath (resp : Object) : void
					{
						//trace("> FLASH: getExePath >");
						createListener (resp);
						sendCommand ("lingo: getDirectorPath(\"getExePathCallBack\"," + __listenerID + ")");
						__listenerID ++;
					}
					protected function getExePathCallBack (oResult : Object) : void
					{
						//trace("> FLASH: getExePathCallBack >");
						//_root.tDebug.text += "\rfrom UTILS: getExePathCallBack:\r\toResult.dirPath: " + oResult.dirPath + "\r\toResult.id: " + oResult.id +"\r";
						//sendAlert("dirPath: " + oResult.dirPath);
						dispatchEvent (
						{
							type : "remoteEvent_" + oResult.id, target : this, data : oResult.dirPath
						});
						cleanUpListener (oResult.id);
					}
					public function createAssets (resp : Object, sAsset : String, sSave : String, sFilePrefix : String) : void
					{
						//trace("> FLASH: createAssets >");
						createListener (resp);
						sendCommand ("lingo: createAssets(\"createAssetsCallBack\"," + __listenerID + ",\"" + sAsset + "\",\"" + sSave + "\",\"" + sFilePrefix + "\")");
						__listenerID ++;
					}
					protected function createAssetsCallBack (oResult : Object) : void
					{
						//trace("> FLASH: createAssetsCallBack >");
						dispatchEvent (
						{
							type : "remoteEvent_" + oResult.id, target : this, data : oResult.fileData
						});
						cleanUpListener (oResult.id);
					}
					public function setImageSizes (resp : Object, nWidthFull : Number, nHeightFull : Number, nWidthThumb : Number, nHeightThumb : Number) : void
					{
						//trace("> FLASH: setImageSizes >");
						createListener (resp);
						sendCommand ("lingo: setImageSizes(\"setImageSizesCallBack\"," + __listenerID + "," + nWidthFull + "," + nHeightFull + "," + nWidthThumb + "," + nHeightThumb + ")");
						__listenerID ++;
					}
					protected function setImageSizesCallBack (oResult : Object) : void
					{
						//trace("> FLASH: setImageSizesCallBack >");
						dispatchEvent (
						{
							type : "remoteEvent_" + oResult.id, target : this, data : oResult.result
						});
						cleanUpListener (oResult.id);
					}
					public function sendAlert (sMsg : String) : void
					{
						sendCommand ("lingo:_player.alert(\"" + sMsg + "\")");
					}
					public function quit (showMessage:Boolean) : void
					{
						if (isDirectorShell)
						{
							sendCommand ("lingo: quit()");
						} else
						{
							//Running in the Flash Projector.
							fscommand ("quit", "");
						}
					}
					/////////////////////////////////
					//  Call lingo directly provided
					// we are in the shell.
					protected function sendCommand (lingoCmdString : String) : void
					{
						if (System.capabilities.playerType == "DirectorXtra")
						{
							getURL (lingoCmdString);
						} else
						{
							trace ("Lingo: " + lingoCmdString);
						}
					}
					public function testGateway () : void {
						trace ("\r\rtesting gateway");
						//getURL('Lingo: trace("PING FROM DIRECTOR UTILS22-----------");');
						// getURL('Lingo: alert("PING FROM DIRECTOR UTILS33-----------");');
						//getURL('Lingo: ping("fromPing");');
						// this.evalLingoAndCallback('trace("hellotest")', null);
				
					}
					/////////////////////////////////////////////////////////////////////////////
					// this is similar to the evalLingoAndCallback but utilizes the older lingo style inside director
					// and uses pass by reference instead of string+ getURL manipulation.
					public function evalLingoAndCallback2 (lingoCmdString : String, callBack : Object) : void
					{
						var callbackId = this.createResponder (callBack);
						this.log.info ("DIrectorUtil.evalLingoAndCallback2('" + lingoCmdString + "')");
						//	getURL('Lingo: trace("PING FROM DIRECTOR UTILS2-----------" + ping("fromPing"));');
						if (System.capabilities.playerType == "DirectorXtra")
						{
							trace ("Flash.calling Director");
							_root.directorUtilStatement = lingoCmdString;
							//'ping(" Hello World");';
							_root.directorUtilStatementResult = null;
							_root.directorUtilStatementCallbackID = callbackId;
							var sCmd = 'Lingo: evalLingoAndCallback2()';
							getURL (sCmd);
				
						} else
						{
							trace ("Lingo: " + lingoCmdString);
							//emulate callback
							this.intV = setInterval (this, "onDirectorCallback", 1000, callbackId, "DummyCallback");
						}
					}
					/////////////////////////////////////////////////////////////////////////////
					// this is similar to sendCommand, but uses a different callback metaphor
					// ends up calling _root.onDirectorCallback() which calls DirectorUtils.onDirectorCallback();
					public function evalLingoAndCallback (lingoCmdString : String, callBack : Object) : void
					{
						var callbackId = this.createResponder (callBack);
						var sCmd = 'Lingo: evalLingoAndCallback2( "' + escape (lingoCmdString) + '",' + callbackId + ')';
						this.log.info ("DIrectorUtil.evalLingoAndCallback('" + sCmd + "')");
						//	getURL('Lingo: trace("PING FROM DIRECTOR UTILS2-----------" + ping("fromPing"));');
						if (System.capabilities.playerType == "DirectorXtra")
						{
							trace ("Flash.calling Director");
							getURL (sCmd);
						} else
						{
							trace ("Lingo: " + sCmd);
							//emulate callback
							this.intV = setInterval (this, "onDirectorCallback", 1000, callbackId, "DummyCallback");
						}
					}
					//////////////////////////////////////////////////////////////////////////////
					// this is routed by a _root.onDirectorCallback created in the constructor
					// as Director can't easily get the Singleton instance
					public function onDirectorCallback (callbackId : String, oArgs : Object) : void
					{
						clearInterval (intV);
						_global.log.warn ("onDirectorCallback " + callbackId, oArgs );
						this.responderStore [callbackId](oArgs);
						delete (this.responderStore [callbackId]);
					}
				});
			navigateToURL(request);
			
			{
				var res = unescape (str);
				//_global.log.warn("decodeString "+ str + " => " + res );
				return res;
			};
			__os = getOSName ();
			this.isDirectorShell = System.capabilities.playerType == "DirectorXtra";
		}
		public function getOSName () : String
		{
			var os : String = System.capabilities.os.toLowerCase ().indexOf ("win") != - 1 ? "win" : "mac";
			if (os == "mac")
			{
				//find first number
				var operSys : String = System.capabilities.os;
				for (var i : Number = 0; i < operSys.length; i ++)
				{
					if ( ! isNaN (parseInt (operSys.substr (i, 1))))
					{
						var majorVersion : Number = Number (operSys.substring (i, operSys.indexOf (".")));
						//sendAlert("majorVersion: " + majorVersion);
						if (majorVersion >= 10)
						{
							// is os x
							os = "mac_osx";
						} else
						{
							os = "mac_os9";
						}
						break;
					}
				}
			}
			return os;
		}
		public function get pathSeparator () : String
		{
			var sSep : String;
			if (__os == "win")
			{
				sSep = "\\";
			} else
			{
				sSep = ":";
			}
			return sSep;
		}
		protected function osFileType (ext : String) : String
		{
			var isWin = (__os == "win");
			// || (__os == "mac_osx");
			var returnStr : String;
			if (isWin)
			{
				return "*." + ext.toLowerCase ();
			} else
			{
				switch (ext.toLowerCase ())
				{
					case "txt" :
					returnStr = "TEXT";
					break;
					case "xml" :
					returnStr = "TEXT";
					break;
					case "jpg" :
					returnStr = "JPEG";
					break;
					case "jpeg" :
					returnStr = "JPEG";
					break;
					case "jpe" :
					returnStr = "JPEG";
					break;
					case "tif" :
					returnStr = "TIFF";
					break;
					default :
					returnStr = "";
				}
				return returnStr;
			}
		}
		protected function cleanUpListener (id : Number) : void
		{
			for (var i = 0; i < __listeners.length; i ++)
			{
				var itm : Object = __listeners [i];
				if (itm.id == id)
				{
					//trace("\tREMOVED LISTENER");
					removeEventListener ("remoteEvent_" + id, itm.data);
					__listeners.splice (i, 1);
					break;
				}
			}
		}
		protected function createListener (resp : Object) : void
		{
			var oDelegate : Object = TProxy.create (resp, resp.onResult);
			addEventListener ("remoteEvent_" + __listenerID, oDelegate);
			__listeners.push (
			{
				id : __listenerID, data : oDelegate
			});
		}
		protected function createResponder (resp : Object) : String
		{
			var nextId = this.responderIDs ++;
			var key = String (nextId);
			this.responderStore [key] = resp;
			trace ("created responder ?" + key + " = " + this.responderStore [key]);
			return key;
		}
		public static function get instance () : DirectorUtils
		{
			if (inst == null) inst = new DirectorUtils ();
			return inst;
		}
		public function formatPath (path : String) : String
		{
			//trace("> FLASH: formatPath(" + path + ") >");
			var sLocal : String = (path.indexOf ("/") != - 1) ? searchReplace (path, "/", "\\") : path;
			if (__os != "win") sLocal = searchReplace (sLocal, "\\", ":");
			return sLocal;
		}
		public function searchReplace (sStr : String, sFind : String, sReplace : String) : String
		{
			return sStr.split (sFind).join (sReplace);
		}
		public function getCDRomDrivePath (resp : Object) : void
		{
			//trace("> FLASH: getCDRomDrivePath > ");
			createListener (resp);
			sendCommand ("lingo: getCDRomDrivePath(\"setCDRomDrivePath\"," + __listenerID + ")");
			__listenerID ++;
		}
		protected function setCDRomDrivePath (oResult : Object) : void
		{
			//trace("> FLASH: setCDRomDrivePath > ");
			//for(var i in oResult){
			///trace("\t" + i + " = " + oResult[i]);
			//}
			__cdromDrivePath = oResult.path;
			dispatchEvent (
			{
				type : "remoteEvent_" + oResult.id, target : this, data : __cdromDrivePath
			});
			cleanUpListener (oResult.id);
		}
		public function getFileList (resp : Object, path : String, filterExt : String) : void
		{
			//trace("> FLASH: getFileList > " + resp + ", " + path + ", " + filterExt);
			createListener (resp);
			path = (path == null) ? "null" : path;
			filterExt = (filterExt == null) ? "null" : filterExt;
			// "*.*" "*.JPG"
			path = formatPath (path);
			sendCommand ("lingo: getFileList(\"setFileList\"," + __listenerID + ",\"" + path + "\",\"" + filterExt + "\")");
			__listenerID ++;
		}
		protected function setFileList (oResult : Object) : void
		{
			//trace("> FLASH: setFileList > ");
			//trace("\toResult.id: " + oResult.id);
			//trace("\toResult.files: " + oResult.files);
			__fileList = oResult.fileList;
			__dirPath = oResult.dirPath;
			dispatchEvent (
			{
				type : "remoteEvent_" + oResult.id, target : this, data : oResult
			});
			cleanUpListener (oResult.id);
		}
		public function fileExists (resp : Object, path : String, fileName : String) : void
		{
			//trace("> FLASH: fileExists > " + path + ", " + fileName);
			createListener (resp);
			path = (path == null) ? "null" : path;
			fileName = (fileName == null) ? "null" : fileName;
			path = formatPath (path);
			sendCommand ("lingo: fileExists(\"setFileExists\"," + __listenerID + ",\"" + path + "\",\"" + fileName + "\")");
			__listenerID ++;
		}
		protected function setFileExists (oResult : Object) : void
		{
			//trace("> FLASH: setFileExists > ");
			//trace("\toResult.id: " + oResult.id);
			//trace("\toResult.fileExists: " + oResult.fileExists);
			var fileExists : Boolean = (oResult.fileExists == 1);
			dispatchEvent (
			{
				type : "remoteEvent_" + oResult.id, target : this, data : fileExists
			});
			cleanUpListener (oResult.id);
		}
		public function fileWrite (resp : Object, path : String, fName : String, fContent : String) : void
		{
			//trace("> FLASH: fileWrite > " );
			createListener (resp);
			sendCommand ("lingo: fileWrite(\"setFileWrite\"," + __listenerID + ",\"" + formatPath (path) + "\",\"" + fName + "\",\"" + fContent + "\")");
			__listenerID ++;
		}
		protected function setFileWrite (oResult : Object) : void
		{
			//trace("> FLASH: setFileExists > ");
			//trace("\toResult.id: " + oResult.id);
			//trace("\toResult.result: " + oResult.result);
			/* oResult.result RETURNS:
			0 OK
			3 Can't create file
			4 Can't write file
			5 Can't create folder
			9 Unknown error
			*/
			dispatchEvent (
			{
				type : "remoteEvent_" + oResult.id, target : this, data : oResult.result
			});
			cleanUpListener (oResult.id);
		}
		public function fileCopy (resp : Object, sourcePath : String, sourceFileName : String, destPath : String, destFileName : String, overWrite : String) : void
		{
			//trace("> FLASH: fileCopy > " );
			createListener (resp);
			/*
			overWrite determines how the copy is done. Can be:
			"Always" always copies the file
			"IfNewer" copies the file if SourceFile is newer than DestFile
			"IfNotExist" copies only if DestFile does not already exist
			*/
			sendCommand ("lingo: fileCopy(\"setFileCopy\"," + __listenerID + ",\"" + formatPath (sourcePath) + "\",\"" + sourceFileName + "\",\"" + formatPath (destPath) + "\",\"" + destFileName + "\",\"" + overWrite + "\")");
			__listenerID ++;
		}
		protected function setFileCopy (oResult : Object) : void
		{
			//trace("> FLASH: setFileExists > ");
			//trace("\toResult.id: " + oResult.id);
			//trace("\toResult.result: " + oResult.result);
			/* oResult.result:
			Returns 0 if the file was copied successfully, otherwise one of these:
			1 Invalid Source file name
			2 Invalid Dest file name
			3 Error reading the Source file
			4 Error writing the Dest file
			5 Couldn't create directory for Dest file
			6 Dest file exists
			7 Dest file is newer that Source file
			*/
			dispatchEvent (
			{
				type : "remoteEvent_" + oResult.id, target : this, data : oResult.result
			});
			cleanUpListener (oResult.id);
		}
		public function showFileDialog (resp : Object, op : String, startDir : String, fileName : String, filterType : String, flags : Array, instr : String, noFolders : Number, x : Number, y : Number) : void
		{
			//trace("> FLASH: showOpenFileDialog > ");
			createListener (resp);
			var isWin : Boolean = __os == "win";
			//process file types for OS
			var osFilterType = "";
			if (filterType != "" && __os != "mac_osx")
			{
				var aExt : Array = filterType.substr (filterType.indexOf ("|") + 1).split (";");
				//trace("aExt = " + aExt);
				var fileExt : String = "";
				var delimiter : String = isWin ? ";" : "|";
				for (var i : Number = 0; i < aExt.length; i ++)
				{
					var ext : String = aExt [i];
					fileExt += (i == 0 ? "" : delimiter ) + osFileType (ext);
				}
				//trace("fileExt = " + fileExt);
				if (isWin)
				{
					osFilterType += filterType.substring (0, filterType.indexOf ("|") + 1 ) + fileExt;
				} else
				{
					osFilterType += fileExt;
				}
			} else
			{
				osFilterType = "";
			}
			/*
			//process flags for OS
			for(var i:Number = 0; i < flags.length; i++){
			if((flags[i] == 524288 || flags[i] == 512 ) && !isWin){
			//remove 32-bit navigation support for Mac OS
			flags.splice(i, 1);
			}
			}
			*/
			//trace("flags = " + flags);
			// add flags in array
			var nFlags : Number = 0;
			for (var i : Number = 0; i < flags.length; i ++)
			{
				nFlags += flags [i];
			}
			//trace("nFlags = " + nFlags);
			//sendAlert("osFilterType: " + osFilterType);
			sendCommand ("lingo: getFilePath(\"setFilePath\"," + __listenerID + ", \"" + op + "\", \"" + startDir + "\", \"" + fileName + "\", \"" + osFilterType + "\", " + nFlags + ", \"" + instr + "\", " + noFolders + ", " + x + ", " + y + ")");
			__listenerID ++;
		}
		protected function setFilePath (oResult : Object) : void
		{
			//trace("> FLASH: setFilePath >");
			dispatchEvent (
			{
				type : "remoteEvent_" + oResult.id, target : this, data : oResult.filePath
			});
			cleanUpListener (oResult.id);
		}
		public function notifyPrint (resp : Object, isPrinting : Boolean) : void
		{
			//trace("> FLASH: notifyPrint > ");
			createListener (resp);
			var nPrinting : Number = isPrinting ? 1 : 0;
			sendCommand ("lingo: notifyPrint(\"notifyPrintCallBack\"," + __listenerID + ", " + nPrinting + ")");
			__listenerID ++;
		}
		protected function notifyPrintCallBack (oResult : Object) : void
		{
			//trace("> FLASH: notifyPrintCallBack >");
			dispatchEvent (
			{
				type : "remoteEvent_" + oResult.id, target : this, data : oResult
			});
			cleanUpListener (oResult.id);
		}
		public function openURL (resp : Object, sLoc : String, sMode : String) : void
		{
			trace ("> FLASH: openURL > " + sLoc);
			if (this.isDirectorShell)
			{
				createListener (resp);
				if (sMode == undefined) sMode = "";
				sendCommand ("lingo: openURL(\"openURLCallBack\"," + __listenerID + ",\"" + sLoc + "\",\"" + sMode + "\")");
				__listenerID ++;
			} else
			{
				var request:URLRequest = new URLRequest((sLoc, sMode);
								resp.onResult ();
							}
						}
						protected function openURLCallBack (oResult : Object) : void
						{
							//trace("> FLASH: openURLCallBack >");
							dispatchEvent (
							{
								type : "remoteEvent_" + oResult.id, target : this, data : oResult.data
							});
							cleanUpListener (oResult.id);
						}
						public function openFile (resp : Object, sLoc : String, sMode : String) : void
						{
							//trace("> FLASH: openFile > ");
							createListener (resp);
							if (sMode == undefined) sMode = "";
							sendCommand ("lingo: openFile(\"openFileCallBack\"," + __listenerID + ",\"" + sLoc + "\",\"" + sMode + "\")");
							__listenerID ++;
						}
						protected function openFileCallBack (oResult : Object) : void
						{
							//trace("> FLASH: openFileCallBack >");
							dispatchEvent (
							{
								type : "remoteEvent_" + oResult.id, target : this, data : oResult.data
							});
							cleanUpListener (oResult.id);
						}
						public function getPathSeparator (resp : Object) : void
						{
							//trace("> FLASH: getPathSeparator > ");
							createListener (resp);
							var sSep : String;
							if (__os == "win")
							{
								sSep = "\\";
							} else
							{
								sSep = ":";
							}
							getPathSeparatorCallBack (
							{
								data : sSep, id : __listenerID
							});
							__listenerID ++;
						}
						protected function getPathSeparatorCallBack (oResult : Object) : void
						{
							//trace("> FLASH: getPathSeparatorCallBack >");
							dispatchEvent (
							{
								type : "remoteEvent_" + oResult.id, target : this, data : oResult.data
							});
							cleanUpListener (oResult.id);
						}
						public function getExePath (resp : Object) : void
						{
							//trace("> FLASH: getExePath >");
							createListener (resp);
							sendCommand ("lingo: getDirectorPath(\"getExePathCallBack\"," + __listenerID + ")");
							__listenerID ++;
						}
						protected function getExePathCallBack (oResult : Object) : void
						{
							//trace("> FLASH: getExePathCallBack >");
							//_root.tDebug.text += "\rfrom UTILS: getExePathCallBack:\r\toResult.dirPath: " + oResult.dirPath + "\r\toResult.id: " + oResult.id +"\r";
							//sendAlert("dirPath: " + oResult.dirPath);
							dispatchEvent (
							{
								type : "remoteEvent_" + oResult.id, target : this, data : oResult.dirPath
							});
							cleanUpListener (oResult.id);
						}
						public function createAssets (resp : Object, sAsset : String, sSave : String, sFilePrefix : String) : void
						{
							//trace("> FLASH: createAssets >");
							createListener (resp);
							sendCommand ("lingo: createAssets(\"createAssetsCallBack\"," + __listenerID + ",\"" + sAsset + "\",\"" + sSave + "\",\"" + sFilePrefix + "\")");
							__listenerID ++;
						}
						protected function createAssetsCallBack (oResult : Object) : void
						{
							//trace("> FLASH: createAssetsCallBack >");
							dispatchEvent (
							{
								type : "remoteEvent_" + oResult.id, target : this, data : oResult.fileData
							});
							cleanUpListener (oResult.id);
						}
						public function setImageSizes (resp : Object, nWidthFull : Number, nHeightFull : Number, nWidthThumb : Number, nHeightThumb : Number) : void
						{
							//trace("> FLASH: setImageSizes >");
							createListener (resp);
							sendCommand ("lingo: setImageSizes(\"setImageSizesCallBack\"," + __listenerID + "," + nWidthFull + "," + nHeightFull + "," + nWidthThumb + "," + nHeightThumb + ")");
							__listenerID ++;
						}
						protected function setImageSizesCallBack (oResult : Object) : void
						{
							//trace("> FLASH: setImageSizesCallBack >");
							dispatchEvent (
							{
								type : "remoteEvent_" + oResult.id, target : this, data : oResult.result
							});
							cleanUpListener (oResult.id);
						}
						public function sendAlert (sMsg : String) : void
						{
							sendCommand ("lingo:_player.alert(\"" + sMsg + "\")");
						}
						public function quit (showMessage:Boolean) : void
						{
							if (isDirectorShell)
							{
								sendCommand ("lingo: quit()");
							} else
							{
								//Running in the Flash Projector.
								fscommand ("quit", "");
							}
						}
						/////////////////////////////////
						//  Call lingo directly provided
						// we are in the shell.
						protected function sendCommand (lingoCmdString : String) : void
						{
							if (System.capabilities.playerType == "DirectorXtra")
							{
								getURL (lingoCmdString);
							} else
							{
								trace ("Lingo: " + lingoCmdString);
							}
						}
						public function testGateway () : void {
							trace ("\r\rtesting gateway");
							//getURL('Lingo: trace("PING FROM DIRECTOR UTILS22-----------");');
							// getURL('Lingo: alert("PING FROM DIRECTOR UTILS33-----------");');
							//getURL('Lingo: ping("fromPing");');
							// this.evalLingoAndCallback('trace("hellotest")', null);
					
						}
						/////////////////////////////////////////////////////////////////////////////
						// this is similar to the evalLingoAndCallback but utilizes the older lingo style inside director
						// and uses pass by reference instead of string+ getURL manipulation.
						public function evalLingoAndCallback2 (lingoCmdString : String, callBack : Object) : void
						{
							var callbackId = this.createResponder (callBack);
							this.log.info ("DIrectorUtil.evalLingoAndCallback2('" + lingoCmdString + "')");
							//	getURL('Lingo: trace("PING FROM DIRECTOR UTILS2-----------" + ping("fromPing"));');
							if (System.capabilities.playerType == "DirectorXtra")
							{
								trace ("Flash.calling Director");
								_root.directorUtilStatement = lingoCmdString;
								//'ping(" Hello World");';
								_root.directorUtilStatementResult = null;
								_root.directorUtilStatementCallbackID = callbackId;
								var sCmd = 'Lingo: evalLingoAndCallback2()';
								getURL (sCmd);
					
							} else
							{
								trace ("Lingo: " + lingoCmdString);
								//emulate callback
								this.intV = setInterval (this, "onDirectorCallback", 1000, callbackId, "DummyCallback");
							}
						}
						/////////////////////////////////////////////////////////////////////////////
						// this is similar to sendCommand, but uses a different callback metaphor
						// ends up calling _root.onDirectorCallback() which calls DirectorUtils.onDirectorCallback();
						public function evalLingoAndCallback (lingoCmdString : String, callBack : Object) : void
						{
							var callbackId = this.createResponder (callBack);
							var sCmd = 'Lingo: evalLingoAndCallback2( "' + escape (lingoCmdString) + '",' + callbackId + ')';
							this.log.info ("DIrectorUtil.evalLingoAndCallback('" + sCmd + "')");
							//	getURL('Lingo: trace("PING FROM DIRECTOR UTILS2-----------" + ping("fromPing"));');
							if (System.capabilities.playerType == "DirectorXtra")
							{
								trace ("Flash.calling Director");
								getURL (sCmd);
							} else
							{
								trace ("Lingo: " + sCmd);
								//emulate callback
								this.intV = setInterval (this, "onDirectorCallback", 1000, callbackId, "DummyCallback");
							}
						}
						//////////////////////////////////////////////////////////////////////////////
						// this is routed by a _root.onDirectorCallback created in the constructor
						// as Director can't easily get the Singleton instance
						public function onDirectorCallback (callbackId : String, oArgs : Object) : void
						{
							clearInterval (intV);
							_global.log.warn ("onDirectorCallback " + callbackId, oArgs );
							this.responderStore [callbackId](oArgs);
							delete (this.responderStore [callbackId]);
						}
					});
				navigateToURL(request);
				
				resp.onResult ();
			}
		}
		protected function openURLCallBack (oResult : Object) : void
		{
			//trace("> FLASH: openURLCallBack >");
			dispatchEvent (
			{
				type : "remoteEvent_" + oResult.id, target : this, data : oResult.data
			});
			cleanUpListener (oResult.id);
		}
		public function openFile (resp : Object, sLoc : String, sMode : String) : void
		{
			//trace("> FLASH: openFile > ");
			createListener (resp);
			if (sMode == undefined) sMode = "";
			sendCommand ("lingo: openFile(\"openFileCallBack\"," + __listenerID + ",\"" + sLoc + "\",\"" + sMode + "\")");
			__listenerID ++;
		}
		protected function openFileCallBack (oResult : Object) : void
		{
			//trace("> FLASH: openFileCallBack >");
			dispatchEvent (
			{
				type : "remoteEvent_" + oResult.id, target : this, data : oResult.data
			});
			cleanUpListener (oResult.id);
		}
		public function getPathSeparator (resp : Object) : void
		{
			//trace("> FLASH: getPathSeparator > ");
			createListener (resp);
			var sSep : String;
			if (__os == "win")
			{
				sSep = "\\";
			} else
			{
				sSep = ":";
			}
			getPathSeparatorCallBack (
			{
				data : sSep, id : __listenerID
			});
			__listenerID ++;
		}
		protected function getPathSeparatorCallBack (oResult : Object) : void
		{
			//trace("> FLASH: getPathSeparatorCallBack >");
			dispatchEvent (
			{
				type : "remoteEvent_" + oResult.id, target : this, data : oResult.data
			});
			cleanUpListener (oResult.id);
		}
		public function getExePath (resp : Object) : void
		{
			//trace("> FLASH: getExePath >");
			createListener (resp);
			sendCommand ("lingo: getDirectorPath(\"getExePathCallBack\"," + __listenerID + ")");
			__listenerID ++;
		}
		protected function getExePathCallBack (oResult : Object) : void
		{
			//trace("> FLASH: getExePathCallBack >");
			//_root.tDebug.text += "\rfrom UTILS: getExePathCallBack:\r\toResult.dirPath: " + oResult.dirPath + "\r\toResult.id: " + oResult.id +"\r";
			//sendAlert("dirPath: " + oResult.dirPath);
			dispatchEvent (
			{
				type : "remoteEvent_" + oResult.id, target : this, data : oResult.dirPath
			});
			cleanUpListener (oResult.id);
		}
		public function createAssets (resp : Object, sAsset : String, sSave : String, sFilePrefix : String) : void
		{
			//trace("> FLASH: createAssets >");
			createListener (resp);
			sendCommand ("lingo: createAssets(\"createAssetsCallBack\"," + __listenerID + ",\"" + sAsset + "\",\"" + sSave + "\",\"" + sFilePrefix + "\")");
			__listenerID ++;
		}
		protected function createAssetsCallBack (oResult : Object) : void
		{
			//trace("> FLASH: createAssetsCallBack >");
			dispatchEvent (
			{
				type : "remoteEvent_" + oResult.id, target : this, data : oResult.fileData
			});
			cleanUpListener (oResult.id);
		}
		public function setImageSizes (resp : Object, nWidthFull : Number, nHeightFull : Number, nWidthThumb : Number, nHeightThumb : Number) : void
		{
			//trace("> FLASH: setImageSizes >");
			createListener (resp);
			sendCommand ("lingo: setImageSizes(\"setImageSizesCallBack\"," + __listenerID + "," + nWidthFull + "," + nHeightFull + "," + nWidthThumb + "," + nHeightThumb + ")");
			__listenerID ++;
		}
		protected function setImageSizesCallBack (oResult : Object) : void
		{
			//trace("> FLASH: setImageSizesCallBack >");
			dispatchEvent (
			{
				type : "remoteEvent_" + oResult.id, target : this, data : oResult.result
			});
			cleanUpListener (oResult.id);
		}
		public function sendAlert (sMsg : String) : void
		{
			sendCommand ("lingo:_player.alert(\"" + sMsg + "\")");
		}
		public function quit (showMessage:Boolean) : void
		{
			if (isDirectorShell)
			{
				sendCommand ("lingo: quit()");
			} else
			{
				//Running in the Flash Projector.
				fscommand ("quit", "");
			}
		}
		/////////////////////////////////
		//  Call lingo directly provided
		// we are in the shell.
		protected function sendCommand (lingoCmdString : String) : void
		{
			if (System.capabilities.playerType == "DirectorXtra")
			{
				var request:URLRequest = new URLRequest((lingoCmdString);
							} else
							{
								trace ("Lingo: " + lingoCmdString);
							}
						}
						public function testGateway () : void {
							trace ("\r\rtesting gateway");
							//getURL('Lingo: trace("PING FROM DIRECTOR UTILS22-----------");');
							// getURL('Lingo: alert("PING FROM DIRECTOR UTILS33-----------");');
							//getURL('Lingo: ping("fromPing");');
							// this.evalLingoAndCallback('trace("hellotest")', null);
					
						}
						/////////////////////////////////////////////////////////////////////////////
						// this is similar to the evalLingoAndCallback but utilizes the older lingo style inside director
						// and uses pass by reference instead of string+ getURL manipulation.
						public function evalLingoAndCallback2 (lingoCmdString : String, callBack : Object) : void
						{
							var callbackId = this.createResponder (callBack);
							this.log.info ("DIrectorUtil.evalLingoAndCallback2('" + lingoCmdString + "')");
							//	getURL('Lingo: trace("PING FROM DIRECTOR UTILS2-----------" + ping("fromPing"));');
							if (System.capabilities.playerType == "DirectorXtra")
							{
								trace ("Flash.calling Director");
								_root.directorUtilStatement = lingoCmdString;
								//'ping(" Hello World");';
								_root.directorUtilStatementResult = null;
								_root.directorUtilStatementCallbackID = callbackId;
								var sCmd = 'Lingo: evalLingoAndCallback2()';
								getURL (sCmd);
					
							} else
							{
								trace ("Lingo: " + lingoCmdString);
								//emulate callback
								this.intV = setInterval (this, "onDirectorCallback", 1000, callbackId, "DummyCallback");
							}
						}
						/////////////////////////////////////////////////////////////////////////////
						// this is similar to sendCommand, but uses a different callback metaphor
						// ends up calling _root.onDirectorCallback() which calls DirectorUtils.onDirectorCallback();
						public function evalLingoAndCallback (lingoCmdString : String, callBack : Object) : void
						{
							var callbackId = this.createResponder (callBack);
							var sCmd = 'Lingo: evalLingoAndCallback2( "' + escape (lingoCmdString) + '",' + callbackId + ')';
							this.log.info ("DIrectorUtil.evalLingoAndCallback('" + sCmd + "')");
							//	getURL('Lingo: trace("PING FROM DIRECTOR UTILS2-----------" + ping("fromPing"));');
							if (System.capabilities.playerType == "DirectorXtra")
							{
								trace ("Flash.calling Director");
								getURL (sCmd);
							} else
							{
								trace ("Lingo: " + sCmd);
								//emulate callback
								this.intV = setInterval (this, "onDirectorCallback", 1000, callbackId, "DummyCallback");
							}
						}
						//////////////////////////////////////////////////////////////////////////////
						// this is routed by a _root.onDirectorCallback created in the constructor
						// as Director can't easily get the Singleton instance
						public function onDirectorCallback (callbackId : String, oArgs : Object) : void
						{
							clearInterval (intV);
							_global.log.warn ("onDirectorCallback " + callbackId, oArgs );
							this.responderStore [callbackId](oArgs);
							delete (this.responderStore [callbackId]);
						}
					});
				navigateToURL(request);
				
			} else
			{
				trace ("Lingo: " + lingoCmdString);
			}
		}
		public function testGateway () : void {
			trace ("\r\rtesting gateway");
			var request:URLRequest = new URLRequest('Lingo: trace("PING FROM DIRECTOR UTILS22-----------");');
			navigateToURL(request);
			
			var request:URLRequest = new URLRequest('Lingo: alert("PING FROM DIRECTOR UTILS33-----------");');
			navigateToURL(request);
			
			var request:URLRequest = new URLRequest('Lingo: ping("fromPing");');
			navigateToURL(request);
			
			// this.evalLingoAndCallback('trace("hellotest")', null);
	
		}
		/////////////////////////////////////////////////////////////////////////////
		// this is similar to the evalLingoAndCallback but utilizes the older lingo style inside director
		var request:URLRequest = new URLRequest(manipulation.
				public function evalLingoAndCallback2 (lingoCmdString : String, callBack : Object) : void
				{
					var callbackId = this.createResponder (callBack);
					this.log.info ("DIrectorUtil.evalLingoAndCallback2('" + lingoCmdString + "')");
					//	getURL('Lingo: trace("PING FROM DIRECTOR UTILS2-----------" + ping("fromPing"));');
					if (System.capabilities.playerType == "DirectorXtra")
					{
						trace ("Flash.calling Director");
						_root.directorUtilStatement = lingoCmdString;
						//'ping(" Hello World");';
						_root.directorUtilStatementResult = null;
						_root.directorUtilStatementCallbackID = callbackId;
						var sCmd = 'Lingo: evalLingoAndCallback2()';
						getURL (sCmd);
			
					} else
					{
						trace ("Lingo: " + lingoCmdString);
						//emulate callback
						this.intV = setInterval (this, "onDirectorCallback", 1000, callbackId, "DummyCallback");
					}
				}
				/////////////////////////////////////////////////////////////////////////////
				// this is similar to sendCommand, but uses a different callback metaphor
				// ends up calling _root.onDirectorCallback() which calls DirectorUtils.onDirectorCallback();
				public function evalLingoAndCallback (lingoCmdString : String, callBack : Object) : void
				{
					var callbackId = this.createResponder (callBack);
					var sCmd = 'Lingo: evalLingoAndCallback2( "' + escape (lingoCmdString) + '",' + callbackId + ')';
					this.log.info ("DIrectorUtil.evalLingoAndCallback('" + sCmd + "')");
					//	getURL('Lingo: trace("PING FROM DIRECTOR UTILS2-----------" + ping("fromPing"));');
					if (System.capabilities.playerType == "DirectorXtra")
					{
						trace ("Flash.calling Director");
						getURL (sCmd);
					} else
					{
						trace ("Lingo: " + sCmd);
						//emulate callback
						this.intV = setInterval (this, "onDirectorCallback", 1000, callbackId, "DummyCallback");
					}
				}
				//////////////////////////////////////////////////////////////////////////////
				// this is routed by a _root.onDirectorCallback created in the constructor
				// as Director can't easily get the Singleton instance
				public function onDirectorCallback (callbackId : String, oArgs : Object) : void
				{
					clearInterval (intV);
					_global.log.warn ("onDirectorCallback " + callbackId, oArgs );
					this.responderStore [callbackId](oArgs);
					delete (this.responderStore [callbackId]);
				}
			});
		navigateToURL(request);
		
		public function evalLingoAndCallback2 (lingoCmdString : String, callBack : Object) : void
		{
			var callbackId = this.createResponder (callBack);
			this.log.info ("DIrectorUtil.evalLingoAndCallback2('" + lingoCmdString + "')");
			var request:URLRequest = new URLRequest('Lingo: trace("PING FROM DIRECTOR UTILS2-----------" + ping("fromPing"));');
			navigateToURL(request);
			
			if (System.capabilities.playerType == "DirectorXtra")
			{
				trace ("Flash.calling Director");
				_root.directorUtilStatement = lingoCmdString;
				//'ping(" Hello World");';
				_root.directorUtilStatementResult = null;
				_root.directorUtilStatementCallbackID = callbackId;
				var sCmd = 'Lingo: evalLingoAndCallback2()';
				var request:URLRequest = new URLRequest((sCmd);
					
							} else
							{
								trace ("Lingo: " + lingoCmdString);
								//emulate callback
								this.intV = setInterval (this, "onDirectorCallback", 1000, callbackId, "DummyCallback");
							}
						}
						/////////////////////////////////////////////////////////////////////////////
						// this is similar to sendCommand, but uses a different callback metaphor
						// ends up calling _root.onDirectorCallback() which calls DirectorUtils.onDirectorCallback();
						public function evalLingoAndCallback (lingoCmdString : String, callBack : Object) : void
						{
							var callbackId = this.createResponder (callBack);
							var sCmd = 'Lingo: evalLingoAndCallback2( "' + escape (lingoCmdString) + '",' + callbackId + ')';
							this.log.info ("DIrectorUtil.evalLingoAndCallback('" + sCmd + "')");
							//	getURL('Lingo: trace("PING FROM DIRECTOR UTILS2-----------" + ping("fromPing"));');
							if (System.capabilities.playerType == "DirectorXtra")
							{
								trace ("Flash.calling Director");
								getURL (sCmd);
							} else
							{
								trace ("Lingo: " + sCmd);
								//emulate callback
								this.intV = setInterval (this, "onDirectorCallback", 1000, callbackId, "DummyCallback");
							}
						}
						//////////////////////////////////////////////////////////////////////////////
						// this is routed by a _root.onDirectorCallback created in the constructor
						// as Director can't easily get the Singleton instance
						public function onDirectorCallback (callbackId : String, oArgs : Object) : void
						{
							clearInterval (intV);
							_global.log.warn ("onDirectorCallback " + callbackId, oArgs );
							this.responderStore [callbackId](oArgs);
							delete (this.responderStore [callbackId]);
						}
					});
				navigateToURL(request);
				
	
			} else
			{
				trace ("Lingo: " + lingoCmdString);
				//emulate callback
				this.intV = setInterval (this, "onDirectorCallback", 1000, callbackId, "DummyCallback");
			}
		}
		/////////////////////////////////////////////////////////////////////////////
		// this is similar to sendCommand, but uses a different callback metaphor
		// ends up calling _root.onDirectorCallback() which calls DirectorUtils.onDirectorCallback();
		public function evalLingoAndCallback (lingoCmdString : String, callBack : Object) : void
		{
			var callbackId = this.createResponder (callBack);
			var sCmd = 'Lingo: evalLingoAndCallback2( "' + escape (lingoCmdString) + '",' + callbackId + ')';
			this.log.info ("DIrectorUtil.evalLingoAndCallback('" + sCmd + "')");
			var request:URLRequest = new URLRequest('Lingo: trace("PING FROM DIRECTOR UTILS2-----------" + ping("fromPing"));');
			navigateToURL(request);
			
			if (System.capabilities.playerType == "DirectorXtra")
			{
				trace ("Flash.calling Director");
				var request:URLRequest = new URLRequest((sCmd);
							} else
							{
								trace ("Lingo: " + sCmd);
								//emulate callback
								this.intV = setInterval (this, "onDirectorCallback", 1000, callbackId, "DummyCallback");
							}
						}
						//////////////////////////////////////////////////////////////////////////////
						// this is routed by a _root.onDirectorCallback created in the constructor
						// as Director can't easily get the Singleton instance
						public function onDirectorCallback (callbackId : String, oArgs : Object) : void
						{
							clearInterval (intV);
							_global.log.warn ("onDirectorCallback " + callbackId, oArgs );
							this.responderStore [callbackId](oArgs);
							delete (this.responderStore [callbackId]);
						}
					});
				navigateToURL(request);
				
			} else
			{
				trace ("Lingo: " + sCmd);
				//emulate callback
				this.intV = setInterval (this, "onDirectorCallback", 1000, callbackId, "DummyCallback");
			}
		}
		//////////////////////////////////////////////////////////////////////////////
		// this is routed by a _root.onDirectorCallback created in the constructor
		// as Director can't easily get the Singleton instance
		public function onDirectorCallback (callbackId : String, oArgs : Object) : void
		{
			clearInterval (intV);
			_global.log.warn ("onDirectorCallback " + callbackId, oArgs );
			this.responderStore [callbackId](oArgs);
			delete (this.responderStore [callbackId]);
		}
	}
	
}