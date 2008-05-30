/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.ui {
	import flash.events.Event;	

	public class SketchEvent extends Event {
		public var frameLabel:String;
		public static  const ENTERED_FRAME_LABEL : String = "ENTERED_FRAME_LABEL";
		public static  const LEFT_FRAME_LABEL :  String = "LEFT_FRAME_LABEL";
		
		
		//public var frameNumber:Numb
		public function SketchEvent(msg:String = ENTERED_FRAME_LABEL,bubbles:Boolean=false, cancelable:Boolean=false) {
			super(msg, bubbles, cancelable);
		}
	}
}
