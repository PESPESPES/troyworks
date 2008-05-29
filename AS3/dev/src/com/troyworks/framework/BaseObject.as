package com.troyworks.framework { 
	/*
	* This serves as a base class for the TroyWorks framework
	* and adds common functionality to most components
	* eventDispatcher this can go away when events are built into every object
	* Some Known extenders
	* 
	*  - ModelObject (unique runtime numeric ID, introspected toString 
	*  - BaseComponent (for UI elements, which adds state/MovieClip related
	*
	
	*
	* @author Troy Gardner
	* @version
	*/
	import com.troyworks.events.TEventDispatcher;
	import com.troyworks.util.DesignByContract;
	
	import flash.display.MovieClip;
	public class BaseObject extends Object
	{
	
		// REQUIRED by DesignByContract
		public var ASSERT : Function;
		public var REQUIRE : Function;
		
		//necessary for the complier,
		public static var evtd :Function = TEventDispatcher;
		
		// REQUIRED by TEventDispatcher
		public var $tevD:TEventDispatcher;
		public var addEventListener : Function;
		public var dispatchEvent : Function;
		public var removeEventListener : Function;
		public var log:Function;
	
		protected static var _className : String = "com.troyworks.framework.BaseObject";
		public function BaseObject ()
		{
		//trace ("BaseObject " );
			
			 ///add in the mixins for ASSERT and REQUIRE
	 		DesignByContract.initialize(this);
	 		// add in support for event dispatching
			TEventDispatcher.initialize(this);
			// add in support for logging
			
		//	log = ApplicationContext.getInstance().getLoggerRef();
		//	_global.ASSetPropFlags (this, "log", 1);
		}
		public function toString():String{
			return _className;
		}
	}
}