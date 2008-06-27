/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.logging {

	/**
	* This primary goal of this class is to adapt trace() to colorizing
	* statements for the SOS logger, via keywords inside the this.trace('HIGHLIGHTP...normal text');
	* 
	* basically use is overriding Object.prototype.trace (which doesn't exist)
	* and referecning it by this.trace.
	* 
	* public static var trace : Function = TraceAdapter.CurrentTracer;
	*/
	public class TraceAdapter {
		public static var sosL:SOSLogger = null;
		public static const HIGHLIGHT:String = "HIGHLIGHT";
		public static var promptOnFatal:Boolean = true;
		public static var NormalTracer:Function = trace;
		public static var SOSTracer:Function = TraceAdapter.traceToSOS;
		public static var CurrentTracer:Function = trace;		
		
		public static function traceNormal(obj : Object ="") : void{
				trace(obj);
		}
		public static function traceToSOS(obj : Object ="") : void{
			if(TraceAdapter.sosL == null || !TraceAdapter.sosL.isConnected()){
				var ss:SOSLogger = new SOSLogger("TraceAdapter");
				TraceAdapter.sosL = ss;
			}
	
			var msg:String = obj.toString();
			if(typeof(obj) =="string"){
				var s : String = String(obj);
				var err : Boolean = s.indexOf("ERROR") >-1;
				var fI:Number = s.indexOf("FAILED");
				var failed:Boolean =  fI>-1 && (s.charAt(fI-1)!= "_" );
				var warn : Boolean = s.indexOf("WARNING") >-1;
				var info : Boolean = s.indexOf("INFO") >-1;
				var breakP:Boolean = s.indexOf("BREAKPOINT") >-1;
				var hiDX:Number = s.indexOf(HIGHLIGHT);
				var highlight : Boolean = hiDX >-1;
				var startO : Boolean = s.indexOf("\\\\\\\\\\\\\\\\") >-1;
				var endO : Boolean = s.indexOf("//////////////////") >-1;
				
				if(err){
					sosL.logLevel(LogLevel.SEVERE, msg);
					if(promptOnFatal){
					//	sosL.sos.createDialog("ERROR", msg);
						//	sosL.sos.createDialog();
					}
					return;
				}else if(failed){
					sosL.logLevel(LogLevel.FLASH_ERROR,msg);
					return;
									
				}else if(warn){
					sosL.logLevel(LogLevel.WARNING,msg);
					return;
				}else if(info){
					sosL.logLevel(LogLevel.INFO,msg);
					return;				
				}else if(highlight){
					//using the single letter/number after highlight
					// translate it into a suitable color
					var color:String = s.charAt((hiDX + HIGHLIGHT.length));
				//	trace("COLOR AT " + (hiDX + HIGHLIGHT.length + 1) + " is " + color);
					var ll:LogLevel = null;
					switch(color){
						case 'P':
						case 'p':
							ll = LogLevel.HILIGHT_PURPLE;
							break;
						case 'B':
							ll = LogLevel.HILIGHT_TURQUOISE;
							break;
						case 'b':
							ll = LogLevel.HILIGHT_SKYBLUE;
							break;
						case 'G':
						case 'g':
							ll = LogLevel.HILIGHT_LIME;
							break;
						case 'y':
							ll = LogLevel.HILIGHT_LEMON;
							break;
						case 'o':
						case 'O':
							ll = LogLevel.HILIGHT_ORANGE;
							break;
						case 'V':
						case 'v':
							ll = LogLevel.HILIGHT_GRAPE;
							break;		
						case '0':
							ll = LogLevel.HILIGHT_GRAY0;
							break;		
						case '1':
							ll = LogLevel.HILIGHT_GRAY1;
							break;		
						case '2':
							ll = LogLevel.HILIGHT_GRAY2;
							break;		
						case '3':
							ll = LogLevel.HILIGHT_GRAY3;
							break;		
						case '4':
							ll = LogLevel.HILIGHT_GRAY4;
							break;		
						case 'Y':
						default:
							ll = LogLevel.HILIGHT_YELLOW;
							break;
					}
					sosL.logLevel(ll,msg);
					return;				
				}else if(startO){
					sosL.logLevel(LogLevel.START,msg);
					return;				
				}else if(endO){
					sosL.logLevel(LogLevel.END,msg);
					return;				
					
				}
			}
			sosL.sos.showMessage(null,msg);
		}
	}
	
}
