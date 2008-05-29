package com.troyworks.framework.bootstrapper { 
	import com.troyworks.framework.logging.ILogger;
	import com.troyworks.framework.logging.LogLevel;
	
	/**
	 * @author Troy Gardner
	 */
	public class BootTraceLogger implements ILogger {
		public static var className : String = "com.troyworks.framework.bootstrapper.BootTraceLogger";
			
		protected static var instance : BootTraceLogger;
			
		/**
		 * @return singleton instance of BootTraceLogger
		 */
		public static function getInstance() : BootTraceLogger {
				if (instance == null)
					instance = new BootTraceLogger();
				return instance;
		}		
		protected function BootTraceLogger() {
			trace("******************************************************");
			trace("******************************************************");
			trace("*******************BootTraceLogger***********************************");
			trace("******************************************************");
			trace("******************************************************");
			trace("******************************************************");
		}
		
		public function toString():String{
			return className;
		}
	
		public function log(sMessage : String) : void {		
			trace(arguments.join(''));
		}
		public function logLevel(nLevel : LogLevel, sMessage : String) : void {		
			trace(arguments.join(''));
		}
	
	}
}