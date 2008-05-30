/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.core.time {


	public class MachineClock extends BaseClock{
		
		public function MachineClock(){
			super();
		}
		/**synchronized override
		 * @return The local machine time.
		*/
		override public function time():Date {
			update(new Date().time);
			return super.time();
		}
		
		private function update(newTime : Number) : void {
			_time.time = newTime;
		}

		/**synchronized override
		 * @return The local machine time in milliseconds
		*/
		override public function getTime():int {
			update(new Date().time);
			return super.getTime();
		}

	}
	
}
