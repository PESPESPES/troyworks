package com.troyworks.framework.ui { 
	import com.troyworks.hsmf.AEvent;
	
	/**
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;
	import flash.text.TextField;
	public class ToolTip extends BaseComponent {
		public var label:String = "";
		public var background_mc:MovieClip;
		public var label_txt:TextField;
		
		public function ToolTip(initialState : Function, hsmfName : String, aInit : Boolean) {
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
		
		/*.................................................................*/
		function s0_viewAssetsLoaded(e : AEvent) : Function
		{
			this.onFunctionEnter ("s0_viewAssetsLoaded-", e, []);
			switch (e.sig)
			{
				case Q_ENTRY_SIG :
				{
					label_txt.autoSize = true;
	
					return null;
				}
			}
			return super.s0_viewAssetsLoaded(e);
		}
		/*.................................................................*/
		function s1_viewCreated(e : AEvent) : Function
		{
			this.onFunctionEnter ("s1_creatingView-", e, []);
			switch(e.sig)
			{
				case Q_ENTRY_SIG :
				{
					isReady = true;
					return null;
				}
			}
			return super.s0_viewAssetsLoaded(e);
		}
	}
}