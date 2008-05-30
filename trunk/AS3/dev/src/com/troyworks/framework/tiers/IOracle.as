/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.framework.tiers {
	import flash.events.Event;

	public class IOracle {
		public function get oracle():IOracle{
			return null;
		};
		public function dispatchEvent(event:Event);
		public function dispatchRequest();
	}
	
}
