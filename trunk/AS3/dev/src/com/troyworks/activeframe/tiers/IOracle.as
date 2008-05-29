/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.activeframe.tier {
	import flash.events.Event;

	public class IOracle {
		public function get oracle():IOracle;
		public function dispatchEvent(event:Event);
		public function dispatchRequest();
	}
	
}
