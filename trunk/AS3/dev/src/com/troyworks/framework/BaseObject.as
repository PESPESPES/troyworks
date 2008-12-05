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
	import com.troyworks.util.DesignByContract;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	public class BaseObject extends EventDispatcher
	{
	
		// REQUIRED by DesignByContract
		public var ASSERT : Function;
		public var REQUIRE : Function;
		public var log:Function;

		public function BaseObject ()
		{
			super();
			//trace ("BaseObject " );
			 ///add in the mixins for ASSERT and REQUIRE
	 		DesignByContract.initialize(this);
			
			log = ApplicationContext.getInstance().getLoggerRef();
		}
		override public function toString():String{
			return getQualifiedClassName(this);
		}
	}
}