package com.troyworks.framework.loader {
	import com.troyworks.core.chain.UnitOfWork;	

	import flash.text.TextFieldAutoSize;	
	import flash.text.TextField;	

	import com.troyworks.core.events.PlayheadEvent;	
	import com.troyworks.framework.loader.TextLoaderUnit;

	import flash.events.Event;

	/**
	 * EngineLoaderConfigurationLoader
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Jun 23, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class EngineLoaderConfigurationLoader extends TextLoaderUnit {
		public function EngineLoaderConfigurationLoader(initState : String = "s__haventStarted", aMode : Boolean = SEQUENTIAL_MODE) {
			super(initState, aMode);
		}

		override public function completeLoadedHandler(event : Event) : void {			
			////////// TODO LAYOUT //////////////////

			var clip : TextField = new TextField();
			var engines : Array = new Array();
			
			var ary : Array = String(event.target.data).split(",");
			clip.text = ary.join(":");
			
			clip.autoSize = TextFieldAutoSize.CENTER;
			clip.x = Math.random() * 50;
			clip.y = Math.random() * 50;
			clip.alpha = .3;
			targetClip.addChild(clip);
			
						var par : UnitOfWork = getParentTask() as UnitOfWork;
			  
			var i : int = 0;
			var n : int = ary.length;
			var 	chainA : UnitOfWork = UnitOfWork.makeParallelWorker();	
			  
			for (;i < n; ++i) {
				trace("HIGHLIGHTR + " +i + "/ " + n + " = " + ary[i]);
			  	try{
				var chainA1:SWFLoaderUnit = new SWFLoaderUnit();
				chainA1.targetClip = targetClip;
				chainA1.mediaURL = ary[i];					
			//	chainA.addChild(chainA1);
				par.addChild(chainA1);  
			
			  	} catch(err:Error){
						trace("ERROR" + err.getStackTrace());			  		
			  	}
			}
//			par.addChild(chainA);  
			
			
			dispatchEvent(new PlayheadEvent(EVT_COMPLETE));
			

			  	  
			  
			//dispatchEvent(event);
		}
	}
}
