package  { 
	import com.troyworks.hsmf.AEvent;
	/**
	 * @author Troy Gardner
	 */
	interface com.troyworks.framework.events.IEventOracle {
	
		public function Q_dispatch(evt:AEvent):void;
	}
}