package com.troyworks.logging { 
	/**
	 * A Class to log messages to the XMLSocket based SOSLogger from powerflasher
	 * http://sos.powerflasher.de/english/english.html
	 * 
	 * this is based off the article 
	 * http://blog.diefirma.de/2006-02-22/howto-fdt-mtasc-and-sos/
	 * 
	 * @author Troy Gardner
	 */
	
	import flash.net.XMLSocket;
	import flash.utils.describeType;
	import com.troyworks.logging.SOS;
	
	public class SOSLogger extends Logger {
		public var owner : Object;
		public var sos : SOS;
		///////////////////////////////////

		public static var sock : XMLSocket;
		protected static var instance : SOSLogger;
		public static var verbose : Boolean = false;
		public static var promptOnFatal:Boolean = false;
	
		public var initState:String = "-1";
		/*****************************************************
		 * Constructor
		 * not public in case a particular party wants a copy to customize the output to
		 * 
		 */
		public function SOSLogger(applicationLogKeyName:String, owningInst:Object= null) {
			super(applicationLogKeyName);			
			initState = "0";
			this.owner = owningInst;
			sos = new SOS();
			
			sos.connect();
			trace("creating SOSLogger" + applicationLogKeyName);
			sos.showMessage(_appKeyName, "new SOSLogger("+ _appKeyName+")");
			initState = "1";
			setupStyles();
	
			initState = "2";
		}
		public function isConnected():Boolean{
			return sos.isConnected;
		}
		public static function getInstance(ownerName : String="DefaultSOSLogger", owner:Object=null) : SOSLogger{
			
			if(SOSLogger.instance == null ){
				trace("creating SOS");
				SOSLogger.instance =  new SOSLogger(ownerName, owner);
			trace("creating SOS2");
			//	SOSLogger.instance.info("SOSLoggerCreated by " + ownerName);
			}
			return SOSLogger.instance;
		}
		/* sets up a bunch of styles for highlighting the lines per applicationName + logLevel
		* 	csock.send("<setKey><name>DefaultSOSLogger_SEVERE</name><color>"+0xee0000+"</color></setKey>\n"); 
		* so anything with log level sever would get colored red.
		* */
		public function setupStyles() : void{
			var 	csock : XMLSocket = sos.getCommandSocket();
			var xml:XML = describeType(LogLevel);
			var xmlL:XMLList = xml..constant;
			var logL:LogLevel;
			for each (var name:String in xml..@name){
				try{
					
					//trace("name" + name);
					logL = LogLevel[name] as LogLevel;
					
					if(logL != null){
				//	trace("LogLevel " + logL.name + " " + logL.color);
				     sos.showMessage("",'<key rgb="'+ Number(logL.color)+'" visible="1"><![CDATA['+logL.name+']]></key>');
					//csock.send("<setKey><name>"+logL.name+"</name><color>"+logL.color+"</color></setKey>\n");
					sos.showMessage("FINE","setup styles");
					}
				}catch(err:Error){
					//ignore
						sos.showMessage("ERROR","could not setup styles");
					trace("SOS.setupStyles " + err);
				}
			}
		}
		
		////////////////////////////////////////////////////////////////////////////
		override public function logBreak() : void{
			sos.showMessage(_appKeyName,"-------------------------------------------------------------------");
		}
		override public function clearLog() : void{
			sos.clearConsole();
		}
		//Outputs to SOS	//trace("<showMessage key='"+nLevel.name + "'>"+nLevel.name + " : "+sMessage+"</showMessage>\n");
		
		override public function logLevel(nLevel : LogLevel, sMessage : String) : void{
			var key:String = nLevel.name;// _appKeyName+"_"+nLevel.name;
			if(nLevel == LogLevel.FATAL){
				sos.showMessage(key,sMessage);
				if(promptOnFatal){
					sos.createDialog(nLevel.name, sMessage);
				}
			}else{
				sos.showMessage(key,sMessage);
			}
		}
		
		public function toString() : String{
			return "SOSLogger for "+_appKeyName;
		}
	}
	
}