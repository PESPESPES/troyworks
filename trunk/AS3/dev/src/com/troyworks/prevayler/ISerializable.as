/**
* In the prevaylance pattern, both commands/transactions and the business logic classes need to implement this
* for all stateful behavior.
* @author Default
* @version 0.1
*/

package com.troyworks.prevayler {

	public interface ISerializable {
		function saveToMemento(args:*):Object{
			
		}
		function restoreFromMemento(memento:Object):void{
			
		}
	}
	
}
