package com.troyworks.controls.tflow {
		
	
	import flash.text.TextField;	
	
	import com.troyworks.ui.FlowControl;
	
	/**
	 * TFlowControl
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Aug 20, 2008
	 * DESCRIPTION ::
	 *
	 */
	dynamic public class TFlowControl extends FlowControl {
		public var flowControlNavStyle:TextField;
		public function TFlowControl() {
			super();
		}
		
		override public function setupNav():void{
						//TODO fix the navigator
			if(flowControlNavStyle != null) { 
				debuggerUI_mc = new FlowControlNavigator(view, flowControlNavStyle);
				debuggerUI_mc.name = "debuggerUI_mc";
				debuggerUI_mc.x = 0;
				debuggerUI_mc.y = 0;
				view.parent.addChild(debuggerUI_mc);
			}
			
		}
			
	}
}
