package com.troyworks.framework.ui { 
	import com.troyworks.util.DesignByContract;
	import com.troyworks.util.DesignByContractError;
	import com.troyworks.events.EVTD;
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
			
			inst.addEventListener(DesignByContract.EVTD_ASSERT_FAILED, this, this.onAssertFailed);
			inst.addEventListener(DesignByContract.EVTD_REQUIRE_FAILED, this, this.onRequireFailed);
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