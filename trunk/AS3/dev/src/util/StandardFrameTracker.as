package  { 
	class util.StandardFrameTracker extends MovieClip {
	import flash.display.MovieClip;
		//////////////////////////////////
		// This class is used with linkage ID's
		// in conjunction with the MVC separation
		// when the corresponding clip is placed on the stage
		// it will broadcast an event when it reaches the appropriate frame
		protected function StandardFrameTracker() {
			trace("new StandardFrameTracker");
		}
		public function onLoad ():void{
			trace("*****************************************");
			trace("**parent "+this.parent+"***** "+this.name+" ***** "+this.parent.currentFrame+"*****************************");
			trace("*****************************************");
			var args = new Object();
			args.parentname = String(this.parent.name);
			args.name = String(this.name);
			args.currentframe = Number(this.parent.currentFrame); 
			this.parent.onReachedFrame(args);
		}
		///////////////////////////////////
		// sets up the linkage between this class and the onstage objecr
		// should be called early on.
		public static function setupLinkage():void {
			trace("*****************StandardFrameTrackersetupLinkage************************");
			Object.registerClass("util.StandardFrameTracker", StandardFrameTracker);
		}
	
	}
	
}