package com.troyworks.logging { 
	import com.troyworks.logging.LogLevel;
	/**
	* AS3 port of the AS2 logger, shares a similar interface to mx.logging.ILogger
	* http://livedocs.adobe.com/flex/2/langref/mx/logging/ILogger.html
	* 
	* See this for some information
	 * @author Troy Gardner
	 */
	 public interface ILogger {
		 function debug(sMessage:String):void;
		 function error(sMessage:String):void;
		 function fatal(sMessage:String):void;
		 function info(sMessage:String):void;
		 function log(level:int, sMessage : String):void;
		 function warn(sMessage:String):void;
		 function logLevel(nLevel : LogLevel, sMessage : String) : void;		
		
	}
}