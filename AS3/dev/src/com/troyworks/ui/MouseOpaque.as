package com.troyworks.ui { 
	/**
	 * @author Troy Gardner
	 */
	import flash.ui.Mouse;
	import flash.display.MovieClip;
	public class MouseOpaque extends MovieClip{
	
		protected var mouseOpaque : Boolean = true;
		public function MouseOpaque() {
			
		}
		public function onLoad():void{
			if(this.mouseOpaque){
				this.useHandCursor = false;
			}else{
				//on full screen zoom in's make the entire screen a button.
				this.useHandCursor = true;
			}
		}
			
		public function onPress():void{
		}
	}
	
}