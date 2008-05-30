package com.troyworks.controls.tuseridle { 
	/**
	 *  A Utility that watches the mouse and keybaords for event to do something like
	 *  hint or run a attention grabber etc.
	 * @author Troy Gardner
	 */
	import flash.events.Event;	
	import flash.events.KeyboardEvent;	
	import flash.events.MouseEvent;	
	import flash.utils.clearInterval;
	import flash.display.MovieClip;
	import flash.utils.setInterval;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
    
	public class UserIdleTracker extends MovieClip {
		
		public static var USE_IDLE_EVTD:String = "USER_IDLE";
	
		protected var idleTime : Number;
		protected var myTimer:Timer;
				
		public function UserIdleTracker(t:Number = NaN) {
			super();
			t = (isNaN(t))?25:t;
			idleTime = t * 1000;
	        resetTimeOut();
			 myTimer = new Timer(1000, 2);
            myTimer.addEventListener("timer", onTimeout);
            myTimer.start();
	    	stage.addEventListener(MouseEvent.MOUSE_DOWN, resetTimeOut);
	    	stage.addEventListener(MouseEvent.MOUSE_UP, resetTimeOut);
	    	stage.addEventListener(MouseEvent.MOUSE_MOVE, resetTimeOut);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, resetTimeOut);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, resetTimeOut);    
			    
		}
		public function onTimeout() : void {
	       myTimer.stop();
	        trace("idle");
	        // do whatever
		}
	
	 	public function resetTimeOut(evt:Event = null) : void {
	       myTimer.reset();
	       myTimer.start();
	       
		}	
	}
}