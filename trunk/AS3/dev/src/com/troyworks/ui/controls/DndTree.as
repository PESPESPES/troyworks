package com.troyworks.ui.controls { 
	/****************************************************************************
	// extended class 'mx.controls.Tree' to add drag-and-drop functionality 
	// by JabbyPanda & Judah 
	// 2006 - sources updated to compile with Mtasc, FDT, strict typing in anticipation of AS3.03.0.
	// 
	// (reused ideas from DDTree component developed by Jonathan Doklovic )
	//****************************************************************************
	
	Notes: 
	This design was written in the early days of Flash 7. It has been refactored many times since then and it has come a long way. It still has much more ways to go. Both JabbyPanda and I have learned much more since we started this (including more design patterns, flash knowledge, etc.). This class could be refactored a few more times and a few places I'm embarassed about the code but it is kept for backward compatibility. If you are reading this and find something you would change create a patch and send it to us. If everyone did that we would have some really slick code. 
	
	Judah
	*/
	
	import mx.updatedcontrols.Tree;
	//import com.judah.utilities.Enumerator;
	import com.troyworks.ui.controls.dataproviders.ContextMenuManager;
	import com.troyworks.ui.controls.dataproviders.DndUIWidgets;
	import com.troyworks.ui.controls.treeclasses.DndDraggerNode;
	import mx.utils.Delegate;
	
	[RequiresDataBinding(true)]
	[IconFile("dndTree.png")]
	//[InspectableList("multipleSelection","rowHeight","canCutAtt")]
	[DataBindingInfo("acceptedTypes","{dataProvider: &quot;XMLDocument&quot;}")]
	
	
	/**
	* Drag and drop Tree class
	* @tiptext Drag and drop Tree class
	* @description The dndTree is an enhanced Tree component extended from the Macromedia Tree. It follows the same model as the Macromedia Tree and can follow the same examples. The dndTree inherits all the properties and methods of the classes it inherits including all the properties and methods of the MovieClip > UIObject class > UIComponent class > View > ScrollView > ScrollSelectList > List component and Tree classes. To begin, study the properties and methods of the Macromedia Tree, TreeDataProvider and the XMLObject class documentation first. The inherited properties and methods are listed in the Flash Help Panel in the Macromedia List and Tree component documentation. The additional properties and methods the dndTree adds are listed here. Since the data you are dealing with in the Tree is XMLDocument and XMLNode objects, you should become familiar with the XMLDocument and XMLNode classes to learn how to navigate and find specific information. To get started read the getting started page.
		@example This first example loads data into the Tree from an xml file. The second example adds data to the Tree from the timeline.
		<pre>
		// Example 1
		// Define XMLDocument object to load the external data
		dataTreeDP = new XMLDocument();
		// set this to true to get rid of white space in your xml
		dataTreeDP.ignoreWhite = true;
	
		// load data into Tree
		function loadData() {
			// load an xml structure data from an xml object
			dataTreeDP.load("testdata.xml");
			
			// onLoad event gets called when the xml file is loaded
			dataTreeDP.onLoad = function() {
				// set the loaded xml file into the Tree
				// if your xml nodes do not have a label attributes then you need to add it to 
				// your nodes or set the labelField or labelFunction to the attribute you want to use as your label
				theTree.dataProvider = dataTreeDP;
				// open the root node
				theTree.setIsOpen(theTree.getTreeNodeAt(0), true);
			}
		}
		// load data into the tree
		loadData()
		</pre>
		<pre>
		// Example 2
		// set the dataProvider to a new XMLDocument object
		theTree.dataProvider = new XMLDocument();
		// using addTreeNode to add a node to the root and get a reference to that node
		var rootNode = theTree.addTreeNode("Root");
		// add node to the root node
		rootNode.addTreeNode("Child Node");
		// open the root node. we could have passed in rootNode and it would have worked the same
		theTree.setIsOpen(theTree.getTreeNodeAt(0), true);
		</pre>
	
	*/
	import flash.utils.clearInterval;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.getTimer;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.display.MovieClip;
	import flash.utils.setInterval;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	public class DndTree extends Tree {	
	
	
		/** Constructor used when creating a new tree
		@description Internal constructor used when creating a new dndTree instance. To create a tree dynamically use the createClassObject method. The dndTree must be in the library for this to work. 
		@usage createClassObject(dndTree,"theTree",5);
		@example The example below creates a tree at runtime.  
		<pre>
		// note: be sure to add the tree to the library
		import com.judah.controls.dndTree;
		createClassObject(dndTree,"theTree",5);
	
		theTree.setSize(180,190);
		theTree.x = 25;
		theTree.y = 25;
	
		theTree.dataProvider = new XMLDocument("<node label='root'><node label='child'/><node label='child 2'/></node>");
		var rootNode = theTree.getTreeNodeAt(0);
		var newChild = rootNode.addTreeNode("new child");
		theTree.setIsOpen(rootNode, true);
		theTree.selectedNode = newChild;
		theTree.setStyle("selectionColor", 0x006699);
		theTree.setStyle("rollOverColor", 0xBECAD6);
		theTree.setStyle("textRollOverColor", 0x2B333C);
		theTree.setStyle("textSelectedColor", 0xFDFDFD);
		</pre>
		*/
		public function DndTree() {
			
			// used to store mouse pointer location		
			objPoint = new Object();
			
			// adding separator to the stage then hiding it - we use getNextHighestDepth because 
			// DepthManager was clashing with the Alert component. The Alert would pop up but have no 
			// content
			//attachMovie("dndSeparator", "separator", DepthManager.kTop++);
			attachMovie("dndSeparator", "separator", this.getNextHighestDepth());
			// hide separator
			separator.visible = false;
			
			// these are included for mtasc support - nicolas does not want to add support for components...
			var _mtasc_a = DndDraggerNode;
			//var _mtasc_b = com.judah.controls.dndTree;
			var _mtasc_c = ContextMenuManager;
			var _mtasc_d = DndUIWidgets;
			var _mtasc_e = mx.updatedcontrols.Tree;
			
			// if we create a dndTree dynamically we need to set some properties
			if (leafNodeXML==undefined) {
				leafNodeXML = "<node label='New Leaf'/>";
			}
			
			if (branchNodeXML==undefined) {
				branchNodeXML = "<node label='New Branch'></node>";
			}
		
		}
		
		
		/**
		@exclude
		This line is for so we can document events
		*/
		//#include "dndTree_events.as"
		
		/**
		The fully qualified class name
		@description Static: The fully qualified class name (for example, mypackage.MyComponent).
		This variable is used in the internal call to the createClassObject() method.
		*/
		static public var symbolOwner:Object = DndTree;
		
		/**
		The name of the ActionScript class
		@description String: The name of the ActionScript class. Contains "dndTree".
		*/
		static public var symbolName:String = "dndTree";
		
		/**
		Class name of the component class
		@description The name of the component class. This does not include the package name and has no corresponding setting in the Flash development environment. You can use the value of this variable when setting style properties.
		*/
		public var className:String = "dndTree";
	
		/**
		Current version number for this component
		@description Current version number for this component.
		*/
		public var versionNumber:String = "3.0.2";
		
		/** 
		Shows debug information
		@tiptext Shows debug information
		@description Shows debug information when available in the trace console. This is partially deprecated. Please ask in the forums. 
		@usage myInstance.showDebug = true;
		@example The example below will show debug information, if any, in the output window.
		<pre>
		theTree.showDebug = true;
		</pre>
		*/
		public var showDebug:Boolean = false;
		
		/** 
		Track debug messages in errorMsg variable
		@tiptext Track debug messages in errorMsg variable
		@description Track debug messages in the errorMsg variable. This is partially deprecated. Please ask in the forums. 
		@usage myInstance.trackDebug = true;
		@example The example below tracks debug information in the errorMsg variable. 
		<pre>
		theTree.trackDebug = true;
		</pre>
		*/
		public var trackDebug:Boolean = false;
		
		/** 
		Error message variable
		@tiptext Error message variable
		@description String. Tracks debug messages variable when trackDebug is true. Trace this to see the event log.
		@usage myInstance.errorMsg;
		@example The example below traces debug information in the errorMsg variable. 
		<pre>
		trace(theTree.errorMsg);
		</pre>
		*/
		public var errorMsg:String = "";
		
		/** 
		Reference to the root movieclip
		@tiptext Reference to the root movieclip
		@description Movieclip. Reference to the root movieclip when determining where to attach the drag_mc when dragging. If you load in the dndTree from an external swf and are having problems you may need to set this property to the root movieclip.
		@usage myInstance.root_mc = _root;
		@example The example sets a reference to the root movieclip. 
		<pre>
		theTree.root_mc = _root;
		</pre>
		*/
		public var root_mc:MovieClip;
	
		
		// ***************************************************
		// Context Menu options
		// ***************************************************
		
		/** 
		Context Menu Item Cut string. Deprecated
		@tiptext Context Menu Item Cut string. Deprecated
		@description Deprecated. To change the text of any of the existing contextMenu items use the contextMenu.customItems.caption property. Note: The Flash Player will not show the contextMenu item if the caption is set to any of the reserved words, "cut, copy, paste". 
		@usage myInstance.cm.customItems[0].caption = "new text".
		@example The example below changes the text of the first contextMenu item. 
		<pre>
		theTree.contextMenu.customItems[0].caption = "new text";
		</pre>
		*/
		public var strCutItem:String = "Cut Item";
		
		/** 
		Context Menu Item Copy string. Deprecated
		@tiptext Context Menu Item Copy string. Deprecated
		@description Deprecated. To change the text of any of the existing contextMenu items use the contextMenu.customItems.caption property. Note: The Flash Player will not show the contextMenu item if the caption is set to any of the reserved words, "cut, copy, paste". 
		@usage myInstance.cm.customItems[0].caption = "new text".
		@example The example below changes the text of the first contextMenu item. 
		<pre>
		theTree.contextMenu.customItems[0].caption = "new text"
		</pre>
		*/
		public var strCopyItem:String = "Copy Item";
		
		/** 
		Context Menu Item Paste Into string. Deprecated
		@tiptext Context Menu Item Paste Into string. Deprecated
		@description Deprecated. To change the text of any of the existing contextMenu items use the contextMenu.customItems.caption property. Note: The Flash Player will not show the contextMenu item if the caption is set to any of the reserved words, "cut, copy, paste". 
		@usage myInstance.cm.customItems[0].caption = "new text".
		@example The example below changes the text of the first contextMenu item. 
		<pre>
		theTree.contextMenu.customItems[0].caption = "new text"
		</pre>
		*/
		public var strPasteInto:String = "Paste Into";
		
		/** 
		Context Menu Item Paste Before string. Deprecated
		@tiptext Context Menu Item Paste Before string. Deprecated
		@description Deprecated. To change the text of any of the existing contextMenu items use the contextMenu.customItems.caption property. Note: The Flash Player will not show the contextMenu item if the caption is set to any of the reserved words, "cut, copy, paste". 
		@usage myInstance.cm.customItems[0].caption = "new text".
		@example The example below changes the text of the first contextMenu item. 
		<pre>
		theTree.contextMenu.customItems[0].caption = "new text"
		</pre>
		*/
		public var strPasteBefore:String = "Paste Before";
		
		/** 
		Context Menu Item Paste After string. Deprecated
		@tiptext Context Menu Item Paste After string. Deprecated
		@description Deprecated. To change the text of any of the existing contextMenu items use the contextMenu.customItems.caption property. Note: The Flash Player will not show the contextMenu item if the caption is set to any of the reserved words, "cut, copy, paste". 
		@usage myInstance.cm.customItems[0].caption = "new text".
		@example The example below changes the text of the first contextMenu item. 
		<pre>
		theTree.contextMenu.customItems[0].caption = "new text"
		</pre>
		*/
		public var strPasteAfter:String = "Paste After";
		
		/** 
		Context Menu Item Remove string. Deprecated
		@tiptext Context Menu Item Remove string. Deprecated
		@description Deprecated. To change the text of any of the existing contextMenu items use the contextMenu.customItems.caption property. Note: The Flash Player will not show the contextMenu item if the caption is set to any of the reserved words, "cut, copy, paste". 
		@usage myInstance.cm.customItems[0].caption = "new text".
		@example The example below changes the text of the first contextMenu item. 
		<pre>
		theTree.contextMenu.customItems[0].caption = "new text"
		</pre>
		*/
		public var strRemoveItem = "Remove Item";
		
		/** 
		Context Menu Item Add Leaf string. Deprecated
		@tiptext Context Menu Item Add Leaf string. Deprecated
		@description Deprecated. To change the text of any of the existing contextMenu items use the contextMenu.customItems.caption property. Note: The Flash Player will not show the contextMenu item if the caption is set to any of the reserved words, "cut, copy, paste". 
		@usage myInstance.cm.customItems[0].caption = "new text".
		@example The example below changes the text of the first contextMenu item. 
		<pre>
		theTree.contextMenu.customItems[0].caption = "new text"
		</pre>
		*/
		public var strAddLeaf:String = "Add Leaf";
		
		/** 
		Context Menu Item Add Branch string. Deprecated
		@tiptext Context Menu Item Add Branch string. Deprecated
		@description Deprecated. To change the text of any of the existing contextMenu items use the contextMenu.customItems.caption property. Note: The Flash Player will not show the contextMenu item if the caption is set to any of the reserved words, "cut, copy, paste". 
		@usage myInstance.cm.customItems[0].caption = "new text".
		@example The example below changes the text of the first contextMenu item. 
		<pre>
		theTree.cm.customItems[0].caption = "new text".
		theTree.contextMenu.customItems[0].caption = "new text".
		</pre>
		*/
		public var strAddBranch:String = "Add Branch";
		
		/** 
		Context Menu Item Rename string. Deprecated
		@tiptext Context Menu Item Rename string. Deprecated
		@description Deprecated. To change the text of any of the existing contextMenu items use the contextMenu.customItems.caption property. Note: The Flash Player will not show the contextMenu item if the caption is set to any of the reserved words, "cut, copy, paste". 
		@usage myInstance.cm.customItems[0].caption = "new text".
		@example The example below changes the text of the first contextMenu item. 
		<pre>
		theTree.cm.customItems[0].caption = "new text".
		theTree.contextMenu.customItems[0].caption = "new text".
		</pre>
		*/
		public var strRenameItem = "Rename Item";
		
		
		/** 
		Cut Item constant
		@tiptext Cut Item constant
		@description Cut Item constant. This is used in copy and paste type operations throughout the dndTree methods. Value is 0.
		@usage trace(myInstance.CUT_ITEM);
		*/
		public var CUT_ITEM:Number = 0;
		
		/** 
		Copy Item constant
		@tiptext Copy Item constant
		@description Copy Item constant. This is used in copy and paste type operations throughout the dndTree methods. Value is 1.
		@usage trace(myInstance.COPY_ITEM);
		*/
		public var COPY_ITEM:Number = 1;
		
		/** 
		Paste Into constant
		@tiptext Paste Into constant
		@description Paste Into constant. This is used in copy and paste type operations throughout the dndTree methods. Value is 2.
		@usage trace(myInstance.PASTE_INTO);
		@example The example inserts the sourceNode into the targetNode. 
		<pre>
		theTree.addLeafNode(targetNode, theTree.PASTE_INTO, sourceNode);
		</pre>
		*/
		public var PASTE_INTO:Number = 2;
		
		/** 
		Paste Before constant
		@tiptext Paste Before constant
		@description Paste Before constant. This is used in copy and paste type operations throughout the dndTree methods. Value is 3.
		@usage trace(myInstance.PASTE_BEFORE);
		@example The example inserts the sourceNode before the targetNode. 
		<pre>
		theTree.addLeafNode(targetNode, theTree.PASTE_BEFORE, sourceNode);
		</pre>
		*/
		public var PASTE_BEFORE:Number = 3;
	
		/** 
		Paste After constant
		@tiptext Paste After constant
		@description Paste After constant. This is used in copy and paste type operations throughout the dndTree methods. Value is 4.
		@usage trace(myInstance.PASTE_AFTER);
		@example The first example inserts the sourceNode after the targetNode. The second example pastes the sourceNode after the targetNode.
		<pre>
		// first example
		theTree.addLeafNode(targetNode, theTree.PASTE_AFTER, sourceNode);
		// second example
		theTree.pasteNode(sourceNode, targetNode, theTree.PASTE_AFTER, moveNode);
		</pre>
		*/
		public var PASTE_AFTER:Number = 4;
		
		/** 
		Add Leaf constant
		@tiptext Add Leaf constant
		@description Add Leaf constant. This is used in copy and paste type operations throughout the dndTree methods. Value is 5.
		@usage trace(myInstance.ADD_LEAF);
		@example The example pastes the sourceNode after the targetNode and we can optionally use ADD_LEAF to generate an addLeafNode event. 
		<pre>
		theTree.pasteNode(sourceNode, targetNode, theTree.PASTE_AFTER, moveNode, theTree.METHOD_CALL, theTree.ADD_LEAF);
		</pre>
		*/
		public var ADD_LEAF:Number = 5;
		
		/** 
		Add Branch constant
		@tiptext Add Branch constant
		@description Add Branch constant. This is used in copy and paste type operations throughout the dndTree methods. Value is 6.
		@usage trace(myInstance.ADD_BRANCH);
		@example The example pastes the sourceNode after the targetNode and we can optionally use ADD_BRANCH to generate an addBranchNode event.
		<pre>
		theTree.pasteNode(sourceNode, targetNode, theTree.PASTE_AFTER, moveNode, theTree.METHOD_CALL, theTree.ADD_BRANCH);
		</pre>
		*/
		public var ADD_BRANCH:Number = 6;
		
		/** 
		Remove Item constant
		@tiptext Remove Item constant
		@description Remove Item constant. This is used in copy and paste type operations throughout the dndTree methods. Value is 7.
		@usage trace(myInstance.REMOVE_ITEM);
		@example The example cuts the sourceNode and we can optionally use REMOVE_ITEM to generate a removeItem event. 
		<pre>
		theTree.cutNode(sourceNode, theTree.REMOVE_ITEM);
		</pre>
		*/
		public var REMOVE_ITEM:Number = 7;
		
		/** 
		Rename Item constant
		@tiptext Rename Item constant
		@description Rename Item constant. This is used in copy and paste type operations throughout the dndTree methods. Value is 8.
		@usage trace(myInstance.RENAME_ITEM);
		@example Traces value.
		<pre>
		trace(theTree.RENAME_ITEM);
		</pre>
		*/
		public var RENAME_ITEM:Number = 8;
		
		/** 
		Drop Event constant
		@tiptext Drop Event constant
		@description Drop Event constant. Used with PasteNode method. Value is 20.
		@usage trace(myInstance.DROP_EVENT);
		@example Traces value.
		<pre>
		trace(theTree.DROP_EVENT);
		</pre>
		*/
		public var DROP_EVENT:Number = 20;
		
		/** 
		Menu Event constant
		@tiptext Menu Event constant
		@description Menu Event constant. Used with PasteNode method. Value is 21.
		@usage trace(myInstance.MENU_EVENT);
		@example Traces value.
		<pre>
		trace(theTree.MENU_EVENT);
		</pre>
		*/
		public var MENU_EVENT:Number = 21;
			
		/** 
		Method Call constant
		@tiptext Method Call constant
		@description Method Call constant. Used with PasteNode method. Value is 22.
		@usage trace(myInstance.METHOD_CALL);
		@example Traces value.
		<pre>
		trace(theTree.METHOD_CALL);
		</pre>
		*/
		public var METHOD_CALL:Number = 22;
		
		// ***************************************************
		// General Options
		// ***************************************************
	
		// helps categorize the inspectable name
		[Inspectable(type=String, defaultValue="", name="General Options", category="_General")]
		protected var generalHeader:String;
		
		/** 
		Enables or disables the Tree	
		@tiptext Enable or disables the Tree
		@description Enables the Tree when set to true. When set to false the Tree is disabled.
		@usage myInstance.enabled = true;
		@example The example below enables the Tree.
		<pre>
		theTree.enabled = true;
		</pre>
		*/
		[Inspectable(type=Boolean, name=" Enable (enabled)", defaultValue="true", category="_General 002")]
		public var enabled:Boolean;
		
		/** 
		Enables or disables drag and drop	
		@tiptext Enable or disable drag and drop	
		@description Enables drag and drop when set to true. When set to false the drag and drop is disabled. Certain functions can still be performed with the context contextMenu. This property is enabled by default. This property can be set through the Component Panel by changing "Enable Drag and Drop" parameter value.
		@usage myInstance.dndEnabled = newValue;
		@example The example below enables the property.
		<pre>
		theTree.dndEnabled = true;
		</pre>
		*/
		[Inspectable(type=Boolean, name=" Enable Drag and Drop (dndEnabled)", defaultValue="true", category="_General 002")]
		public var dndEnabled:Boolean = true;
		
		/** 
		Displays or hides the tree	
		@tiptext Displays or hides the tree
		@description Displays the Tree when set to true. When set to false hides the Tree.
		@usage myInstance.visible = true;
		@example The example below displays the tree.
		<pre>
		theTree.visible = true;
		</pre>
		*/
		[Inspectable(type=Boolean, name=" Visible (visible)", defaultValue="true", category="_General 010")]
		public var visible: Boolean;
		
		/** 
		Id of movieclip when dragging and dropping rows
		@tiptext Id of movieclip when dragging and dropping rows
		@description Id of movieclip when dragging and dropping rows. This movieclip only exists when a user starts dragging. It contains many properties including, node, nodes, item, items, dndReadOnly, multipleselection, selectedIndex, selectedIndices, isDragging, moveAfterDropMode, owner, copyIcon, noDropIcon, nodeIcon, label_mc, nodeLength and origName. In addition, each node in the "nodes" array have the following properties:
		<pre>
		theNode.bIsNodeBranch = getIsBranch(theNode);
		theNode.bIsNodeOpen   = getIsOpen(theNode);
		theNode.bIsParentNodeBranch = getIsBranch(theNode.parentNode);
		theNode.owner = this;
		theNode.indices = indices;
		theNode.itemIndex = indices[i];
		theNode.readOnly = dndReadOnly;
		// we don't use this now but we may in the future
		// right now it is the same as calling theNode.removeTreeNode()
		theNode.removeMe = function() {
			theNode.removeTreeNode();
		}
		</pre>You can use the modifyDragMC function to modify the drag_mc before it is dragged.
		@usage _root.drag_mc;
		@example The example below adds a property to drag_mc.
		<pre>
		myInstance.modifyDragMC = function (drag_mc) {
			drag_mc.myProp = "Bill";
			// enumerate drag_mc here to see it's properties
			trace(drag_mc.nodes);
		}
		</pre>
		@see #modifyDragMC
		@see #drawSeparator
		*/
		public var drag_mc:MovieClip;
	
		/** 
		Scroll drag speed in milliseconds
		@tiptext Scroll drag speed in milliseconds
		@description Scroll drag speed in milliseconds. Change this property to speed up or slow down the vertical scrollV speed. The default scrollDragSpeed is 150 milliseconds.
		@usage myInstance.scrollDragSpeed = 200;
		@example Sets the scrollV speed to 200 milliseconds.
		<pre>
		theTree.scrollDragSpeed = 200;
		</pre>
		*/
		public var scrollDragSpeed:Number = 150;
		
		/**
		@exclude
		*/
		protected var lastScrollDragTime:Number = 0;
	
		/** 
		Method to manually set the icon of the row
		@tiptext Method to manually set the icon of the row
		@description Method to manually set the icon of the row. You can use this function to set the icon of the row. Normally it is set by reading the value of the node's "icon" attribute. This method will over write any default value. You can return undefined to return the default value. I also recommend you use this function rather than the iconField property for better control and compatibility. 
		@usage theTree.iconFunction = function(node) { return item.attributes.label };
		@param node XMLNode that is associated with the row being rendered. Contains the property "attributes" that contains a reference to all the attributes in the original xml node. 
		@example The example below sets a default icon if the icon attribute is undefined.
		<pre>
		// set the icon to use 
		theTree.iconFunction = function(node) {
		  // this icon function checks if a icon attribute exists
		  // if it does not exist it uses the default built in icon
		  var icon = node.attributes.icon;
		  
		  if (icon != undefined && icon!="") {
				return icon;
		  }
		}
		</pre>
		@see #cellrenderer
		*/
		public function iconFunction(node:Object):void {
			super.iconFunction(node);
		}
		
		/** 
		Method to manually set the label of the row
		@tiptext Method to manually set the label of the row
		@description Method to manually set the label of the row. You can use this function to set the label of the row. Normally it is set by reading the value of the node's "label" attribute. This method will over write any default value. You can return undefined to return the default value. I also recommend you use this function rather than the labelField property for better control and compatibility. 
		@usage theTree.labelFunction = function(item) { return item.attributes.label };
		@param node XMLNode that is associated with the row being rendered. Contains the property "attributes" that contains a reference to all the attributes in the original xml node. 
		@example The example below sets a default label if the label attribute is undefined.
		<pre>
		//set the label to use 
		theTree.labelFunction = function(node) {
		  // this label function checks if a label attribute exists
		  // if it does not exist it uses the default
		  var label = node.attributes.label;
		  
		  if (label != undefined && label!="") {
				return label;
		  }
			else {
				return "No Label Defined";
			}
		}
		</pre>
		@see #cellrenderer
		*/
		public function labelFunction(node:Object):void {
			super.labelFunction(node);
		}
	
		/** 
		Enables or disables the right-click context contextMenu
		@tiptext Enables or disables the right-click context contextMenu
		@description Enables context contextMenu operations when set to true. When set to false no right click contextMenu appears when right-clicking on a node. This property is enabled by default. Certain functions can still be performed if drag and drop is enabled. This property can be set through the Component panel by changing "Enable Context Menu" parameter value. To add or remove context contextMenu items from the existing context contextMenu see the cm property. To use a completely new contextMenu use the contextMenu property.
		@usage myInstance.enableContextMenu = true;
		@example The example below enables the context contextMenu.
		<pre>
		// Example 1 - enable the context contextMenu
		theTree.enableContextMenu = true;
		</pre>
		@see #cm
		@see #contextMenu
		@see #permitContextMenu
		*/
		[Inspectable(type=Boolean, name=" Enable Context Menu (enableContextMenu)", defaultValue="true", category="_General 010")]	
		public function set enableContextMenu(isEnabled : Boolean) : void{
			root_mc = getRoot(this);
			_enableContextMenu = isEnabled;
			// enabling context contextMenu
			if (_enableContextMenu){
				if (_backupMenu!=undefined) {
					this['contextMenu'] = _backupMenu;
					ContextMenuManager.registerMovieClip(root_mc, this, _backupMenu.customItems);
				}
				else {
					// new ContextMenu can be attached via contextMenu command
				}
			}
			else {
				_backupMenu = this['contextMenu'].copy();
				ContextMenuManager.unregisterMovieClip(root_mc, this);
				this['contextMenu'] = undefined;
			}
		}
		
		// getter
		public function get enableContextMenu() : Boolean{
			return _enableContextMenu;
		}     
		
		/** 
		Determines if nodes can be renamed from within the textfield in the Tree
		@tiptext Determines if nodes can be renamed from within the textfield in the Tree
		@description Boolean. Determines if nodes can be renamed from within the textfield in the Tree. If enabled then the user can double click on a node and a rename textfield appears. The user can then type in a new name for the node. This can work in conjunction with the labelField and labelFunction as well. Esc cancels the edit. Enter commits the edit. You can use the renameTextRestrict property and validateNodeLabel to control and permit or deny what text they can enter and commit. 
		@usage myInstance.enableRenameNode = true;
		@example The example below enables the rename feature.
		<pre>
		theTree.enableRenameItem = false;
		</pre>
		@see #renameOnDoubleClick
		@see #renameTextRestrict
		@see #validateItemLabel
		@see #labelFunction
		@see #setItemLabel
		*/
		[Inspectable(type=Boolean, name=" Enable Rename Node (enableRenameNode)", defaultValue="true", category="_General 010")]
		public var enableRenameNode:Boolean = true;
		
		/** 
		Determines if an item can be renamed on double click
		@tiptext Determines if an item can be renamed on double click
		@description Boolean. Determines if an item can be renamed on the double click event. If this property is true then a user can double click on a row item and a rename textfield appears. The user can then type in a new label for the item. If this property is false then the rename textfield is not shown on a double click event. If the enableRenameNode property is set to true then rename is still possible through the "Rename Item" in the context contextMenu. Esc cancels the edit. Enter or tab commits the edit. You can use the renameTextRestrict property and validateItemLabel for more control. If you define the labelFunction you may need to redefine the setItemLabel function. You can also prevent renaming on individual nodes by using the permitRename function. See permission examples.
		@usage myInstance.enableRenameItem = true;
		@example The example below disables the rename feature on double click. 
		<pre>
		theTree.renameOnDoubleClick = false;
		</pre>
		@see #renameTextRestrict
		@see #validateItemLabel
		@see #labelFunction
		@see #setItemLabel
		@see #permitRename
		*/
		[Inspectable(type=Boolean, name=" Rename on DoubleClick (renameOnDoubleClick)", defaultValue="true", category="_General 010")]
		public var renameOnDoubleClick:Boolean = true;
	
		/** 
		Determines if keypresses in the Tree find and select rows
		@tiptext Determines if keypresses in the Tree find and select rows
		@usage myInstance.enableKeySearch = true;
		@description Boolean. Determines if keypresses in the Tree find and select rows. If enabled then the user can type a key and the Tree will search for the row by the current key pressed. If you have a row with a label named "John" and you click the letter "J" then the row is selected. If multiple rows start with the letter "J" then the rows are selected in the order they appear. 
		@example The example below disables key searching.
		<pre>
		myInstance.enableKeySearch = false;
		</pre>
		*/
		[Inspectable(type=Boolean, name=" Enable Keyboard Search (enableKeySearch)", defaultValue="true", category="_General 010")]
		public var enableKeySearch:Boolean = true;
	
		/** 
		The height in pixels of the gutter space inbetween nodes
		@tiptext The height in pixels of the gutter space inbetween nodes
		@description Number. Amount of space in pixels into a nodes row that counts as the drop before or drop after zone. The default value of dndGutter is 5. This property can be set through the Component Panel by changing the "Gutter Space" parameter value. 
		@usage myInstance.dndGutter = newValue;
		@example The example below sets the property.
		<pre>
		theTree.dndGutter = 5;
		</pre>
		*/
		[Inspectable(type=Number, name=" Gutter Space (dndGutter)", defaultValue="5", category="_General 010")]
		public var dndGutter:Number = 5;
	
		/** 
		Open a closed branch on paste into
		@tiptext Open a closed branch on paste into
		@description Boolean. Opens a closed branch when a user drops or pastes nodes into it. The default value of openClosedBranchOnPasteInto is true. This property can be set through the Component Panel by changing the "Open Closed Branch on Paste Into" parameter value. 
		@usage myInstance.openClosedBranchOnPasteInto = newValue;
		@example The example below enables the property.
		<pre>
		theTree.openClosedBranchOnPasteInto = true;
		</pre>
		*/
		[Inspectable(type=Boolean, name=" Open Closed Branch on Paste Into (openClosedBranchOnPasteInto)", defaultValue="true", category="_General 010")]
		public var openClosedBranchOnPasteInto:Boolean = true;
		
		/** 
		Preserves branch nodes as branch nodes
		@tiptext Preserves branch nodes as branch nodes
		@description Boolean. Preserves branch nodes as branch nodes in the Tree. It does not initially set any nodes to branches. For example, this property will preserves a branch node as a branch when the last child node is removed instead of it reverting back to a leaf. The default value of preserveBranches is true. This property can be set through the Component Panel by changing the "Preserve Branches" parameter value. Initially you can loop through and set branches without children to a branch node using setIsBranch(node, true) or you can set each node icon to "dndBranchClosedIcon" or "dndLeafIcon" using the iconFunction. See the icon example. 
		<p>You can use the labelFunction to specifically and automatically type your nodes on an as needed basis. The labelFunction is called when a row is drawn. You would check if an attribute exists or check if childNodes exist (its up to you to determine) and set the node to a leaf or branch. Use setIsBranch(theNode, true) or setIsBranch(theNode, false). Note you cannot set a node to a leaf node type if it has children.</p>
		@usage myInstance.preserveBranches = newValue;
		@example The example below enables the property.
		<pre>
		theTree.preserveBranches = true;
		</pre>
		@see #iconFunction
		@see #labelFunction
		*/
		[Inspectable(type=Boolean, name=" Preserve Branches on Drag Out (preserveBranches)", defaultValue="false", category="_General 010")]
		public var preserveBranches:Boolean = false;
		
		/** 
		Can drop on empty rows
		@tiptext Can drop on empty rows
		@description Boolean. Can drag and drop on any empty rows. Empty rows are the rows that appear beneath the last occupied node in the tree. IE When you have the root node closed the rows that appear beneath it are the empty rows. The default value of canDropOnEmptyRows is false. This property can be set through the Component Panel by changing the "Can Drop on Empty Rows" parameter value. 
		@usage myInstance.canDropOnEmptyRows = newValue;
		@example The example below enables the property.
		<pre>
		theTree.canDropOnEmptyRows = true;
		</pre>
		*/
		[Inspectable(type=Boolean, name=" Can Drop on Empty Rows (canDropOnEmptyRows)", defaultValue="false", category="_General 010")]
		public var canDropOnEmptyRows:Boolean = false;
		
		/** 
		Prevents the user from dropping into a leaf node
		@tiptext Prevents the user from dropping into a leaf node
		@description Boolean. Prevents the user from dropping into a leaf node. The default value of preventDropIntoLeafNodes is false. The user can still paste into a leaf using the context contextMenu. You can prevent this by using the permitContextMenu function.
		@usage myInstance.preventDropIntoLeafNodes = newValue;
		@example The example below prevents drop into leaf node
		<pre>
		theTree.preventDropIntoLeafNodes = true;
		</pre>
		@see #permitContextMenu
		*/
		[Inspectable(type=Boolean, name=" Prevent Drop Into Leaf Nodes (preventDropIntoLeafNodes)", defaultValue="false", category="_General 010")]
		public var preventDropIntoLeafNodes:Boolean = false;
		
		/** 
		Do not insert a row on drop
		@tiptext Do not insert a row on drop
		@description Boolean. Do not insert a row on drop. This allows you to drop on a row and generate a drop or onDrop event without actually inserting a row. 
		@usage myInstance.doNotInsertOnDrop = true;
		@example The example below creates this behavior.
		<pre>
		theTree.doNotInsertOnDrop = true;
	
		function droppedOnto(evt) {
			trace("dropped onto="+evt.targetNode);
			trace("dropped ="+evt.nodes);
		}
		theTree.addEventListener("onDrop",droppedOnto);
	
		</pre>
		*/
		[Inspectable(type=Boolean, name=" Do Not Insert on Drop (doNotInsertOnDrop)", defaultValue="false", category="_General 010")]
		public var doNotInsertOnDrop:Boolean;
		
		/** 
		If true mutiple row selection is allowed
		@tiptext If true mutiple row selection is allowed
		@description Boolean. If true mutiple row selection is allowed. 
		@usage myInstance.multipleSelection = true;
		@example The example below enables the multipleSelection.
		<pre>
		theTree.multipleSelection = true;
		</pre>
		*/
		[Inspectable(type=Boolean, name=" Multiple Selection (multipleSelection)", defaultValue="false", category="_General 010")]
		public var multipleSelection:Boolean = false;
	
		/** 
		Enables all move operations to be copy operations
		@tiptext Enables all move operations to be copy operations
		@description Boolean. Enables all move operations to be copy operations when dragging to another dndComponent. You can still drag and drop inside of the Tree. To prevent dragging and dropping inside the source component use the permitDropFunction and check if the owner is the same. The default value of dndReadOnly is false. This property can be set through Component panel by changing "Read Only" parameter value. 
		@usage myInstance.dndReadOnly = newValue;
		@example The example below enables the property.
		<pre>
		theTree.dndReadOnly = true;
		</pre>
		*/
		[Inspectable(type=Boolean, name=" Read Only (dndReadOnly)", defaultValue="false", category="_General 010")]
		public var dndReadOnly:Boolean = false;
		
		/**
		@exclude
		*/
		[Inspectable(type=String, name=" Vertical Scroll Policy (vScrollPolicy)", enumeration="on,off,auto", defaultValue="auto", category="_General 010")]
		public var vScrollPolicy:String = "auto";
	
		// ***************************************************
		// Style Options
		// ***************************************************
		
		/**
		@exclude
		@description spacer for styles
		*/
		[Inspectable(type=String, name="  ", defaultValue=" ", category="_Style")]
		public var styleSpacer:String; 
		
		/**
		@exclude
		@description header for styles
		*/
		[Inspectable(type=String, name="Style", defaultValue=" ", category="_Style")]
		public var styleHeader:String;
		
		/** 
		Node icon to show when dragging. Deprecated
		@tiptext Node icon to show when dragging. Deprecated
		@description Node icon to show when dragging. The dragDuplicateRow must be set to false for this to have an effect. This property is deprecated in favor enabling the dragDuplicateRow property and modifying the drag_mc directly using the modifyDragMC function. It can be turned off by setting the enableDragIcon to false.
		@see #enableDragIcon
		@see #modifyDragMC
		*/
		public var nodeIcon:MovieClip;
		
		/**
		Copy icon shown when dragging
		@tiptext Copy icon shown when dragging
		@description Copy icon shown when dragging. Use the strCopyIcon property to use a different icon than the default icon. 
		@usage myInstance.copyIcon = "linkageId";
		@example The example below uses a different copy icon.
		<pre>
		theTree.copyIcon = "myIconId";
		</pre>
		@see #copyIconX
		@see #copyIconY
		@see #modifyDragMC
		*/
		public var copyIcon:MovieClip;
		
		/** 
		Id of icon when dragging a closed branch node. Deprecated
		@tiptext Id of icon when dragging a closed branch node. Deprecated
		@description Id of icon when dragging a closed branch node. The dragDuplicateRow must be set to false for this to have an effect. This property is deprecated in favor enabling the dragDuplicateRow property and modifying the drag_mc directly using the modifyDragMC function. The default value of strDragBranchIcon is "dndBranchClosedIcon". Any other movieclip you use must exist in the library or on the stage. This property can be set through the Component Panel by changing "Drag Closed Branch Icon" parameter value.
		@usage myInstance.strDragBranchIcon = "newValue";
		@example The example below sets the property.
		<pre>
		theTree.strDragBranchIcon = "myIconId";
		</pre>
		*/
		[Inspectable(type=String, name=" Drag Closed Branch Icon (strDragBranchIcon)", defaultValue="dndBranchClosedIcon", category="_Style 010")]
		public var strDragBranchIcon:String = "dndBranchClosedIcon";
		
		/** 
		Id of icon when dragging an opened branch node. Deprecated
		@tiptext Id of icon when dragging an opened branch node. Deprecated
		@description Id of icon when dragging an opened branch node. The dragDuplicateRow must be set to false for this to have an effect. This property is deprecated in favor enabling the dragDuplicateRow property and modifying the drag_mc directly using the modifyDragMC function. The default value of strDragBranchOpenedIcon is "dndBranchOpenIcon". Any other movieclip you use must exist in the library or on the stage. This property can be set through the Component Panel by changing "Drag Opened Branch Icon" parameter value.
		@usage myInstance.strDragBranchOpenedIcon = "newValue";
		@example The example below sets the property.
		<pre>
		theTree.strDragBranchOpenedIcon = "myIconId";
		</pre>
		*/
		[Inspectable(type=String, name=" Drag Opened Branch Icon (strDragBranchOpenedIcon)", defaultValue="dndBranchOpenIcon", category="_Style 010")]
		public var strDragBranchOpenedIcon:String = "dndBranchOpenIcon";
		
		/** 
		Id of icon when dragging a leaf node. Deprecated
		@tiptext Id of icon when dragging a leaf node. Deprecated
		@description Id of icon when dragging a leaf node. The dragDuplicateRow must be set to false for this to have an effect. This property is deprecated in favor enabling the dragDuplicateRow property and modifying the drag_mc directly using the modifyDragMC function. The default value of strDragLeafIcon is "dndLeafIcon". Any other movieclip you use must exist in the library or on the stage. This property can be set through the Component Panel by changing "Drag Leaf Icon" parameter value.
		@usage myInstance.strDragLeafIcon = "newValue";
		@example The example below sets the property.
		<pre>
		theTree.strDragLeafIcon = "myIconId";
		</pre>
		*/
		[Inspectable(type=String, name=" Drag Leaf Icon (strDragLeafIcon)", defaultValue="dndLeafIcon", category="_Style 010")]
		public var strDragLeafIcon:String = "dndLeafIcon";
		
		/** 
		Id of icon when dragging is not permitted	
		@tiptext Id of icon when dragging is not permitted
		@description Id of icon when dragging is not permitted. The default value of strNoDropIcon is "dndNoDropIcon". Any other movieclip you use must exist in the library or on the stage. This property can be set through the Component Panel by changing "No Drop Icon" parameter value. The dndTree includes one additional built in icon called "dndNoDropIcon2".
		@usage myInstance.strNoDropIcon = "newValue";
		@example The example below sets the property.
		<pre>
		theTree.strNoDropIcon = "myIconId";
		</pre>
		*/
		[Inspectable(type=String, name=" No Drop Icon (strNoDropIcon)", defaultValue="dndNoDropIcon", category="_Style 010")]
		public var strNoDropIcon:String = "dndNoDropIcon"; 
		
		/** 
		Id of icon to show when copying a node
		@tiptext Id of icon to show when copying a node
		@description Id of icon to show when copying a node. The default value of strCopyIcon is "dndCopyIcon". Any other movieclip you use must exist in the library or on the stage. This property can be set through the Component Panel by changing "Copy Icon" parameter value.
		@usage myInstance.strCopyIcon = "newValue";
		@example The example below sets the property.
		<pre>
		theTree.dndCopyIcon = "myIconId";
		</pre>
		*/
		[Inspectable(type=String, name=" Copy Icon (strCopyIcon)", defaultValue="dndCopyIcon", category="_Style 010")]
		public var strCopyIcon:String = "dndCopyIcon";
		
		/** 
		Id of generic icon. Deprecated
		@tiptext Id of generic icon. Deprecated
		@description Id of generic icon. Deprecated. The dragDuplicateRow must be set to false for this to have an effect. This property is deprecated in favor enabling the dragDuplicateRow property and modifying the drag_mc directly using the modifyDragMC function. 
		@usage myInstance.strGenericIcon = "newValue";
		@example The example below sets the property.
		<pre>
		theTree.strGenericIcon = "myIconId";
		</pre>
		@see #dragDuplicateRow
		@see #modifyDragMC
		*/
		[Inspectable(type=String, name=" Generic Drag Icon (strGenericIcon)", defaultValue="dndGenericIcon", category="_Style 010")]
		public var strGenericIcon:String = "dndGenericIcon";
		
		/** 
		Displays or hides the node label while dragging. Deprecated
		@tiptext Displays or hides the node label while dragging. Deprecated
		@description Boolean. Displays or hides the node label while dragging. Deprecated. The dragDuplicateRow must be set to false for this to have an effect. This property is deprecated in favor enabling the dragDuplicateRow property and modifying the drag_mc directly using the modifyDragMC function. 
		@usage myInstance.enableDisplayLabel = newValue;
		@example The example below enables the property.
		<pre>
		theTree.enableDisplayLabel = true;
		</pre>
		@see #dragDuplicateRow
		@see #modifyDragMC
		*/
		[Inspectable(type=Boolean, name=" Display Label while Dragging (enableDisplayLabel)", defaultValue="true", category="_Style 010")]
		public var enableDisplayLabel:Boolean = true;
		
		/** 
		Displays or hides a highlight rect when dragging. Deprecated
		@tiptext Displays or hides a highlight rect when dragging. Deprecated
		@description Boolean. Displays or hides a highlight rect when dragging. Deprecated. The dragDuplicateRow must be set to false for this to have an effect. This property is deprecated in favor enabling the dragDuplicateRow property and setting the dragRowStyle to "normal", "selected" or "highlight".
		@usage myInstance.enableDragHighlight = newValue;
		@example The example below enables the property.
		<pre>
		theTree.enableDragHighlight = true;
		</pre>
		@see #dragDuplicateRow
		@see #dragHighlightAlpha
		@see #modifyDragMC
		@see #dragRowStyle
		*/
		[Inspectable(type=Boolean, name=" Show Drag Highlight (enableDragHighlight)", defaultValue="true", category="_Style 010")]
		public var enableDragHighlight:Boolean = true;
		
		/** 
		Creates an exact duplicate of the row you are dragging.
		@tiptext Creates an exact duplicate of the row you are dragging.
		@description Boolean. This feature creates an exact duplicate of the row you are dragging. This feature was created after many of the other drag features were already created and makes the other features obsolete. You can choose the style of the dragged duplicate row by setting the dragRowStyle. Using this style property you can drag a duplicate row in any of the row states, "normal", "selected" or hightlight". You should enable this property to have an exact copy of the row you are dragging and if you need to modify it then make modifications to the drag_mc using the modifyDragMC function. Enumerate drag_mc in the modifyDragMC function to see the properties. Reference the row_mc0 property of the drag_mc to modify it's properties. 
		@usage myInstance.dragDuplicateRow = true;
		@example The example below disables the dragDuplicateRow property.
		<pre>
		theTree.dragDuplicateRow = false;
		</pre>
		@see #dragHighlightAlpha
		@see #enableDragHighlight
		@see #dragHighlightColor
		@see #enableDragIcon
		@see #dragRowStyle
		*/
		[Inspectable(type=Boolean, name=" Drag Duplicate Row (dragDuplicateRow)", defaultValue="true", category="_Style 010")]
		public var dragDuplicateRow:Boolean = true;
		
		/** 
		The default row style of the rows in the drag mc
		@tiptext The default row style of the rows in the drag mc
		@description String. The default row style of the rows in the drag mc. This property gives the dragged rows the appearance of a "normal", "selected" or "highlight" row style. The default style is "selected". You must have dragDuplicateRow set to true for this to have an effect.
		@usage myInstance.dragRowStyle = "normal";
		@example The example below sets the dragRowStyle to "normal".
		<pre>
		theTree.dragRowStyle = "normal";
		</pre>
		@see #dragDuplicateRow
		@see #dragHighlightAlpha
		@see #enableDragHighlight
		@see #dragHighlightColor
		@see #enableDragIcon
		*/
		[Inspectable(type=String, name=" Drag Row Style (dragRowStyle)", defaultValue="selected", enumeration="normal,selected,highlighted", category="_Style 010")]
		public var dragRowStyle:String;
		
		/** 
		Transparency amount of the highlight rect when dragging
		@tiptext Transparency amount of the highlight rect when dragging
		@description Number. Transparency amount of the highlight rect when dragging. The default value of dragHighlightAlpha is 50. 
		@usage myInstance.dragHighlightAlpha = 30;
		@example The example below sets the transparency to 30 percent.
		<pre>
		theTree.dragHighlightAlpha = 30;
		</pre>
		*/
		[Inspectable(type=Number, name=" Drag Highlight Alpha (dragHighlightAlpha)", defaultValue="50", category="_Style 010")]
		public var dragHighlightAlpha:Number = 50;
		
		/** 
		@exclude
		*/
		[Inspectable(type=Color, name=" Drag Highlight Color (dragHighlightColor)", defaultValue="#BECAD6", category="_Style 010")]
		public var dragHighlightColor:Number;
		
		/** 
		Displays or hides a node's icon when dragging. Deprecated
		@tiptext Displays or hides a node's icon when dragging. Deprecated
		@description Boolean. Displays or hides a node's icon when dragging. The dragDuplicateRow must be set to false for this to have an effect. This property is deprecated in favor enabling the dragDuplicateRow property and modifying the drag_mc directly using the modifyDragMC function. 
		@usage myInstance.enableDragIcon = newValue;
		@example The example below enables the property.
		<pre>
		theTree.enableDragIcon = true;
		</pre>
		@see #dragDuplicateRow
		*/
		[Inspectable(type=Boolean, name=" Show Drag Node Icons (enableDragIcon)", defaultValue="true", category="_Style 010")]
		public var enableDragIcon:Boolean = true;
		
		/** 
		Displays or hides the default generic drag icon when dragging. Deprecated
		@tiptext Displays or hides the default generic drag icon when dragging. Deprecated
		@description Boolean. Displays or hides the default generic drag icon (strGenericIcon) when dragging instead of the current node icon. The dragDuplicateRow must be set to false for this to have an effect. This property is deprecated in favor enabling the dragDuplicateRow property and modifying the drag_mc directly using the modifyDragMC function. This property can be set through Component panel by changing "Show Generic Drag Node" parameter value. 
		@usage myInstance.enableGenericIcon = true;
		@example The example below enables the generic icon.
		<pre>
		theTree.enableGenericIcon = true;
		</pre>
		@see #dragDuplicateRow
		*/
		[Inspectable(type=Boolean, name=" Show Generic Node Icon (enableGenericIcon)", defaultValue="false", category="_Style 010")]
		public var enableGenericIcon:Boolean;
		
		/** 
		Draws a drag line over rows
		@tiptext Draws a drag line over rows
		@description Boolean. Draws a drag line over rows as a visual guideline. As you drag over the Tree rows the drag separator will pause before, after or in the middle of the row. You can modify the look and feel of the drag line using the drawSeparator function.
		@usage myInstance.drawDragLine = true;
		@example The code below turns on the drag line.
		<pre>
		theTree.drawDragLine = true;
		</pre>
		@see #drawSeparator
		*/
		[Inspectable(type=Boolean, name=" Drag Line (enableDragLine)", defaultValue="true", category="_Style 010")]
		public var enableDragLine:Boolean = true;
		
		/** 
		@exclude
		*/
		[Inspectable(type=String, name=" Border Style (borderStyle)", enumeration="none,solid,inset,outset", defaultValue="solid", category="_Style 010")]
		public var borderStyle:String = "solid";
		
		/** 
		@exclude
		*/
		[Inspectable(type=Color, name=" Border Color (borderColor)", defaultValue="#D5DDDD", category="_Style 010")]
		public var borderColor;
		
		/** 
		@exclude
		*/
		[Inspectable(type=Color, name=" Selection Color (selectionColor)", defaultValue="#006699", category="_Style 010")]
		public var selectionColor;
		
		/** 
		@exclude
		*/
		[Inspectable(type=Color, name=" Roll Over Color (rollOverColor)", defaultValue="#BECAD6", category="_Style 010")]
		public var rollOverColor;
		
		/** 
		@exclude
		*/
		[Inspectable(type=Boolean, name=" Use Roll Over (useRollOver)", defaultValue="false", category="_Style 010")]
		public var useRollOver:Boolean = false;
		
		/** 
		@exclude
		*/
		[Inspectable(type=Color, name=" Text Roll Over Color (textRollOverColor)", defaultValue="#2B333C", category="_Style 010")]
		public var textRollOverColor;
		
		/** 
		@exclude
		*/
		[Inspectable(type=Color, name=" Text Selected Color (textSelectedColor)", defaultValue="#FDFDFD", category="_Style 010")]
		public var textSelectedColor;
		
		/** 
		@exclude
		* The selection does not really look good with the double clicking / rename feature
		*/
		public var selectionDuration:Number = 0;
		
		/** 
		@exclude
		*/
		[Inspectable(type=String, name=" Default Leaf Icon (defaultLeafIcon)", defaultValue="dndLeafIcon", category="_Style 010")]
		public var defaultLeafIcon:String = "dndLeafIcon";;
		
		/** 
		@exclude
		*/
		[Inspectable(type=String, name=" Folder Open Icon (folderOpenIcon)", defaultValue="dndBranchOpenIcon", category="_Style 010")]
		public var folderOpenIcon:String = "dndBranchOpenIcon";
		
		/** 
		@exclude
		*/
		[Inspectable(type=String, name=" Folder Closed Icon (folderClosedIcon)", defaultValue="dndBranchClosedIcon", category="_Style 010")]
		public var folderClosedIcon:String = "dndBranchClosedIcon";
		
		/** 
		@exclude
		*/
		[Inspectable(type=String, name=" Disclosure Open Icon (disclosureOpenIcon)", defaultValue="dndDisclosureOpenIcon", category="_Style 010")]
		public var disclosureOpenIcon:String = "dndDisclosureOpenIcon";
		
		/**
		@exclude
		*/
		[Inspectable(type=String, name=" Disclosure Closed Icon (disclosureClosedIcon)", defaultValue="dndDisclosureClosedIcon", category="_Style 010")]
		public var disclosureClosedIcon:String = "dndDisclosureClosedIcon";
		
		// boolean property indicates whether the drag mc is in between two nodes
		protected var bInGutter:Boolean;
		
		// object to hold "x" and "y" coordinate of the mouse pointer
		protected var objPoint:Object;
		
		/** 
		Reference to the target node after drag and drop
		@tiptext Reference to the target node after drag and drop
		@description Object. Reference to the target node during drag and drop operation. Another way to put it is as you drag a node over another node the node or row that you drop onto is the target node. This node is set after a successful drag and drop. 
		@usage myInstance.targetNode;
		@example The example below traces the property.
		<pre>
		trace(theTree.targetNode);
		</pre>
		*/
		public var targetNode:XMLNode;
		
		// used when dragging over an empty row
		protected var emptyRow:Boolean;
		
		// the node used for copy and paste operations. deprecated
		protected var theCopyNode;
		
		/** 
		Reference to the copied nodes
		@tiptext Reference to the copied nodes
		@description Array of Nodes. Reference to an array of nodes. This array of nodes is created when a user selects "Cut Item" or "Copy Item" from the context contextMenu. This array also is created when the user calls the methods cutNode or copyNode.
		@usage myInstance.theCopyNodes;
		@example The example below traces the property.
		<pre>
		trace(theTree.theCopyNodes);
		</pre>
		*/
		public var theCopyNodes:Array;
		
		/** 
		Reference to the copied list items
		@tiptext Reference to the copied list items
		@description Array of dategrid items. Reference to an array of list items. This array of list items is created when a user selects "Cut Item" or "Copy Item" from the context contextMenu. This array also is created when the user calls the methods cutNode or copyNode.
		@usage myInstance.theCopyItems;
		@example The example below traces the property.
		<pre>
		trace(theTree.theCopyItems);
		</pre>
		@see #convertToItem
		*/
		public var theCopyItems:Array;
		
		/** 
		Reference to the copied datagrid items
		@tiptext Reference to the copied datagrid items
		@description Array of dategrid items. Reference to an array of datagrid items. This array of datagrid items is created when a user selects "Cut Item" or "Copy Item" from the context contextMenu. This array also is created when the user calls the methods cutNode or copyNode.
		@usage myInstance.theCopyGridItems;
		@example The example below traces the property.
		<pre>
		trace(theTree.theCopyGridItems);
		</pre>
		*/
		public var theCopyGridItems:Array;
		
		// start dragging when you mouse moves out of the row
		[Inspectable(type=Boolean, name=" Drag on Roll Out (dragOnRollOut)", defaultValue="false", category="_General 010")]
		public var dragOnRollOut:Boolean = false;
		
		// number of pixels to move before we start dragging
		public var movementBeforeDrag:Number = 4;
		
		// boolean value that indicates the position of the mouse as it is dragged over a row 
		protected var dragOverAbove:Boolean;
		// boolean value that indicates the position of the mouse as it is dragged over a row 
		protected var dragOverBelow:Boolean;
		
		/** 
		Contains current or last position of the dragged node
		@tiptext Contains current or last position of the dragged node
		@description Contains current or last position of the dragged node. When dragging this property contains one of the constants dndTree.PASTE_INTO, dndTree.PASTE_AFTER, dndTree.PASTE_BEFORE. 
		@usage myInstance.dragOverPos;
		@example The example below traces the property.
		<pre>
		trace(theTree.dragOverPos);
		</pre>
		*/
		public var dragOverPos:Number = 0;
		
		/** 
		Reference to the ContextMenu
		@tiptext Reference to the ContextMenu
		@description ContextMenu; Reference to ContextMenu. The ContextMenu class is documented in the Help Panel. You can change the context contextMenu items easily by following the examples in the Help Panel or by following the examples provided with the component. 
		
		<br><br>The contextMenu has an additional method called, "find(caption:String)" that returns the item by matching the item's caption. Each customItem in the customItems array, the array of items that make up the context contextMenu, have an additional "action" property that contains one of the dndTree contants, PASTE_INTO, PASTER_AFTER, etc. useful for internal dndTree methods. 
		
		<br><br>When you create your own context contextMenu items add the owner property. The owner should be a reference to the component. This allows the component to work inside nested movieclips.
		
		<br><br>This is also a duplicate of the contextMenu property. You do not want to over write the contextMenu property with your own contextMenu because the contextMenu will not work in nested movieclips in Flash Player 7 and 8. Instead add or remove items from the existing contextMenu or if you would like to use a different contextMenu add it to the contextMenu property. This will provide the necessary behaviors to work in nested movieclips and to handle selecting the node the mouse is over (which is not always the selected node). You can always revert back to the default contextMenu by setting contextMenu to the cm property. 
		
		<br><br>To change the text of any of the existing contextMenu items use the caption property. For example, myTree.cm.customItems[0].caption = "new text".
		@usage myInstance.cm;
		@example This example shows adding, removing and renaming of the contextMenu items.
		<pre>
		// get reference to the context contextMenu contextMenu items array - you may have to use the theTree.contextMenu property if you are using your own contextMenu
		var menuItems = theTree.cm.customItems;
		// create our new context contextMenu items
		var newMenuItem = new ContextMenuItem("My Menu Item", doSomething, true);
		var newMenuItem2 = new ContextMenuItem("Inserted Item", doSomething, true);
		
		// set this when the component is in a nested movieclip
		newMenuItem.owner = theTree;
		newMenuItem2.owner = theTree;
		
		// add an item to the end of the component
		menuItems.push(newMenuItem);
		
		// remove two previous contextMenu items
		menuItems.splice(5,2);
		
		// add a new item at the beginning of the contextMenu stack
		menuItems.splice(0,0,newMenuItem2);
		
		// add a separator before item 1
		menuItems[1].separatorBefore = true;
		
		// rename an existing contextMenu item
		menuItems[1].caption = "Cut the item out";
	
		// this function is called by our context contextMenu items
		function doSomething(obj:Object, menuItem:Object):void {
			// be aware of scope issues in this function
			trace("obj=" + obj)
			trace("you clicked " + menuItem.caption)
		}
		</pre>
		@see #permitContextMenu
		*/
		public var cm:ContextMenu;
		
		/**
		* @exclude
		* movieclip that is used to show the position of the mouse as it is dragged between rows
		*/
		public var separator:MovieClip;
		
		// @exclude
		[Bindable(type="XMLDocument")]
		public var _inherited_dataProvider:Object;
	
		// used to indicate if mouse is over tree when dragging
		protected var bIsTreeTarget:Boolean = false;
		
		// used to indicate if cross drag is enabled in the tree
		protected var bCrossDragEnabled:Boolean = false;
		
		/**
		* Enable automatic horizontal scrollbars
		* @description Enable automatic horizontal scrollbars. When this is set to true horizontal scrollV bars are created or removed based on how wide the visible child nodes are. Horizontal scrollbars are determined when a branch is open or closed. You can manually call the method that shows or hides the scrollV bars by calling dndTree.setHorizontalScroll() or dndTree.setHorizontalScrollLater(). The setHorizontalScroll method waits a frame and then calls the setHorizontalScrollLater() function.
		*/
		[Inspectable(type=Boolean, name=" Enable Auto Horizontal Scrollbars (enableAutoHorizontalScrollPolicy)", defaultValue="false", category="_General 010")]
		public var enableAutoHorizontalScrollPolicy:Boolean = false;
		
		// movieclip with class that captures context contextMenu events
		//public var menuEvtHandler:MovieClip;
		
		// indicates to move the node
		protected var moveAfterDropMode:Boolean = true;
	
		/** 
		Absolute index of the row the mouse was last over
		@tiptext Absolute index of the row the mouse was last over
		@description Number. Absolute index of the row the mouse was last over.
		@usage myInstance.lastOver;
		@example The example below traces the property.
		<pre>
		trace(theTree.lastOver);
		</pre>
		*/
		public var lastOver:Number;
		
		/** 
		Relative index of the row the mouse was last over
		@tiptext Relative index of the row the mouse was last over
		@description Number. Relative index of the row the mouse was last over.
		@usage myInstance.lastOverIndex;
		@example The example below traces the property.
		<pre>
		trace(theTree.lastOverIndex);
		</pre>
		*/
		public var lastOverIndex:Number;
	
		/** 
		Reference to the last node moved
		@tiptext Reference to the last node moved
		@description Boolean. Reference to the last node moved in the Tree. 
		@usage movedNode = myInstance.lastMovedItem;
		@example The example returns the last moved node.
		<pre>
		movedNode = theTree.lastMovedItem;
		</pre>
		*/
		public var lastMovedItem:Object;
		
		/** 
		Index of the last moved node
		@tiptext Index of the last moved node
		@description Boolean. Index of the last moved node in the Tree. 
		@usage movedNodeIndex = myInstance.lastMovedIndex;
		@example The example returns the index of the last moved node.
		<pre>
		movedNodeIndex = theTree.lastMovedIndex;
		</pre>
		*/
		public var lastMovedIndex:Number;	
		
		/** 
		Parent node of the last moved node
		@tiptext Parent node of the last moved node
		@description Boolean. Parent node of the last moved node.
		@usage parentNode = myInstance.lastMovedParent;
		@example The example returns the parent node of the last moved node.
		<pre>
		parentNode = theTree.lastMovedParent;
		</pre>
		*/
		public var lastMovedParent:Object;
		
		/** 
		Owner of the last moved node
		@tiptext Owner of the last moved node
		@description Boolean. Owner of the last moved node.
		@usage theNodeSource = myInstance.lastMovedSource;
		@example The example returns the owner of the last moved node.
		<pre>
		theNodeSource = theTree.lastMovedSource;
		</pre>
		*/
		public var lastMovedSource:Object;
		
		/** 
		Reference to the last nodes moved
		@tiptext Reference to the last nodes moved
		@description Array of Nodes. Reference to an array of the last nodes moved in the Tree. 
		@usage movedNode = myInstance.lastMovedItems[0];
		@example The example gets the number of moved nodes.
		<pre>
		movedNode = theTree.lastMovedItems.length;
		</pre>
		*/
		public var lastMovedItems:Array;
		
		/** 
		Indices of the last moved nodes
		@tiptext Indices of the last moved nodes
		@description Array of indices of the last moved nodes in the Tree. 
		@usage movedNodeIndex = myInstance.lastMovedIndices[0];
		@example The example returns the index of the first of the last moved nodes.
		<pre>
		movedNodeIndex = theTree.lastMovedIndices[0];
		</pre>
		*/
		public var lastMovedIndices:Array;
		
		/** 
		Parent nodes of the last moved nodes
		@tiptext Parent nodes of the last moved nodes
		@description Array of Nodes. Parent nodes of each of the last moved nodes.
		@usage parentNode = myInstance.lastMovedParents[0];
		@example The example returns the parent node of the firts node of the last moved nodes.
		<pre>
		parentNode = theTree.lastMovedParents[0];
		</pre>
		*/
		public var lastMovedParents:Array;
		
		/** 
		Owners of the last moved nodes
		@tiptext Owners of the last moved nodes
		@description Array of Objects. This is an array of the owners of the last moved nodes. Typically this will be another dndTree or dndComponent.
		@usage theNodeSource = myInstance.lastMovedSources[0];
		@example The example returns the owner of the first node of the last moved nodes.
		<pre>
		theNodeSource = theTree.lastMovedSources[0];
		</pre>
		*/
		public var lastMovedSources:Object;
		
		/** 
		Owners of the last selected nodes
		@tiptext Owners of the last selected nodes
		@description Array of Objects. This is an array of the owners of the last selected nodes. Typically this will be another dndTree or dndComponent.
		@usage theNodeSource = myInstance.lastSelectedSources[0];
		@example The example returns the owner of the first node of the last selected nodes.
		<pre>
		theNodeSource = theTree.lastSelectedSources[0];
		</pre>
		*/
		public var lastSelectedSources:Object;
		
		/** 
		Parent node where nodes were pasted into
		@tiptext Parent node where nodes were pasted into
		@description XMLNode. Parent node where nodes were pasted into. If nodes are pasted into the root node then this property will reference the dndTree.dataProvider.
		@usage theNodeSource = myInstance.thePasteToParentNode;
		@example The example returns the parent node of nodes that were most recently pasted.
		<pre>
		parentNode = theTree.thePasteToParentNode;
		</pre>
		@see #targetNode
		@see #pastePosition
		*/
		public var thePasteToParentNode :XMLNode;
		
		/**
		Relative index in the parent node where nodes were pasted into
		@tiptext Relative index in the parent node where nodes were pasted into
		@description Number. Relative index in the parent node where nodes were pasted into. If the nodes are pasted into the first position of a branch node then the thePasteToPosition would be 0.
		@usage theNodeSource = myInstance.thePasteToPosition;
		@example The example returns the position in the parent node of nodes that were most recently pasted.
		<pre>
		position = theTree.thePasteToPosition;
		</pre>
		@see #targetNode
		*/
		public var thePasteToPosition:Number;
		
		/** 
		Reference to a movieclip to use as a trashcan. Deprecated
		@tiptext Reference to a movieclip to use as a trashcan. Deprecated
		@description Movieclip. Reference to a movieclip to use as a trashcan. Refer to the examples with this component.
		@deprecated Since version 2
		*/
		public var trashCan:MovieClip;
		
		/** 
		Indicates set of characters a user may enter into the rename text field.
		@tiptext Indicates set of characters a user may enter into the rename text field.
		@description String. Indicates a set of characters a user may enter into the rename textfield. See the Textfield.restrict property for more information. See also validateNodeLabel
		@usage myInstance.renameTextRestrict = "A-Za-z0-9 ";
		@example The example limits the text to only allows letters, numbers and spaces.
		<pre>
		theTree.renameTextRestrict = "A-Za-z0-9 ";
		</pre>
		@see #renameOnDoubleClick
		@see #renameTextRestrict
		@see #validateItemLabel
		@see #labelFunction
		@see #setItemLabel
		*/
		public var renameTextRestrict:String;
		
		/** 
		Position to paste new leaf
		@tiptext Position to paste new leaf
		@description String. Indicates the paste position (into, after, before) of new leaf nodes. The default is PASTE_INTO.
		@usage myInstance.addLeafPastePosition = myInstance.PASTE_AFTER;
		@example This code causes added leaf nodes to be added after the selected node.
		<pre>
		theTree.addLeafPastePosition = theTree.PASTE_AFTER;
		</pre>
		*/
		public var addLeafPastePosition:String;
		
		/** 
		Position to paste new branch nodes
		@tiptext Position to paste branch nodes
		@description Indicates the paste position (into, after, before) when adding new branch nodes. The default is PASTE_INTO.
		@usage myInstance.addBranchPastePosition = myInstance.PASTE_AFTER
		@example This code causes added branch nodes to be added after the selected node.
		<pre>
		theTree.addBranchPastePosition = theTree.PASTE_AFTER;
		</pre>
		*/
		public var addBranchPastePosition:String;
		
		/** 
		Default XMLDocument to use when adding leaf nodes
		@tiptext Default XMLDocument to use when adding leaf nodes
		@description String. Indicates the default XMLDocument to use when adding leaf nodes from the "Add Leaf" context contextMenu. Also used as the default value in the addLeafNode() method. This property can be set through the Component Panel by changing the "Default XMLDocument Leaf Node" parameter value. 
		@usage myInstance.leafNodeXML = "<node label='my node'/>";
		@example This code creates a leaf node from the leafNodeXML property and adds it after the selected node.
		<pre>
		theTree.leafNodeXML = "<node label='my node'/>";
		theTree.addLeafNode(theTree.selectedNode, theTree.PASTE_AFTER);
		</pre>
		*/
		//[Inspectable(type=String, name=" Default XMLDocument Leaf Node (leafNodeXML)", defaultValue="&lt;node label=&quot;New Leaf&quot; &gt;" category="_General 010")]
		public var leafNodeXML:String;
		
		/** 
		Default XMLDocument to use when adding branch nodes
		@tiptext Default XMLDocument to use when adding branch nodes
		@description String. Indicates the default XMLDocument to use when adding branch nodes from the "Add Branch" context contextMenu. Also used as the default value in the addBranchNode() method. This property can be set through the Component Panel by changing the "Default XMLDocument Branch Node" parameter value. 
		@usage myInstance.branchNodeXML = "<node label='my node'></node>";
		@example This code creates a branch node from the branchNodeXML property and adds it after the selected node.
		<pre>
		theTree.branchNodeXML = "<node label='my node'></node>";
		theTree.addBranchNode(theTree.selectedNode, theTree.PASTE_INTO);
		</pre>
		*/
		//[Inspectable(type=String, name=" Default XMLDocument Branch Node (branchNodeXML)", defaultValue="&lt;node label=&quot;New Branch&quot; &gt;&lt;/node&gt;" category="_General 010")]
		public var branchNodeXML:String;
		
		/** 
		Time in milliseconds to separate a doubleclick from a delayed click
		@tiptext Time in milliseconds to separate a doubleclick from a delayed click
		@description Number. Time in milliseconds that separates a doubleclick event from a delayed click. The default value is 350 milliseconds. Two clicks on a row within 350 milliseconds dispatches a doubleClick event. If two clicks occur after the clickThreshold then a delayedClick event is dispatched. 
		@usage myInstance.clickThreshold = 400;
		@example This code sets the clickThreshold to 400 milliseconds.
		<pre>
		theTree.clickThreshold = 400;
		</pre>
		*/
		public var clickThreshold:Number = 350;
		
		// is drag in progress
		protected var dragInProgress :Boolean = false;
		
		//selectedRow Id not sure
		protected var selectedRowID  :Number;
		
		//protected var noDropIcon	 :MovieClip;	
		protected var m_copyControlMode:String;
		
		// row index where dragging sequence begins
		protected var startDragRowID   :Number;
		
		// used for double click events
		protected var startDblClickRowID  :Number;
		
		// used for delayed click events
		protected var startDelayedClickRowID:Number;
		
		// time since last click. used for double click event
		protected var lastDoubleClickTime:Number;
		
		// time since last click. used for delayed click event
		protected var lastDelayedClickTime:Number;
	
		// holds the value for X coordinate for the icon of dragged node
		protected var m_copyIconY:Number;
		
		// holds the value for Y coordinate for the icon of dragged node
		protected var m_copyIconX:Number;
		
		// determines whether the node can be dropped
		protected var bCanDrop:Boolean;
		
		// determines whether CTRL button is pressed
		protected var isCtrlButtonPressed:Boolean = false;
		
		// determines whether user is renaming a text field
		protected var	isRenaming:Boolean = false;
		
		// used to prevent double rename node dispatch onKillFocus
		protected var hasRenamed:Boolean = false;
		
		/** 
		Name of rename label to access when using a cellrenderer
		@tiptext Name of rename label to access when using a cellrenderer
		@description String. Name of rename label to access when using a cellrenderer. If you create a label in your cellrenderer you should set this property to the name of the label. 
		@usage myInstance.renameField = "mylabel";
		@example 
		<pre>
		theTree.renameField = "theLabel";
		</pre>
		*/
		public var renameField:String;
		
		/** 
		Reference to the current ContextMenu.
		@tiptext Reference to the current ContextMenu.
		@description ContextMenu; Reference to ContextMenu. Use the contextMenu property to set new context contextMenu. Only use this property to modify the existing contextMenu. See the help on the "cm" property.
		@see #contextMenu
		@see #cm
		*/
		public var contextMenu;
		
	    /**
		@exclude
		@description interval ID, used for delayed scrolling of rows
		*/
	    protected var delayedNextRowScrollID:Number; 
	    
	    /**
		@exclude
		@description variable used to hold a reserve copy of current context contextMenu
		*/
	    protected var _backupMenu : ContextMenu;
	    
		/**
		@exclude
		@description internal variable, allows/ prohibits display of contextMenu
		*/
	    protected var _enableContextMenu : Boolean;
		
		/**
		Enable tooltip
		@description Enable the tooltip. When this is enabled and the cell does not fit into the width of the component then a tooltip is show next to the mouse. You can set the time before the tooltip is shown by changing the toolTipDelay property. You can set the showToolTipsOnAllRows property to show tool tips on all rows regardless if they fit in the component or not. Note: The tooltip depth is set to 1000 on the root level by default. To set it higher or lower set the toolTipDepth. You can style the tooltip by using the toolTipFunction.
		@see #toolTipDelay
		@see #toolTipDepth
		@see #showToolTipsOnAllRows
		@see #toolTipFunction
		*/
		[Inspectable(type=Boolean, name=" Enable Tool Tip (enableToolTip)", defaultValue="true", category="_General 010")]
	    public var enableToolTip:Boolean = true;
		
	    /**
		@exclude
		@description interval ID, used for delayed tooltip showing
		*/
	    protected var delayedToolTipID:Number;
		
		/**
		Tooltip delayed response in milliseconds
		@tiptext Tooltip delayed response in milliseconds
		@description Tooltip delayed response in milliseconds. This is the amount of time to wait before showing the tooltip. The default value is 750 milliseocnds.
		@usage myInstance.toolTipDelay = 500;
		@example This example the tool tip delay to 500 milliseconds.
		<pre>
		theTree.toolTipDelay = 500;
		</pre>
		@see #enableToolTip
		@see #toolTipDepth
		@see #showToolTipsOnAllRows
		@see #toolTipFunction
		*/
		public var toolTipDelay:Number = 750;
		
		/**
		Tooltip depth
		@tiptext Tooltip depth
		@description Tooltip depth. This is the depth that the tooltip will be created at on the root movieclip. 
		@usage myInstance.toolTipDepth = 1000;
		@example This example the tool tip depth to 2000.
		<pre>
		theTree.toolTipDepth = 2000;
		</pre>
		@see #enableToolTip
		@see #toolTipDelay
		@see #showToolTipsOnAllRows
		@see #toolTipFunction
		*/
		public var toolTipDepth:Number = 1000;
		
		/**
		Show tooltips on all rows
		@tiptext Show tooltips on all rows
		@description Show tooltips on all rows. By default tooltips are only shown on rows that do not fit inside the width of the component. Enabling this property causes tooltips to show up on all rows. 
		@usage myInstance.showToolTipsOnAllRows = true;
		@example This example enables showToolTipsOnAllRows.
		<pre>
		theTree.showToolTipsOnAllRows = true;
		</pre>
		@see #enableToolTip
		@see #toolTipDelay
		@see #toolTipDepth
		@see #toolTipFunction
		*/
		public var showToolTipsOnAllRows:Boolean = false;
	    
	    
	    public var contextMenuManager:ContextMenuManager;
	
		public var isLoaded : Boolean;
	
		public var isReady : Boolean;
	    
	    protected function onLoad():void{
	    	super.onLoad();
	    	trace("DndTree.onLoad");
	    	isLoaded = true;
	    	isReady = true;
	    	parent.onChildClipLoad(this);
	    }
		/**
		@exclude
		This sets the default values
		*/
		public function init():void {
			
			// call the original init method
			super.init();
			
			// create a context contextMenu for right click options
			cm = new ContextMenu();
			cm.hideBuiltInItems();
			
			// create the context contextMenu items
			var cutItem = new ContextMenuItem(strCutItem, onCutTreeItemMenu);
			var copyItem = new ContextMenuItem(strCopyItem, onCopyTreeItemMenu);
			var piItem = new ContextMenuItem(strPasteInto, onPasteIntoTreeItemMenu);
			var pbItem = new ContextMenuItem(strPasteBefore, onPasteBeforeTreeItemMenu);
			var paItem = new ContextMenuItem(strPasteAfter, onPasteAfterTreeItemMenu);
			var alItem = new ContextMenuItem(strAddLeaf, onAddLeafTreeItemMenu, true);
			var abItem = new ContextMenuItem(strAddBranch, onAddBranchTreeItemMenu);
			var remItem = new ContextMenuItem(strRemoveItem, onRemoveTreeItemMenu, true);
			var renItem = new ContextMenuItem(strRenameItem, onRenameTreeItemMenu, true);
			
			// create references to static variables
			cutItem.action = CUT_ITEM;
			copyItem.action = COPY_ITEM;
			piItem.action = PASTE_INTO;
			pbItem.action = PASTE_BEFORE;
			paItem.action = PASTE_AFTER;
			alItem.action = ADD_LEAF;
			abItem.action = ADD_BRANCH;
			remItem.action = REMOVE_ITEM;
			renItem.action = RENAME_ITEM;
			
			// add the context contextMenu items in this order
			cm.customItems.push(cutItem);
			cm.customItems.push(copyItem);
			cm.customItems.push(piItem);
			cm.customItems.push(pbItem);
			cm.customItems.push(paItem);
			cm.customItems.push(alItem);
			cm.customItems.push(abItem);
			cm.customItems.push(remItem);
			cm.customItems.push(renItem);
			
			// Get the list of selected nodes on right mouse click
			cm.onSelect = this.onContextMenuPreSelect;
			
			// a method to get a reference to contextMenu items by caption name
			cm.find = function (strCaption:String) {
				for(var i:Number=0; i < ContextMenu(this).customItems.length; i++) {
					if (ContextMenu(this).customItems[i].caption == strCaption) {
						return ContextMenu(this).customItems[i];
					}
				}
				return false;
			};
			
			// get real _root
			root_mc = getRoot(this);
			
			// cMenuManager if not at the _root > use workaround
			//if (this.parent != root_mc) {
				// TODO: Comment on this
				ContextMenuManager.registerMovieClip(root_mc, this, cm.customItems);
			//}
			//else {
				// set up Context Menu as usual
				//this.theContextMenu = cm;
				this["contextMenu"] = cm;
			//}
			
			/*	
			// cMenuManager if not at the _root > use workaround
			if (this.parent != _root) {
				var contextMenu_MovieClipToAttach:MovieClip;
				contextMenu_MovieClipToAttach = this;
	  
				// TODO: Comment on this
				while (contextMenu_MovieClipToAttach.parent !=_root)	{
					contextMenu_MovieClipToAttach = contextMenu_MovieClipToAttach.parent;					
				}
				
				// TODO: Comment on this
				contextMenuManager.registerMovieClip(contextMenu_MovieClipToAttach, this, cm.customItems);
			}
			else {
				// set up Context Menu as usual
				//this.theContextMenu = cm;
				this["contextMenu"] = cm;
			}
			*/
			
			// create Object to subscribe to dndTree as a Listener
			var treeListener = new Object();
			
			//handler function called on Tree component "itemRollOver" event	  
			treeListener.itemRollOver = function(eventObj:Object) {
				var theTree = eventObj.target;
				// lastOver property is the absolute row index
				var absRowIndex:Number = eventObj.index;
				var rowIndex = absRowIndex - theTree.vPosition;
				
				// keep track of row mouse was last over
				theTree.lastOver = absRowIndex;
				theTree.lastOverIndex = rowIndex;
				var bIsEmptyRow = (theTree.getItemAt(absRowIndex)==undefined)? true : false;
				
				if (theTree.enableToolTip && !bIsEmptyRow) {
					
					if (theTree.delayedToolTipID==undefined)
					{
						theTree.delayedToolTipID = setInterval(theTree, "showToolTip", theTree.toolTipDelay);
						
						//lastScrollDragTime = getTimer();
					}
				}
			};
			
			//handler function called on "itemRollOver" event	  
			treeListener.itemRollOut = function(eventObj:Object) {
				var theTree = eventObj.target;
				if (theTree.enableToolTip) {
					theTree.hideToolTip();
				}
			};
			
			//handler function called on Tree component "change" event	  
			treeListener.change = function(eventObj:Object)	{
				var theTree = eventObj.target;
				//trace("\ntheTree.vPosition="+theTree.vPosition)
				//trace("eventObj.index="+eventObj.index)
				//trace("rowIndex="+rowIndex)
				//trace("theTree.selectedIndex="+theTree.selectedIndex)
				
				// this may be necessary???
				//theTree.lastOver = theTree.selectedIndex;
			};
			
			// listen for item roll over changes
			addEventListener("itemRollOver", treeListener);
			addEventListener("itemRollOver", treeListener);
			addEventListener("change", treeListener);
	        
			//show horizontal Scroller if required upon nodeOpen or nodeClose event
			addEventListener("nodeOpen", setHorizontalScroll);
			addEventListener("nodeClose", setHorizontalScroll);
			//addEventListener("scrollV", resizeTreeWidth);	
			
			// listen to keyboard events for multiple selection and copy operations
			//Keyboard.addListener(this);
			
			// init variables with default values				
			theCopyNodes = new Array();
			theCopyItems = new Array();
			theCopyGridItems = new Array();
			
			// set the copy icon location
			copyIconX = 10;
			copyIconY = 10;
			
			lastScrollDragTime = getTimer();
		}
		
		/**
		Method to display tooltip
		@tiptext Method to display tooltip
		@description Method to display tooltip. 
		*/
		public function showToolTip():void {
			var theRoot = getRoot(this);
			var row = rows[lastOverIndex];
			var cellWidth:Number = row.cell.getPreferredWidth();
			
			// its width comes back undefined
			if (cellWidth != undefined) {
				// The offset accounts for the indent of child tree items...
				var offset:Number = row.cell.x;
				// add in disclosure width
				//offset += row.nodeIcon.width;
				//trace(" row.nodeIcon.width="+row.nodeIcon.width)
				//offset += row.disclosure.x;
				cellWidth += offset;
			}
			//trace("cellWidth = " + cellWidth + ":width=" + width);
			// get mouse position
			//objPoint.x = root_mc.mouseX;
			//objPoint.y = root_mc.mouseY;
			
			if (cellWidth > width || showToolTipsOnAllRows) {
				// convert mouse position over stage to mouse position over row
				//theRow.globalToLocal(objPoint);
				var mousex:Number = theRoot.mouseX + 18;
				var mousey:Number = theRoot.mouseY + 15;
				var row_mc = theRoot.createObject(__rowRenderer, "dnd_tooltip_mc", toolTipDepth, {owner:this, styleName:this});
				//trace("depth ="+row_mc.getDepth());
				row_mc.x = mousex;
				row_mc.setSize(cellWidth, __rowHeight);
				//var itemIndex = Math.max(__vPosition+__rowCount+i+nodeList.length-rowsToMove,rowIndex+nodeList.length);
				row_mc.drawRow(getItemAt(lastOver), "normal");
				row_mc.y = mousey;
				row_mc.nodeIcon.visible = false;
				row_mc.disclosure.visible = false;
				//row_mc.alpha = dragHighlightAlpha;
				// do not remove this next line. removing this line causes drag scrolling to stop working
				row_mc.bG_mc.visible = false;
				toolTipFunction(row_mc);
				//XXX move this someplace more realistic
				this.onMouseMove = function()
				{
					Object(this).hideToolTip();
					//theRoot.dnd_tooltip_txt.x = mousex + 15;
					//theRoot.dnd_tooltip_txt.y = mousey + 15;
					//updateAfterEvent();
				};
			}
			
			clearInterval(delayedToolTipID);
			delete delayedToolTipID;
		}
		
		/**
		Method to hide tooltip
		@tiptext Method to hide tooltip
		@description Method to hide tooltip. 
		*/
		public function hideToolTip() :void{
			var theRoot = getRoot(this);
			//theRoot.dnd_tooltip_mc.removeTextField();
			theRoot.dnd_tooltip_mc.removeMovieClip();
			onMouseMove = null;
			
			clearInterval(delayedToolTipID);
			delete delayedToolTipID;
		}
		
		/**
		Method to modify tooltip movieclip directly after it has been created
		@tiptext Method to modify tooltip movieclip directly after it has been created
		@description Method to modify tooltip movieclip directly after it has been created. A copy of the row is passed as the first parameter. The tooltip is the textfield on the row modified with a background and border. The textfield reference is the cll property. If you use a cellrenderer then you may need to reference the renameField property or your own textfield depending on if you added it to your cellrenderer or not.
		@param Row that contains the textfield that is used as the tooltip
		@example This is the code of the tooltip function
		<pre>
		function toolTipFunction(row_mc) {
			// determine if we are using a cell renderer by checking if cell has the renameField or a textfield we know exists in our cellrenderer
			var bCellRenderer:Boolean = (row_mc.cll.renameField != undefined) ?  true : false;
			// get a reference to the row label - you may need to point this to your textfield
			var rowLabel = (bCellRenderer) ? row_mc.cll.renameField : row_mc.cll;
			// set selectable to false to prevent text cursor 
			rowLabel.selectable = false;
			// set border color, border and background
			rowLabel.setStyle("borderColor",0xD5DDDD);
			rowLabel.border = true;
			rowLabel.background = true;
			// some properties i've turned off but could be enabled
			//rowLabel.autoSize = "left";
			//rowLabel.wordWrap = true;
			//rowLabel.multiline = true;
			// autosize text field
			rowLabel.autoSize = "center";
			// snap cell (label) to the left edge of the row which is positioned next to the mouse
			row_mc.cell.x = 0;
		}
		</pre>
		*/
		public function toolTipFunction(row_mc:MovieClip):void {
			// determine if we are using a cell renderer by checking if cell has the renameField or a textfield we know exists in our cellrenderer
			var bCellRenderer:Boolean = (row_mc.cll.renameField != undefined) ?  true : false;
			// get a reference to the row label - you may need to point this to your textfield
			var rowLabel = (bCellRenderer) ? row_mc.cll.renameField : row_mc.cll;
			// set selectable to false to prevent text cursor 
			rowLabel.selectable = false;
			// set border color, border and background
			rowLabel.setStyle("borderColor",0xD5DDDD);
			rowLabel.border = true;
			rowLabel.background = true;
			// some properties i've turned off but could be enabled
			//rowLabel.autoSize = "left";
			//rowLabel.wordWrap = true;
			//rowLabel.multiline = true;
			// autosize text field
			rowLabel.autoSize = "center";
			// snap cell (label) to the left edge of the row which is positioned next to the mouse
			row_mc.cell.x = 0;
		}
		
		/** 
		Allows the user to set their own ContextMenu
		@tiptext Allows the user to set their own ContextMenu
		@description Allows the user to set their own ContextMenu. You do not want to overwrite the contextMenu property with your own contextMenu because the contextMenu will not work in nested movieclips in Flash Player 7 and 8. Instead use this property to add a new contextMenu or add or remove items from the existing contextMenu (recommended if you need to keep existing functionality). This property will provide the necessary behaviors to make your contextMenu work in nested movieclips and it will select the node the mouse is over (the right click event does not normally select the node the mouse is over). You can always revert back to the default contextMenu by setting contextMenu to the cm property. 
		
		<br><br>When you create your own context contextMenu items add the owner property. The owner should be a reference to the component. This allows the component to work inside nested movieclips.
		
		<br><br>If you define a onSelect callback function in your contextMenu you need to define it before it is assigned to this property. This is because the tree will use the onSelect function to handle nested movieclip behavior. The onSelect function if defined will then be assigned to the tree.onContextMenuSelect function and called directly after the Tree has handled the context contextMenu onSelect event. 
		
		<br><br>The ContextMenu class is documented in the Help Panel. You can change the context contextMenu items easily by following the examples in the Help Panel or by following the examples provided with the component. You cannot use the captions, "cut,copy,paste" as these are reserved by the Flash Player. You cannot add more than 15 custom contextMenu items in Flash Player 7 or 8.
		@usage myInstance.contextMenu;
		@example This example adds a new contextMenu to the tree.
		<pre>
		// create a context contextMenu for right click options
		newMenu = new ContextMenu();
		newMenu.hideBuiltInItems();
		
		// create the context contextMenu items
		var option1 = new ContextMenuItem("Test item-4", onTest);
		var option2 = new ContextMenuItem("Test item-5", onTest);
		var option3 = new ContextMenuItem("Test item-6", onTest);
	
		function onTest(target_mc:MovieClip, obj:Object) {
		  trace ("context-contextMenu handler");
		}
		
		// add the context contextMenu items in this order
		newMenu.customItems.push(option1);
		newMenu.customItems.push(option2);
		newMenu.customItems.push(option3);
		
		// optional pre select function
		newMenu.onSelect = function() {
			trace("using my own on select");
		}
		
		// assign the new context contextMenu to the contextMenu property (not the contextMenu property)
		theTree.contextMenu = newMenu;
		</pre>
		@see #cm
		@see #permitContextMenu
		*/
		public function set contextMenu(newMenu:ContextMenu) {
			
			ContextMenuManager.unregisterMovieClip(root_mc, this);
			
			// add our own context contextMenu pre select handler
			// this is to handle canceling the rename function and selected the node under the mouse 
			// which is not always the selected node
			// if contextMenu on select is not defined then we define our own
			if (newMenu.onSelect==undefined) {
				newMenu.onSelect = this.onContextMenuPreSelect;
			}
			else {
				// if they define their own onSelect then we assign it to the onContextMenuSelect function
				// we then define our own. our function will call their function when ours has finished
				onContextMenuSelect = newMenu.onSelect;
				newMenu.onSelect = onContextMenuPreSelect;
			}
			this["contextMenu"] = newMenu;
			this.cm = newMenu;
			ContextMenuManager.registerMovieClip(root_mc, this, newMenu.customItems);
			
			// store context contextMenu in _backMenu contextMenu
			_backupMenu = newMenu.copy();
		}
		
		/**
		* @exclude
		* @return
		*/
		public function get contextMenu() : ContextMenu {
			// get real _root
			var root_mc = getRoot(this);
			// cMenuManager if not at the _root > use workaround
			if (this.parent != root_mc) {
				return this["contextMenu"];
			}
			else {
				return this["contextMenu"];
			}
		}
	    
		/**
		* protected access function executed prior to rendering of context contextMenu 
		* @exclude
		* 
		*/
		protected function onContextMenuPreSelect(): void	{
			//trace("\nonContextMenuPreSelect()")
			// we turn off the ctrl button because it sticks 
			isCtrlButtonPressed = false;
			
			// if user was renaming a node then cancel the rename operation
			cancelRename();
			
			// make sure that we select the node the user has their mouse over. it is not always the selected node
			selectLastOverNode();
			
			// get node mouse is over. NOTE! this is NOT always the selected node
			var theSelectedNodes = selectedNodes;
			var theIndices = selectedIndices;
			
			//var customItems = theList.contextMenu.customItems;
			var customItems = cm.customItems;
			
			// check if we want to enable the context contextMenu
			if (!enableContextMenu) {
				// hide all items
				for (var i=0;i< customItems.length;i++) {
					customItems[i].visible = false;
				}
				return;
			}
			
			// not sure if i have to do this but we set all contextMenu items back to visible
			// TODO TEST - once we add a permitDrop function in a project we can test this 
			for (var i=0;i< customItems.length;i++) {
				customItems[i].visible = true;
			}
			
			// we are HIDING or SHOWING the contextMenu items using permitContext (which is theTree.permitContextMenu)
			for (var i=0; i< theSelectedNodes.length; i++) {
				var theNode = theSelectedNodes[i];
				// all contextMenu items are visible because of the code above so we hide them if one node fails
				for (var j=0;j<customItems.length;j++) {
					// TODO: TEST - this needs to be tested (J)
					// allow the user to show or hide the items they want
					var bVisible = permitContextMenu(theNode, customItems[j].action, customItems[j], cm);
					// if it should be invisible we change it here
					if (!bVisible) {
						customItems[j].visible = bVisible;
					}
					// if it's visible we don't do anything. so as we are going through the nodes
					// we only turn off the items once for all and never turn them back on in this event
				}
			}
			
			// dispatch an event even though we shouldnt really need to do this
			dispatchEvent ({type:"contextMenu", target:this, cm:cm, contextMenu:contextMenu});
			onContextMenuSelect();
		}
		
		/**
		* User customizable function for manipulating the context contextMenu
		* @tiptext User customizable function for manipulating the context contextMenu
		* @description User customizable function for manipulating the context contextMenu before it is shown. Use the permitContextMenu to show or hide the contextMenu items based on the nodes the user has selected at the time. 
		* @example This function allows you to hide the first contextMenu item
		<pre>
		theTree.onContextMenuSelect = function () {
			var customItems = theTree.cm.customItems;
			customItems[0].visible = false;
		}
		</pre>
		*/
		public function onContextMenuSelect() : void{
			
		}
		
		/**
		* this function selects the node that the mouse is over when a person right-clicks. this is not always the selected node
		* @exclude
		*/
		protected function selectLastOverNode() : void{
			//**************************************
			// RIGHT CLICK ROW STATES DEFINED BELOW
			//**************************************
			// User right clicks on single selected row 
			// - get last over row. select the row
			// User right clicks on a selected row out of multiple selected rows
			// - use the selectedNodes property. do not reselect any other nodes
			// User right clicks on a non-selected row out of multiple selected rows
			// - select the non-selected rows and deselect other rows.
			// User right clicks on a non-selected row out of multiple selected rows and...
			// - CTRL key is pressed - not supported per windows explorer so we are not going to support it
			// - user must multi-select before right clicking and right click on any of the selected rows
			
			// get node mouse is over. NOTE! this is NOT always the selected node
			var lastOverNode = getItemAt(lastOver);
	
			// check if clicking on a node that is already selected
			if (!isRowClickedAlreadySelected(lastOver))	{
				selectedNodes = new Array(lastOverNode);
				selectedNode = lastOverNode;
			}
	
		}
		
		/**
		A function called when user selects "rename item" from context contextMenu
		@tiptext A function called when user selects "rename item" from context contextMenu
		@description A function called when user selects "rename item" from context contextMenu
		@param A reference to the tree. If this is undefined use menuItem owner property
		@param A reference to the contextMenu item
		*/
		protected function onRenameTreeItemMenu(obj:Object, menuItem:Object):void {
			// obj is the list
			var menuCaption:String = menuItem.caption;
			
			// This ties in with the context contextMenu manager
			if (obj.className !="dndTree") {
				if (menuItem.owner!=undefined) {
					obj = menuItem.owner;
				}
			}
			
			var eventType = obj.RENAME_ITEM;
			// not sure why i'm not getting the selectedIndex here - there may be a reason but i may have over looked this
			var rowIndex = obj.lastOverIndex;
			
			
			//trace("ON RENAME\nlastOverIndex="+obj.lastOverIndex)
			//trace("lastOver="+obj.lastOver)
			//trace("vPosition="+obj.vPosition)
			var bEnabled = (obj.enableRenameNode);
			var bOneSelected = (obj.selectedIndices.length < 2);
			var bPermit = obj.permitRename(obj.selectedNode);
			var alternateRowIndex = obj.selectedIndex - obj.vPosition;
			//trace("rowIndex="+rowIndex)
			//trace("obj.selectedIndex="+obj.selectedIndex)
	
			if (obj.lastOverIndex != alternateRowIndex) {
				// in the browser the row index is different than in the ide. why? i don't know but this seems to fix it.
				rowIndex = alternateRowIndex;
			}
			
			// If multiple selections occur we don't do anything
			// allow user to rename node label
			if (bEnabled && bOneSelected && bPermit)	{
				obj.renameFunction(rowIndex, obj.MENU_EVENT);
			}
		}
	
		
		/** 
		Lets the user override the normal rename method
		@tiptext Lets the user override the normal rename method
		@description Lets the user override the normal rename method. You can use this function to override the default behavior. 
		@usage myInstance.renameFunction = function(row,eventSource) {};
		@param Number - The row index
		@param Number - The event source. Either a MENU_EVENT or METHOD_CALL. Optional
		@example The code below is the default code
		<pre>
		// The code below is the default code
		function renameFunction (rowIndex, eventSource) {
			// show the rename textfield
			showRenameNode(rowIndex, eventSource);
		}
		</pre>
		*/
		public function renameFunction (rowIndex:Number, eventSource:Number):void {
			showRenameNode(rowIndex, eventSource);
		}
		
		/** 
		A function called when user selects "remove item" from context contextMenu
		@tiptext A function called when user selects "remove item" from context contextMenu
		@description A function called when user selects "remove item" from context contextMenu
		@param A reference to the tree. If this is undefined use menuItem.owner
		@param A reference to the contextMenu item
		*/
		protected function onRemoveTreeItemMenu(obj:Object, menuItem:Object) :void{
			
			// This ties in with the context contextMenu manager
			if (obj.className !="dndTree") {
				if (menuItem.owner!=undefined) {
					// each contextMenu item should define the owner property to work within nested movieclips
					obj = menuItem.owner;
				}
			}
			
			// work around for backwards compatibility - see onPasteTreeItemMenu
			obj.strRemoveItem = menuItem.caption;
			obj.onCutTreeItemMenu(obj,menuItem);
			
		}
		
		/** 
		A function called when user selects "cut item" from context contextMenu
		@tiptext A function called when user selects "cut item" from context contextMenu
		@description A function called when user selects "cut item" from context contextMenu
		@param A reference to the tree. If this is undefined use menuItem.owner
		@param A reference to the contextMenu item
		*/
		protected function onCutTreeItemMenu(obj:Object, menuItem:Object):void {
			//trace("\nonCutItemMenu()")
			// obj is the list
			var menuCaption:String = menuItem.caption;	
			var eventType;
			
			// This ties in with the context contextMenu manager
			if (obj.className !="dndTree") {
				if (menuItem.owner!=undefined) {						
					obj = menuItem.owner;
				}
			}
	
			// get event type
			if (menuCaption==obj.strCutItem) {
				eventType = obj.CUT_ITEM;
			}
			else {
				eventType = obj.REMOVE_ITEM;
			}
			
			var indices = obj.selectedIndices;
			var rowIndex = obj.selectedIndices[obj.selectedIndices.length-1];
			
			//pressedCellIndex = obj.getPressedCellIndex(rowIndex);
			
			//trace("BS - selectedIndics=" + selectedIndices)
			//trace("BS - indices=" + indices)
			// the order of items is out of wack. reorder by position
			indices.sort(obj.sortByNumber);
			indices.reverse();
			//selectedItems.sort(sortByNumber);
			//selectedItems.reverse();
			//indices.reverse()
			obj.selectedIndices = indices;
			//trace(" obj.selectedIndices.length = " + obj.selectedIndices.length);
			
			// we call this method to alert user if they are sure they want to remove
			var canRemove = obj.permitRemove(obj, menuItem, menuCaption, eventType);
			if (!canRemove) {
				//trace(" cannot remove!")
				return;
			}
			
			// remove previous cut or copied items
			obj.removeClipboardItems();
			
			// TODO: Comment what this does
			var cutNodes:Array = new Array();
			
			// TODO: Comment what this does
			if (!obj.multipleSelection) {
				// get selected node
				var theSelectedNode = obj.selectedNode;	
			
				// INPORTANT: stores node properties (node type, is node open) values in the node object		
				theSelectedNode.bIsNodeBranch = obj.getIsBranch(theSelectedNode);						
				theSelectedNode.bIsNodeOpen   = obj.getIsOpen(theSelectedNode);		
				
				theSelectedNode.owner = obj;
				theSelectedNode.indices = indices;
				theSelectedNode.itemIndex = obj.selectedIndex;
				theSelectedNode.readOnly = obj.dndReadOnly;
	
				// we don't use this now but we may in the future
				theSelectedNode.removeMe = function() {
					obj.owner.removeTreeNode();
				};
				// TODO: Comment what this does
				cutNodes.push(obj.selectedNode);
				
				// TODO: Comment what this does
				obj.cutNode(cutNodes, obj.MENU_EVENT);
			}
			else {
				// TODO: Comment what this does
				cutNodes = obj.selectedNodes;
				obj.cutNode(cutNodes, obj.MENU_EVENT, eventType);	
			}
		}
	
		/** 
		A function to cut node from the Tree
		@tiptext A function to cut node from the Tree
		@description Method to cut node from the Tree. A cutNode event is generated when this method is called. The event contains the target which is a reference to the Tree and the eventSource, which indicates if the method was called from the context contextMenu.
		@usage myInstance.cutNode(theNodes,eventSource,eventType);
		@returns Reference to the cut nodes
		@param theNodes - The selected node or selected nodes
		@param eventSource - Optional. Constant that refers to the source of the call. Typically tree.MENU_EVENT
		@param eventType - Optional. Constant that refers to the event of the call. If REMOVE_ITEM is passed in then a removeNode event is generated.
		@example The example below cuts the selected node from the Tree.
		<pre>
		theTree.cutNode(theTree.selectedNode);
		</pre>
		*/	
		public function cutNode(theNodes:Object, eventSource:Object, eventType:Object):Object {
			// hold the node array
			var cutNodes;
			
			// if node is not selected alert the user to select one and exit function
			if (theNodes == undefined) {
				addError("cutNode", "theNodes is undefined");
				return false;
			}
			
			// remove previous cut or copied items
			removeClipboardItems();
			
			// nodes to select after node is cut
			var theNextSibling, theParentNode;
			
			// check if node is array or not
			var multipleSelections = (theNodes.length==undefined) ? false : true;
			
			if (multipleSelections) {
				cutNodes = theNodes;
			}
			else {
				cutNodes = new Array (theNodes);
			}
			var newArray:Array = new Array();
			
			// the order of items is out of wack. reorder by position
			var indices = selectedIndices;
			indices.sort(sortByNumber);
			indices.reverse();
			selectedIndices = indices;
			for (var i=0; i < selectedIndices.length; i++) {
				newArray.push(selectedIndices[i]);
				//trace(" adding itemIndex to array = "+ newArray[i])
			}
			
			//trace(" newArray.length = " +newArray.length)
			
			var index;
			// loop through selected nodes and remove them
			for (var i=0; i < cutNodes.length; i++)	{
				index = newArray[i];
				var theNewItem = new Object();
				
				//var theItem = cutNodes[i];
				//var theItem = getItemAt(index);
				var node = cutNodes[i];
				
				// IMPORTANT: stores item properties (item type, is item open) values in the item object		
				node.bIsNodeBranch = getIsBranch(cutNodes[i]);
				node.bIsBranch = getIsBranch(cutNodes[i]);
				node.bIsNodeOpen = getIsOpen(cutNodes[i]);
				node.bIsOpen = getIsOpen(cutNodes[i]);
				node.owner = this;
				//theNewItem.pressedCellIndex = pressedCellIndex;
				node.indices = indices;
				node.itemIndex = index;
				node.readOnly = dndReadOnly;
				// we don't use this because it is removed right away - see below
				node.removeMe = function(newIndex:Number) {
					//trace ("\nremoveMe")
					//trace (" this=" + this)
					//trace (" obj.owner=" + obj.owner)
					//this..removeTreeNode();
				};
				
				//var node = cutNodes[i];
				var item = convertToItem(node);
				var gridItem = convertToGridItem(node);
				
				// store in array for future paste operations
				theCopyItems.push(item);
				theCopyGridItems.push(gridItem);
				theCopyNodes.push(node);
	
				// get any sibling after the selected node
				// we select it or the parent node after we have cut the selected node
				theNextSibling = node.nextSibling;
				theParentNode  = node.parentNode;
	 
				// keep parent node a branch if we want to preserve branches
				if (theParentNode.childNodes.length>1) {
					setIsBranch(theParentNode, true);
				}
				else {
					if (preserveBranches == false) {
						setIsOpen(theParentNode, false);
						setIsBranch(theParentNode, false);
						
						delete theParentNode.bIsNodeBranch;
						delete theParentNode.bIsNodeOpen;
					}
					else {
						setIsBranch(theParentNode, true);
					}
				}
				
				// removes the selected node
				node.removeTreeNode();
				
				// select next sibling or parent node
				if (theNextSibling != undefined) {
					selectedNode = theNextSibling;
				}
				else {
					selectedNode = theParentNode;
				}
			}
			
			// TODO: Comment what this does
			var crossdndWidgetList:DndUIWidgets = DndUIWidgets.getWidgetList ();
			
			// TODO: Comment what this does
			for (var i:Number = 0; i < crossdndWidgetList.length; i++) {
				crossdndWidgetList.getItemAt(i).theCopyItems = theCopyItems;
				crossdndWidgetList.getItemAt(i).theCopyGridItems = theCopyGridItems;
				crossdndWidgetList.getItemAt(i).theCopyNodes = theCopyNodes;
			}
			
			// dispatch correct event
			if (eventType==REMOVE_ITEM) {
				// dispatch remove event. pass in the eventSource for users
				dispatchEvent ({type:"removeNode", target:this, removedIndices:newArray, eventSource:eventSource});	
				dispatchEvent ({type:"onRemoveNode", target:this, removedIndices:newArray, eventSource:eventSource});
			}
			else {
				// dispatch cutNode event. pass in the eventSource for users
				dispatchEvent ({type:"cutNode", target:this, removedIndices:newArray, eventSource:eventSource});	
				dispatchEvent ({type:"onCutNode", target:this, removedIndices:newArray, eventSource:eventSource});
			}
			
			// do horizontal scrollV policy
			setHorizontalScroll();
			
			return theCopyNodes;
		}	
	
		/** 
		A function called when user selects "copy item" from context contextMenu
		@tiptext A function called when user selects "copy item" from context contextMenu
		@description A function called when user selects "copy item" from context contextMenu
		@param A reference to the tree. If this is undefined use menuItem.owner 
		@param A reference to the contextMenu item
		*/
		protected function onCopyTreeItemMenu(obj:Object, menuItem:Object):void {
			// obj is the myInstance
			var menuCaption:String = menuItem.caption;
			
			// This ties in with the context contextMenu manager
			if (obj.className !="dndTree") {
				if (menuItem.owner!=undefined) {
					obj = menuItem.owner;
				}
			}
			
			var eventSource = obj.MENU_EVENT;
			var eventType = obj.COPY_ITEM;
			
			// remove previous clipboard items
			obj.removeClipboardItems();
	
			// TODO: Comment what this does
			var copyNodes:Array = new Array();
			var indices = obj.selectedIndices;
			var rowIndex = obj.selectedIndices[obj.selectedIndices.length-1];
			
			// the order of items is out of wack. reorder by position
			indices.sort(obj.sortByNumber);
			indices.reverse();
			obj.selectedIndices = indices;
	
			// copy the selected node or list items
			if (!obj.multipleSelection) {
				// get selected node
				var theSelectedNode = obj.selectedNode;	
			
				// don't think this is necessary here bc it is getting set in the next method
				// IMPORTANT: stores node properties (node type, is node open) values in the node object		
				theSelectedNode.bIsNodeBranch = obj.getIsBranch(theSelectedNode);						
				theSelectedNode.bIsNodeOpen   = obj.getIsOpen(theSelectedNode);	
				
				// theSelectedNode is not getting passed into here. may cause errors???
				copyNodes.push(obj.selectedNode);
				
				// call copy node method
				obj.copyNode(copyNodes, eventSource, eventType);
			}
			else {
				// get selected nodes
				copyNodes = obj.selectedNodes;
				// call copy nodes method
				obj.copyNode(copyNodes, eventSource, eventType);
			}
		}
	
		/** 
		A function to copy nodes from the Tree
		@tiptext A function to copy nodes from the Tree
		@description Method to copy nodes from the Tree. A copyNode event is generated when this method is called. The event contains the target which is a reference to the Tree and the eventSource, which indicates if the method was called from the context contextMenu.
		@usage myInstance.copyNode(theNodes,eventSource);
		@returns Reference to the copy nodes
		@param theNodes - The selected node or selected nodes
		@param eventSource - Optional. Constant that refers to the source of the call. Typically tree.MENU_EVENT
		@example The example below copies the selected node.
		<pre>
		theTree.copyNode(theTree.selectedNode);
		</pre>
		*/
		public function copyNode(theNodes:Object, eventSource:Object):Boolean {
			// hold our node array
			var copiedNodes;
			// node is not selected - exit function
			if (theNodes == undefined) {
				addError("copyNode", "theNodes is undefined");
				return false;
			}
			
			// remove previous clipboard items
			removeClipboardItems();
			
			// check if node is array or not
			var multipleSelections = (theNodes.length==undefined) ? false : true;
			
			if (multipleSelections) {
				copiedNodes = theNodes;			
			}
			else {			
				copiedNodes = new Array (theNodes);			
			}
			
			// temporary cloned node
			var theCopyNode;
			
			var newArray:Array = new Array();
			
			// the order of items is out of wack. reorder by position
			var indices = selectedIndices;
			var rowIndex = selectedIndices[selectedIndices.length-1];
			
			//pressedCellIndex = getPressedCellIndex(rowIndex);
			
			indices.sort(sortByNumber);
			indices.reverse();
			selectedIndices = indices;
			for (var i=0; i < selectedIndices.length; i++) {
				newArray.push(selectedIndices[i]);
				//trace(" adding itemIndex to array = "+ newArray[i])
			}
			
			// loop through node array
			for (var i=0; i < copiedNodes.length; i++) {
				var index = newArray[i];
				var theNewItem = new Object();
				
				//var theNode = cutNodes[i];
				var theNode = getItemAt(index);
				// set some properties we may use later
				var node = copiedNodes[i].cloneNode(true);
				
				// IMPORTANT: stores item properties (item type, is item open) values in the item object		
				node.bIsNodeBranch = getIsBranch(copiedNodes[i]);
				node.bIsBranch = getIsBranch(copiedNodes[i]);
				node.bIsNodeOpen = getIsOpen(copiedNodes[i]);
				node.bIsOpen = getIsOpen(copiedNodes[i]);
				node.owner = this;
				//node.pressedCellIndex = pressedCellIndex;
				node.indices = indices;
				node.itemIndex = index;
				node.readOnly = dndReadOnly;
				// we don't use this now but we may in the future
				node.removeMe = function() {
					//trace ("\nremoveMe")
					//trace (" this=" + this)
					//this.owner.removeTreeNode();
				};
				
				// add to copied nodes array
				var item = convertToItem(node);
				var gridItem = convertToGridItem(node);
				
				// store array for future paste operations
				theCopyItems.push(item);
				theCopyGridItems.push(gridItem);
				theCopyNodes.push(node);
			}
			
			// get list of cross drag dnd widgets
			var crossdndWidgetList:DndUIWidgets = DndUIWidgets.getWidgetList ();
			
			// syncronize the copied nodes so we can paste into any of them and get the same results
			for (var i = 0; i < crossdndWidgetList.length; i++) {
				crossdndWidgetList.getItemAt(i).theCopyItems = theCopyItems;
				crossdndWidgetList.getItemAt(i).theCopyGridItems = theCopyGridItems;
				crossdndWidgetList.getItemAt(i).theCopyNodes = theCopyNodes;
			}
			
			// dispatch copyNode event. pass in the eventSource for users
			dispatchEvent ({type:"copyNode", target:this, copiedIndices:newArray, eventSource:eventSource});	
			dispatchEvent ({type:"onCopyNode", target:this, copiedIndices:newArray, eventSource:eventSource});
			
			return true;
		}
		
		// method called when user selects paste before
		protected function onPasteBeforeTreeItemMenu(obj:Object, menuItem:Object):void {
			
			// This ties in with the context contextMenu manager
			if (obj.className !="dndTree") {
				if (menuItem.owner!=undefined) {
					obj = menuItem.owner;
				}
			}
			
			// work around for backwards compatibility - see onPasteTreeItemMenu
			obj.strPasteBefore = menuItem.caption;
			obj.onPasteTreeItemMenu(obj,menuItem);
			
		}
		
		// method called when user selects paste after
		protected function onPasteAfterTreeItemMenu(obj:Object, menuItem:Object):void {
	
			// This ties in with the context contextMenu manager
			if (obj.className !="dndTree") {
				if (menuItem.owner!=undefined) {
					obj = menuItem.owner;
				}
			}
			
			// work around for backwards compatibility - see onPasteTreeItemMenu
			obj.strPasteAfter = menuItem.caption;
			obj.onPasteTreeItemMenu(obj,menuItem);
			
		}
		
		// method called when user selects paste into
		protected function onPasteIntoTreeItemMenu(obj:Object, menuItem:Object):void {
			
			// This ties in with the context contextMenu manager
			if (obj.className !="dndTree") {
				if (menuItem.owner!=undefined) {
					obj = menuItem.owner;
				}
			}
			
			// work around for backwards compatibility - see onPasteTreeItemMenu
			obj.strPasteInto = menuItem.caption;
			obj.onPasteTreeItemMenu(obj,menuItem);
			
		}
		
		// method called when user selects add leaf
		protected function onAddLeafTreeItemMenu(obj:Object, menuItem:Object):void {
			
			// This ties in with the context contextMenu manager
			if (obj.className !="dndTree") {
				if (menuItem.owner!=undefined) {
					obj = menuItem.owner;
				}
			}
			
			// work around for backwards compatibility - see onPasteTreeItemMenu
			obj.strAddLeaf = menuItem.caption;
			obj.onPasteTreeItemMenu(obj,menuItem);
			
		}
		
		// method called when user selects add branch
		protected function onAddBranchTreeItemMenu(obj:Object, menuItem:Object):void {
			
			// This ties in with the context contextMenu manager
			if (obj.className !="dndTree") {
				if (menuItem.owner!=undefined) {
					obj = menuItem.owner;
				}
			}
			
			// work around for backwards compatibility - see onPasteTreeItemMenu
			obj.strAddBranch = menuItem.caption;
			obj.onPasteTreeItemMenu(obj,menuItem);
			
		}
		
		// method called when user selects paste into, paste after, paste before, 
		// add leaf or add branch from the context contextMenu
		protected function onPasteTreeItemMenu(obj:Object, menuItem:Object):Boolean {
			// obj is the list
			// get paste type
			var pasteType:String = menuItem.caption;
			var pastePosition:String = menuItem.caption;
			var menuCaption:String = menuItem.caption;
			var theNode;
			var theNodes:Array  = new Array();
			
			// This ties in with the context contextMenu manager
			if (obj.className !="dndTree") {
				if (menuItem.owner!=undefined) {
					obj = menuItem.owner;
				}
			}
	
			// get the selected nodes
			var theSelectedNode = obj.selectedNode;
			var theSelectedNodes = obj.selectedNodes;
			// check if user selected add leaf or add branch
			// if so then all set copyNode to custom leaf or branch
			if (menuCaption == obj.strAddLeaf) {
				// create a new xml node from our added leaf node string
				theNode = new XMLDocument(obj.leafNodeXML);
				theNode = theNode.firstChild;
				// position paste into, after or before
				pastePosition = obj.addLeafPastePosition;
				// add node to local array of nodes
				theNodes.push (theNode);
				// set paste type
				pasteType = obj.ADD_LEAF;
			}
			else if (menuCaption == obj.strAddBranch) {
				// create a new xml node from our added leaf node string
				theNode = new XMLDocument(obj.branchNodeXML);
				theNode = theNode.firstChild;
				// add properties we will use later
				theNode.bIsNodeBranch = true;
				obj.setIsBranch(theNode, true);
				// position paste into, after or before
				pastePosition = obj.addBranchPastePosition;
				// add the copied node to the copied nodes array
				theNodes.push (theNode);
				// set paste type
				pasteType = obj.ADD_BRANCH;
			}
			else {
				switch (menuCaption) {
					case obj.strPasteInto: {
						pasteType = obj.PASTE_INTO;
						pastePosition = obj.PASTE_INTO;
						break;	
					}
					case obj.strPasteBefore: {
						pasteType = obj.PASTE_BEFORE;
						pastePosition = obj.PASTE_BEFORE;
						break;	
					}
					case obj.strPasteAfter: {
						pasteType = obj.PASTE_AFTER;
						pastePosition = obj.PASTE_AFTER;
						break;	
					}
				}
				// loop through array of selected nodes
				for (var i=0; i< obj.theCopyNodes.length; i++ )	{
					theNodes.push(obj.theCopyNodes[i]);
				}
			}
			
			// we cannot paste if we do not have any nodes to paste
			if (theNodes.length == 0) {
				addError("onPasteTreeItemMenu", "there are no nodes to paste");
				return false;
			}
			
			// call pasteNode (theSourceNode, theTargetNode, thePosition, moveNode, eventSource, eventConstant)
			var ret = obj.pasteNode(theNodes, theSelectedNode, pastePosition, false, obj.MENU_EVENT, pasteType);
			return ret;
		}
	
		/** 
		Method to insert or move nodes into the Tree
		@tiptext Method to insert or move nodes into the Tree
		@description Method to insert or move nodes into the Tree at specific places. A pasteNode event is generated when this method is called. The event contains the target, which is a reference to the Tree, the eventSource, which indicates if the method was called from the context contextMenu, pastePosition, which indicates the position above, below or into the target node, targetNode, which is a reference to the target node and targetIndex which is the target node index.
		@usage myInstance.pasteNode(theSourceNode, theTargetNode, pastePosition, moveNode, eventSource, eventConstant);
		@returns Returns a reference to the XMLNode or an array of XMLNodes. Same reference as selectedNode or selectedNodes. 
		@param theSourceNodes - The node or nodes that will be inserted into the tree.
		@param theTargetNode - The location by node of where to insert the source nodes. 
		@param pastePosition - Constant that refers to the paste position (PASTE_INTO, PASTE_BEFORE, PASTE_AFTER).
		@param moveNode - Boolean. Indicates to move or copy the nodes from their original location. 
		@param eventSource - Optional. A constant used to indicate the source of the method. Also used to generate the appropriate events (pasteNode, drop, addLeafNode, addBranchNode). Value can be DROP_EVENT, MENU_EVENT or METHOD_CALL. If not specified a pasteNode event is generated. 
		@param eventConstant - Optional. A constant used to indicate and generate an ADD_LEAF or ADD_BRANCH event. 
		@example The example below pastes a node into the root node.
		<pre>
		theTree.pasteNode(theTree.selectedNode, theTree.dataProvider, theTree.PASTE_INTO, true);
		</pre>
		*/
		public function pasteNode(theSourceNode:Object , theTargetNode:Object , pastePosition:Object , moveNode:Object , eventSource:Object , eventConstant:Object ):Object {
			// oh god this was a pain in the !@$ - look at the crap i had to deal with... er...
			// get paste type
			var bIsReadOnly:Boolean = false;
			var sameList:Boolean;
			var targetIndex = theTargetNode.itemIndex;
			var bBranchIsOpen:Boolean = false;
			var bIsParentNodeBranch:Boolean = false;
			var bIsBranch:Boolean = false;
			var bPreserveBranches:Boolean = false;
			
			// copied from dndDataGrid
			// trace(" theTargetItem.itemIndex="+theTargetItem.itemIndex)
			if (eventSource==MENU_EVENT) {
				//theTargetIndex = selectedIndex;
				//theTargetNode.itemIndex = theTargetIndex;
				//trace(" contextMenu item event. theTargetItem.itemIndex="+theTargetNode.itemIndex)
			}
			// end copied from dndDataGrid
			var emptyList:Boolean;
			var afterList:Boolean;
			
			// if not defined then check variable type
			var multipleSelections = (theSourceNode.length==undefined) ? false : true;
			var theSourceNodes;
			
			if (multipleSelections) {
				theSourceNodes = theSourceNode;
			}
			else {			
				theSourceNodes = new Array (theSourceNode);			
			}
			
			// check if target node exists or is empty row 
			if (theTargetNode==undefined || theTargetNode.emptyRow) {
				// is tree empty?
				if (this.dataProvider.length==0) {
					emptyList = true;
				}
				else {
					afterList = true;
					// not sure what this is doing???
					if (this==undefined) {
						return false;
					}
				}
			}
			
			// get target node parent and move position
			var theParentNode, theMovePosition;
			// get the indexes so we can sort correctly
			var theSourceLowestIndex = theSourceNodes[theSourceNodes.length-1].itemIndex + vPosition;
			var theSourceHighestIndex = theSourceNodes[0].itemIndex + vPosition;
			// copied from dndDataGrid
			//var theRelativePosition = theTargetNode.itemIndex;
			
			//check if we are pasting within the same list
			if (theSourceNodes[0].owner == this) {
				sameList = true;
			}
			
			// check if parent node is branch. if so add as first child
			// also determine new position to move node to
			// if it is an empty tree
			if (emptyList) {
				// plan to add it to the root node
				theParentNode = dataProvider;
				theMovePosition = 0;
				//trace("pasteType= PASTE TO EMPTY LIST #" + 1);
			}
			// if adding to an empty rows determine 
			else if (afterList) {
				// add nodes to root branch
				theParentNode = dataProvider;
				theMovePosition = dataProvider.numChildren;
				// because we are pasting AFTER we need to reorder the nodes
				theSourceNodes.reverse();
				//trace("pasteType= PASTE TO EMPTY ROW #" + 2);
			}
			// check if we paste into. if so then we put it as first child of parent
			else if (pastePosition==PASTE_INTO) {
				//trace("doing pastePosition=" + pastePosition);
				theParentNode = theTargetNode;
				theMovePosition = 0;
				//trace("pasteType= PASTE INTO #" + 3);
			}
			// we are pasting before or after
			else {
				// get parent node - we will add copy node under this branch
				theParentNode = theTargetNode.parentNode;
				// determine position of target node among child nodes
				var theRelativePosition = getNodePos(theTargetNode);
				// determine new position to move node to
				if (pastePosition==PASTE_BEFORE) {
					// PASTE BEFORE
					theMovePosition = theRelativePosition;
					var theTargetIndex = getDisplayIndex(theTargetNode)+vPosition;
					var isSameParent = (theParentNode == theSourceNodes[0].parentNode);
					//trace("pasteType= PASTE BEFORE #" + 4);
					//trace("isSameParent=" + isSameParent);
					//trace("theTargetNode DisplayIndex =" + getDisplayIndex(theTargetNode));
					//trace("theTargetNode AbsRowIndex =" + (getDisplayIndex(theTargetNode)+vPosition));
					//trace("target ID="+ theTargetNode.getID())
					//trace("theSourceLowestIndex=" + theSourceLowestIndex);
					//trace("theSourceHighestIndex =" + theSourceHighestIndex);
					
					//trace("theMovePosition=" + theMovePosition);
					//trace("theSourceNodes[0].nextSibling=" + theSourceNodes[0].nextSibling);
					// WHEN SHOULD WE REVERSE IT? 
					if (theTargetIndex>theSourceHighestIndex) {
						//trace("theTargetIndex("+theTargetIndex+") is AFTER theSourceHighestIndex ("+theSourceHighestIndex+")")
						//trace("  reversing the array")
						if (isSameParent) {
							if (moveNode) {
								theSourceNodes.reverse();
							}
						}
					}
					if (theTargetIndex<theSourceLowestIndex){
						//trace("theTargetIndex("+theTargetIndex+") is BEFORE theSourceLowestIndex ("+theSourceLowestIndex+")")
						//trace("  reversing the array")
						//theSourceNodes.reverse();
					}
					
				}
				else {
					// if parent node is a branch and branch is open then we want to add as a child
					if (getIsOpen(theTargetNode) && eventSource==DROP_EVENT && theTargetNode.hasChildNodes()) {
						// PASTE INTO
						// TODO: Add check to make sure target node is NOT last node (with empty rows after it). 
						theParentNode = theTargetNode;
						//trace("doing pastePosition=" + pastePosition);
						theMovePosition = 0;
						//trace("pasteType= PASTE AFTER BUT INTO #" + 5);
					}
					else {
						// PASTE AFTER
						theMovePosition = theRelativePosition + 1;
						//trace("pasteType= PASTE AFTER #" + 6);
						var theTargetIndex = getDisplayIndex(theTargetNode)+vPosition;
						var isSameParent = (theParentNode == theSourceNodes[0].parentNode);
						//trace("pasteType= PASTE BEFORE #" + 4);
						//trace("isSameParent=" + isSameParent);
						//trace("theTargetNode DisplayIndex =" + getDisplayIndex(theTargetNode));
						//trace("theTargetNode AbsRowIndex =" + (getDisplayIndex(theTargetNode)+vPosition));
						//trace("theSourceLowestIndex=" + theSourceLowestIndex);
						//trace("theSourceHighestIndex =" + theSourceHighestIndex);
						
						if (theTargetIndex>theSourceHighestIndex) {
							//trace("theTargetIndex("+theTargetIndex+") is AFTER theSourceHighestIndex ("+theSourceHighestIndex+")")
							//trace("  reversing the array")
							//theSourceNodes.reverse();
							if (isSameParent) {
								theSourceNodes.reverse();
							}
						}
						if (theTargetIndex<theSourceLowestIndex){
							//trace("theTargetIndex("+theTargetIndex+") is BEFORE theSourceLowestIndex ("+theSourceLowestIndex+")")
							//theSourceNodes.reverse();
							//trace("  reversing the array")
							//if (!isSameParent) {
							//}
						}
						if (theTargetIndex==theSourceLowestIndex-1 && eventSource==DROP_EVENT) {
							//trace("You're dropping right above you!")
							//trace("  reversing the array")
							if (isSameParent) {
							//	theSourceNodes.reverse();
							}
						}
						
					}
					// because we are pasting AFTER we need to reorder the nodes correctly
					//theSourceNodes.reverse();
				}
			}
			
			// get collection of node positions
			lastMovedItem 	= theSourceNodes[0];
			lastMovedIndex 	= theSourceNodes[0].itemIndex;
			lastMovedParent = theSourceNodes[0].parentNode;
			lastMovedSource = theSourceNodes[0].owner;
			// note. these cannot be objects
			lastMovedItems = new Array();
			lastMovedIndices = new Array();
			lastMovedParents = new Array();
			lastMovedSources = new Array();
			
			
			// array of nodes to be pasted
			var selectionArray:Array = new Array();
			var removeArray:Array = new Array();
			
			// loop through the source nodes and add them one by one
			for (var i=0; i<theSourceNodes.length; i++) {
				// can go in multipleInstances loop
				bIsBranch = theSourceNodes[i].bIsNodeBranch;
				bBranchIsOpen = theSourceNodes[i].bIsNodeOpen;
				bIsParentNodeBranch = theSourceNodes[i].bIsParentNodeBranch;
				bIsReadOnly = theSourceNodes[i].readOnly;
				bPreserveBranches = theSourceNodes[i].bPreserveBranches;
				
				// readonly should only work externally
				if (!sameList) {
					moveNode = (bIsReadOnly) ? false: moveNode;
				}
				
				// destroy variabales used in the moved node 
				delete theSourceNodes[i].bIsNodeBranch;
				delete theSourceNodes[i].bIsBranch;
				delete theSourceNodes[i].bIsNodeOpen;
				delete theSourceNodes[i].bIsOpen;
				delete theSourceNodes[i].bIsParentNodeBranch;
				
				// paste the copied node
				// we clone the node because the addTreeNodeAt will move it otherwise
				var theResult = theParentNode.addTreeNodeAt(theMovePosition, theSourceNodes[i].cloneNode(true));
	
				// set references for the moved node
				lastMovedItems[i] 	= theSourceNodes[i];
				lastMovedIndices[i] = theSourceNodes[i].itemIndex;
				lastMovedSources[i] = theSourceNodes[i].owner;
				// set references for the moved node
				lastMovedParents[i] = theSourceNodes[i].parentNode;
				
				// remove the moved node
				if (moveNode) {
					
					if (sameList) {
						// check if we need preserve the parent node as a branch when the last child node is removed 
						if (bIsParentNodeBranch && bPreserveBranches) {
							var theSourceParentNode = theSourceNodes[i].parentNode;
							// set references for the moved node
							theSourceNodes[i].removeTreeNode();
							theSourceNodes[i].owner.setIsBranch(theSourceParentNode, true);
						}
						else {
							var theSourceParentNode = theSourceNodes[i].parentNode;
							
							// if we are deleting the last child node
							if (theSourceParentNode.childNodes.length == 1){
								theSourceNodes[i].owner.setIsOpen(theSourceParentNode, false);								
								theSourceNodes[i].owner.setIsBranch(theSourceParentNode, false);
							}
							
							theSourceNodes[i].removeTreeNode();
							
							delete theSourceParentNode.bIsNodeBranch;
							delete theSourceParentNode.bIsNodeOpen;
						}
					}
					else {
						theSourceNodes[i].removeMe(i);
						//theSourceNodes[i].removeTreeNode();
					}
					// end check if same list
					
				}
				else {
					//trace("  not moving node")
				}
				
				// add to array to select later
				selectionArray.push (theResult);
				
				
				// destroy references created in the moved node
				
				delete theSourceNodes[i].owner;
				delete theSourceNodes[i].indices;
				delete theSourceNodes[i].itemIndex;
				delete theSourceNodes[i].readOnly;
				delete theSourceNodes[i].bPreserveBranches;
				delete theSourceNodes[i].removeMe;
				
				// Andriy - I used this code in the dndList but that is because the dndList did not have a
				/*
				theSourceNode.owner = "";
				theSourceNode.itemIndex = "";
				theTargetNode.owner = "";
				theTargetNode.itemIndex = "";
				delete theSourceNode.owner;
				delete theSourceNode.itemIndex;
				delete theTargetNode.owner;
				delete theTargetNode.itemIndex;
				*/
				
				// keep branches branches
				setIsBranch(theResult, bIsBranch);
				
				// keep open branches open
				setIsOpen(theResult, bBranchIsOpen);
				
				
				// assign to 2 dndTree's properties from public API new values
				thePasteToParentNode	= theParentNode;
				thePasteToPosition		= theMovePosition;
			}
			
			// determine if mulitiple nodes were dragged
			var selectLength:Number = theSourceNodes.length;
			
			// check if we want to open a closed branch when nodes are dropped into it
			if (!getIsOpen(theParentNode) && openClosedBranchOnPasteInto) {
				setIsOpen(theParentNode, true, false, true);
	
				if (selectionArray.length >1) {
					// select the nodes we just pasted
					selectedNodes = selectionArray;
				}
				else {
					selectedNode = selectionArray[0];
				}
				
			}
			else {
				// if branch is open then select nodes
				if (getIsOpen(theParentNode)) {
					
					if (selectionArray.length >1) {
						// select the nodes we just pasted
						selectedNodes = selectionArray;
					}
					else {
						selectedNode = selectionArray[0];
					}
				}
				// otherwise select parent node
				else {
					selectedNode = theParentNode;
				}
			}
			
			// ID count number of currently selected row 	we use absolute indexing here by the help of property 'vPosition'
			//var absRowIndex:Number = rowIndex + this.vPosition;
			// fixes right click on lastOver position when first click is row press (not right click)
			lastOver = selectedIndex;
			
			// determine if this was a drop event, context contextMenu event or method call
			if (eventSource==DROP_EVENT) {
					dispatchEvent ({type:"drop", target:this, eventSource:eventSource, pastePosition:pastePosition, targetNode:theTargetNode, targetIndex:targetIndex});
					dispatchEvent ({type:"onDrop", target:this, eventSource:eventSource, pastePosition:pastePosition, targetNode:theTargetNode, targetIndex:targetIndex});
			}
			else if (eventSource==MENU_EVENT) {
				if (eventConstant==ADD_LEAF) {
					dispatchEvent ({type:"addLeafNode", target:this, eventSource:eventSource, pastePosition:pastePosition, targetNode:theTargetNode, targetIndex:targetIndex});
					dispatchEvent ({type:"onAddLeafNode", target:this, eventSource:eventSource, pastePosition:pastePosition, targetNode:theTargetNode, targetIndex:targetIndex});
				}
				else if (eventConstant==ADD_BRANCH) {
					dispatchEvent ({type:"addBranchNode", target:this, eventSource:eventSource, pastePosition:pastePosition, targetNode:theTargetNode, targetIndex:targetIndex});
					dispatchEvent ({type:"onAddBranchNode", target:this, eventSource:eventSource, pastePosition:pastePosition, targetNode:theTargetNode, targetIndex:targetIndex});
				}
				else {
					dispatchEvent ({type:"pasteNode", target:this, eventSource:eventSource, pastePosition:pastePosition, targetNode:theTargetNode, targetIndex:targetIndex});
					dispatchEvent ({type:"onPasteNode", target:this, eventSource:eventSource, pastePosition:pastePosition, targetNode:theTargetNode, targetIndex:targetIndex});
				}
			}
			else {
				dispatchEvent ({type:"pasteNode", target:this, eventSource:eventSource, pastePosition:pastePosition, targetNode:theTargetNode, targetIndex:targetIndex});
				dispatchEvent ({type:"onPasteNode", target:this, eventSource:eventSource, pastePosition:pastePosition, targetNode:theTargetNode, targetIndex:targetIndex});
			}
			
			// reevaluate sizing for horizontal scrollV policy 
			setHorizontalScroll();
			if (!sameList) {
				lastMovedSource.setHorizontalScroll();
			}
			
			if (selectLength >1) {
				return selectedNodes; 
			}
			else {
				return Object(selectedNodes)[0];
			}
		}
		
		/** 
		Method called when user drags and drops nodes
		@tiptext Method called when user drags and drops nodes
		@description Method called when user drags and drops nodes. This is a function wrapper around the pasteNode function with the same parameters. The only parameter different is the eventSource parameter is set to the DROP_EVENT constant. An onDrop event is generated when a user drops an item onto the tree. See pasteNode for more info. After some user feedback it is recommended to override the pasteNode function. See permissions. 
		@example The dropNode function defined.
		<pre>
		public function dropNode(theSourceNode, theTargetNode, pastePosition, moveNode, eventSource, eventConstant) {
			return pasteNode(theSourceNode, theTargetNode, pastePosition, moveNode, eventSource, eventConstant);
		}
		</pre>
		@see #pasteNode
		*/
		public function dropNode(theSourceNode:Object , theTargetNode:Object, pastePosition:Object, moveNode:Object, eventSource:Object, eventConstant:Object) :Object{
			return pasteNode(theSourceNode, theTargetNode, pastePosition, moveNode, eventSource, eventConstant);
		}
		
		/** 
		Method to add a leaf node to the tree
		@tiptext Method to add a leaf node to the tree
		@description Method to add a leaf node to the Tree. An addLeafNode event is generated when this method is called. The event contains the target which is a reference to the Tree and the eventSource, which indicates if the method was called from the context contextMenu.
		@usage myInstance.addLeafNode(theTargetNode, pastePosition, theSourceNode);
		@param theTargetNode - Optional. The specific location by node of where to add the leaf node. If left out then the root node is used.
		@param theSourceNode - Optional. The xml node. If this value is not passed in then the property leafNodeXML is used. 
		@param pastePosition - Optional. Constant that refers to the paste position (PASTE_INTO, PASTE_BEFORE, PASTE_AFTER). If the pastePosition is not included then the dndTree uses the property addLeafPastePosition. 
		@example The example below adds the default leaf node after the selected node.
		<pre>
		theTree.addLeafNode(theTree.selectedNode, theTree.PASTE_AFTER);
		</pre>
		*/
		public function addLeafNode(theTargetNode:Object, pastePosition:Object, theSourceNode:Object) :Object{
			// check what type of paste operation to use
			if (pastePosition==undefined) {
				pastePosition = addLeafPastePosition;
			}
			
			// check if target node is defined
			// if not then add leaf as the root node
			if (theTargetNode==undefined) {
				theTargetNode = dataProvider.firstChild;
			}
			
			// theSourceNode is an alternative node. this is just for convience
			// if we don't supply theSourceNode then we create a node based on the leafNodeXML property
			if (theSourceNode==undefined) {
				theSourceNode = new XMLDocument(leafNodeXML);
				theSourceNode = theSourceNode.firstChild;
				setIsBranch(theSourceNode,false);
				theSourceNode.bIsNodeBranch = false;
				theSourceNode.bIsNodeOpen = false;
				theSourceNode.bIsParentNodeBranch = false;
			}
			
			// call pasteNode (theSourceNode, theTargetNode, pastePosition, moveNode, eventSource, eventConstant)
			var ret = pasteNode(theSourceNode, theTargetNode, pastePosition, false, METHOD_CALL, ADD_LEAF);
			
			// make sure we get the right node when branch nodes are closed
			if (getIsBranch(ret) && !getIsOpen(ret) && pastePosition==PASTE_INTO) {
				return theTargetNode.firstChild;
			}
			else {
				return ret;
			}
		}
		
		/** 
		Method to add a branch node to the tree
		@tiptext Method to add a branch node to the tree
		@description Method to add a branch node to the tree. An addBranchNode event is generated when this method is called. The event contains the target which is a reference to the tree and the eventSource, which indicates if the method was called from the context contextMenu.
		@usage myInstance.addBranchNode([theTargetNode[, pastePosition[, theSourceNode]]]);
		@param theTargetNode - Optional. The location by node of where to add the branch node. If left out then the root node is used.
		@param pastePosition - Optional. Constant that refers to the paste position (PASTE_INTO, PASTE_BEFORE, PASTE_AFTER). If the pastePosition is not included then the dndTree uses the property addBranchPastePosition.
		@param theSourceNode - Optional. The xml node. If this value is not passed in then the property branchNodeXML is used.
		@example The example below adds a branch node after the selected node.
		<pre>
		var newBranchNode = theTree.addBranchNode(theTree.selectedNode, theTree.PASTE_AFTER);
		trace("newNode = "+newBranchNode);
		</pre>
		*/
		public function addBranchNode(theTargetNode:Object, pastePosition:Object, theSourceNode:Object) :Object{
			
			// check what type of paste operation to use
			if (pastePosition==undefined) {
				pastePosition = addBranchPastePosition;
			}
			
			// check if target node is defined. if not we want to add it to root
			if (theTargetNode==undefined) {
				theTargetNode = dataProvider.firstChild;
			}
			
			// theSourceNode is an alternative node. this is just for convience
			// if we don't supply theSourceNode then we create a node based on the leafNodeXML property
			if (theSourceNode==undefined) {
				theSourceNode = new XMLDocument(branchNodeXML);
				theSourceNode = theSourceNode.firstChild;
				setIsBranch(theSourceNode,true);
				theSourceNode.bIsNodeBranch = true;
				theSourceNode.bIsNodeOpen = false;
				theSourceNode.bIsParentNodeBranch = false;
			}
			
			// call pasteNode (theSourceNode, theTargetNode, pastePosition, moveNode, eventSource, eventConstant)
			var ret = pasteNode(theSourceNode, theTargetNode, pastePosition, false, METHOD_CALL, ADD_LEAF);
			
			// make sure we get the right node when branch nodes are closed
			if (getIsBranch(ret) && !getIsOpen(ret) && pastePosition==PASTE_INTO) {
				return theTargetNode.firstChild;
			}
			else {
				return ret;
			}
		}
		
	
		// not used
		protected function selectNodes(theParentNode:Object, theSelectedNodes:Array):void {
			selectedNodes = theSelectedNodes;
		}
	
		/** 
		A user defined function to allow or prevent drop
		@tiptext A user defined function to prevent or allow drop
		@description A user defined function used to prevent or allow drop. As you drag over each node, you check the target and the source node and determine if the user is allowed to drop the nodes he is dragging into, above or before the node the mouse is over. If you return true then the drop will be successful. If you return false then the drop will not be allowed, a "noDrop" icon will appear in the drag_mc and nothing will be inserted when the user stops dragging. If you return true then the mouse appears normal and when the user stops dragging items the user is dragging will be inserted in the desired location. The default value returned by this function is true.
		@usage myInstance.permitDropFunction = userFunctionName;
		@returns Boolean
		@param theSourceNode:XMLNode - The selected node.
		@param theTargetNode:XMLNode - The target node.
		@param theAction:String - The current drag operation or pastePosition. This can be PASTE_INTO, PASTE_AFTER or PASTE_BEFORE.
		@example The example below prevents a user from pasting the copied node into a leaf node.
		<pre>
		theTree.permitDropFunction = function (theSourceNode, theTargetNode, theAction) {
			if (theTree.getIsLeaf(theSourceNode)) {
				if (theAction==theTree.PASTE_INTO) {
					return false;
				}
			}
			return true;
		}
		</pre>
		*/
		public function permitDropFunction(theSourceNode:Object, theTargetNode:Object, theAction:Object):Boolean {
			return true;
		}
		
		// used to give us the functionality in multiselection - yeah, actually i have no idea
		protected function ondndTreeMouseButtonReleased():void {
		
			// work only on multiple selections
			if ((selectedIndices.length > 1)) {
					// 
					var isAlreadySelected:Boolean;
					var newSelectedItemsIDsArray:Array; 
					
					// new set of selected nodes
					newSelectedItemsIDsArray = new Array();
					for (var k=0; k< selectedIndices.length; k++)	{
						if (selectedIndices[k]== this.selectedRowID) {
							isAlreadySelected = true;
						}
						else {
							newSelectedItemsIDsArray.push(selectedIndices[k]);
						}
					}
					
					if (isAlreadySelected) {	
						// reselect all the node previosly selected except current one
						setSelectedIndices(newSelectedItemsIDsArray);
					}
				}
				
				// tell the tree we are not dragging
				this.dragInProgress = false;
				
				// TODO: Comment on this
				delete this.onMouseUp;
				delete this.ondndTreeMouseButtonReleased;			
		}
		
		// sort by number function
		protected function sortByNumber(a:Object, b:Object):Boolean {
			return (a > b);
		}
	
		/**
		Modifies the drag movieclip before dragging
		@tiptext Modifies the drag movieclip before dragging
		@description Lets the user modify the drag movieclip before dragging and dropping rows. This movieclip only exists when a user starts dragging. It contains many properties including node, nodes, item, items, dndReadOnly, multipleSelection, selectedIndex, selectedIndices, isDragging, moveAfterDropMode, owner, copyIcon, noDropIcon, nodeIcon, label_mc, nodeLength and origName. In addition to that each node in the "nodes" array have the following properties:
		<pre>
		theNode.bIsNodeBranch;
		theNode.bIsBranch;
		theNode.bIsNodeOpen;
		theNode.bIsOpen;
		theNode.owner;
		theNode.indices;
		theNode.itemIndex;
		theNode.readOnly;
		// self removing method
		theNode.removeMe()
		</pre>
		@param drag_mc Movieclip that is being dragged around
		@example The example below adds a property to drag_mc.
		<pre>
		myInstance.modifyDragMC = function (drag_mc) {
			drag_mc.addedProperty = "myAddedValue";
			trace(theDrag_mc.nodes.length);
		}
		</pre>
		@see #drawSeparator
		*/
		public function modifyDragMC(drag_mc:MovieClip):Boolean {
			return true;
		}
		
		// @exclude
		// TODO: Add this to the dndDragManager class when it is created
		public function convertTo(theObjectType:Object, theNode:Object, multipleSelections:Object):Object {
			//trace("\nconvertTo()")
			// holds the list item and items
			var theItem;
			var theItems = new Array();
			var theType = theObjectType.toLowerCase();
			
			// checks if multiple selection is allowed
			if (multipleSelections==undefined) {
				multipleSelections = (theNode.length==undefined) ? false : true;
			}
			
			// checks what type we want to convert our node to
			if (theType=="item") {
				// check if multiple selections
				if (!multipleSelections) {
					// converts single node:XMLNode into a list item:Object
					theItem = convertToItem(theNode);
					return theItem;
				}
				else {
					// loop through multiple selections
					for (var i=0;i < theNode.length; i++) {
						// converts multiple nodes:XMLNode into a list items:Object
						theItems[i] = convertToItem(theNode[i]);			
					}
					return theItems;
				}
			} 
			else if (theType=="griditem") {
				if (!multipleSelections) {
					theItem = this.convertToGridItem(theNode);
					return theItem;
				}
				else {
					for (var i=0;i < theNode.length; i++) {
						theItems[i] = convertToGridItem(theNode[i]);			
					}
					return theItems;
				}
			}
			else if (theType=="other") {
				if (!multipleSelections) {
					theItem = convertToOther(theNode);
					return theItem;
				}
				else {
					for (var i=0;i < theNode.length; i++) {
						theItems[i] = convertToOther(theNode[i]);			
					}
					return theItems;
				}
			}
		}
		
		/**
		Converts single tree node into a list item
		@description Converts a single tree node into a list item. Used internally. It also copies any properties the tree node may have. Overrite this method if you need to extend this. 
		@example The method is shown below. 
		<pre>
		public function convertToItem(theNode) {
			// create new item from xml node
			var newItem = new Object();
			
			// loop through and add any attributes
			for (var prop in theNode.attributes) {
				newItem[prop] = theNode.attributes[prop];
			}
			
			// loop through and add any properties 
			for (var prop in theNode) {
				newItem[prop] = theNode[prop];
			}
			
			return newItem;
		}
		</pre>
		*/
		public function convertToItem(theNode:Object) :Object{
			// create new item from xml node
			var newItem = new Object();
			
			// loop through and add any attributes
			for (var prop in theNode.attributes) {
				newItem[prop] = theNode.attributes[prop];
			}
			
			// loop through and add any properties 
			for (var prop in theNode) {
				newItem[prop] = theNode[prop];
			}
			
			return newItem;
		}
		
		/**
		Converts single tree node into a datagrid row
		@description Converts a single tree node into a datagrid row. Used internally. Not yet implemented. It also copies any properties the tree node may have. Overrite this method if you need to extend this. The method is shown below. 
		@example 
		<pre>
		public function convertToGridItem(theNode) {
			// create new grid row from xml node
			var gridItem = new Object();
			// NOTE: This may copy references from the node. 
	
			// loop through and add any attributes
			for (var prop in theNode.attributes) {
				gridItem[prop] = theNode.attributes[prop];
			}
			
			// loop through and add any properties 
			for (var prop in theNode) {
				gridItem[prop] = theNode[prop];
			}
			
			return gridItem;
		}
		</pre>
		*/
		public function convertToGridItem(theNode:Object) :Object{
			//trace("\nconvertToGridItem()")
			// create new grid row from xml node
			var gridItem = new Object();
			
			// loop through and add any attributes
			for (var prop in theNode.attributes) {
				gridItem[prop] = theNode.attributes[prop];
			}
			
			// loop through and add any properties 
			for (var prop in theNode) {
				gridItem[prop] = theNode[prop];
			}
			
			return gridItem;
		}
		
		// @exclude
		public function convertToOther(theNode:Object):Object {
			return theNode;
		}
		
		
		// @exclude
		// Drag and Drop Sequence
		// 7. Dispatched event from drag_mc onMouseMove function
		// check drag position and permission to drop
		// update drag mc node display accordingly
		protected function onDraggerMove(eventObj:Object):Boolean {
			// get copy of drag mc
			var drag_mc = eventObj.target;				
			// get references to nodes
			var node  = drag_mc.node;
			var nodes = drag_mc.nodes;
			var multipleSelections = drag_mc.multipleSelections;
			var root_mc:MovieClip = getRoot(this);
			
			// set can drop flag optimistic
			bCanDrop = true;
			
			// drag enabled
			if (dndEnabled==false) {
				return false;
			}
			
			// move noDropAllowed cursor
			drag_mc.noDropIcon.x = root_mc.mouseX-5;
			drag_mc.noDropIcon.y = root_mc.mouseY-5;
			
			// move copyIcon
			//drag_mc.copyIcon.x = _root.mouseX + copyIconX;
			//drag_mc.copyIcon.y = _root.mouseY + copyIconY;
			
			
			// test if we are dragging the mouse over component
			if (globalHitTest()) {
				// test if mouse is over row
				if (hitTest(root_mc.mouseX, root_mc.mouseY)) {
					// flag that we are over this tree
					bIsTreeTarget = true;
					
					//loop over displayed rows and highlight as needed
					for (var i=0; i<rows.length; i++) {
						var theRow = rows[i];
						// check if mouse is within hitarea of row and what part - top, middle, bottom
						if(theRow.hitTest(root_mc.mouseX, root_mc.mouseY)) {
							
							// get current absolute row index;
							var itemIndex = vPosition + i;
							//var cellIndex = getPressedCellIndex(itemIndex);
							
							// create temporary node
							var tmpTarget;
							tmpTarget = getItemAt(itemIndex);
							var bIsBranch = getIsBranch(tmpTarget);
							
							// get mouse position
							objPoint.x = root_mc.mouseX;
							objPoint.y = root_mc.mouseY;
							
							// convert mouse position over stage to mouse position over row
							theRow.globalToLocal(objPoint);
							
							// stores position of mouse over row
							dragOverPos   = PASTE_INTO;
							dragOverAbove = false;
							dragOverBelow = false;
							var theRowHeight = theRow.height;
							var rowDelta = theRow.height / 2;
							var curY = objPoint.y;
							// we use newY to position the seperator mc
							var newY = 0;
							
							// get if a branch
							if (!bIsBranch && preventDropIntoLeafNodes) {
								// get position of mouse over row - above or below
								if (curY <= rowDelta) {
									dragOverPos = PASTE_BEFORE;
									dragOverAbove = true;
									dragOverBelow = false;
								}
								else {
									dragOverPos = PASTE_AFTER;
									dragOverBelow = true;
									dragOverAbove = false;
								}
							}
							else {
								if (curY <= dndGutter) {
									dragOverPos = PASTE_BEFORE;
									dragOverAbove = true;
									dragOverBelow = false;
								}
								else if (curY < 0 || curY >= (theRowHeight - dndGutter)) {
									dragOverPos = PASTE_AFTER;
									dragOverBelow = true;
									dragOverAbove = false;
								}
								else {
									dragOverPos = PASTE_INTO;
									dragOverBelow = false;
									dragOverAbove = false;
								}
							}
	
							/*		
							// get position of dragNode - over, above or below drop node
							if (objPoint.y <= dndGutter) {
								dragOverPos = PASTE_BEFORE;
								dragOverAbove = true;
								dragOverBelow = false;
								newY = -objPoint.y - 2;
							}
							else if (objPoint.y < 0 || objPoint.y >= (rows[i].height - dndGutter)) {
								dragOverPos = PASTE_AFTER;
								dragOverBelow = true;
								dragOverAbove = false;
								newY = rows[i].height - objPoint.y - 2;
							}
							else {
								newY = dndGutter + 2 - objPoint.y;
							}
							*/
							
							// define if it's an empty row
							emptyRow = false;
							
							// check if mouse is over an empty row 
							// if so we want to let user drop in that space if canDropInEmptyRow is true
							if (tmpTarget==undefined) {
								emptyRow = true;
							}
							// set absolute rowIndex
							tmpTarget.itemIndex = itemIndex;
							// put our temp node into tree target node 
							targetNode = tmpTarget;
							
							// check drop permissions so we can give visual feedback
							// i tried to make this into a function called permitDrop() but 
							// the passed references didn't behave correctly. it was really odd behavior
							for (var j=0;j<nodes.length;j++) {
								if (targetNode==nodes[j]) {
									addError("onDraggerMove", "Cannot drop node on self");
									// do not let a node drop onto it's self
									bCanDrop = false;
									break;
								}
								else if (isTargetChild(targetNode, nodes[j])) {
									addError("onDraggerMove", "Cannot drop parent on child");
									bCanDrop = false;
									break;
								}
								// we are over unknown territory
								else if (targetNode==undefined) {
									// check if we are over empty row
									if (emptyRow) {
										// check if can drop node on empty row
										if (!canDropOnEmptyRows) {
											addError("onDraggerMove", "Cannot drop on empty rows");
											bCanDrop = false;
											break;
										}
										else {
											// check whether we are dragging root node from the same tree onto empty row
											if (nodes[j] == this.getTreeNodeAt(0)) {
												addError("onDraggerMove", "Cannot drop root node onto empty rows");
												bCanDrop = false;
												break;
											}
										}
									}
									// not over any rows
									else {
										addError("onDraggerMove", "Cannot drop outside of rows");
										bCanDrop = false;
										break;
									}
								}
								
								// we passed the first tests now we do more extensive tests
								if (bCanDrop) {
									// let user decide if it is ok to drop node
									bCanDrop = permitDropFunction(nodes[j], targetNode, dragOverPos);
									// if we can't drop then break so we can save some cpu cycles
									if (!bCanDrop) {
										break;
									}
								}
							} // end for
							
							// update icon display
							if (bCanDrop)	{
								// hide custom cursor (no drop cursor)
								drag_mc.hideCustomCursor();
								var move = drag_mc.moveAfterDropMode;
								var readOnly = drag_mc.dndReadOnly;
								
								// check if we want to move or copy
								if (readOnly) {
									if (drag_mc.owner != this) {
										// show copy icon
										drag_mc.copyIcon.visible = true;
									}
									else {
										// do not show copy icon over same list
										drag_mc.copyIcon.visible = false;
									}
								}
								else {
									if (!move) {
										drag_mc.copyIcon.visible = true;
									}
									else {
										drag_mc.copyIcon.visible = false;
									}
								}
							}
							else {
								// show custom cursor
								drag_mc.showCustomCursor();
							}
							
							// get mouse location
							objPoint.y = root_mc.mouseY;
							objPoint.x = root_mc.mouseX;
							// set mouse pointer relative to this instance
							globalToLocal(objPoint);
							
							// draw separator line
							if (dragOverAbove || dragOverBelow || emptyRow) {
								if (enableDragLine) {
									// draws separator line. user can redefine this
									drawSeparator(objPoint, theRow, dragOverPos, bCanDrop);
									// this means we are in the "paste before" or "paste after" space inside the row
								}
								bInGutter = true;
							}
							else{
								if (enableDragLine) {
									// draws separator line. user can redefine this
									drawSeparator(objPoint, theRow, dragOverPos, bCanDrop);
									// we are outside of the gutter space. either in the paste into or somewhere else
								}
								bInGutter = false;
							} // end if (draw separator line)
						} // end if (row HitArea)
					} // end for (for cycle)
				} // end if (theTree hitArea)
				else {
					// we are outside of current Tree
					bIsTreeTarget = false;
					bInGutter = false;
					// if moved outside - hide the separator
					separator.visible = false;	
				}
			} // end if (global dndWidgets)	
			else {
				// we are outside any of dndWidget
				bIsTreeTarget = false;
				bInGutter = false;
				// if moved outside - hide the separator
				separator.visible = false;
				// show custom cursor	
				drag_mc.showCustomCursor();
			}
		}
		
		/**
		Draws separator line when dragging 
		@description Draws separator line when dragging. This method is provided in case you want to create your own drag separator. For example, you could use this function to highlight rows as you drag over them. The enableDragLine must be set to true to use this function. 
		@param Object. The object pointer. It contains the x and y position of the mouse over the component
		@param Movieclip. A reference to the row the mouse is over
		@param Number. The position the mouse is at relative to the row with a value of one of the constants PASTE_BEFORE, PASTE_BEFORE or PASTE_INTO
		@param Boolean. Indicates if the user has permission to drop on this row
		@example The method is shown below.
		<pre>
		// here is the drawSeparator code
		function drawSeparator(objPoint, row, dragOverPos, bCanDrop) {
			//var maxWidth = 24;
			var maxWidth = width/2;
			//var maxWidth = objPoint.x - 5;
			//trace("maxWidth="+maxWidth)
			
			if (dragOverPos == PASTE_BEFORE) {
				separator.visible = true;
				if (row.state!="normal") {
					//row.setState("normal", false);
				}
				separator.y = row.y;
			}
			else if (dragOverPos == PASTE_BEFORE) {
				separator.visible = true;
				//row.icon_mc.alpha = 100;
				//row.setState("normal", false);
				//row.icon_mc.gotoAndStop(1);
				// this unhighlights the row
				if (row.state!="normal") {
					//row.setState("normal", false);
				}
				separator.y = row.y + rowHeight;
			}
			else if(dragOverPos == PASTE_INTO) {
				//separator.visible = false;
				// row.icon_mc.alpha = 100;
				// this highlights the row
				if (row.state!="highlighted") {
					//row.setState("highlighted", false);
				}
				separator.y = row.y + (rowHeight/2);
				//separator.y = objPoint.y;
				//row.icon_mc.gotoAndStop(2);
				// hide separator if we cannot drop
				//if (bCanDrop) {
				//	trace("bCanDrop = true")
				//	separator.visible = false;
				//}
				//else {
				//	separator.visible = true;
				//}
			}
			separator.alpha  = 100;
			separator.width  = maxWidth;
			separator.height = 1;
			separator.graphics.clear();
			separator.graphics.lineStyle(1, 0x666666, 50);
			separator.graphics.moveTo(0, 0);
			separator.graphics.lineTo(width,0);
			//separator.y = objPoint.y;
			separator.x = 5;
			// we can track the depth that we are at but it doesn't look that good.
			//separator.x = row.nodeIcon.x;
		}
		</pre>
		@see #enableDragLine
		*/
		public function drawSeparator(objPoint:Object, row:Object, dragOverPos:Object, bCanDrop:Boolean) :void{
			//var maxWidth = 24;
			var maxWidth = width/2;
			//var maxWidth = objPoint.x - 5;
			//trace("maxWidth="+maxWidth)
			
			if (dragOverPos == PASTE_BEFORE) {
				separator.visible = true;
				if (row.state!="normal") {
					//row.setState("normal", false);
				}
				separator.y = row.y;
			}
			else if (dragOverPos == PASTE_AFTER) {
				separator.visible = true;
				//row.icon_mc.alpha = 100;
				//row.setState("normal", false);
				//row.icon_mc.gotoAndStop(1);
				// this unhighlights the row
				if (row.state!="normal") {
					//row.setState("normal", false);
				}
				separator.y = row.y + rowHeight;
				//trace("_rowHeight="+rowHeight)
				//trace("rowHeight="+rowHeight)
			}
			else if(dragOverPos == PASTE_INTO) {
				//separator.visible = false;
				// row.icon_mc.alpha = 100;
				// this highlights the row
				if (row.state!="highlighted") {
					//row.setState("highlighted", false);
				}
				separator.y = row.y + (rowHeight/2);
				//separator.y = objPoint.y;
				//row.icon_mc.gotoAndStop(2);
				// hide separator if we cannot drop
				//if (bCanDrop) {
				//	trace("bCanDrop = true")
				//	separator.visible = false;
				//}
				//else {
				//	separator.visible = true;
				//}
				//
			}
			separator.alpha  = 100;
			separator.width  = maxWidth;
			separator.height = 1;
			separator.graphics.clear();
			separator.graphics.lineStyle(1, 0x666666, 50);
			separator.graphics.moveTo(0, 0);
			separator.graphics.lineTo(width,0);
			//separator.y = objPoint.y;
			// we can track the depth that we are at but it doesn't look that good.
			//separator.x = row.nodeIcon.x;
			separator.x = 5;
		}
	 	
		// @exclude
		// Drag and Drop Sequence
		// 9. Drop event fired by Mouse Up event generated by drag mc
		protected function onDraggerDrop(eventObj:Object):Object {
			//tracef("onDraggerDrop")
			// get reference to drag_mc
			var drag_mc = eventObj.target;
			var node = drag_mc.node;
			var nodes = drag_mc.nodes;
			var rowIndex;
			moveAfterDropMode = drag_mc.moveAfterDropMode;
			rowIndex = Object(targetNode).itemIndex;
			
			// show separator
			separator.visible = false;
			
			// hide custom cursor
			drag_mc.hideCustomCursor();
			
			// if this tree is not the target or we cannot drop then exit
			if (!bIsTreeTarget || !bCanDrop) {
				addError("onDraggerDrop", "Cannot drop or Tree is not Target");
	 			return false;
			}
			
			// if not defined then check variable type
			var multipleSelections = (nodes.length==undefined) ? false : true;
			
			// if array is not defined then define array
			if (!multipleSelections) {
				nodes = new Array (node);
			}
			
			// check drop permissions for all nodes
			for (var j=0;j<nodes.length;j++) {
				// check to make sure we do not let a node drop onto it's self
				if (targetNode==nodes[j]) {
					addError("onDraggerDrop", "Cannot drop node on self");
					bCanDrop = false;
					break;
				}
				// check to make sure we do not let a parent node drop onto a child node
				else if (isTargetChild(targetNode, nodes[j])) {
					addError("onDraggerDrop", "Cannot drop parent node on child node");
					bCanDrop = false;
					break;
				}
				// we are somewhere we do not know yet
				else if (targetNode==undefined) {
					// check if we are over empty row
					if (emptyRow) {
						// check if can drop node on empty row
						if (!canDropOnEmptyRows) {
							addError("onDraggerDrop", "Cannot drop node on empty rows");
							bCanDrop = false;
							break;
						}
						// we can drop on empty nodes
						else {
							// check whether we are dragging root node from the same tree									
							if (nodes[j] == this.getTreeNodeAt(0)) {
								addError("onDraggerDrop", "Cannot drop root node onto empty row");
								bCanDrop = false;
								break;
							}
						}
					}
					// we are somewhere else not a row
					else {
						addError("onDraggerDrop", "Cannot drop into outerspace");
						bCanDrop = false;
						break;
					}
				}
				
				// we passed the first tests now we check for any user defined permissions
				if (bCanDrop) {
					bCanDrop = permitDropFunction(nodes[j], targetNode, dragOverPos);
					// if we can't drop then break so we can save some cpu cycles
					if (!bCanDrop)  {
						break;
					}
				}
				
				// TODO: Comment on what this does			
				delete this.startDragRowID;
			}
			
			// if we can drop insert nodes at the drop position
			if (bCanDrop) {
				
				var results;
				
				if (doNotInsertOnDrop) {
					dispatchEvent ({type:"drop", target:this, eventSource:DROP_EVENT, pastePosition:dragOverPos, 
									targetNode:targetNode, targetIndex:rowIndex, nodes:nodes, node:nodes[0]});
					dispatchEvent ({type:"onDrop", target:this, eventSource:DROP_EVENT, pastePosition:dragOverPos, 
									targetNode:targetNode, targetIndex:rowIndex, nodes:nodes, node:nodes[0]});
				}
				else {
					results = dropNode(nodes, targetNode, dragOverPos, moveAfterDropMode, DROP_EVENT);
				}
				
				/*
				// pasteNode (theSourceNode, theTargetNode, pastePosition, moveNode, eventSource, eventConstant)
				results = dropNode(nodes, targetNode, dragOverPos, moveAfterDropMode, DROP_EVENT);
				*/
				bInGutter = false;
				
				// get ref to row
				if (dragOverPos==PASTE_BEFORE) {
					rowIndex = Object(targetNode).itemIndex;
				}
				else if (dragOverPos==PASTE_AFTER) {
					rowIndex = Object(targetNode).itemIndex +1;
				}
				else if (dragOverPos==PASTE_INTO) {
					rowIndex = Object(targetNode).itemIndex;
				}
				
				if (Object(targetNode).itemIndex==undefined) {
					rowIndex = dataProvider.length-1;
				}
	
				var theRow = rows[Number(rowIndex-vPosition)];
				
				if (results!=false && drag_mc.successfulDrop!=undefined) {
					drag_mc.successfulDrop(this, targetNode, dragOverPos, theRow);
				}
				
				return results;
			}
		
			return null;
		}
		
		/**
		Gets the label of the node 
		@description Gets the label of the node. Uses and returns the substitute label if the parameter is supplied and the label of the node is undefined.
		@usage theTree.getNodeLabel(node);
		@param theNode XMLNode: The tree node
		@param subIcon String: The text of a substitute label. 
		@returns String. Text of the label.
		@example 
		<pre>
		trace(theTree.getNodeLabel(node));
		</pre>
		*/
		public function getNodeLabel(theNode:Object, subLabel:Object):Object {
			// sublabel provides an alternative label
			var nodeLabel = subLabel;
			var retVal = labelFunction(theNode);
	
			// if a label function exists then get the text to display
			if (retVal!=undefined) {
				nodeLabel = retVal;
			}
			else if (labelField != undefined) {
				// if an label field exists then get the label for that
				var labelValue = theNode.attributes[labelField];
				// if it is not blank then set it
				if (labelValue!=undefined) {
					nodeLabel = labelValue;
				}
				else {
					nodeLabel = subLabel;
				}
			}
			else {
				// labelField and labelFunction are not set
				nodeLabel = theNode.attributes.label;
			}
			
			return nodeLabel;
		}
		
		/**
		Gets the icon of the node 
		@description Gets the icon of the node. Uses and returns the substitute icon if the parameter is supplied. If the substitute icon is not supplied it uses the built in icon. 
		@usage theTree.getNodeIcon(node);
		@param theNode XMLNode: The tree node
		@param subIcon String: Identifier of a substitute icon. Substitute icon is a movieclip. 
		@returns String. Name of icon.
		@example 
		<pre>
		trace(theTree.nodeIcon(node));
		</pre>
		*/
		public function getNodeIcon(theNode:Object, subIcon:Object):Object {
			// subIcon provides an alternative icon
			var nodeIcon;
			var styleIcon = getStyle("defaultIcon");
			var retVal = iconFunction(theNode);
	
			// if a icon function exists then get the text to display
			if (retVal!=undefined) {
				nodeIcon = retVal;
			}
			else if (iconField != undefined) {
				// if an label field exists then get the label for that
				var iconValue = theNode.attributes[iconField];
				// if it is not blank then set it
				if (iconValue!=undefined) {
					nodeIcon = iconValue;
				}
			}
			else if (styleIcon!=undefined) {
				// use the style icon if it exists
				nodeIcon = styleIcon;
			}
			else if (subIcon!=undefined) {
				// use the alternative icon if it exists
				nodeIcon = subIcon;
			}
			else {
				//nodeIcon = getIsBranch(theNode) ? strDragBranchIcon : strDragLeafIcon;
				//nodeIcon = getIsOpen(theNode) ? strDragBranchOpenedIcon : nodeIcon;
			}
			
			return nodeIcon;
		}
		
		/** 
		Lets the user show an alert before a cut or remove event
		@tiptext Lets the user show an alert before a cut or remove event
		@description Lets the user show an alert before a cut or remove event. You can define this to pop up an alert prompt similar to windows explorer. Because of the nature of the Alert component we cannot get the button clicked syncronously, as far as I know. Therefore, we have to manually call the method we would have performed when the user clicks the OK button. See permissions example. 
		@usage myInstance.permitRemove = someFunction;
		@returns Boolean Returns false to prevent cut or remove. Return true to continue cut or remove.
		@param Object - The tree.
		@param Object - The menuItem.
		@param String - The caption of the contextMenu item.
		@param String - The current event operation. This can be REMOVE_ITEM or CUT_ITEM.
		@example The example prompts the user before removing the selected item.
		<pre>
		// import the alert contol - add to the library
		import mx.controls.Alert;
		
		// prompt user on remove event
		theTree.permitRemove = function (theTree, menuItem, menuCaption, eventType) {
			// BE CAREFUL of SCOPE ISSUES HERE - check your references are correct
			var itemLabel = theTree.selectedItem.label;
			var eventName = "cut";
			var output = "";
			// check if this is a remove event
			if (eventType == theTree.REMOVE_ITEM) {
				eventName = "remove";
			}
			
			myClickHandler = function (evt) {
				if (evt.detail == Alert.OK) {
					theTree.cutNode(theTree.selectedItems, theTree.MENU_EVENT, eventType);
				}
			}
			output = "Are you sure you want to " + eventName + " " + itemLabel + "?";
			var myAlert = Alert.show(output, "Confirm File Delete", Alert.OK | Alert.CANCEL, this, myClickHandler, "stockIcon", Alert.OK);
			return false;
		}
		</pre>
		@see #permitDropFunction
		@see #permitContextMenu
		*/
		public function permitRemove(obj:Object, menuItem:Object, menuCaption:Object, eventType:Object, cellIndex:Object) :Boolean{
			return true;
		}
	
		/** 
		A user defined function to allow rename on a node
		@tiptext A user defined function to allow rename on a node
		@description A user defined function to show the rename textfield on a node. If this function returns false then no rename textfield will be shown for the selected node. This is useful if you do not want to show a rename textfield on specific nodes such as the root node or branch nodes. 
		@usage myInstance.permitRename = function(theSourceNode) {};
		@returns Boolean Return true to show rename text field. Return false to not show rename text field.
		@param theSourceNode:XMLNode - The selected node
		@see #validateNodeLabel, #renameTextRestrict, #enableRenameNode
		@example The example below hides the rename text field on branch nodes.
		<pre>
		theTree.permitRename = function (theSourceNode) {
			// check if the node is a branch node
			if (theTree.getIsBranch(theSourceNode)) {
				// if it is then do not show the rename text field
				return false;
			}
			return true;
		}
		</pre>
		@see #validateItemLabel
		@see #renameTextRestrict
		@see #enableRenameItem
		@see #renameOnDoubleClick
		@see #strRenameItem
		@see #permitContextMenu
		*/
		public function permitRename(theSourceNode:Object) :Boolean{
			return true;
		}
		
		
		/** 
		A user defined function to display context contextMenu items
		@tiptext A user defined function to display context contextMenu items
		@description A user defined function to show or hide context contextMenu items. When a user right-clicks on a node in the Tree the permitContextMenu function is called for every item in the contextMenu. If you return true to this function the contextMenu item shows up. If you return false then the contextMenu item is hidden. If you have multiple nodes selected this procedure is called on every node. Any node that hides a contextMenu item for itself hides it for the rest of the nodes. For example, let's say you did not want the user to cut out any branch nodes. So you would use this function to check if the contextMenu item being checked is a CUT_ITEM contextMenu item and theSourceNode being passed in is a branch. If they are then return false. Now, lets say the user has selected nine leaf nodes and one branch node. Because we are returning false on the conditions we have setup in this function the "Cut Item" contextMenu item will not show up in the context contextMenu. 
		@usage myInstance.permitContextMenu = function(theSourceNode,theAction,theMenuItem,theContextMenu) {};
		@returns Boolean
		@param theSourceNode:XMLNode - The selected node
		@param theAction:String - Reference to a static event variable if one is assigned such as (PASTE_INTO, ADD_LEAF, etc).
		@param theMenuItem:Object - Reference to custom item object
		@param theContextMenu:ContextMenu - Reference to the context contextMenu
		@example The example below hides the "Paste Into" contextMenu item preventing a user from pasting the copied node into a leaf node.
		<pre>
		theTree.permitContextMenu = function (theSourceNode, theAction, theMenuItem, theContextMenu) {
			// trace("the node being examined is " + theSourceNode.attributes.label)
			// trace("   the contextMenu item being passed in is="+ theMenuItem.caption)
			// prevent a user from pasting into a leaf node if preventDropIntoLeafNodes is set to true
			if (theTree.getIsLeaf(theSourceNode) && preventDropIntoLeafNodes && theAction==theTree.PASTE_INTO) {
				return false;
			}
			return true;
		}
		</pre>
		*/
		public function permitContextMenu(theSourceNode:XMLNode, theAction:Object, theMenuItem:Object, theContextMenu:Object) :Boolean{
			// prevent a user from pasting into a leaf node if preventDropIntoLeafNodes is set to true
			if (getIsLeaf(theSourceNode) && preventDropIntoLeafNodes && theAction==PASTE_INTO) {
				return false;
			}
			return true;
		}
	
		/** 
		A user defined function to allow open or closing of node. Deprecated.
		@tiptext A user defined function to allow open or closing of node. Deprecated.
		@description Deprecated. Use permitOpen or permitClose functions. A user defined function to allow open or closing of node. This default value returned by this function is true. 
		@usage myInstance.permitOpenClose = function(theNode, bOpen) {};
		@returns Boolean
		@param theNode:XMLNode - The selected node
		@param bOpen:Boolean - Refers to the method being called on the node. If true then the node is trying to be opened. If false then the node is trying to be closed.
		@example The example below prevents a user from closing branch nodes.
		<pre>
		
		theTree.permitOpenClose = function (theNode, bOpen) {
			if (this.getIsBranch(theNode) && bOpen==false) {
				return false;
			}
			return true;
		}
		</pre>
		@see #permitOpen
		@see #permitClose
		*/
		public function permitOpenClose(theNode:Object, bOpen:Object):Object {
			var ret = true;
			
			if (bOpen) {
				ret = permitOpen(theNode);
			}
			else {
				ret = permitClose(theNode);
			}
			
			return ret;
		}
	
		/** 
		A user defined function to allow open of node
		@tiptext A user defined function to allow open of node
		@description A user defined function to allow open of node. This default value returned by this function is true.
		@usage myInstance.permitOpen = function(theNode) {};
		@returns Boolean
		@param theNode:XMLNode - The selected node
		@example The example below prevents a user from opening branch.
		<pre>
		theTree.permitOpen = function (theNode) {
			if (this.getIsBranch(theNode)) {
				return false;
			}
			return true;
		}
		</pre>
		@see #permitClose
		*/
		public function permitOpen(theNode:Object):Boolean {
			return true;
		}
	
		/** 
		A user defined function to allow close of a node
		@tiptext A user defined function to allow close of a node
		@description A user defined function to allow close of a node. This default value returned by this function is true.
		@usage myInstance.permitOpen = function(theNode) {};
		@returns Boolean
		@param theNode:XMLNode - The selected node
		@example The example below prevents a user from closing branch.
		<pre>
		theTree.permitClose = function (theNode) {
			if (this.getIsBranch(theNode)) {
				return false;
			}
			return true;
		}
		</pre>
		@see #permitOpen
		*/
		public function permitClose(theNode:Object):Boolean {
			return true;
		}
		
		//@exclude
		// gets position of node relative to it's parent
		public function getNodePos(theNode:Object) :Number{
			var count:Number = 0;
			var prevNode:XMLNode = theNode.previousSibling;
			while (prevNode != undefined) {
				prevNode = prevNode.previousSibling;
				count += 1;
			}
			return count;
		}
		
		//@exclude
		// checks whether targetNode is a child of parentNodeAnc
		protected function checkAncestor(theTargetNode:XMLNode, parentNodeAnc:Object):Boolean {
			var tmpNode:XMLNode = theTargetNode;
			var ret:Boolean = false;
			while (tmpNode.parentNode != null) {
				ret = (tmpNode.parentNode == parentNodeAnc);
				
				if (ret) break;
				tmpNode = tmpNode.parentNode;
			}
			return ret;
		}
		
		// @exclude
		// checks whether targetNode is a grandchild of draggedNode. returns boolean
		public function isTargetChild(theTargetNode:XMLNode,theSourceNode:Object) :Boolean{
			return checkAncestor(theTargetNode, theSourceNode);
		}
		
		/**
		Checks if node is a leaf node
		@description Checks if node is a leaf node
		@usage theTree.getIsLeaf(node);
		@param node XMLNode tree node.
		@returns Boolean. True if node is leaf. False if node is branch. 
		@example 
		<pre>
		theTree.getIsLeaf(node);
		</pre>
		*/
		public function getIsLeaf(node:XMLNode):Boolean {
			return !getIsBranch(node);
		}
		
		//@exclude
		// keep cross drag backwards capability
		protected function setCrossDrag(enable:Boolean):void {
			enableCrossDrag = enable;
		}
		
		/** 
		Enables cross dragging between other drag and drop controls
		@tiptext Enables cross dragging between other drag and drop controls
		@description Enables cross dragging between other drag and drop controls. 
		@returns Boolean - True allows dragging and dropping to other controls. False does not let nodes drop onto other controls.
		@example The example enables drag and drop between these two tree components.
		<pre>
		theTree.enableCrossDrag = true;
		theTree2.enableCrossDrag = true;
		</pre>
		*/
		[Inspectable(type=Boolean, name=" Enable Cross Drag and Drop (enableCrossDrag)", defaultValue="false", category="_General 010")]
		public function get enableCrossDrag():Boolean {
			return bCrossDragEnabled;
		}
		
		//@exclude
		public function set enableCrossDrag(enable:Boolean):void {
	  
			var crossdndWidgetList:DndUIWidgets = DndUIWidgets.getWidgetList ();
			if (enable) {			
				crossdndWidgetList.addItem(this);
				bCrossDragEnabled = enable;
			}
			else {
				bCrossDragEnabled = false;
				crossdndWidgetList.removeItem(this);
			}	
		}
		
		/**
		Sets the X coordinate for the copy icon
		@tiptext Sets the X coordinate for the copy icon
		@description Number; Sets the X coordinate for the copy icon.
		*/
		public function set copyIconX(newValue:Number):void {
			m_copyIconX = newValue;
		}
		
		/**
		Gets the X coordinate for the copy icon
		@tiptext Gets the X coordinate for the copy icon
		@description Number; Gets the X coordinate for the copy icon.
		*/
		public function get copyIconX() :Number{
			return m_copyIconX;
		}
		
		/**
		Sets the Y coordinate for the copy icon
		@tiptext Sets the Y coordinate for the copy icon
		@description Number; Sets the Y coordinate for the copy icon.
		*/
		public function set copyIconY(newValue:Number):void{
	  		m_copyIconY = newValue;
		}
		
		/**
		Gets the Y coordinate for the copy icon
		@tiptext Gets the Y coordinate for the copy icon
		@description Number; Gets the Y coordinate for the copy icon.
		*/
		public function get copyIconY():Number{
			return m_copyIconY;
		}
		
		// key listener
		protected function onKeyDown(e:Object) :void{
	
			if (Keyboard.isDown(Keyboard.CONTROL)) {
				copyControlMode     = "COPY";		
				isCtrlButtonPressed = true;
			}
			else {
				copyControlMode   = "MOVE";
				isCtrlButtonPressed = false;
			}
			
			if (isRenaming) {
				//trace("renaming " + e.getCode())
			}
			else {
				//trace("passing " + e.getCode() + " through")
				super.keyDown(e);
			}
		}
		
		//@exclude
		protected function onKeyUp():void {	
			isCtrlButtonPressed = false;
			// reset dragging mode to the default - the node will be removed after dragging ends
			copyControlMode   = "MOVE";	
		}
		
		//@exclude
		// sets whether copyIcon is visible or not - either copying or moving
		public function set copyControlMode(newValue:String) {
		
			switch (newValue) {
				case "COPY": {
					moveAfterDropMode = false;	
					
					if (drag_mc.isDragging) {									
						//------------COPY node-------------
						drag_mc.copyIcon.visible = true;
					}					
					break;
				}
				case "MOVE": {
					moveAfterDropMode = true;
					if (drag_mc.isDragging) {
						//------------MOVE node-------------
						drag_mc.copyIcon.visible = false;
					}
					
					break;	
				}			 
			}
		
			m_copyControlMode = newValue;
		}
		
		// controls copy
		public function get copyControlMode() {
			return m_copyControlMode;
		}
		
		/**
		* This function returns TRUE if the row was already selected before mouse click
		* @description Operates with absolute indexing.
		* @param Number - absolute index of the tree row
		* @exclude
		*/
		protected function isRowClickedAlreadySelected(absRowIndex:Number):Boolean {
			var bIsAlreadySelected = false;
			
			for (var k=0; k< selectedIndices.length; k++) {
				if (selectedIndices[k]== absRowIndex) {
					bIsAlreadySelected = true;
				}
			}
			return 	bIsAlreadySelected;		
		}
		
	
		// @exclude
		// shows the custom "noDrop possible" cursor
		public function showCustomCursor()	:void{
			Mouse.hide();
			drag_mc.noDropIcon.visible = true;		
		}
		
		// @exclude
		// hides the custom "noDrop possible" cursor
		public function hideCustomCursor()	:void{
			Mouse.show();
			drag_mc.noDropIcon.visible = false;
		}
	
		/**
		Shows renaming textfield over row
		@description Shows a textfield over row that the user can type into to rename the item label. The user can rename from the context contextMenu or double click on a row to show the rename textfield. To prevent renaming on double click disable the renameOnDoubleClick property. This is mostly an internal method. 
		@param Relative row index. The selectedIndex, lastOver, lastOverIndex and vPosition are useful in finding the row. 
		@param Menu item event or double click event.
		@example
		<pre>
		// shows the rename text field on the first visible row
		theTree.showRenameNode(0);
		</pre>
		@see #enableRenameItem
		@see #setItemLabel
		@see #validateItemLabel
		@see #permitRename
		@see #renameField
		@see #renameOnDoubleClick
		@see #renameTextRestrict
		@see #renameFunction
		@see #selectedIndex
		@see #lastOver
		@see #lastOverIndex
		@see #vPosition
		*/
		public function showRenameNode(rowIndex:Number, eventSource:Object):void{
			// set rename variable to prevent navigating the rows with the keys
			isRenaming = true;
			// is used to prevent dispatching rename node twice weirdness on kill focus
			hasRenamed = false;
			
			// row view of selected node and reference to row label
			var row = rows[rowIndex];
			var customRenderer = (row.cll.renameField != undefined);
			var rowLabel = (customRenderer) ? row.cll.renameField : row.cll;
			var nestedX = (customRenderer) ? rowLabel.nestedX : rowLabel.x;
			var nestedY = (customRenderer) ? rowLabel.nestedY : rowLabel.y-2;
			
			// create new label and place it over original label
			// set the format to the same font as the current row label
			var txtObjFormat = rowLabel._getTextFormat();
			// TODO: looks like we are setting the width wrong with width instead of width
			row.rename_txt = new TextField();
			row.addChildAt(row.rename_txt, 100);
			row.rename_txt.x = nestedX;
			row.rename_txt.y = nestedY;
			row.rename_txt.width = rowLabel.width;
			row.rename_txt.height = rowLabel.height-1;
			
			
			var r_txt = row.rename_txt;
			r_txt.border = true;
			r_txt.borderColor = 0xD5DDDD;
			r_txt.background = true;
			r_txt.selectable = true;
			r_txt.setNewTextFormat(txtObjFormat);
			r_txt.type = "input";
			r_txt.text = rowLabel.text;
			r_txt.orgText = rowLabel.text;
			r_txt.owner = this;
			r_txt.rowIndex = rowIndex;
			r_txt.row = row;
			r_txt.selectedNode = this.selectedNode;
			
			// if the user sets the new property renameTextRestrict we will use it on our rename text field	
			if (this.renameTextRestrict!=undefined) {
				r_txt.restrict = this.renameTextRestrict;
			}
	
			// set focus on text field and select the text
			Selection.setFocus(r_txt);
			Selection.setSelection(0, r_txt.text.length);
			
			// on lost focus check if content validates using new function validateNodeLabel()
			// if it validates then set the label using new function setNodeLabel()
			// if it does not validate then let be shown still
			r_txt.onKillFocus = function() {
				if (Object(this).dispatched) return;
				var strLabel  = Object(this).text;
				var theTree = Object(this).owner;
				var validated = theTree.validateNodeLabel(strLabel, this);
				
				if (validated) {
					// set the node label
					theTree.setNodeLabel(Object(this).selectedNode, strLabel);
					// hide the editable textfield
					Object(this).visible = false;
					// dispatch an event only if node label changes
					if (Object(this).orgText != strLabel && !theTree.hasRenamed) {
						theTree.dispatchEvent({type:"renameNode", target:Object(this).owner, rowIndex:Object(this).rowIndex, row:Object(this).row, originalText:Object(this).orgText, node:Object(this).selectedNode});
						theTree.hasRenamed = true;
					}
					// stop text field from listening to the keyboard
					Keyboard.removeListener(this);
					// TODO: Redraw the row specifically. 
					theTree.refresh();
					theTree.setHorizontalScroll();
					Object(this).onKillFocus = null;
					Object(this).onKeyDown = null;
					this = null;
				}
				else {
					Selection.setFocus(this);
				}
			}; // end onKillFocus
		
			r_txt.onKeyDown = function () {
				var key = Keyboard.getCode();
				var theTree = Object(this).owner;
				
				if (key == Keyboard.ENTER || key == Keyboard.TAB) {
					//trace("Enter or tab key pressed")
					var strLabel = Object(this).text;
					var validated = theTree.validateNodeLabel(strLabel, this);
					//trace("strLabel="+strLabel)
					//trace("validated="+validated)
					if (validated) {
						Keyboard.removeListener(this);
						theTree.isRenaming = false;
						theTree.setNodeLabel(Object(this).selectedNode, strLabel);
						// we do not have to dispatch here because we dispatch on kill focus
						Object(this).visible = false;
						theTree.refresh();
						theTree.setHorizontalScroll();
						Object(this).onKillFocus = null;
						Object(this).onKeyDown = null;
						this = null;
					}
				}
				if (key == Keyboard.ESCAPE) {
					Keyboard.removeListener(this);
					theTree.isRenaming = false;
					Object(this).text = Object(this).orgText;
					Object(this).visible = false;
					Object(this).onKillFocus = null;
					Object(this).onKeyDown = null;
					this = null;
				}
			}; // end onKeyDown
			
			Keyboard.addListener(r_txt);
			
			this.cancelRename = function() {
				//trace("\ncancelRename()")
				Keyboard.removeListener(r_txt);
				Object(this).isRenaming = false;
				r_txt.text = r_txt.orgText;
				r_txt.visible = false;
				r_txt.onKillFocus = null;
				r_txt.onKeyDown = null;
				r_txt = null;
			};
		}
	
		/** 
		Cancels a rename node operation
		@tiptext Cancels a rename node operation
		@description Cancels a rename node operation. No changes are saved. Mostly an internal method. 
		@returns Boolean - True if rename operation was in progress and closed. False if rename node was not in progress.
		@example The example cancels a rename operation when a user is process of renaming a node.
		<pre>
		theTree.cancelRename()
		</pre>
		*/
		public function cancelRename():void {
		}
	
		/** 
		Validates renamed node labels
		@tiptext Validates renamed node labels
		@description Allows the developer to validates values entered when a user renames a node. 
		@returns Boolean - True allows the node label to be renamed. False cancels the changes, enters the original value and highlights the text.
		@param newText:String - The node or nodes that will be inserted into the tree.
		@param renameTextField - The location by node of where to insert the source nodes. 
		@example The example below creates a user defined validation called when a user renames a node.
		<pre>
		theTree.validateNodeLabel = function(newText, renameTextField) {
			// check if new text user entered is blank. this is the default code of this function
			if (newText=="") {
				trace("label is blank!!! ahhh run away!!!");
				// restore original text
				renameTextField.text = renameTextField.orgText;
				// reselect text and cancel commit
				Selection.setSelection(0, renameTextField.length);
				return false;
			}
			else {
				// new text is not blank. allow rename
				return true;
			}
		}
		</pre>
		*/
		public function validateNodeLabel(newText:String, renameTextField:TextField):Boolean {
			// check if new text user entered is blank. this is the default code of this function
			if (newText=="") {
				// restore original text
				renameTextField.text = renameTextField.orgText;
				// reselect text and cancel commit
				Selection.setSelection(0, renameTextField.length);
				return false;
			}
			else {
				// new text is not blank. allow rename
				return true;
			}
		}
		
		/** 
		A method to call to set the node label
		@tiptext A method to call to set the node label
		@description A method to call to set the node label. If the labelFunction function is defined then you may need to modify this function. If the labelField property is defined then the labelText string is applied to that. If neither of these two properties are defined then the node.attributes.label is set to the labelText value. See also labelFunction, labelField, enableRenameNode features.	
		@usage myInstance.setNodeLabel(theSourceNode, labelText);
		@returns String. A string of the new label text.
		@param theNode - The node that is being renamed. 
		@param labelText - Optional. The new text for the label. Only optional if the labelFunction is defined.
		@example The example below sets the text of the node to "My new label".
		<pre>
		theTree.setNodeLabel(theTree.selectedNode, labelText)
		</pre>
		<pre>
		// setNodeLabel function defined
		public function setNodeLabel (theNode:XMLNode, labelText:String):String {
			var nodeLabel:String;
			
			// if a label function exists then set the text to display
			if (labelField != undefined) {
				// if an label field exists then set the label for that
				theNode.attributes[labelField] = labelText;
				nodeLabel = labelText;
			}
			else {
				// labelField is not set
				theNode.attributes.label = labelText;
				nodeLabel = labelText;
			}
			return nodeLabel;
		}
		</pre>
		*/
		public function setNodeLabel (theNode:XMLNode, labelText:String):String {
			var nodeLabel:String;
			
			// if a label function exists then set the text to display
			if (labelField != undefined) {
				// if an label field exists then set the label for that
				theNode.attributes[labelField] = labelText;
				nodeLabel = labelText;
			}
			else {
				// labelField is not set
				theNode.attributes.label = labelText;
				nodeLabel = labelText;
			}
			return nodeLabel;
		}
	
		/**
		* @exclude
		* Adds listeners to dragging movieclip
		*/
		protected function addDNDEventsListener()	:void{
			var crossdndWidgetList:DndUIWidgets = DndUIWidgets.getWidgetList ();		
			
			// START :: wiring events
			drag_mc.addEventListener ("onDraggerMove", this);
			drag_mc.addEventListener ("onDraggerDrop", this);
			
			if (this.trashCan != undefined) {
				drag_mc.addEventListener ("onDraggerMove", this.trashCan);
				drag_mc.addEventListener ("onDraggerDrop", this.trashCan);
			}
			
			for (var i = 0; i < crossdndWidgetList.length; i++)	{
				
				drag_mc.addEventListener ("onDraggerMove", crossdndWidgetList.getItemAt(i));				
				drag_mc.addEventListener ("onDraggerDrop", crossdndWidgetList.getItemAt(i));
				
				// assign drag_mc instance to the every cross drag and drop widgets enabled 
				crossdndWidgetList.getItemAt(i).drag_mc  = drag_mc;
				
				if (_global.dndCrossUIWidgets[i].trashCan != undefined) {
					drag_mc.addEventListener ("onDraggerMove", crossdndWidgetList.getItemAt(i).trashCan);
					drag_mc.addEventListener ("onDraggerDrop", crossdndWidgetList.getItemAt(i).trashCan);
				}
			}
			
			// END :: wiring events
		}
		
		/**
		* @exclude
		* Removes event listeners from dragging movieclip on mouseup - called in dndDraggerNode
		* 
		*/
		protected function removeDNDEventsListener():void {
			var crossdndWidgetList:DndUIWidgets = DndUIWidgets.getWidgetList ();
			
			drag_mc.removeEventListener ("onDraggerMove", this);
			drag_mc.removeEventListener ("onDraggerDrop", this);
			
			if (this.trashCan != undefined) {				
				drag_mc.removeEventListener ("onDraggerMove", this.trashCan);
				drag_mc.removeEventListener ("onDraggerDrop", this.trashCan);
			}
			
			for (var i = 0; i < crossdndWidgetList.length; i++)	{
				drag_mc.removeEventListener ("onDraggerMove", crossdndWidgetList.getItemAt(i));				
				drag_mc.removeEventListener ("onDraggerDrop", crossdndWidgetList.getItemAt(i));
			}
		}
		
		
		// checks whether we are over any of dndWidget while dragging
		protected function globalHitTest():Boolean {
			var isHitTest:Boolean = false;
			var crossdndWidgetList:DndUIWidgets = DndUIWidgets.getWidgetList ();		
			
			//if dndWidget is not enabled in cross-dragging, return always TRUE
			if (!enableCrossDrag) {
			   return true;	
			}
			
			for (var i = 0; i < crossdndWidgetList.length; i++) {					
				if (crossdndWidgetList.getItemAt(i).hitTest(_root.mouseX, _root.mouseY))				{
					isHitTest = true;
					break;
				}
			}
			return isHitTest;
		}
		
		// row roll over listener
		public function onRowRollOver(rowIndex : Number) : void  {		
			super.onRowRollOver(rowIndex);
			
			// lastOver property operates with absolute row index
			var absRowIndex:Number =  rowIndex + this.vPosition; 
			
			lastOver  = absRowIndex;					
		}
		
		// row roll out listener
		public function onRowRollOut(rowIndex : Number) : void {								
			super.onRowRollOut(rowIndex);
			trace("onRowRollOut");
			drag_mc.isDragging  = true;		
			drag_mc.beginDrag(this, drag_mc);
			//dispatchEvent({type:"onRowDrag", target:this, rowIndex:rowIndex, drag_mc:drag_mc});
			// required to delete dndTree's handler for onMouseUp event in this case
			// this handler messed up the selection of tree nodes pasted
			delete this.onMouseUp;
			delete this.ondndTreeMouseButtonReleased;
			
		}
	
		// overrides the onRowDragOver event of ScrollSelectList class
		public function onRowDragOver(rowIndex : Number) : void {
			var curTime = getTimer();
			var timeSinceLastScroll = curTime - lastScrollDragTime;
			//var timeToScroll:Boolean = (curTime - lastScrollDragTime > scrollDragSpeed);
			var timeToScroll:Boolean = true;
			
			if (drag_mc.isDragging!=true) {
				drag_mc.isDragging = true;
				drag_mc.beginDrag(this, drag_mc);
			}
			
			// required to delete dndTree's handler for onMouseUp event in this case
			// this handler messed up the selection of tree nodes pasted
			delete this.onMouseUp;
			delete this.ondndTreeMouseButtonReleased;
			
			// scrollV the list when we are at the top or the bottom of the list 
			// and it's time to scrollV (match desired scrollV speed)
			if (rowIndex == (this.rowCount-1) && timeToScroll) {
				//trace("Scrolling down...")                        
				if (delayedNextRowScrollID==undefined)
				{
					delayedNextRowScrollID = setInterval(this, "delayedNextRowScroll", scrollDragSpeed, true);
				}        
				//this.vPosition +=1;
				//lastScrollDragTime = curTime;
			}
			else
			if (rowIndex == 0 && timeToScroll) {
				//trace("Scrolling up...")                        
				if (delayedNextRowScrollID==undefined)
				{
					delayedNextRowScrollID = setInterval(this, "delayedNextRowScroll", scrollDragSpeed, false);
					lastScrollDragTime = curTime;
				}
				//this.vPosition -=1;
				//lastScrollDragTime = curTime;
			}
		}
		
		//delayed tree scrolling rows execution
		protected function delayedNextRowScroll(directionDown:Boolean) : void {
			if (directionDown) {
				this.vPosition +=1;
			}
			else {
				this.vPosition -=1;
			}
			
			// set targetNode to a tree row in vPosition location
			targetNode = getItemAt(this.vPosition);
			Object(targetNode).itemIndex = this.vPosition;
	        
			clearInterval(delayedNextRowScrollID);
			delete delayedNextRowScrollID;
		}
		
		// check for doubleclick event
		protected function isDoubleClick(currentRowIndex:Number):Boolean {
			var nowClickTime = getTimer();		
			
			var dClick:Boolean = ((nowClickTime- this.lastDoubleClickTime < 350) && (this.startDblClickRowID == currentRowIndex));
			
			this.lastDoubleClickTime = nowClickTime;
		
			this.startDblClickRowID = currentRowIndex;
			
			return dClick;
		}
		
		// check for delayed click event
		protected function isDelayedClick(currentRowIndex:Number):Boolean {
	
			var nowClickTime = getTimer();
			var dClick:Boolean = false;
			
			dClick = ((nowClickTime- this.lastDelayedClickTime > 350) && (this.startDelayedClickRowID == currentRowIndex));
			
			this.lastDelayedClickTime   = nowClickTime;
			this.startDelayedClickRowID = currentRowIndex;
			
			return dClick;
		}
		
		/**
		* Find root movieclip
		* @description Find root movieclip. Used when the dndTree has been loaded into another swf. 
		*/
		public function getRoot(mc:MovieClip):MovieClip {
			var rootReference:MovieClip;
			rootReference = mc;
	
			// we let user define root it 
			if (root_mc !=undefined) {
				
				return root_mc;
			}
			
			// find root
			while (rootReference.parent !=undefined)	{
				rootReference = rootReference.parent;
			}
			
			// return reference to root movieclip
			return rootReference;
		}
	
	
		/**
		* Removes items from the clipboard
		* @description Removes items from the clipboard. Mostly internal method.  
		*/
		public function removeClipboardItems():void {
	
			// graphics.clear the copy list items array
			var len = theCopyItems.length;
			//trace(" thecopyitems.length="+len)
			for (var i=0; i < len; i++) {
				theCopyItems.pop();	
			}
			
			// graphics.clear the copy list items array
			len = theCopyGridItems.length;
			for (var i=0; i < len; i++) {
				theCopyGridItems.pop();
			}
			
			// graphics.clear the copy nodes array
			len = theCopyNodes.length;
			for (var i=0; i < len; i++) {
				theCopyNodes.pop();	
			}
		
		}
		
		// trace output if showDebug is true
		public function traced(strMessage:String):void {
			if (showDebug || showDebug=="true") { 
				trace(strMessage);
			}
		}
		
		// adds an error 
		public function addError(strFunction:String, strMessage:String) :void{
			if (trackDebug || trackDebug=="true") {
				errorMsg += strFunction + "\n " + strMessage;
			}
			if (showDebug || showDebug=="true") {
				strMessage = strFunction + "\n " + strMessage;
				trace(strMessage);
			}
		}
		
		/**
		* Shows or hides horizontal scrollV bars if they are needed for the current set of visible rows
		* @description Shows or hides horizontal scrollV bars if they are needed for the current set of visible rows. This method is made available for you to manually check for and enable or disable horizontal scrollV bars. The enableAutoHorizontalScrollPolicy must be set to true for this function to be effective. This function uses doLater to call setHorizontalScrollLater on the next frame. The reason for this is to get rid of scrollbar artifacts that sometimes exist when you run this method immeadiately. This and the changes made to the scrollview class gets rid of scrollbar artifacts 99% of the time but they have still shown up from time to time. The fixes we did on this were in the mx.core.scrollview classes. If this becomes an issue you can turn on the scrollbar permanently or you can request the modified scrollview class.
		*/
		public function setHorizontalScroll():void {
			doLater(this, "setHorizontalScrollLater");
		}
		
		// displays scrollV bars if the tree needs it. this runs on the next frame after setHorizontalScroll is called
		public function setHorizontalScrollLater():void {
			
			// CHECK IF WE NEED TO ENABLE HORIZONTAL SCROLLBAR
			if (!enableAutoHorizontalScrollPolicy) {
				return;
			}
			
	        var maxWidth:Number = 0;
			var vScrollPolicyBackup:String;
	
	        // iterate through the un-collapsed items in the tree to determine
	        // the maximum width of the cells
	        for (var i:Number = 0; i < this.length; i++) {
				var cellWidth:Number = rows[i].cell.getPreferredWidth();
	
				// if a tree item is opened but is scrolled out of view,
				// its width comes back undefined
				if (cellWidth != undefined) {
					// The offset accounts for the indent of child tree items...
					var offset:Number = rows[i].cell.x;
					// add in disclosure width
					offset += rows[i].nodeIcon.width;
					//offset += rows[0].disclosure.x;
					cellWidth += offset;
					
					// Update the maximum width...
					maxWidth = Math.max(maxWidth, cellWidth);
				}
				
				//trace("tree item " + i + "'s width = " + cell_width + ", (x,y) = " +
				//this.rows[i].cell.x + ", " + this.rows[i].cell.y);
			}
			//trace("max cell width = " + max_width);
			//trace("tree instance width = " + the_tree.width);
	
			// now that we have the max width of the un-collapsed tree items, we
			// need to calculate how much scrollbar is necessary (i.e., the value
			// to use in tree.maxHPosition)
			var scrollWidth:Number = Math.abs(Math.min(0, this.width - maxWidth));
	
			// set the maximum number of pixels to scrollV horizontally
			maxHPosition = scrollWidth;
	
			// Note: setting the hScrollPolicy from "on" to "off" causes the vertical ScrollBar 
			// to flicker (if it is not currently visible)
			// to see this you have to first make the vertical scrollbars show 
			// and then when they are off make the horizontal bars show or hide
			
			// if the widest tree item fits in the tree instance already, turn off the scrollV bar
			//trace("hScrollPolicy ="+ hScrollPolicy);
			hScrollPolicy = ((scrollWidth == 0) ? "off" : "on");
			//var out = ((scrollWidth == 0) ? "off" : "on")
			//trace("hScrollPolicy ="+ out);
			
			/*
			// if the widest tree item fits in the tree instance already, turn off the scrollV bar
			// check if we need to enable the horizontal scrollV bar
			if (scrollWidth != 0) {
				// yes. we do. going from OFF to ON
				// add scrollbars. are they already on?
				if (hScrollPolicy == "on") {
					// yes, scrollV bars are already on. do nothing. we have already resized in prev code by setting the maxHPosition
				}
				else {
					// no, we need to turn scrollV bars on
					//trace("going from OFF to ON")
					// my guess to fix this is to turn vScrollPolicy from auto to off
					
					// check if vertical scrollV bar is on by checking if max vertical position is greater than 0
					if (maxVPosition!=0) {
						// yes, vertical scrollV bar is on. we only need to turn on horizontal scrollV bars
						hScrollPolicy = "on";
					}
					else {
						// no vertical scrollV bars are not on. we need to prevent flickering
						vScrollPolicyBackup = vScrollPolicy;
						vScrollPolicy = "off";
						this['vSB'].visible = false;
						//var e = new Enumerator();
						//e.tracee(this)
						hScrollPolicy = "on";
						// trying to hide the vertical scrollV bar
						this['vSB'].visible = false;
						updateAfterEvent();
						vScrollPolicy = vScrollPolicyBackup;
						// THE vSB (vertical scrollV bar) is getting created when we turn on the hScrollPolicy. WTF???
						//trace(" vSB="+this['vSB']);
						//trace(" hSB="+this['hSB']);
						//e.tracee(this)
					}
				}
			}
			else {
				// going from ON to OFF
				//trace("going from ON to OFF")
				// scrollWidth is 0. That means we do not need to add scrollV bars
				// check if vertical scrollV bar is on by checking if max vertical position is greater than 0
				if (maxVPosition!=0) {
					// yes, vertical scrollV bar is on. we only need to turn off horizontal scrollV bars
					hScrollPolicy = "off";
				}
				else {
					// no, vertical scrollV bars are not on. we need to prevent flickering
					vScrollPolicyBackup = vScrollPolicy;
					vScrollPolicy = "off";
					this['vSB'].visible = false;
					updateAfterEvent();
					hScrollPolicy = "off";
					vScrollPolicy = vScrollPolicyBackup;
				}
			}
			*/
			
	    }
	
		// don't know what is in this code but it breaks any javadoc comments after it in as2doc
		// on row press
		protected function onRowPress(rowIndex:Number):Boolean {
			
			// flag to check if ctrl is pressed
			// ctrl triggers the onRowPress while dragging causing all sorts of weird behavior
			var isCtrlPressed = false;
			var isMovieclip = false;
			var root_mc:MovieClip = getRoot(this);
			
			// drag_mc is undefined if it comes from an external source
			if (drag_mc==undefined) {
				if (root_mc.drag_mc!=undefined && root_mc.drag_mc.isMovieClip) {
					isMovieclip = root_mc.drag_mc.isMovieclip;
				}
			}
			else {
				isCtrlPressed = drag_mc.isCtrlButtonPressed;
			}
			
			
			// ctrl triggers the onRowPress while dragging causing all sorts of weird behavior
			if (isCtrlPressed || isMovieclip) {
				return false;
			}
			
			// ID count number of currently selected row we use absolute indexing here by the help of property 'vPosition'
			var absRowIndex:Number = rowIndex + this.vPosition;
			// fixes right click on lastOver position when first click is row press (not right click)
			lastOver = absRowIndex;
			
			// check if the nodes are being dragged
			//if (!isDragging || isDragging==undefined) {
			if (true) {
				// check for multiple nodes are selected
				if (selectedIndices.length > 1) {
					// check if clicking on a node that is already selected
					if (isRowClickedAlreadySelected(absRowIndex)) {
						// Handle Mouse Button release
						this.onMouseUp = ondndTreeMouseButtonReleased;
					}
					else {
						// call original tree onRowPress method
						super.onRowPress(rowIndex);	
						// dispatch singleClick event for row
						dispatchEvent({type:"singleClick", target:this, rowIndex:rowIndex, absRowIndex:absRowIndex});				
					}
				}
				else {
					// call original tree onRowPress method
					super.onRowPress(rowIndex);
					// dispatch singleClick event for row
					dispatchEvent({type:"singleClick", target:this, rowIndex:rowIndex, absRowIndex:absRowIndex});	
				}
			}
			else {
				onRowRollOver(rowIndex);
			}
			
			// check if row is already selected
			if (isRowClickedAlreadySelected(absRowIndex)) {
				// check for doubleclick event
				if (isDoubleClick(absRowIndex)) {
					// TODO: Test this next line. may cause problems
					// call original onRowPress method so we have access to the selected node property
					//super.onRowPress(rowIndex);
					//trace("absRowIndex="+absRowIndex)
					//selectedIndex = absRowIndex;
					var bOneSelected = (selectedIndices.length < 2);
					var bPermit = permitRename(selectedNode);
	
					// allow user to rename item label
					if ((enableRenameNode) && (selectedIndices.length < 2)) {
						// TODO: DATAGRID ITEM
						if (renameOnDoubleClick) {
							var bPermitRename = permitRename(selectedNode);
							
							if (bPermitRename) {
								renameFunction(rowIndex, METHOD_CALL);
							}
						}
					}
	
					// dispatch doubleClick event for row
					dispatchEvent({type:"doubleClick", target:this, rowIndex:rowIndex, absRowIndex:absRowIndex});
					return true;
				}
				else {
					// check for delayed click event
					if (isDelayedClick(absRowIndex)) {
						// TODO: Test this next line. may cause problems
						// call original tree onRowPress method so we have access to the selected node property
						//super.onRowPress(rowIndex);
					
						// if allowed and selectedIndeces is lower than 2
						dispatchEvent({type:"delayedClick", target:this, rowIndex:rowIndex, absRowIndex:absRowIndex});
					}
				}
			}
			
			// flag to check if we are dragging
			var isDragging 	= drag_mc.isDragging;
			// flag to only draw generic icon once
			var iconDrawn = false;
			
			// check if drag and drop is enabled - exit if not
			if (!dndEnabled) {
				return false;
			}
			
			// check if row clicked is already selected
			if (isRowClickedAlreadySelected(absRowIndex)) {
				// we are not dragging so start dragging code
				if (isDragging==undefined) {
					var indices = selectedIndices;
					// the order of items is out of wack. reorder by position
					indices.sort(sortByNumber);
					selectedIndices = indices;
	
					// get selected nodes
					var node = selectedNode;
					var nodes:Object = selectedNodes;
					var nodeLength = nodes.length;
					lastSelectedSources = selectedNodes;
					
					// attach "ghost" node glued to mouse pointer
					// this movieclip inherits the dndDraggerNode class
					//this.drag_mc = _root.attachMovie("dndNodeDragger", "drag_mc", this.getNextHighestDepth());
					//var d_mc = root_mc.attachMovie("dndNodeDragger", "drag_mc", DepthManager.kTop++);
					var d_mc = root_mc.attachMovie("dndNodeDragger", "drag_mc", root_mc.getNextHighestDepth());
					// we cannot attach to the root if we are in one swf loaded in by another movie using loadMovie()
					if (d_mc==undefined) {
						//trace("d_mc==undefined")
						d_mc = this.attachMovie("dndNodeDragger", "drag_mc", root_mc.getNextHighestDepth());
					}
					drag_mc = d_mc;
					// indicates if we drag on specified pixel movement or on roll out of row
					drag_mc.dragOnRollOut = dragOnRollOut;
					// drag after a specified amount of pixel movement - see draggernode class
					drag_mc.movementBeforeDrag = movementBeforeDrag;
					
					// indicates multiple selecions
					drag_mc.multipleSelections = multipleSelection;
					// indicates row index of visible rows
					drag_mc.rowIndex = rowIndex;
					// indicates absolute row index of all rows (visible and invisible)
					drag_mc.absRowIndex = absRowIndex;
					// selected index 
					drag_mc.selectedIndex = selectedIndex;
					// selected indices
					drag_mc.selectedIndices = indices;
					// reference to the list
					drag_mc.owner = this;
					// read only means copy and not move
					drag_mc.dndReadOnly = dndReadOnly;
					
					// drag_mc listens to all dnd widgets
					addDNDEventsListener();
					
					// create array of multiple selected nodes 
					for (var i=0; i<nodeLength; i++) {
						var theNode = nodes[i];
						// stores node properties and values in the node object (node type, is node open)
						theNode.bIsNodeBranch = getIsBranch(theNode);
						theNode.bIsNodeOpen = getIsOpen(theNode);
						theNode.bIsParentNodeBranch = getIsBranch(theNode.parentNode);
						theNode.bPreserveBranches = preserveBranches;
						theNode.owner = this;
						theNode.indices = indices;
						theNode.itemIndex = indices[i];
						theNode.readOnly = dndReadOnly;
						theNode.itemType= "node";
						theNode._self = theNode;
						theNode.removeTreeNode = nodes[i].removeTreeNode;
						
						// we use this now to remove remote nodes
						theNode.removeMe = function(index:Number) {
							// this refers to the current node
							var curNode = nodes[index];
							var theTree = curNode.owner;
							var theSourceParentNode = curNode.parentNode;
							//trace("running removeMe on " + curNode.attributes.label)
							//trace(" theTree="+theTree);
							//trace(" curNode="+curNode);
							//trace(" curNode.bIsParentNodeBranch="+curNode.bIsParentNodeBranch);
							// check if we need preserve the parent node as a branch when the last child node is removed 
							if (curNode.bIsParentNodeBranch && curNode.bPreserveBranches) {
								theTree.setIsBranch(theSourceParentNode, true);
							}
							else {
								// check if we are deleting the last child node
								if (theSourceParentNode.childNodes.length == 1) {						
									theTree.setIsOpen(theSourceParentNode, false);
									theTree.setIsBranch(theSourceParentNode, false);
								}
								delete theSourceParentNode.bIsNodeBranch;
								delete theSourceParentNode.bIsNodeOpen;
							}
							//trace(" curNode.removeTreeNode="+curNode.removeTreeNode);
							//trace(" theTree.setHorizontalScroll="+theTree.setHorizontalScroll);
							curNode.removeTreeNode();
							// doesnt always 
							theTree.setHorizontalScroll();
						};
						
						// sets the current y position of the drag highlight
						var curY = (i==0) ? 0 : (__rowHeight * i) + (i * 2);
	
						// creates an exact duplicate of the selected rows - yeha! one of the best features i got working
						// we have this if condition for backwards compatibility
						if (dragDuplicateRow) {
							var movieName:String = String("row_mc"+i);
							var row_mc = drag_mc.createObject(__rowRenderer, movieName, drag_mc.getNextHighestDepth(), {owner:this, styleName:this, width:width, height:__rowHeight});
							//trace("depth ="+row_mc.getDepth());
							row_mc.rowIndex = rowIndex;
							row_mc.setSize(width, __rowHeight);
							//row_mc.size();
							row_mc.drawRow(theNode, dragRowStyle);
							row_mc.y = curY;
							row_mc.alpha = dragHighlightAlpha;
							row_mc.disclosure.visible = false;
							// do not remove this next line. removing this line causes drag scrolling to stop working
							row_mc.bG_mc.visible = false;
						}
						else {
							// reset the nodeIconWidth
							var nodeIconWidth = 0;
							
							// add icon to drag mc
							if (enableDragIcon) {
								// check if we are getting a generic icon
								if (enableGenericIcon) {
									if (iconDrawn==false) {
										// This works!!! The problem was the gif and png. I had to test the bitmap. 
										// when I did I saw the same distortion as before. So I changed it to jpeg and now it works.
										var nodeIcon_mc = drag_mc.attachMovie(strGenericIcon, "nodeIcon" + i, i + 10);
										nodeIcon_mc.visible = true;
										nodeIcon_mc.x = 2;
										nodeIcon_mc.y = 8; 
										nodeIconWidth = nodeIcon_mc.width;
										iconDrawn = true;
									}
								}
								else {
									// we are not using the generic icon
									var iconName = getNodeIcon(theNode, "spacer_mc");
	
									var nodeIcon_mc = drag_mc.attachMovie(iconName, "nodeIcon" + i, i + 10);
									nodeIcon_mc.visible = true;
									nodeIcon_mc.x = 2;
									nodeIcon_mc.y = curY+2;
									nodeIconWidth = nodeIcon_mc.width;
								}
							}
							
							// set width indentation for label
							if (nodeIconWidth==undefined || nodeIconWidth < 1) {
								nodeIconWidth = 5;
							}
							
							var curW = width + nodeIconWidth - 15;
							// create background highlight
							if (enableDragHighlight) {
								var bg_mc = drag_mc.createEmptyMovieClip("bg_mc"+ i, i + 5);
								//this.createEmptyMovieClip("logo_mc", this.getNextHighestDepth());
								//trace("dragHighlightColor="+dragHighlightColor)
								//trace("dragHighlightColor.toString(16)="+dragHighlightColor.toString(16))
								//var color_str = "0x"+getStyle("selectionColor").toString(16);
								var color_str = "0x"+dragHighlightColor.toString(16);
								bg_mc.graphics.beginFill(color_str,dragHighlightAlpha);
								bg_mc.graphics.moveTo(0,curY);
								bg_mc.graphics.lineTo(curW, curY);
								bg_mc.graphics.lineTo(curW, curY + __rowHeight);
								bg_mc.graphics.lineTo(0, curY + __rowHeight);
								bg_mc.graphics.lineTo(0, curY);
								bg_mc.graphics.endFill();
							}
							
							// get node label
							var nodeLabel = getNodeLabel(theNode);
							
							// create label
							if (nodeLabel!=undefined && enableDisplayLabel) {
								if (nodeIconWidth==undefined || nodeIconWidth < 1) {
									nodeIconWidth = drag_mc.noDropIcon.width;
								}
								// attach label to drag mc
								var label_mc = drag_mc.attachMovie("Label", "label_mc" + i, i + 100, {styleName:this, text: nodeLabel});
								drag_mc.origName = nodeLabel;
								label_mc.x = nodeIconWidth + 2;
								label_mc.y = curY+2;
								label_mc.width = 200;
								label_mc.color = "0x" + getStyle("textSelectedColor").toString(16);
							}
						}
					}
					
					// icon to show when you cannot drop
					//drag_mc.noDropIcon = drag_mc.attachMovie(strNoDropIcon, "noDropIcon", 10100, {x:this.mouseX-5, y:this.mouseY-5});
					//drag_mc.noDropIcon = _root.attachMovie(strNoDropIcon, "noDropIcon", _root.getNextHighestDepth());
					drag_mc.noDropIcon = root_mc.attachMovie(strNoDropIcon, "noDropIcon", root_mc.getNextHighestDepth());
					drag_mc.noDropIcon.x = this.mouseX-5;
					drag_mc.noDropIcon.y = this.mouseY-5;
					drag_mc.noDropIcon.visible = false;
					
					// add nodes to drag mc
					drag_mc.node = node;
					drag_mc.nodes = nodes;
					
					// we reverse the array because the drag mcs will be upside down
					drag_mc.nodes.reverse();
					
					// we create list items so we can drop on dnd lists
					// user can use the user defined convertToItem method to create their own list items
					drag_mc.item  = convertTo("item", node, false);
					drag_mc.items = convertTo("item", nodes, true);
					
					// we create datagrid items so we can drop on dndDataGrid
					// user can use the user defined convertToGridItem method to create their own list items
					drag_mc.gridItem  = convertTo("gridItem", node, false);
					drag_mc.gridItems = convertTo("gridItem", nodes, true);
					
					// add copy icon to drag mc
					drag_mc.attachMovie(strCopyIcon, "copyIcon", root_mc.getNextHighestDepth());
					
					// hide copy icon unless user holds down ctrl
					if (dndReadOnly) {
						drag_mc.copyIcon.visible = true;
					}
					else {
						drag_mc.copyIcon.visible = false;
					}
					
					// set the copy icon location
					drag_mc.copyIcon.x = copyIconX;
					drag_mc.copyIcon.y = copyIconY;
					
					// get mouse position
					objPoint.x = root_mc.mouseX;
					objPoint.y = root_mc.mouseY;
					
					var theRow = rows[rowIndex];
					
					// convert mouse position over stage to mouse position over row
					theRow.globalToLocal(objPoint);
					
					if (enableDragHighlight) {
						// store for later use
						drag_mc.xOffset = (0 - objPoint.x);
						drag_mc.yOffset = (0 - __rowHeight/2);
						// set the position of the drag_mc relative to the drag position
						drag_mc.SHIFT_ICON_DRAG_XPOSITION = drag_mc.xOffset;
						drag_mc.SHIFT_ICON_DRAG_YPOSITION = drag_mc.yOffset;
						// set the copy icon location
						drag_mc.copyIcon.x = copyIconX + Math.abs(drag_mc.xOffset);
						drag_mc.copyIcon.y = copyIconY + Math.abs(drag_mc.yOffset);
					}
					else if (enableDragIcon) {
						// store for later use
						drag_mc.xOffset = (0 - theRow.icon_mc.width/2 -2);
						drag_mc.yOffset = (0 - theRow.icon_mc.height/2 -2);
						// set the position of the drag_mc relative to the drag position
						drag_mc.SHIFT_ICON_DRAG_XPOSITION = drag_mc.xOffset;
						drag_mc.SHIFT_ICON_DRAG_YPOSITION = drag_mc.yOffset;
						// set the copy icon location
						drag_mc.copyIcon.x = copyIconX + Math.abs(drag_mc.xOffset)+2;
						drag_mc.copyIcon.y = copyIconY + Math.abs(drag_mc.yOffset)+2;
					}
					
					// set row index for later use
					this.startDragRowID = rowIndex;
					
					// let the user make changes to the drag_mc before we start dragging
					modifyDragMC(drag_mc);
					
					// Drag and Drop Sequence
					// 2. Start to drag the mc that contains our graphics and node information
					// Steps 3-6 are in dndNodeDragger class in beginDrag method
					//drag_mc.beginDrag(this, drag_mc);
				}
			}
			
			// ID of currently selected row. we use absolute indexing here by the help of property 'vPosition'
			this.selectedRowID = rowIndex + this.vPosition;
	
		}
	
	}
}