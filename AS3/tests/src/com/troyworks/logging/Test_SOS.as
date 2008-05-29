/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.logging {
	import com.troyworks.tester.AsynchronousTestSuite;
	import com.troyworks.tester.SynchronousTestSuite;
	import com.troyworks.logging.TraceAdapter;

	
	public class Test_SOS extends SynchronousTestSuite{
			public var trace:Function;
			public var logger:SOSLogger;
			
			public function Test_SOS(){
				super();	
				trace = TraceAdapter.TraceToSOS;
			}

			public function test_connect():Boolean{
				var res:Boolean = false;	
				/*sos = new SOS();
					sos.connect();
					
					sos.showMessage("TroyWorks_Test","!!!!!!!!!!!!!!!!!!!!!!!hello from TroyWorks_Test!!!!!!!!!!!!!!!!!!!!");
					sos.showMessage("TroyWorks_Test", "A = A \r B = B \r C = C");
					//sos.createDialog("Hello popup");
					sos.clearConsole();*/
					try{
				//	TraceAdapter.setTraceOutputToSOS();
				//	this.trace("HIGHLIGHT sos this.trace");
				//	TraceAdapter.setTraceOutputToFlashTrace();
				//	this.trace("NORMAL this.trace");
//					trace = TraceAdapter.getNormalTracer();
					trace("trace()");
//					trace = TraceAdapter.TraceToSOS;
					trace("trace2()");
					
					var log:ILogger = new SOSLogger("TroyWorks_Test");
					log.fatal("fatal message");
					log.fatal("fatal message with folded a\rb\rc");
					log.debug("debug message");
					log.error("error message");
					log.info("info message");
					//log.severe("severe message");
					res =  true;
					}catch(err:Error){
						res =  false;
					}finally{
						return res;
					}
			}
			public function test_traceOutputTests():Boolean{
				//trace = TraceAdapter.TraceToSOS;
				trace("test_traceOutputTests=================");
				trace("number " + 1);
				trace("string " +  new String("HelloWorld"));
				trace("error " +  "error message"); //won't work for highlighting/prompt
				trace("ERROR " +  "error message2"); //will work
				trace("WARNING " +  "warning message");
				trace("INFO " +  "info message");
				trace("HIGHLIGHT " +  "highlight message");
				trace("\\\\\\\\\\\\\\\\ " +  "start section message");
				var _ary : Array = ["A","B","C","D"];
				trace("array1 " + _ary);
				//trace("array2 " + util.Trace.me(_ary, "Array2", true));
				trace("////////////////// " +  "end section message");
				return true;
			}
			public function test_SOSLogger_BasicData() : Boolean{
				trace("0 " + TraceAdapter + " " + SOSLogger);
				//trace = TraceAdapter.TraceToSOS;
				trace("1");
				logger = SOSLogger.getInstance("TestSOSLogger");
				REQUIRE(logger != null, "Logger Can't be null");
				trace("2");
				logger.log(0, "Hello From SOSLogger");
				trace("3");
				logger.logBreak();
				trace("4");
				var _ary : Array = ["A","B","C","D"];
				trace("5");
				logger.log(0,"Array");
				logger.log(1, _ary.toString());
				logger.logBreak();
		//		logger.log(util.Trace.me(_ary, "Array2", true));
				logger.logBreak();
	//			logger.clearLog();
				return true;
			}
	}
}
