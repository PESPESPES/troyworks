package com.troyworks.util {

	/**
	 *  A utility to package up extra parameters and pass them on to a function closure
	 *  either appending the passed in arguments, or just calling back with original, 
	 *  returning the result, making this a good abstraction point.
	 *  
	 *  It's a fullblown class so that references to this can be retargetted or in the
	 *  case of event listeners added/removed as needed.
	 *  
	 *  
	 *  The later is useful
	 *  
	 * Refs:
	 * http://www.person13.com/articles/proxy/Proxy.htm
	 * http://wildwinter.blogspot.com/2007/04/come-back-delegate-all-is-forgiven.html
	 * 
	 * and also similar classes 
	 * com.troyworks.core.EventAdapter and EventProxyOptionalArgs
	 * 
	 * @author Troy Gardner, Ian Thomas, Joey Lott
	 *
	 *Given this test function 
	 *   function sayHi(target:Object = null, opt2:Object = ""):void {
	trace("sayHi " + target + " " + opt2);
	}
	var sayHiProxy = new FunctionProxy(sayHi);
	sayHiProxy.callWithAppended();// "sayHi null"
	sayHiProxy.callWithAppended("fromMe");  //sayHi fromMe
	sayHiProxy.callWithOriginal("fromMe"); //sayHi   
       
	// CASE 1:
	var sayHiProxy = new FunctionProxy(sayHi, null);
	sayHiProxy.callWithAppended();// "sayHi  null"
	sayHiProxy.callWithAppended("fromMe");  //sayHi fromMe null
	sayHiProxy.callWithOriginal("fromMe"); //sayHi
	// CASE 1:
	var sayHiProxy = new FunctionProxy(sayHi, "callbackParam");
	sayHiProxy.callWithAppended();// "sayHi  "callbackParam"
	sayHiProxy.callWithAppended("fromMe");  //sayHi fromMe "callbackParam"
	sayHiProxy.callWithOriginal("fromMe"); //sayHi    "callbackParam"
     
	 */

	
	public class FunctionProxy {

		public var args : Array;
		public var fn : Function;

		public function FunctionProxy(fn : Function,...args) {
			//		trace("new Function Proxy " + args.length);
			this.fn = fn;
		//	trace("args " + args.length + " " + args + " " + args[0]);
			this.args = (args.length == 0) ? null : args.concat();
		}

		public function callWithAppended(...innerArgs) : * {
		//	trace("innerArgs " + innerArgs);
		//	trace("args " + args);
			if(args == null) {
				//no extra args
		//		trace("no extra args");
				return fn.apply(null, innerArgs);
			}else {
				//passed extra args
		//		trace("passed extra args");
				//NOte this is kinda slow due to the array manipulation overhead
				return fn.apply(null, innerArgs.concat(args));
			}
		}

		/* this calls back the function with the original arguments passed in
		 * ignoring the arguments passed in this time, rather 
		 * versus appending the passed in values.
		 * 
		 * This is useful for adapting MouseClicks to function calls.
		 */
		public function callWithOriginal(...innerArgs) : * {
		//	trace("callWithOriginal.....");
		//	trace("ignoring innerArgs " + innerArgs);
		//	trace("args " + args);
			if(args == null) {
				//no extra args
		//		trace("no args");
				return fn.apply(null, []);
			}else {
				//passed extra args
		//		trace("has original args " + args + " " + args.length + " " + args[0].name);
				return fn.apply(null, args);
			}
		}

		public static function create(fn : Function,...args) : Function {
			//note passing...args into the following 'wraps' the args in another args
			var res : FunctionProxy = new FunctionProxy(fn);
			//don't change the following!
			res.args = args;
			return res.callWithAppended;
		}

		
		public static function createCallback(fn : Function,...args) : Function {
		//	trace("createCallback " + args.length + " " + args[0].name);
			//note passing...args into the following 'wraps' the args in another args
			var res : FunctionProxy = new FunctionProxy(fn);
			//don't change the following!
			res.args = args;
			return res.callWithOriginal;
		}
	}
}
