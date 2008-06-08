package com.troyworks.controls.tmodal { 
	
	/**
	 * @author Troy Gardner
	 */
	public class ModalDialogShield extends BaseComponent {
		protected var mouseOpaque : Boolean = true;
		
		public function ModalDialogShield(initialState : Function, hsmfName : String, aInit : Boolean) {
			super(initialState, "ModalDialogShield", aInit);
		}
	
		public function onLoad():void{
			if(this.mouseOpaque){
				this.useHandCursor = false;
			}else{
				//on full screen zoom in's make the entire screen a button.
				this.useHandCursor = true;
			}
			super.onLoad();
		}
			
		public function onPress():void{
		}
	}
}