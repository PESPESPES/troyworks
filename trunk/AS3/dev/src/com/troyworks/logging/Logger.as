package com.troyworks.logging { 
	import com.troyworks.logging.ILogger;
	import com.troyworks.logging.LogLevel;
	/**
	* Basic logger for the
	* the base/abstract class uses trace() for output
	* subclasses override the functionality for sockets etc.
	* 
	 * @author Troy Gardner (troy@troyworks.com)
	 */
	public class Logger implements ILogger {
	
	
		/* app keyname, used for filtering */
		protected var _appKeyName : String;
		protected var minLogLevelVisible:int = -1;
		protected var maxLogLevelVisible:int = int.MAX_VALUE;
		/*	constructor, pass it the name of the class for filtering */
		function Logger(sName : String= "DefaultLogger") {
			_appKeyName = sName;
		}
		//////////// ACCESSORS //////////////////////////////////
		public function getName() : String {
			return _appKeyName;
		}
		public function setMinLogLevel(Minint:Number):void{
			minLogLevelVisible =Minint;
		}
		public function setMaxLogLevel(Maxint:Number):void{
			maxLogLevelVisible = Maxint;
		}
		/////////////// BASIC LOG LEVELS /////////////////////////
		public function fatal(sMessage : String) : void {
			if(LogLevel.FATAL.isEnabledForOutput){
				logLevel(LogLevel.FATAL, sMessage);
			}
		}
		public function severe(sMessage : String) : void {
			if(LogLevel.SEVERE.isEnabledForOutput){
				logLevel(LogLevel.SEVERE, sMessage);
			}
		}
		public function flash_error(sMessage : String) : void {
			if(LogLevel.FLASH_ERROR.isEnabledForOutput){
				logLevel(LogLevel.FLASH_ERROR, sMessage);
			}
		}
		public function error(sMessage : String) : void {
			if(LogLevel.ERROR.isEnabledForOutput){
				logLevel(LogLevel.ERROR, sMessage);
			}
		}
		public function warn(sMessage : String) : void {
			if(LogLevel.WARNING.isEnabledForOutput){
				logLevel(LogLevel.WARNING, sMessage);
			}
		}
		public function info(sMessage : String) : void {
			if(LogLevel.INFO.isEnabledForOutput){
				logLevel(LogLevel.INFO, sMessage);
			}
		}
		public function debug(sMessage : String) : void {
			if(LogLevel.DEBUG.isEnabledForOutput){
				logLevel(LogLevel.DEBUG, sMessage);
			}
		}
		public function log(level:int, sMessage : String) : void {
			var passesMin:Boolean = level >minLogLevelVisible;
			var passesMax:Boolean = level < maxLogLevelVisible;
			if(LogLevel.LOG.isEnabledForOutput && passesMin && passesMax){
				logLevel(LogLevel.LOG, level+ " "+ sMessage);
			}
		}
		///////////////////////////////////////////////////////////
		public function logLevel(nLevel : LogLevel, sMessage : String) : void{
			 trace("logLevel " + nLevel.name + " msg: " + sMessage  + " " + _appKeyName);	
		}
		//////////////////////////////////////////////////
		public function startSig(sMessage : String) : void {
			logLevel(LogLevel.START, sMessage);
		}
		public function endSig(sMessage : String) : void {
			logLevel(LogLevel.END, sMessage);
		}
	    //////////////////////////////////////////////////
		public function highlight(sMessage : String) : void {
			logLevel(LogLevel.HILIGHT_YELLOW, sMessage);
		}
		public function logBreak() : void{
			trace("---------------------------------------------------------------");
		}
		public function clearLog() : void{
		}

	}
}