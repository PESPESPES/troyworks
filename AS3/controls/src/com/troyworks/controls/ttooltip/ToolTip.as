package com.troyworks.controls.ttooltip {
	import com.troyworks.framework.ui.BaseComponent; 

	
	/**
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;
	import flash.text.TextField;
	public class ToolTip extends BaseComponent {
		public var label:String = "";
		public var background_mc:MovieClip;
		public var label_txt:TextField;
		
		public function ToolTip(initialState : String, hsmfName : String, aInit : Boolean) {
			super(initialState, hsmfName, true);
		}
		public function hide():void{
		}
		public function show():void{
		}
		public function setLabel(msg:String):void{
			trace("toolTip.setLabel " +msg + " label_txt " + label_txt + " " + label_txt.text);
			label = msg;
			//label_txt.ht
			label_txt.text = msg;
			background_mc.width = label_txt.width + 40;
			background_mc.x = label_txt.x -20;
		}
		public function setX(num:Number):void{
			
		}
		
		
	}
}