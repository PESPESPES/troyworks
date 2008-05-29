package{
		import flash.events.*;
		import flash.display.MovieClip;

	public class LateViewBinding extends MovieClip{
		
		public function LateViewBinding(){
			trace("stage " + stage);
			addEventListener(Event.ADDED_TO_STAGE,addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE,removedFromStage);
			addEventListener(Event.ADDED,addedTo);
			addEventListener(Event.REMOVED,removedFrom);

		}
		function addedToStage(event:Event):void {
			trace("addedToStage " + event.target);
		}
		function removedFromStage(event:Event):void {
			trace("removedFromStage " + event.target);
		}
		function addedTo(event:Event):void {
			trace("addedTo " + event.target);
		}
		function removedFrom(event:Event):void {
			trace("removedFrom " + event.target);
		}

	}
}