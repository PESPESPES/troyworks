package com.troyworks.framework.frametracker { 
	/**
	 * This class is bound to movie clips on stage, and detects the name of the event
	 * 
	 * This is typically subclassed by application specific events on given frames
	 * to notify the engine what to do, this enabled non-scriptors to communicate with 
	 * the API.
	 * 
	 * @author Troy Gardner
	 */
	
	import com.troyworks.hsmf.AEvent;
	import com.troyworks.hsmf.Signal;
	import com.troyworks.framework.Application;
	import com.troyworks.spring.Factory;
	import com.troyworks.framework.events.IEventOracle;
	import com.troyworks.hsmf.Hsmf;
	import com.troyworks.framework.logging.SOSLogger;
	import com.troyworks.framework.logging.ILogger;
	import com.troyworks.framework.logging.Logger;
	import com.troyworks.framework.logging.LogLevel;
	import flash.display.MovieClip;
	public class FrameTracker extends MovieClip{
		public var evt:AEvent;
		public var logger:ILogger;
		//this has issues during the casting from the oracle, as is a MovieClip and it seems to lose it's link to 
		// the interfaces it implmeents.
		public var oracle:Object; //AEventOracle;
		public static var SINGLE_EVENT:Number = 1;
		public static var DUAL_EVENT:Number =2;
		public var mode:Number = FrameTracker.SINGLE_EVENT;
		//
		public var evt_name:String;
		public var evt2_name:String;
		
		protected static var _a:Object = IEventOracle;
		
		//////////////////////////////////
		// This class is used with linkage ID's
		// in conjunction with the MVC separation
		// when the corresponding clip is placed on the stage
		// it will broadcast an event when it reaches t
		protected function FrameTracker() {
			super();
	
			this.logger = ILogger(Factory.getImplementor("Logger"));
			this.logger.logLevel(LogLevel.INFO ,"new FrameTrackerfffffffffffffffffffff");
			Factory.listRegistrants();
			//var o = Factory.getImplementor("Oracle");
			//var io = AEventOracle(io); //RETURNS NULL!!! 
			//trace(AEventOracle + "o " + o + " io " + io);
			this.oracle =Factory.getImplementor("Oracle");
					this.logger.log("FT Factory? oracle?" + this.oracle);
		}
		public function onLoad():void{
			this.onFrameChanged(true);
		}
		public function onUnload():void{
			if(this.mode == FrameTracker.DUAL_EVENT){
				this.onFrameChanged(false);	
			}
		}
		///////////////////////////////////
		// sets up the linkage between this class and the onstage objecr
		// should be called early on.
		public static function setupLinkage() : void {
			Object.registerClass("FrameTracker", FrameTracker);
		}
	
		public function onFrameChanged(enter:Boolean) : void {
			this.logger.logLevel(LogLevel.INFO , "*****************************************");
			this.logger.logLevel(LogLevel.INFO ,"FrameTracker evt_name " + this.evt_name +  " " + enter);
			this.logger.logLevel(LogLevel.INFO ,"**parent "+this.parent+"***** "+this.name+" ***** "+this.parent.currentFrame+"*****************************");
			this.logger.logLevel(LogLevel.INFO ,"*****************************************");
			var evt:AEvent = new AEvent();
			evt.sig = Hsmf.USER_SIG;
			var args = new Object();
			args.parentname = String(this.parent.name);
			args.target = this.parent;
			args.name = ((this.evt_name!=null)?String(this.evt_name):String(this.name))+((enter)?"":"ed");
			args.currentframe = Number(this.parent.currentFrame); 
			evt.args = args;
			this.oracle.dispatch(evt);	
		}
	
	}
}