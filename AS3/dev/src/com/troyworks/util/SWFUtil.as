package com.troyworks.util {
	import flash.display.DisplayObject;	
	import flash.geom.Point; 
	import flash.display.MovieClip;
	import flash.system.System;
	import flash.system.Capabilities;

	class SWFUtil {
		public static var currentOS : String = null;
		private static var getURLPath : String;
		//private static var pathSeparator : String;

		//		var request:URLRequest = new URLRequest(ath : String = null;
		public static function isFullyLoaded(_mc : MovieClip) : Boolean {
			//					var _mc = eval (clipPath);
			return (_mc.totalFrames != null && _mc.totalFrames > 0 && _mc.framesLoaded >= _mc.totalFrames) ? true : false;
		}

		public static function hasStartedLoading(_mc : MovieClip) : Boolean {
			//var _mc = eval (clipPath);
			return (_mc.totalFrames != null && _mc.totalFrames > 0) ? true : false;
		}

		public static function inBrowser() : Boolean {
			var s = Capabilities.playerType;
			return (s == "PlugIn" || s == "ActiveX") ? true : false;
		}
		public static function get pathSeparator () : String
				{
					var sSep : String;
					var osN = SWFUtil.getOSName ();
					if (osN == "win")
					{
						sSep = "\\";
					} else if (osN == "mac")
					{
						sSep = ":";
					} else
					{
						sSep = "/";
					}
					return sSep;
				};
		/* used to indicate if a swf or a string is on the web via looking if the url/string contains 
		 * 'http://'
		 */
		public static function onWeb(o : Object) : Boolean {
			var res : Boolean = false;
			var path : String = null;
			if(o is MovieClip) {
				path = MovieClip(o)._url;
			}else if(o is String) {
				path = String(o);
			}
			res = path.indexOf("http://") > -1; 
			return res;
		}

		// Given two movie clips and a series of points converts between the too cooridinate spaces

		public static function localToLocal(from : MovieClip, to : MovieClip, points : Object) : void {
			var point : Object = null;
			var _ary : Array = new Array();
			if(points is Array  ) {
				_ary = Array(points);
			}else if(points is Object) {
				_ary.push(point);
			}else {
				point = new Object();
				point.x = 0;
				point.y = 0;
				_ary.push(point);
			}
			for(var i in _ary) {
				point = _ary[i];
				from.localToGlobal(point as Point);
				to.globalToLocal(point as Point);
			}
		}

		public static function getURLCleaned(_mc : DisplayObject) : String {
			if (SWFUtil.getURLPath == null) {
				var flashURL : String = unescape(_mc.loaderInfo.url);
				//"file:///C|/Documents%20and%20Settings/Troy%20Gardner/My%20Documents/Work%20My%20Current%20Projects/Schematic%20%2DMcDougal%20Littel/dev/flash/clientApplication/";
				var a : Number = flashURL.lastIndexOf("/");
				if (a == -1) {
					a = flashURL.lastIndexOf("\\");
				}
				var pathSep : String = SWFUtil.pathSeparator;
				//trace ("path separator: '" + pathSep + "'");
				/////////
				var cleanedPath : String = "";
				if (flashURL.indexOf("|") != -1) {
					var indexOfDriveSep : Number = flashURL.indexOf("|", 0);
					var driveLetter : String = flashURL.substring(indexOfDriveSep - 1, indexOfDriveSep);
					var pathFromRoot : String = flashURL.substring(indexOfDriveSep + 1, a + 1);
					//	trace ("'" + driveLetter + "' - '" + pathFromRoot + "'");
					cleanedPath = driveLetter + ":" + pathFromRoot;
					var di : Number = cleanedPath.lastIndexOf("/", (cleanedPath.length - 2));
					//	trace (" ON A PC !!!!!!!!!!!!");
					SWFUtil.currentOS = "PC";
					cleanedPath = SWFUtil.formatPath(cleanedPath, "win");
				} else if (flashURL.indexOf("///") != -1) {
					//	DirectorUtils.instance.sendAlert("Assuming Mac...");
					// assume mac
					var pathFromRoot : String = flashURL.substring(flashURL.indexOf("///") + 3, a + 1);
					//	trace("'"+driveLetter +"' - '" + pathFromRoot+"'");
					cleanedPath = pathFromRoot.split("/").join(":");
					var di : Number = cleanedPath.lastIndexOf(":", (cleanedPath.length - 2));
					//	trace (" ON A MAC !!!!!!!!!!!!");
					SWFUtil.currentOS = "MAC";
					cleanedPath = SWFUtil.formatPath(cleanedPath, "mac");
				} else {
					//in a browser
					cleanedPath = flashURL.substring(0, a + 1);
				}
				//trace ("cleanedPath " + cleanedPath);
				SWFUtil.getURLPath = cleanedPath;
			}
			return SWFUtil.getURLPath;
		}

		public static function formatPath(path : String, osN : String) : String {
			var sLocal : String = path;
			var sSep : String = null;
			osN = (osN == null) ? SWFUtil.getOSName() : osN;
			var inBrowser : Boolean = SWFUtil.inBrowser();
			//trace ("> FLASH: formatPath(" + path + ") > for" + osN + " inBrowser " + inBrowser);
			if (osN == "win" && !inBrowser) {
				//	trace ("formmating windows");
				sSep = "\\";
			} else if (osN == "mac" && !inBrowser) {
				//	trace ("formmating mac");
				sSep = ":";
			} else {
				//	trace ("formmating default" + osN);
				sSep = "/";
			}
			if (path.indexOf("/") != -1) {
				sLocal = SWFUtil.searchReplace(sLocal, "/", sSep);
			}
			if (path.indexOf("\\") != -1) {
				sLocal = SWFUtil.searchReplace(sLocal, "\\", sSep);
			}
			//trace ("> FLASH: formatPath(" + path + ") >\r" + sLocal);
			return sLocal;
		}

		public static function searchReplace(sStr : String, sFind : String, sReplace : String) : String {
			return sStr.split(sFind).join(sReplace);
		}

		public static function getOSName() : String {
			var os : String = "unknown";
			var hasWin : Boolean = Capabilities.os.toLowerCase().indexOf("win") != -1;
			var hasMac : Boolean = Capabilities.os.toLowerCase().indexOf("mac") != -1;
			if (hasMac) {
				os = "mac";
				//find first number
				var operSys : String = Capabilities.os;
				var majorVersion : Number = 0;
				for (var i : Number = 0;i < operSys.length; i++) {
					if ( !isNaN(parseInt(operSys.substr(i, 1)))) {
						majorVersion = Number(operSys.substring(i, operSys.indexOf(".")));
						break;
					}
				}
				//sendAlert("majorVersion: " + majorVersion);
				if (majorVersion >= 10) {
					// is os x
					os = "mac_osx";
				} else {
					os = "mac_os9";
				}
			} else if (hasWin) {
				os = "win";
			}
			//	trace ("******getOSName****" + System.capabilities.os.toLowerCase () + " " + os);
			return os;
		}

		public static function getParentPath(path : String) : String {
			var a = Math.max(path.lastIndexOf("/", path.length - 2), path.lastIndexOf("\\", path.length - 2));
			return path.substring(0, a + 1);
		}

		public static function getPathSeparator() : String {
			var sSep : String;
			var osN = SWFUtil.getOSName();
			if (osN == "win") {
				sSep = "\\";
			} else if (osN == "mac") {
				sSep = ":";
			} else {
				sSep = "/";
			}
			return sSep;
		};

		//Gets the domain part from the url
		//  var t1= "http://someth.som.som.com/asfa/asfda/asdfa/sas.swf";
		//  var t2= "http://someth.som.som.com";
		//	 trace(getDomain(t1));
		//   trace(getDomain(t2));
		//RETURNS
		//  http://someth.som.som.com
		//	http://someth.som.som.com
		public static function getDomain(str : String) : String {
			//
			//		if(str == null) {
			//			str = unescape(_root._url);
			//			}
			var firstSlashPast : Number = str.indexOf("/", "http://".length);
			if (firstSlashPast != -1) {
				var a = str.substring(0, firstSlashPast);
				var b = str.substring(firstSlashPast, str.length);
				return a;
			}else {
				return str;
			}
		}
	}	
}