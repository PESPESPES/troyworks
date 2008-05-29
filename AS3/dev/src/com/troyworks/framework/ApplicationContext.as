package com.troyworks.framework { 
	import com.troyworks.spring.Factory;
	import com.troyworks.framework.logging.ILogger;
	import com.troyworks.framework.events.IEventOracle;
	import com.troyworks.events.TEventDispatcher;
	import com.troyworks.framework.bootstrapper.BootTraceLogger;
	import com.troyworks.framework.logging.SOSLogger;
	import com.troyworks.util.DesignByContract;
	
	/**
	 * This serves as a SWF specific place to get common services, for contextualized
	 * logging,
	 * events
	 * bootstrapping
	 * 
	 * @author Troy Gardner
	 */
	public class ApplicationContext extends Factory {
		  	// REQUIRED by DesignByContract
		public var ASSERT : Function;
		public var REQUIRE : Function;
		protected static var instance : ApplicationContext;
		protected var loggers:Array = new Array();
		protected static var _b:Function = SOSLogger;
		protected static var _c:Function = BootTraceLogger;
		protected static var startUpDate:Date = new Date();
		protected static var displayName:String = "DefaultApplicationContext";
		/*design by contract log, logs errors for this particular statemachine */
		public var dbclog : Array = new Array ();
		/**
		 * @return singleton instance of ApplicationContext
		 */
		public static function getInstance() : ApplicationContext {
		/* 		trace("******************************************************");
				trace("******************************************************");
				trace("*******************ApplicationContex.getInstancet***********************************");
				trace("******************************************************");
				trace("******************************************************");
				trace("******************************************************");
		*/
			if (instance == null){
				instance = new ApplicationContext();
				var obj:Object = new Object();
				obj["Logger"] = "com.troyworks.framework.logging.SOSLogger";
				obj["Oracle"] = "com.troyworks.framework.events.DummyEventDispatcher";
				registerImplementers(obj);
				instance.loggers.push(BootTraceLogger.getInstance());
				  ///add in the mixins for ASSERT and REQUIRE
	 			DesignByContract.initialize(instance);
			//	instance.loggers.push(SOSLogger.getInstance());
			trace("ApplicationContext.getInstance() created new");
			}
			return instance;
		}
		
		protected function ApplicationContext() {
	   		super();		
	   		trace("******************************************************");
			trace("******************************************************");
			trace("*******************ApplicationContext2***********************************");
			trace("******************************************************");
			trace("******************************************************");
			trace("******************************************************");
		}
		public function getLogger():ILogger{
		   var l =	getImplementor("Logger");
		   var lc = ILogger(l);
		   return l;
		}
		public function getEventOracle():IEventOracle{
			var ocl = getImplementor("Oracle");
			var oclc = IEventOracle(ocl);
			return ocl;
		}
		public function getStartupDate():Date{
			return startUpDate;
		}
		public function getDisplayName():String{
			return displayName;
		}
		public function log():void{
	//			SOSLogger.traceToSOS("PRE: AppContext.log");
			
			for(var i in loggers){
		//		SOSLogger.traceToSOS("PRE: [ AppContext.log " + i);	
				var log:ILogger = ILogger(loggers[i]);
				log.log.apply(log, arguments);
			}
		}
		/***************************************************
		 *  Returns a Delegate to the logging operation to use 
		 *  wherever logging is needed by children created by the factory
		 *  or by _global.log in the main timeline.
		 *  
		 */
		public function getLoggerRef() : Function {
			//	SOSLogger.traceToSOS("PRE: getLoggerREf");
	
			var f = function()
			{
				var target = arguments.callee.target;
				var func = arguments.callee.func;
	//			SOSLogger.traceToSOS("PRE: LoggerDelegate() args:" + arguments + " target " + target + " func " + func);
				return func.apply(target, arguments);
			};
	
			f.target = this;
			f.func = this.log;
			return f;
		}
	
		/*******************************************
		 * this function is useful for setting breakpoints 
		 * when an assert or require fails.
		 */
		public function onAssertFailed(msg : String, critical:Boolean) : void{
			dbclog.push (msg);
			trace("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace("XXXXXXXXXX   ERROR ERROR ERROR ERROR ERROR ERROR ERROR    XXXXXXXXXXXXXXXXXXXXX");		
			trace("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace(displayName + " has errors XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" + dbclog.join("\r"));
			trace("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
		}
	}
}