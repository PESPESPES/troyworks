package com.troyworks.controls.tmodal {
	import com.troyworks.util.DesignByContractEvent; 
	import com.troyworks.util.DesignByContract;
	/**
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;
	import flash.text.TextField;
	public class DebugErrorStatusModalDialog extends MovieClip {
	
		public var status_txt:TextField;
		
		public function onLoad():void{
	//		trace("DebugErrorStatusModalDialog.onLoad");
			 visible = DesignByContract.appIsHalted ;
			 status_txt.text ="Fatal Error:\r" + DesignByContract.appHaltMessage;
			var inst:DesignByContract = DesignByContract.getInstance();
			
			inst.addEventListener(DesignByContractEvent.ASSERT_FAILED,  this.onAssertFailed);
			inst.addEventListener(DesignByContractEvent.REQUIRE_FAILED,  this.onRequireFailed);
		}
		public function onAssertFailed(e:Object):void{
			//visible = true;
		}
		public function onRequireFailed(e:Object):void{
		//	trace("DebugErrorStatusModalDialog.onRequireFailed");
			visible = true;
			status_txt.text = e.msg;
	
		}
	}
}