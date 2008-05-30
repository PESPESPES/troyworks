/**
* Implementors of this class provide methods to save and restore their values 
* from a byte Array stream.
* 
* Typical use is from a class that implements native serialization or provides a memento of sorts that
* can write/read from the stream.
* 
* In the prevaylance pattern, both commands/transactions and the business logic classes need to implement this
* for all stateful behavior.
* 
* @author Default
* @version 0.1
*/

package com.troyworks.core.persistance {
	import flash.utils.ByteArray;

	public interface IExternalizable {
		 function saveExternal(byteAry:ByteArray);
		 function readExternal(byteAry:ByteArray);
	}
	
}
