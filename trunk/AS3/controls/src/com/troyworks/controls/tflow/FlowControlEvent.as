package com.troyworks.controls.tflow {
	import flash.events.Event;

	/**
	 * FlowControlEvent
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Nov 25, 2008
	 * DESCRIPTION ::
	 *
	 */  

	public class FlowControlEvent extends Event {
		public var frameLabel : String;
		public static  const ENTERED_FRAME_LABEL : String = "ENTERED_FRAME_LABEL";
		public static  const LEFT_FRAME_LABEL : String = "LEFT_FRAME_LABEL";

		
		//public var frameNumber:Numb
		public function FlowControlEvent(msg : String = ENTERED_FRAME_LABEL,bubbles : Boolean = false, cancelable : Boolean = false) {
			super(msg, bubbles, cancelable);
		}
	}
}
