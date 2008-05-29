package com.troyworks.datastructures.btree { 
	/********
	*Btree-Grehan	January 2002 issue	Java Pro magazine	©2002 Fawcette Technical Publications
	*
	*
	* Btree code This is the source code for the B-tree. Routines provided allow for adding key/objects, deleting, searching, and traversing the tree in both directions.
	*/
	import flash.ui.Keyboard;
	public class bTree {
		//public static int BOF = 1;
		//public static int EOF = 2;
		//public static int NOTFOUND = 3;
		//public static int ALREADYEXISTS = 4;
		//public static int STACKERROR = 5;
		//public static int TREEERROR = 6;
		//public static int MAXSTACK = 8;
		public static var BOF:Number = 1;
		public static var EOF:Number = 2;
		public static var NOTFOUND:Number = 3;
		public static var ALREADYEXISTS:Number = 4;
		public static var STACKERROR:Number = 5;
		public static var TREEERROR:Number = 6;
		public static var MAXSTACK:Number = 8;
		/*	public String name;
			public bTreeKeyPage root;
			public int numKeys;
			public bTreeKeyPage currentPage;
			public int currentIndex;
			public bTreeKey currentKey;
			public Object currentObject;
			public bTreeKeyPage[] keyPageStack;
			public int[] indexStack;
			public int stackDepth;
			public boolean atKey;
		*/
		public var name:String;
		public var root:bTreeKeyPage;
		public var numKeys:Number = 0;
		public var currentPage:bTreeKeyPage;
		public var currentIndex:Number;
		public var currentKey:bTreeKey;
		public var currentObject:Object;
		public var keyPageStack:Array;
		public var indexStack:Array;
		public var stackDepth:Number;
		public var atKey:Boolean;
		public function bTree(newName:String) {
			name = newName;
			//keyPageStack = new bTreeKeyPage[MAXSTACK]();
			//indexStack = new Array[MAXSTACK]();
			keyPageStack = new Array(MAXSTACK);
			indexStack = new Array(MAXSTACK);
		}
		// Return data Object if found.
		// Null otherwise.
		//  currentPage, currentIndex set
		public function seek(targetKey:bTreeKey):Object {
			if (search(targetKey) == true) {
				setCurrent();
				return (currentObject);
			} else {
				return (null);
			}
		}
		// Add key/data object to tree
		//  Return 0 if ok, <>0 if error
		public function addItem(newKey:bTreeKey, newObject:Object):Number {
			var i, j, k:Number;
			var split:Boolean;
			var saveKey:bTreeKey = null;
			var saveObject:Object = null;
			var savePagePointer:bTreeKeyPage = null;
			var leftPagePtr:bTreeKeyPage = null;
			var rightPagePtr:bTreeKeyPage = null;
			atKey = true;
			// If tree is empty, make a root
			if (numKeys == 0) {
				root = currentPage=new bTreeKeyPage();
				currentIndex = 0;
				root.insert(newKey, newObject, currentIndex);
				numKeys++;
				return (0);
			}
			if (search(newKey) == true) {
				return (ALREADYEXISTS);
			}
			do {
				split = false;
				// About to insert key. See if the
				// page is going to overflow
				if ((i=currentPage.numKeys) == bTreeKeyPage.MAXKEYS) {
					// Save rightmost key/data/pointer
					split = true;
					i--;
					if (currentIndex == bTreeKeyPage.MAXKEYS) {
						saveKey = newKey;
						saveObject = newObject;
						savePagePointer = rightPagePtr;
					} else {
						saveKey = currentPage.keyArray[i];
						saveObject = currentPage.dataArray[i];
						savePagePointer = currentPage.pageArray[i+1];
					}
				}
				// Insert key/object at
				// current location
				if (currentIndex != bTreeKeyPage.MAXKEYS) {
					currentPage.insert(newKey, newObject, currentIndex);
					currentPage.pageArray[currentIndex] = leftPagePtr;
					currentPage.pageArray[currentIndex+1] = rightPagePtr;
				}
				if (split == false) {
					numKeys++;
					return (0);
				}
				// Split has occurred.
				// Pull the middle key out
				i = parseInt(String(bTreeKeyPage.MAXKEYS/2));
				newKey = currentPage.keyArray[i];
				currentPage.keyArray[i] = null;
				newObject = currentPage.dataArray[i];
				currentPage.dataArray[i] = null;
				leftPagePtr = currentPage;
				// Create new page for the right
				// half of the old page and move
				// right half in
				// (Note that since we are dealing
				// with object references, we HAVE
				// to graphics.clear them from the old page,
				// or we might leak objects.)
				rightPagePtr = new bTreeKeyPage();
				k = 0;
				for (j=i+1; j<bTreeKeyPage.MAXKEYS; j++) {
					rightPagePtr.pageArray[k] = currentPage.pageArray[j];
					currentPage.pageArray[j] = null;
					rightPagePtr.keyArray[k] = currentPage.keyArray[j];
					currentPage.keyArray[j] = null;
					rightPagePtr.dataArray[k] = currentPage.dataArray[j];
					currentPage.dataArray[j] = null;
					k++;
				}
				rightPagePtr.pageArray[k] = currentPage.pageArray[bTreeKeyPage.MAXKEYS];
				rightPagePtr.keyArray[k] = saveKey;
				rightPagePtr.dataArray[k] = saveObject;
				rightPagePtr.pageArray[k+1] = savePagePointer;
				leftPagePtr.numKeys = i;
				rightPagePtr.numKeys = bTreeKeyPage.MAXKEYS-i;
				// Try to pop. If we can't pop, make
				//  a new root
			} while (pop() == true);
			root = currentPage=new bTreeKeyPage();
			currentIndex = 0;
			root.insert(newKey, newObject, currentIndex);
			root.pageArray[0] = leftPagePtr;
			root.pageArray[1] = rightPagePtr;
			numKeys++;
			return (0);
		}
		// Remove key/data object
		//  Return 0 if ok, <>0 if error
		public function removeItem(newKey:bTreeKey):Number {
			var reSeek:Boolean = false;
			var tpage:bTreeKeyPage;
			var tindex:Number;
			var leftPage:bTreeKeyPage;
			var rightPage:bTreeKeyPage;
			// Is the key there?
			if (search(newKey) == false) {
				return (NOTFOUND);
			}
			while (true) {
				// If either left or right pointer
				// is null, we're at a leaf or a
				// delete is percolating up the tree
				// Collapse the page at the key
				// location
				if ((currentPage.pageArray[currentIndex] == null) || (currentPage.pageArray[currentIndex+1] == null)) {
					// Save non-null pointer
					if (currentPage.pageArray[currentIndex] == null) {
						tpage = currentPage.pageArray[currentIndex+1];
					} else {
						tpage = currentPage.pageArray[currentIndex];
					}
					// At leaf - delete the key/data
					currentPage.deleteAt(currentIndex);
					// Rewrite non-null pointer
					currentPage.pageArray[currentIndex] = tpage;
					// If we've deleted the last key
					// from the page, eliminate the
					// page and pop up a level.
					// Null the page pointer
					// at the index we've popped to.
					// If we can't pop, all the keys
					// have been eliminated (or,
					// they should have).
					//  Null the root, graphics.clear the
					// keycount
					if (currentPage.numKeys == 0) {
						// Following guards against leaks
						currentPage.pageArray[0] = null;
						if (pop() == true) {
							// Null pointer to node
							// just deleted
							currentPage.pageArray[currentIndex] = null;
							numKeys--;
							// Perform re-seek to
							//  reestablish location
							search(newKey);
							return (0);
						}
						// Can't pop -- graphics.clear the root
						root = null;
						currentPage = null;
						numKeys = 0;
						atKey = false;
						return (0);
					}
					// If we haven't deleted the last
					// key, see if we have few enough
					// keys on a sibling node to
					// coalesce the two. If the
					// keycount is even, look at the
					// sibling to the left first;
					//  if the keycount is odd, look at
					// the sibling to the right first.
					if (stackDepth == 0) {
						// At root - no siblings
						numKeys--;
						search(newKey);
						return (0);
					}
					// Get parent page and index
					tpage = keyPageStack[stackDepth-1];
					tindex = indexStack[stackDepth-1];
					// Get sibling pages
					if (tindex>0) {
						leftPage = tpage.pageArray[tindex-1];
					} else {
						leftPage = null;
					}
					if (tindex<tpage.numKeys) {
						rightPage = tpage.pageArray[tindex+1];
					} else {
						rightPage = null;
					}
					// Decide which sibling
					if (numKeys%2 == 0) {
						if (leftPage == null) {
							leftPage = currentPage;
						} else {
							rightPage = currentPage;
						}
					} else if (rightPage == null) {
						rightPage = currentPage;
					} else {
						leftPage = currentPage;
					}
					// Sanity check
					if (leftPage == null || rightPage == null) {
						return (TREEERROR);
					}
					// Are the siblings small enough
					//  to coalesce
					if (leftPage.numKeys+rightPage.numKeys+1>bTreeKeyPage.MAXKEYS) {
						// Coalescing not possible, exit
						--numKeys;
						search(newKey);
						return (0);
					} else {
						// Coalescing is possible. Grab
						// the parent key, build a new
						// node. Discard the old node.
						// (If sibling is left page, then
						// the new page is left page,
						// plus parent key, plus original
						// page. New page is old left
						// page. If sibling is right
						// page, then the new page
						// is the original page, the
						// parent key, plus the right
						// page.
						//   Once the new page is
						// created, delete the key on the
						// parent page. Then cycle back
						// up and delete the parent key.)
						coalesce(tpage, tindex, leftPage, rightPage);
						// Null right page of parent
						tpage.pageArray[tindex+1] = null;
						// Pop up and delete parent
						pop();
						continue;
					}
				} else {
					// Not at a leaf. Get a successor
					// or predecessor key.
					//  Copy the xxcessor key into the
					// deleted key's slot, then "move
					// down" to the leaf and
					// do a delete there.
					// Note that doing the delete could
					// cause a "percolation" up the
					// tree.
					// Save current page and  and index
					tpage = currentPage;
					tindex = currentIndex;
					if (currentPage.pageArray[currentIndex] != null) {
						// Get predecessor if possible
						if (seekRightTree() == false) {
							return (STACKERROR);
						}
					} else {
						// Get successor
						if (currentPage.pageArray[currentIndex+1] == null) {
							return (TREEERROR);
						}
						currentIndex++;
						if (seekLeftTree() == false) {
							return (STACKERROR);
						}
					}
					// Replace key/data with 
					//  successor/predecessor
					tpage.keyArray[tindex] = currentPage.keyArray[currentIndex];
					tpage.dataArray[tindex] = currentPage.dataArray[currentIndex];
					// Reenter loop to delete key
					// on leaf
				}
			}
		}
		// Coalesce a node
		//  Combine the left page, the parent
		// key (at offset index) and the right 
		// page contents.
		//  The contents of the right page are
		// nulled. Note that it's the job of the
		// caller to delete the parent.
		protected function coalesce(parent:bTreeKeyPage, index:Number, left:bTreeKeyPage, right:bTreeKeyPage):void {
			var i, j:Number;
			// Append the parent key to the end
			//  of the left key page
			left.keyArray[left.numKeys] = parent.keyArray[index];
			left.dataArray[left.numKeys] = parent.dataArray[index];
			// Append the contents of the right
			// page onto the left key page
			j = left.numKeys+1;
			for (i=0; i<right.numKeys; i++) {
				left.pageArray[j] = right.pageArray[i];
				left.dataArray[j] = right.dataArray[i];
				left.keyArray[j] = right.keyArray[i];
				j++;
			}
			left.pageArray[left.numKeys+right.numKeys+1] = right.pageArray[right.numKeys];
			left.numKeys += right.numKeys+1;
			// Null the right page (no leaks)
			for (i=0; i<right.numKeys; i++) {
				right.pageArray[i] = null;
				right.keyArray[i] = null;
				right.dataArray[i] = null;
			}
			right.pageArray[right.numKeys] = null;
		}
		// Set to beginning of tree
		public function rewind():void {
			currentPage = root;
			currentIndex = 0;
			if (numKeys != 0) {
				clearStack();
				if (currentPage.pageArray[currentIndex] != null) {
					seekLeftTree();
				}
			}
			atKey = false;
		}
		// Set to end of tree
		public function toEnd():void {
			currentPage = root;
			if (numKeys != 0) {
				clearStack();
				currentIndex = currentPage.numKeys;
				if (currentPage.pageArray[currentIndex] != null) {
					seekRightTree();
					currentIndex++;
				}
			} else {
				currentIndex = 0;
			}
			atKey = false;
		}
		// Seek to location of next key in tree
		//  Returns 0 if ok, <>0 if error
		public function gotoNextKey():Number {
			if (numKeys == 0) {
				return (EOF);
			}
			// If we are at a key, then
			// advance the index
			if (atKey == true) {
				currentIndex++;
			}
			// If we are not at a key, then see if
			//  the pointer is null.
			if (currentPage.pageArray[currentIndex] == null) {
				// Pointer is null, is it the
				//  last one on the page?
				if (currentIndex == currentPage.numKeys) {
					// Last pointer on page. We have
					//  to pop up
					while (pop() == true) {
						if (currentIndex != currentPage.numKeys) {
							setCurrent();
							return (0);
						}
					}
					atKey = false;
					return (EOF);
				} else {
					// Not last pointer on page.
					// Skip to next key
					setCurrent();
					return (0);
				}
			}
			// Pointer not null, seek to
			//  "leftmost" key in current
			//  subtree
			if (seekLeftTree() == true) {
				setCurrent();
				return (0);
			}
			atKey = false;
			return (EOF);
		}
		// Go to location of prev. key in tree
		//  Returns 0 if ok, <>0 if error
		public function gotoPrevKey():Number {
			if (numKeys == 0) {
				return (BOF);
			}
			// If we are at a key, then "back up"
			// the index -- which, in reality,
			// does nothing
			// if(atKey==true)
			// { }
			// If we are not at a key, then see if
			//  the pointer is null.
			if (currentPage.pageArray[currentIndex] == null) {
				// Pointer is null, is it the
				//  first one on the page?
				if (currentIndex == 0) {
					// First pointer on page. We have
					//  to pop up
					while (pop() == true) {
						if (currentIndex != 0) {
							currentIndex--;
							setCurrent();
							return (0);
						}
					}
					atKey = false;
					return (BOF);
				} else {
					// Not first pointer on page.
					// Skip to previous key
					currentIndex--;
					setCurrent();
					return (0);
				}
			}
			// Pointer not null, seek to
			//  "rightmost" key in current
			//  subtree
			if (seekRightTree() == true) {
				setCurrent();
				return (0);
			}
			atKey = false;
			return (EOF);
		}
		// Internal method used by seek previous
		//  and seek next
		protected function setCurrent():void {
			atKey = true;
			currentKey = currentPage.keyArray[currentIndex];
			currentObject = currentPage.dataArray[currentIndex];
		}
		// Internal search method used by seek,
		// insert, and delete
		protected function search(targetKey:bTreeKey):Boolean {
			// File empty?
			if (numKeys == 0) {
				return (false);
			}
			// Search - start at root
			clearStack();
			currentPage = root;
			do {
				currentIndex = currentPage.search(targetKey);
				if (currentIndex>=0) {
					// Keyboard found
					break;
				}
				currentIndex = (-currentIndex)-1;
				if (currentPage.pageArray[currentIndex] == null) {
					atKey = false;
					return (false);
				}
				if (push() == false) {
					return (false);
				}
				currentPage = currentPage.pageArray[currentIndex];
			} while (true);
			atKey = true;
			return (true);
		}
		// Seeks to leftmost key in
		// current subtree
		protected function seekLeftTree():Boolean {
			while (push() == true) {
				currentPage = currentPage.pageArray[currentIndex];
				currentIndex = 0;
				if (currentPage.pageArray[currentIndex] == null) {
					return (true);
				}
			}
			return (false);
		}
		// Seeks to rightmost key in
		//  current subtree
		protected function seekRightTree():Boolean {
			while (push() == true) {
				currentPage = currentPage.pageArray[currentIndex];
				currentIndex = currentPage.numKeys;
				if (currentPage.pageArray[currentIndex] == null) {
					currentIndex--;
					return (true);
				}
			}
			return (false);
		}
		// Internal routine to push stack
		protected function push():Boolean {
			if (stackDepth == MAXSTACK) {
				return (false);
			}
			keyPageStack[stackDepth] = currentPage;
			indexStack[stackDepth++] = currentIndex;
			return (true);
		}
		// Internal routine to pop stack
		protected function pop():Boolean {
			if (stackDepth == 0) {
				return (false);
			}
			stackDepth--;
			currentPage = keyPageStack[stackDepth];
			currentIndex = indexStack[stackDepth];
			return (true);
		}
		// Internal routine to graphics.clear references
		// on stack
		protected function clearStack():void {
			for (var i = 0; i<MAXSTACK; i++) {
				keyPageStack[i] = null;
			}
			stackDepth = 0;
		}
	}
	
}