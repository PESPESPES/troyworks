package com.troyworks.data.btree { 
	///////////////////////////////////////////////////
	// Class definition for a key page in the bTree
	///////////////////////////////////////////////////
	class bTreeKeyPage {
		public static var MAXKEYS:Number = 4;
		public var numKeys:Number;
		//bTreeKey[]
		public var keyArray:Array;
		//bTreeKeyPage array
		public var pageArray:Array;
		//object Array
		public var dataArray:Array;
		// Constructor
		public function bTreeKeyPage() {
			numKeys = 0;
			// No keys on page yet
			// Pre-allocate the arrays -
			// but for now they're all NULL
	//		keyArray = new bTreeKey[MAXKEYS]();
	//		pageArray = new bTreeKeyPage[MAXKEYS+1]();
	//		dataArray = new Object[MAXKEYS]();
			keyArray = new Array(MAXKEYS);
			pageArray = new Array(MAXKEYS+1);
			dataArray = new Array(MAXKEYS);
		}
		// search
		// Given a btreekey object, search
		// for that object on this page.
		// Returns loc.
		// If loc>=0 then the key was found
		// on this page and loc is index of
		// located key. If loc<\<>0 then the key
		// was not found on this page and
		// abs(loc)-1 is index of where the
		// key SHOULD be.
		public function search(targetKey:bTreeKey):Number {
			var lo:Number = 0;
			var hi:Number = this.numKeys-1;
			var mid:Number = 0;
			if (keyArray[lo].compare(targetKey)>0) {
				return (-1);
			}
			do {
				mid = parseInt(String((lo+hi)/2));
				if (keyArray[mid].compare(targetKey) == 0) {
					return (mid);
				}
				if (keyArray[mid].compare(targetKey)>0) {
					hi = mid-1;
				} else {
					lo = mid+1;
				}
			} while (lo<=hi);
			return (-lo-1);
		}
		// insert
		// Insert the btreekey object  and data
		// object at index. Everything on page
		// is slid "to the right" to make space.
		// numKeys is incremented
		public function insert(newKey:bTreeKey, newData:Object, index:Number):void {
			// If adding to right, no moving to do
			trace("insert at " + index);
			if (index<numKeys) {
				// Shuffle up
				for (var i = numKeys-1; i>=index; i--) {
					keyArray[i+1] = keyArray[i];
					pageArray[i+2] = pageArray[i+1];
					dataArray[i+1] = dataArray[i];
				}
			}
			// Insert new items
			keyArray[index] = newKey;
			dataArray[index] = newData;
			numKeys++;
		}
		// delete
		// Delete the btreekey reference,
		// keypage reference, and data
		// reference at index. Everything
		// on page is slid "to the left"
		// numKeys is decremented
		public function deleteAt(index:Number):void {
			// If rightmost key..nothing to do
			if (index<numKeys-1) {
				// Shuffle down
				for (var i = index; i<numKeys; i++) {
					keyArray[i] = keyArray[i+1];
					pageArray[i+1] = pageArray[i+2];
					dataArray[i] = dataArray[i+1];
				}
			}
			// Decrement key count and null
			// rightmost item on node
			numKeys--;
			keyArray[numKeys] = null;
			pageArray[numKeys+1] = null;
			dataArray[numKeys] = null;
		}
	}
	
}