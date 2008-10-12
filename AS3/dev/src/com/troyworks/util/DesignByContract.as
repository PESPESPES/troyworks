package com.troyworks.util{
	import flash.events.EventDispatcher;
	import com.troyworks.util.DesignByContractEvent;
	//import com.troyworks.events.TProxy;
	//import com.troyworks.events.TEventDispatcher;
	/*******************************************************
	 * A utility to centralize tests 
	 * thus during debugging there are easy ways to quickly find
	 * where errors are occuring 
	 * 
	 * To add this to your class via a mixin style do the following:
	 * 
	 * 1) In the class variables add:
	 * 
	  // REQUIRED by DesignByContract
	public var ASSERT : Function;
	public var REQUIRE : Function;
	 * 
	 * 2) In the constructor add:
	 * 
	  ///add in the mixins for ASSERT and REQUIRE
	 DesignByContract.initialize(this);
	 *
	 * 3) if you need access to the notification (e.g. to send errors add 
	 *  a function like this
	 *  
	  //*******************************************
	 //* this function is useful for setting breakpoints 
	 //* when an assert or require fails.
	 //*
	public function onAssertFailed(evt:Object) : void{
	trace("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ERROR" +toStringShort() + "  XXXXXXXXXXXXXXXXXX " + util.Trace.me(evt));
	
	if(evt.fatal){
	 (evt.msg); //NOTE that this ERROR will typically 
	}
	}
	 */
	public class DesignByContract extends EventDispatcher {
		public static  var IDz:Number = 0;
		public static  var log : Array = new Array ();



		protected static  var bDescriptionXXX : Object;
		public static  var appIsHalted : Boolean = false;
		public static  var appHaltMessage:String = null;
		public static  var HALT_ON_ERRORS : Boolean = false;

		public static  const EVTD_REQUIRE_FAILED : String = "EVTD_REQUIRE_FAILED";
		public static  const EVTD_ASSERT_FAILED : String = "EVTD_ASSERT_FAILED";
		public static  const REQUIRE_FAILED:String = "REQUIRE FAILED";
		public static  const ASSERT_FAILED:String = "ASSERT FAILED";

		/* used in replacing vars in methods */
		public static  const VAR1:String = "%1";
		public static  const VAR2:String = "%2";
		public static  const VAR3:String = "%3";

		protected static  var instance : DesignByContract;

		public var ID:Number = -1;
		public var myLog : Array = new Array();

		public static  var isDispatching : Boolean = false;

		public function DesignByContract() {
			ID = IDz++;
			trace(" new DesignByContract" + ID);

			///TEventDispatcher.initialize(this);
			//$tevD.debugTracesOn = true;
			addEventListener(DesignByContractEvent.ASSERT_FAILED, this.onAssertFailed);
			addEventListener(DesignByContractEvent.REQUIRE_FAILED,  this.onAssertFailed);
		}
		public function onAssertFailed(e : Object):void {
			//Insert a breakpoint here.
			//trace("!!!!!!!!!!!!!!!!!!!!!!!!! DesignByContract"+ID+" ERROR !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\r" + util.Trace.me(e, e.message) + " fatal?: "+ e.fatal);
			trace("!!!!!!!!!!!!!!!!!!!!!!!!! DesignByContract"+ID+" ERROR !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\r" + e.message + " fatal?: "+ e.fatal);

			if (e !=null && e.fatal && DesignByContract.HALT_ON_ERRORS && !DesignByContract.appIsHalted) {
				DesignByContract.appIsHalted = true;
				DesignByContract.appHaltMessage = e.message;
			}
			//throw new DesignByContractError(e);

		}
		/**
		 * @return singleton instance of DesignByContract
		 */
		public static function getInstance():DesignByContract {
			if (instance == null) {
				instance = new DesignByContract();
			}
			return instance;
		}
		/**
		* mixin/add listening and dispatching methods to an object
		* @param object the object to receive the methods
		*/
		public static function initialize(object : Object):void {
			//trace("HIGHLIGHTP DBC.initialize");
			DesignByContract.REQUIRE(object != null, "DesignByContract.initialize(null), null is invalid argument");

			//var dbc : DesignByContract = new DesignByContract();
			//backup the pointers to the old EventDispatcher
			object.ASSERT = DesignByContract.ASSERT;
			object.REQUIRE = DesignByContract.REQUIRE;
			if (object.hasOwnProperty("onAssertFailed")) {
				DesignByContract.getInstance().addEventListener(DesignByContractEvent.ASSERT_FAILED, object.onAssertFailed);
				DesignByContract.getInstance().addEventListener(DesignByContractEvent.REQUIRE_FAILED, object.onAssertFailed);
			}
			//object.onAssertFailed = TProxy.create(object, DesignByContract.onAssertFailed);
			//hide them in for loops
			//_global.ASSetPropFlags (object, "ASSERT", 1);
			//_global.ASSetPropFlags (object, "REQUIRE", 1);


		}
		public static function ASSERT(test : Boolean, desc : String, aFatal : Boolean = false):Boolean {
			var s:String;
			if (appIsHalted ) {

				s = "*** DBC isHalted ****" + DesignByContract.appHaltMessage ;
				trace(s);
				if (!isDispatching) {
					trace("throwing ASSERT DesignByContractError");
					throw new DesignByContractEvent(s);
				} else {
					return false;
				}
			}
			if ( ! test) {
				s = "*** ASSERT ERROR ****"+ desc + "  failed";
				trace("ASSERT failed: " + s);
				log.push(s);
				isDispatching = true;
				var dbcE:DesignByContractEvent = new DesignByContractEvent(DesignByContractEvent.ASSERT_FAILED);
				dbcE.message = s;
				dbcE.fatal = aFatal;

				DesignByContract.getInstance().dispatchEvent(dbcE);
				isDispatching =false;
				return false;
			}else{
			 	return true;	
			}
		}
		public static function REQUIRE(test : Boolean, desc : String, var1:* = undefined, var2:* = undefined, var3:* = undefined):Boolean {
			var s:String;

			if (appIsHalted) {

				s = "*** DBC isHalted ****"+ DesignByContract.appHaltMessage ;
				trace(s);
				if (!isDispatching) {
					trace("throwing REQUIRE DesignByContractEvent");
					throw new DesignByContractEvent(s);
				} else {
					return false;
				}
			}
			if ( ! test) {

				if (desc == null) {
					s = "ERROR DBC BREAKPOINT";
				} else {
					if (arguments.length>2) {
						desc = desc.split(VAR1).join(arguments[3]);
					}
					if (arguments.length>3) {
						desc = desc.split(VAR2).join(arguments[4]);
					}
					if (arguments.length>4) {
						desc = desc.split(VAR3).join(arguments[5]);
					}

					s = "***REQUIRE ERROR ****"+ desc + " Require failed";
				}
				trace("REQUIRE failed: " + s);
				log.push(s);
				isDispatching = true;
				var dbcE:DesignByContractEvent = new DesignByContractEvent(DesignByContractEvent.REQUIRE_FAILED);
				dbcE.message = s;
				dbcE.fatal = true;

				DesignByContract.getInstance().dispatchEvent(dbcE);
				isDispatching = false;
				return false;
			}else{
			 	return true;	
			}

		}
		public static function toString():String {
			return "DesignByContractLog:\r\t" + log.join("\r\t");
		}
		public static function clearLog():void {
			log = new Array();
		}
	}
}