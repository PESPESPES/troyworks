package  { 
	class util.FrameTracker extends MovieClip {
	import flash.display.MovieClip;
		//////////////////////////////////
		// This class is used with linkage ID's
		// in conjunction with the MVC separation
		// when the corresponding clip is placed on the stage
		// it will broadcast an event when it reaches t
		protected function FrameTracker() {
			this.onFrameChanged();
		}
		///////////////////////////////////
		// sets up the linkage between this class and the onstage objecr
		// should be called early on.
		public static function setupLinkage() : void {
			trace("*****************FrameTrackersetupLinkage************************");
			trace("*****************FrameTrackersetupLinkage************************");
			trace("*****************FrameTrackersetupLinkage************************");
			trace("*****************FrameTrackersetupLinkage************************");
			Object.registerClass("FrameTracker", FrameTracker);
		}
		public function onFrameChanged() : void {
			trace("*****************************************");
			trace("**parent "+this.parent+"***** "+this.name+" ***** "+this.parent.currentFrame+"*****************************");
			trace("*****************************************");
			var args = new Object();
			args.parentname = String(this.parent.name);
			args.name = String(this.name);
			args.currentframe = Number(this.parent.currentFrame); 
			//kinda hackish not using a concrete class
			_global.rootCore.createAndAddEvent("FRAMETRACKER", args);
			_global.rootCore.dispatchEvents();
		}
	}
	
}