package com.troyworks.ui.controls { 
	/**
	 * @author Troy Gardner
	 */
	public class DndTree_events {
	
	//@exclude
	// we put this here because the documentation software has problems with the first item in an include
	protected var spacerDocumentation:Number;
	
	
	[Event("addLeafNode")]
	/** 
	Event generated when a leaf node is added
	@tiptext Event generated when a leaf node is added
	@description Event. Event generated when a leaf node is added to the Tree. This event includes three properties. Target is a reference to the Tree, eventSource contains an internal constant for MENU_EVENT or METHOD_CALL and pastePosition contains the location in the target node where the paste occured (passing the constants PASTE_INTO, PASTE_BEFORE, PASTE_AFTER).
	@usage myInstance.addEventListener("addLeafNode", myListener);
	@example The example below adds a listener to the addLeafNode event. 
	<pre>
	// include delegation class
	import mx.utils.Delegate;
	// Add Leaf Node event function
	function addLeafNodeEvent(evt:Object):void {
		trace("A leaf node has been added to the tree!");
		// reference to the tree
		var theTree = evt.target;
		// references to all the nodes involved 
		trace("The added leaf node or parent node="+theTree.selectedNode);
		trace("The target node="+theTree.targetNode);
		trace("pastePosition="+evt.pastePosition);
		trace("thePasteToPosition="+theTree.thePasteToPosition);
		trace("thePasteToParentNode="+theTree.thePasteToParentNode);
	}
	// we add a function that "listens" for the add event. When a addLeafNode event is generated this function is called. 
	theTree.addEventListener("addLeafNode", addLeafNodeEvent);
	</pre>
	*/
	public var addLeafNode_Event;
	
	[Event("addBranchNode")]
	/** 
	Event generated when a branch node is added
	@tiptext Event generated when a branch node is added
	@description Event. Event generated when a branch node is added to the Tree. This event includes three properties. Target is a reference to the Tree, eventSource contains an internal constant for MENU_EVENT or METHOD_CALL and pastePosition contains the location in the target node where the paste occured (passing the constants PASTE_INTO, PASTE_BEFORE, PASTE_AFTER).
	@usage myInstance.addEventListener("addBranchNode", myListener);
	@example The example below adds a listener to the addBranchNode event. 
	<pre>
	// include delegation class
	import mx.utils.Delegate;
	// Add Branch Node event function
	function addBranchNodeEvent(evt:Object):void {
		trace("A branch node has been added to the tree!");
		// reference to the tree
		var theTree = evt.target;
		// references to all the nodes involved 
		trace("The added branch node ="+theTree.selectedNode);
		trace("The target node="+theTree.targetNode);
		trace("pastePosition="+evt.pastePosition);
		trace("thePasteToPosition="+theTree.thePasteToPosition);
		trace("thePasteToParentNode="+theTree.thePasteToParentNode);
	}
	// we add a function that "listens" for the add event. When an addBranchNode event is generated this function is called. 
	theTree.addEventListener("addBranchNode", addBranchNodeEvent);
	</pre>
	*/
	public var addBranchNode_Event;
	
	[Event("copyNode")]
	/** 
	Event generated when a node is copied
	@tiptext Event generated when a node is copied
	@description Event. Event generated when a node is copied from the Tree. When items are cut, copied or removed they are copied into the dndComponent.theCopyItems, dndComponent.theCopyNodes and the dndComponent.theCopyGridItems arrays. If enableCrossDrag property is true then the cut, copied or removed items will be available to any dndComponent that also has their cross drag property enabled. When you then paste from the context contextMenu this is where those items come from. This event includes three properties. The target is a reference to the Tree, eventSource contains an internal constant for the MENU_EVENT or METHOD_CALL and copiedIndices is a reference to the selectedIndices. 
	@usage myInstance.addEventListener("copyNode", myListener);
	@example The example below adds a listener to the copyNode event. 
	<pre>
	// include delegation class
	import mx.utils.Delegate;
	// Copy event function
	function copyNodeEvent(evt:Object):void {
		trace("A node has been copied from the tree!");
		// reference to the tree
		var theTree = evt.target;
		// references to all the nodes involved 
		trace("Copied nodes="+theTree.theCopyNodes);
		trace("Copied nodes="+theTree.selectedNodes);
	}
	// we add a function that "listens" for the copy event. When a copyNode event is generated this function is called. 
	theTree.addEventListener("copyNode", copyNodeEvent);
	</pre>
	*/
	public var copyNode_Event:Object;
	
	[Event("cutNode")]
	/** 
	Event generated when a node is cut
	@tiptext Event generated when a node is cut
	@description Event. Event generated when a node is cut from the Tree. When items are cut, copied or removed they are copied into the dndComponent.theCopyItems, dndComponent.theCopyNodes and the dndComponent.theCopyGridItems arrays. If enableCrossDrag property is true then the cut, copied or removed items will be available to any dndComponent that also has their cross drag property enabled. When you then paste from the context contextMenu this is where those items come from. This event includes three properties. This event includes two properties. Target is a reference to the Tree, eventSource contains an internal constant for the MENU_EVENT or METHOD_CALL. 
	@usage myInstance.addEventListener("cutNode", myListener);
	@example The example below adds a listener to the cutNode event. 
	<pre>
	// include delegation class
	import mx.utils.Delegate;
	// Cut event function
	function cutNodeEvent(evt:Object):void {
		trace("A node has been cut from the tree!");
		// reference to the tree
		var theTree = evt.target;
		// references to all the nodes and components involved 
		trace("Cut nodes="+theTree.theCopyNodes);
		trace("The parent or sibling node="+theTree.selectedNode);
	}
	// we add a function that "listens" for the cut event. When a cutNode event is generated this function is called. 
	theTree.addEventListener("cutNode", cutNodeEvent);
	</pre>
	*/
	public var cutNode_Event;
	
	[Event("removeNode")]
	/** 
	Event generated when a node is removed
	@tiptext Event generated when a node is removed
	@description Event. Event generated when a node is removed or deleted from the Tree. When items are cut, copied or removed they are copied into the dndComponent.theCopyItems, dndComponent.theCopyNodes and the dndComponent.theCopyGridItems arrays. If enableCrossDrag property is true then the cut, copied or removed items will be available to any dndComponent that also has their cross drag property enabled. When you then paste from the context contextMenu this is where those items come from. This event includes three properties. This event includes two properties. Target is a reference to the Tree, eventSource is a internal constant for the MENU_EVENT. 
	@usage theTree.addEventListener("removeNode", myListener);
	@example The example below adds a listener to the removeNode event. 
	<pre>
	// include delegation class
	import mx.utils.Delegate;
	// Remove Event
	function removeNode(evt:Object):void {
		trace("A node has been removed from the Tree!");
		// reference to the tree
		var theTree = evt.target;
		// references to all the nodes and components involved 
		trace("Removed nodes="+theTree.theCopyNodes);
		trace("The parent or sibling node="+theTree.selectedNode);
	}
	// we add a function that "listens" for the remove event. When a removeNode event is generated this function gets called. 
	theTree.addEventListener("removeNode", removeNode);
	</pre>
	*/
	public var removeNode_Event:Object;
	
	[Event("pasteNode")]
	/** 
	Event generated after pasteNode method is called
	@tiptext Event generated after pasteNode method is called
	@description Event. Event generated after the pasteNode method is called. When items are cut, copied or removed they are copied into the dndComponent.theCopyItems, dndComponent.theCopyNodes and the dndComponent.theCopyGridItems arrays. If enableCrossDrag property is true then the cut, copied or removed items will be available to any dndComponent that also has their cross drag property enabled. When you then paste from the context contextMenu this is where those items come from. This event includes five  properties. The target contains a reference to the Tree, eventSource contains an internal constant for METHOD_CALL, pastePosition contains the location in the target node where the paste occured (PASTE_INTO, PASTE_BEFORE, PASTE_AFTER), targetNode contains a reference to the targetNode and targetIndex contains a reference to the target index.  You can also use properties in the Tree for more information. Some useful properties are lastMovedItem, lastMovedIndex, lastMovedParent, lastMovedSource, lastMovedItems, lastMovedIndices, lastMovedParents, lastMovedSources, lastSelectedSources, selectedNode, selectedNode.firstChild and selectedNodes.
	@usage myInstance.addEventListener("pasteNode", myListener);
	@example The example below adds a listener to the pasteNode event. 
	<pre>
	// include delegation class
	import mx.utils.Delegate;
	// Paste Node event function
	function pasteNodeEvent(evt:Object):void {
		trace("A node has been pasted into the Tree!");
		// reference to the tree
		var theTree = evt.target;
		// references to all the nodes and components involved 
		trace("pastePosition="+evt.pastePosition);
		trace("thePasteToPosition="+theTree.thePasteToPosition);
		trace("thePasteToParentNode="+theTree.thePasteToParentNode);
		trace("lastMovedItem="+theTree.lastMovedItem);
		trace("lastMovedIndex="+theTree.lastMovedIndex);
		trace("lastMovedParent="+theTree.lastMovedParent);
		trace("lastMovedSource="+theTree.lastMovedSource);
		trace("lastMovedItems="+theTree.lastMovedItems);
		trace("lastMovedIndices="+theTree.lastMovedIndices);
		trace("lastMovedParents="+theTree.lastMovedParents);
		trace("lastMovedSources="+theTree.lastMovedSources);
		trace("targetNode="+theTree.targetNode);
		trace("targetNode="+theTree.selectedNode);
		trace("targetNode="+theTree.selectedNodes);
		trace("targetNode="+theTree.selectedNode.firstChild);
	}
	// we add a function that "listens" for the paste event. When a pasteNode event is generated this function gets called. 
	theTree.addEventListener("pasteNode", pasteNodeEvent);
	</pre>
	*/
	public var pasteNode_Event:Object;
	
	[Event("onDrop")]
	/** 
	Event generated after a drag and drop
	@tiptext Event generated after a drag and drop
	@description Event. Event generated after a user drags and drops nodes into the Tree. This event includes five properties. The target contains a reference to the Tree, eventSource contains an internal constant for the DROP_EVENT, pastePosition contains the location in the target node where the paste occured (PASTE_INTO, PASTE_BEFORE, PASTE_AFTER), targetNode contains a reference to the target node and targetIndex contains a reference to the targetIndex. You can also use properties in the Tree for more information. Some useful properties are lastMovedItem, lastMovedIndex, lastMovedParent, lastMovedSource, lastMovedItems, lastMovedIndices, lastMovedParents, lastMovedSources, lastSelectedSources, selectedNode, selectedNode.firstChild and selectedNodes.
	@usage myInstance.addEventListener("onDrop", myListener);
	@example The example below adds a listener to the drop event. 
	<pre>
	// include delegation class
	import mx.utils.Delegate;
	// Drop Event
	function nodeDrop(evt:Object):void {
		trace("A node has been dropped onto the Tree!");
		// reference to the tree
		var theTree = evt.target;
		// references to all the nodes and components involved 
		trace("pastePosition="+evt.pastePosition);
		trace("thePasteToPosition="+theTree.thePasteToPosition);
		trace("thePasteToParentNode="+theTree.thePasteToParentNode);
		trace("lastMovedItem="+theTree.lastMovedItem);
		trace("lastMovedIndex="+theTree.lastMovedIndex);
		trace("lastMovedParent="+theTree.lastMovedParent);
		trace("lastMovedSource="+theTree.lastMovedSource);
		trace("lastMovedItems="+theTree.lastMovedItems);
		trace("lastMovedIndices="+theTree.lastMovedIndices);
		trace("lastMovedParents="+theTree.lastMovedParents);
		trace("lastMovedSources="+theTree.lastMovedSources);
		trace("targetNode="+theTree.targetNode);
		trace("selectedNode="+theTree.selectedNode);
		trace("selectedNodes="+theTree.selectedNodes);
		trace("selectedNode.firstChild="+theTree.selectedNode.firstChild);
	}
	// we add a function that "listens" for the drop event. When a drop event is generated this function gets called. 
	theTree.addEventListener("onDrop", nodeDrop);
	</pre>
	*/
	public var drop_Event:Object;
	
	[Event("singleClick")]
	/** 
	Event generated when a row is single clicked
	@tiptext Event generated when a row is single clicked
	@description Event. Event generated when a row is single clicked. This event includes three properties. Target contains a reference to the Tree, rowIndex contains the index of the row within the visible rows and absRowIndex contains the absolute index of the row within all rows.
	@usage myInstance.addEventListener("singleClick", myListener);
	@example The example below adds a listener to the single click event. 
	<pre>
	// include delegation class
	import mx.utils.Delegate;
	// Double click event function
	function singleClickEvent(evt:Object):void {
		trace("A row has been single clicked!");
		// reference to the tree
		var theTree = evt.target;
		// references to all the nodes and components involved 
		trace("absRowIndex="+evt.absRowIndex);
		trace("rowIndex="+evt.rowIndex);
		trace("selectedIndex="+theTree.selectedIndex);
		trace("this node has been clicked="+theTree.selectedNode);
	}
	// we add a function that "listens" for the single click event. When a singleClick event is generated this function gets called. 
	theTree.addEventListener("singleClick", singleClickEvent);
	</pre>
	*/
	public var singleClick_Event:Object;
	
	[Event("doubleClick")]
	/** 
	Event generated when a row is double clicked
	@tiptext Event generated when a row is double clicked
	@description Event. Event generated when a row is double clicked. This event includes three properties. Target contains a reference to the Tree, rowIndex contains the index of the row within the visible rows and absRowIndex contains the absolute index of the row within all rows. You can use this property to get a reference to node or row mc. 
	@usage myInstance.addEventListener("doubleClick", myListener);
	@example The example below adds a listener to the double click event. 
	<pre>
	// include delegation class
	import mx.utils.Delegate;
	// Double click event function
	function doubleClickEvent(evt:Object):void {
		trace("A row has been double clicked!");
		// reference to the tree
		var theTree = evt.target;
		// references to all the nodes and components involved 
		trace("absRowIndex="+evt.absRowIndex);
		trace("rowIndex="+evt.rowIndex);
		trace("doubleclicked node="+theTree.selectedNode);
	}
	// we add a function that "listens" for the double click event. When a doubleClick event is generated this function gets called. 
	theTree.addEventListener("doubleClick", doubleClickEvent);
	</pre>
	*/
	public var doubleClick_Event:Object;
	
	[Event("delayedClick")]
	/** 
	Event generated when a row is delayed clicked
	@tiptext Event generated when a row is delayed clicked
	@description Event. Event generated when a row is delayed clicked. This event includes three properties. Target contains a reference to the Tree, rowIndex contains the index of the row within the visible rows and absRowIndex contains the absolute index of the row within all rows. You can use this property to get a reference to node or row mc. 
	@usage myInstance.addEventListener("delayedClick", myListener);
	@example The example below adds a listener to the delayed click event. 
	<pre>
	// include delegation class
	import mx.utils.Delegate;
	// Delayed click event function
	function delayedClickEvent(evt:Object):void {
		trace("A row has been delay clicked!");
		// reference to the tree
		var theTree = evt.target;
		// references to all the nodes and components involved 
		trace("absRowIndex="+evt.absRowIndex);
		trace("rowIndex="+evt.rowIndex);
		trace("delayedclicked node="+theTree.selectedNode);
	}
	// we add a function that "listens" for the delayed click event. When a delayedClick event is generated this function gets called. 
	theTree.addEventListener("delayedClick", delayedClickEvent);
	</pre>
	*/
	public var delayedClick_Event:Object;
	
	[Event("renameNode")]
	/** 
	Event generated when a node is renamed
	@tiptext Event generated when a node is renamed
	@description Event. Event generated when a node is renamed. This event includes five properties. Target is a reference to the Tree, rowIndex is reference to the row index, row is a reference to the row, node is a reference to the node and originalText is a reference to the original text. See also validateNodeLabel and renameTextRestrict.
	@usage myInstance.addEventListener("renameNode", myListener);
	@example The example below adds a listener to the renameNode event. 
	<pre>
	// include delegation class
	import mx.utils.Delegate;
	// renameNode event function
	function renameNodeEvent(evt:Object):void {
		trace("A node has been renamed");
		// reference to the tree
		var theTree = evt.target;
		// references to all the nodes involved 
		trace("The renamed node="+evt.node);
		trace("The rowIndex="+evt.rowIndex);
		trace("The row movieclip="+evt.row);
		trace("The original text="+evt.originalText);
	}
	// we add a function that "listens" for the renameNode event. When a renameNode event is generated this function is called. 
	theTree.addEventListener("renameNode", renameNodeEvent);
	</pre>
	@see #validateNodeLabel
	@see #renameTextRestrict
	*/
	public var renameNode_Event:Object;
	
	[Event("nodeOpen")]
	/** 
	Event generated when a branch node is opened
	@tiptext Event generated when a branch node is opened
	@description <p>Event. Event generated when a branch node is opened. This event includes two properties. Target is a reference to the Tree and node contains the node that has closed.</p>
	@usage myInstance.addEventListener("nodeOpen", myListener);
	@example <p>The example below adds a listener to the nodeOpen event. </p>
	<pre>
	// include delegation class
	import mx.utils.Delegate;
	// Node Open event function
	function nodeOpenEvent(evt:Object):void {
		trace("A branch node has been opened!");
		// reference to the tree
		var theTree = evt.target;
		// reference to the node opened
		trace("The opened node="+evt.target.node);
	}
	// we add a function that "listens" for the node open event. When a nodeOpen event is generated this function is called. 
	theTree.addEventListener("nodeOpen", nodeOpenEvent);
	</pre>
	*/
	public var nodeOpen_Event:Object;
	
	[Event("nodeClose")]
	/** 
	Event generated when a branch node is closed
	@tiptext Event generated when a branch node is closed
	@description <p>Event. Event generated when a branch node is closed. This event includes two properties. Target is a reference to the Tree and node contains the node that has closed.</p>
	@usage myInstance.addEventListener("nodeClose", myListener);
	@example <p>The example below adds a listener to the nodeOpen event. </p>
	<pre>
	// include delegation class
	import mx.utils.Delegate;
	// Node Close event function
	function nodeCloseEvent(evt:Object):void {
		trace("A branch node has been closed!");
		// reference to the tree
		var theTree = evt.target;
		// reference to the node closed
		trace("The closed node="+evt.target.node);
	}
	// we add a function that "listens" for the node close event. When a nodeClose event is generated this function is called. 
	theTree.addEventListener("nodeClose", nodeCloseEvent);
	</pre>
	*/
	public var nodeClose_Event:Object;
	}
}