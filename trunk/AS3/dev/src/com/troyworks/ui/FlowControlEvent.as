/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.ui {
	import flash.events.Event;	

	public class FlowControlEvent extends Event {
		public var frameLabel:String;
		public var frameNumber:Number;
		public static  const ENTERED_FRAME_LABEL : String = "ENTERED_FRAME_LABEL";
		public static  const LEFT_FRAME_LABEL :  String = "LEFT_FRAME_LABEL";
		public static  const REQUESTED_FRAME_LABEL : String = "REQUESTED_FRAME_LABEL";
			public static  const REQUESTED_FRAME_NUMBER : String = "REQUESTED_FRAME_NUMBER";
		
		//public var frameNumber:Numb
		public function FlowControlEvent(msg:String = ENTERED_FRAME_LABEL,bubbles:Boolean=false, cancelable:Boolean=false) {
			super(msg, bubbles, cancelable);
		}
	}
}
