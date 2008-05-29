/**
 * To change the state of the business objects, the client code must use a Transaction like this one.
* @author Default
* @version 0.1
*/

package com.troyworks.prevayler.demo1 {
//	import Date;
	import com.troyworks.prevayler.Transaction;
	
	public class NumberStorageTransaction implements Transaction {
		
		private var _numberToKeep:int;
		
		public function NumberStorageTransaction(numberToKeep:int)  {
				_numberToKeep = numberToKeep;
		}
		public function executeOn(prevalentSystem:Object, ignored:Date):void{
			NumberKeeper(prevalentSystem).keep(_numberToKeep);
		}
	}
	
}
