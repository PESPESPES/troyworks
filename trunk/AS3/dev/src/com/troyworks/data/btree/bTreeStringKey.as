package com.troyworks.data.btree { 
	//String Keyboard
	//Listing 3. This class implements the bTreeKey interface and defines a key that is a simple String datatype.
	// Class for implementing a key
	// that's a String
     class bTreeStringKey implements bTreeKey {
		public var key:String;
		// The key element
		// Comparison method
		public function bTreeStringKey(key:String){
	       this.key = key;		
		}
		public function compare(thatkey:bTreeKey):Number {
			var s:String = String(thatkey.getKey());
			if (key<s) {
				return -1;
			} else if (s<key) {
				return 1;
			} else {
				return 0;
			}
		}
		// Return reference to key object
		public function getKey():Object {
			return (this.key);
		}
		// Return reference to key object
		public function toString():String {
			return this.key;
		}
	}
	
}