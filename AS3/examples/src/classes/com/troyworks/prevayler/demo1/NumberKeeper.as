/**
 * The NumberKeeper and all its references are the prevalent system.
 * i.e: They are the "business objects" and will be transparently persisted by Prevayler.

* @author Default
* @version 0.1
*/

package com.troyworks.prevayler.demo1 {

	public class NumberKeeper {
		
		private var _numbers:Array = new Array();
		
		public function NumberKeeper() {
			
		}
		public function numbers():Array{
			return _numbers;
		}
		protected function keep(nextNumber:int):void{
			_numbers.push(nextNumber);
		}
		public function lastNumber():int{
			return (_numbers.length == 0)? 0: int(_numbers[_numbers.length-1]);
		}
		
	}
	
}
