package com.troyworks.framework.ui { 
	/**
	 *  A Utility that watches the mouse and keybaords for event to do something like
	 *  hint or run a attention grabber etc.
	 * @author Troy Gardner
	 */
	import flash.utils.clearInterval;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.display.MovieClip;
	import flash.utils.setInterval;
	public class UserIdleTracker extends MovieClip {
		
		public static var USE_IDLE_EVTD:String = "USER_IDLE";
	
		protected var idleTime : Object;
	
		protected var idleID : Object;
		public function UserIdleTracker(t:Number) {
			super();
			t = (t== null)?25:t;
			idleTime = t * 1000;
	        idleID = -1;
	        onEventHandler();
	        onMouseDown =
	        onMouseUp = 
	        onMouseMove = 
	        onKeyDown = 
	        onKeyUp = 
	        onEventHandler;
	    	Mouse.addListener(this);
			Keyboard.addListener(this);    
		}
		public function onTimeout() : void {
	        clearInterval(this.idleID);
	        this.idleID = 0;
	
	        trace("idle");
	        // do whatever
		}
	
	 	public function onEventHandler() : void {
	        clearInterval(this.idleID);
	        this.idleID = setInterval(this, "timeout", this.idleTime);
		}	
	}
}