package mdl {
	import flash.events.EventDispatcher;
	import flash.events.Event;	

	/**
	 * @author Troy Gardner
	 */
	public class CompositeModel extends EventDispatcher {
		public function CompositeModel() {
			super();
		}
		public function redispatchEvent(evt:Event):void{
			dispatchEvent(evt);
		}
	}
}
