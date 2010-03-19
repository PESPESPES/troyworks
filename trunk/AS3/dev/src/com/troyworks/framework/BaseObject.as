package com.troyworks.framework { 
	import flash.events.Event;
	import flash.events.IEventDispatcher;
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
	
	public class BaseObject extends EventDispatcher implements IEventDispatcher	{
	
		// REQUIRED by DesignByContract
		public var ASSERT : Function;
		public var REQUIRE : Function;
		public var log:Function;
		public var dispatchEventsEnabled:Boolean = true;

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
		
		override public function dispatchEvent(event : Event) : Boolean {
			// TODO: Auto-generated method stub
			return (dispatchEventsEnabled)? super.dispatchEvent(event):false;
		}		

	}
}