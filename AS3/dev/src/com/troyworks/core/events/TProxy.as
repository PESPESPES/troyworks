package com.troyworks.core.events {
	import com.troyworks.util.Trace; 
	import com.troyworks.util.DesignByContract;
	/**
	 * 
	 * @see <a href="http://www.person13.com/">Joey Lott</a>
	 * @author Troy Gardner @author Joey Lott
	 */
	public class TProxy {
	  public static var IDz:Number = 0;
	  public static var DEBUG_TRACES_ON:Boolean = false;
	  public static var currentUserName:String = "unnamed";
	  public static var className:String = "TProxy";
	  public static var ASSERT:Function = DesignByContract.ASSERT;
	  public static var REQUIRE:Function= DesignByContract.REQUIRE;
		/* ignoreCallbackParams is useful for when you are using things like Tweens whose callbacks
		 * send the calling function, displacing the usr event originally passed in.*/
		public static var IgnoreCallbackParams : Boolean = false;
	  /**********************************************************
	   * Similar to Delegate.create, this accepts an object and a function as well 
	   * as an arbitrary number of arguments to append to the end of whatever
	   * the caller of the proxy passes to it.
	   * 
	   * e.g.
	   * TProxy.create(obj, obj.callback, "A","B","C")
	   * 
	   * this is based on Joey Lott's approach with several changes
	   * 
	   * NOTE: caller and callee refer to this Proxy not the originating 
	   * calling class, if needed pass in the caller via the parameters
	   * (this is how it works in AS3.0 as well).
	   * 
	   * This is especially useful if your object has a public non-static className property
	   * for when things go wrong.
	   * 
	   * e.g.
	   *  	public static var CLASSNAME:String = "com.troyworks.events.TEventDispatcher";
			public var className:String = CLASSNAME;
	   * 
	   * 
	   */
	  public static function create(aScopeObj:Object, fFunction:Function):Function {
	    var id:Number = TProxy.IDz++; 
	    if(!DesignByContract.isDispatching){
	    REQUIRE(DesignByContract.appIsHalted == false, "TProxy ignoring, fix previous errors first");
	    }
		REQUIRE(aScopeObj != null,currentUserName + ":TProxy " + id +" aScope cannot be null");
		REQUIRE(fFunction != null,currentUserName + ":TProxy " + id +" must have a valid function to call, cannot be null " + Trace.me(aScopeObj,"aScopeObj",false));
		REQUIRE(fFunction is Function,currentUserName + ":TProxy " + id +" tFunction must be of type function");
		/////// parse the user parameters, removing the object and target
	    var aUsrParams:Array = new Array();
	    for(var i:Number = 2; i < arguments.length; i++) {
	      aUsrParams[i - 2] = arguments[i];
	   }
		var usrName:String = String(TProxy.currentUserName);
		var debugTracesOn:Boolean = new Boolean(TProxy.DEBUG_TRACES_ON);
		var ignoreParams:Boolean = new Boolean(TProxy.IgnoreCallbackParams);
		/////// Create proxy object////////////
		// note that the objects are passed in
		// from the above
	    var fProxy:Function = function():Object {
	    if(!DesignByContract.isDispatching&& DesignByContract.appIsHalted){
	    	return null;
	 //   DesignByContract.REQUIRE(DesignByContract.appIsHalted == false, "TProxy ignoring, fix previous errors first");
	    }  	
	      var aActualParameters:Array = (ignoreParams == true)?aUsrParams: arguments.concat(aUsrParams);
	      if(debugTracesOn == true){
	      	var t:Array = new Array();
	     	t.push("************** TPROXY:"+ id + " CALLBACK for "  + usrName+ " ********************** HIGHLIGHTO");
	     	t.push("************** aScopeObj:"+ aScopeObj + " **********************");
	      	t.push("**************** with " + aActualParameters.length + " total params, of which " + aUsrParams.length +" are USR params ************************");
	      	if(aActualParameters.length >0){
	      		t.push(Trace.me(aActualParameters, "Params", false));
	      	}
	      	trace(t.join("\r"));
	      }
	      //trace("adding Callee2? " + addCallee + " isFalse" + + " " + + (addCallee=="true"));
	  
	      return fFunction.apply(aScopeObj, aActualParameters);
	    };
	       if(debugTracesOn == true){
	       	var t:Array = new Array();
	      	t.push("................ TPROXY:"+ id + " CREATED for " + TProxy.currentUserName+".....................HIGHLIGHTV");
	      	t.push("................ with " + aUsrParams.length + " User params: .......................");  
	      	if(aUsrParams.length >0){
	      		t.push(Trace.me(aUsrParams, "Usr Params", false));
	      	}
	      	trace(t.join("\r"));
	      }
	    //////// append them to the Object (the power of prototyping)
	    // save them later so we can use them for removing during collection
	    // eg. in TDispatcher
	    fProxy.id = id;
	    fProxy.obj = aScopeObj;
	    fProxy.fn = fFunction;
	    fProxy.rcallee = arguments.callee; 
	 	// fProxy.rcaller = arguments.caller; // NO longer supported in AS3
	    fProxy.typeName = className;
	
	    return fProxy;
	
	  }
	}
	
	
}