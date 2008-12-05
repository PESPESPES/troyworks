package com.troyworks.ui.controls.dataproviders { 
	/**
	* Recordset to XMLDocument tree class
	* @description This class is used to convert a recordset into an xml tree
	* @author Judah Frangipane
	* @usage RecordsetToXML.parse()
	* @example This example takes a recordset from Flash remoting and organizes it into a xml tree structure for the Tree component. You can also use it to take a List or DataGrid component and convert it into an xml list. If you want to output a different xml structure then modify the convertToNode function. You can change the node name and root node name in the xml by changing the associated nodeName and rootNodeName properties. See the parse function for more documentation.
	* <pre>
		// A item in this recordset have these properties
		//    Label:String = "Cameras"
		//    ParentID:Number = 2
		//    Order:Number = 1
		//    ID:Number = 1
		
		import com.judah.controls.dataproviders.RecordsetToXML;
		// setup services...
		myService.getCatalogs();
		
		// service calls successful results function
		function getCatalogs_Result(result){
			// create custom root node 
			var myTreeRoot = new XMLDocument();
			myTreeRoot.addTreeNode("Product Catalog", 0);
			myTreeRoot = myTreeRoot.firstChild;
			myTree.dataProvider = RecordsetToXML.parse(result.items,"ID","ParentID","Label", myTreeRoot, true, true);
			// you could pass in 0 in the "ParentID" field if the recordset does not have a parent id
			//myTree.dataProvider = RecordsetToXML.parse(result.items,"ID",0,"Label", myTreeRoot, true, true);
			// if you want to output a different xml structure then modify the convertToNode function
		}
		</pre>
	import flash.media.Camera;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	*/
	public class RecordsetToXML {
		/**
		A user customizable node name
		@description A user customizable node name. By default each node name is "node".
		*/
		public static var nodeName:String = "node";
		/**
		A user customizable root node name
		@description A user customizable root node name. By default the root node name is "nodes".
		*/
		public static var rootNodeName:String = "nodes";
	  
		/**
		A user customizable function to convert the row item into a node
		@description A user customizable function to convert the row item into a node
		@param Object - The row item that will be converted into a node
		@param Object - The node that will be created from the row item
		@param String - Field in the database or property in the item that should be used as the labelField as defined in the tree
		@param Boolean - Takes the value of the labelField defined in the item and copies that value into the "label" attribute. Default value is false. Optional
		*/
		public static function convertToNode(theItem:Object, newNode:Object, labelField:String, createLabelAttribute:Boolean) :Object{
			var attributes:Object = newNode.attributes;
			
			// add current row properties as attributes
			for(var property:String in theItem) {
				attributes[property] = theItem[property];
				// if there is no corresponding field in the database with the name "label" allow user to assign it here
				if (createLabelAttribute) {
					attributes["label"] = theItem[labelField];
				}
			}
			return newNode;
		}
		
		/**
		Parses the recordset into an xml dom
		@description Parses the recordset into an xml dom
		@usage myTree.dataProvider = RecordsetToXML.parse(recordset.items,"id field","parent id field","tree label field", xmlRootNode, bPlaceOnRoot, bCreateStandardTreeLabel);
		@param Object - Recordset or resultset items property usually from a remoting call
		@param String - Id field of the record. Corresponds directly with the parentIdField
		@param String - Id of the record that is the parent of this record. Zero or undefined if the record is on the root. Corresponds directly with the idField. Pass in undefined, 0 or a field that does not exist if there are no parent ids in your recordset.
		@param String - Field in the database that should be used as the labelField as defined in the tree
		@param String - Text or XMLNode object to be used for the root node. The placeOnRoot property must be false to see this node in the tree view. Optional
		@param Boolean - Defines if the records with no parent are directly on the root of the tree or if they are underneath a visible root node. Default value is false. Optional
		@param Boolean - Takes field in the database defined as the labelField and copies that value into the "label" attribute. Default value is false. Optional
		@example This code parses a recordset from a getCatalogs service call and places it into a tree.
		<pre>
		// A item in this recordset have these properties
		//    Label:String = "Cameras"
		//    ParentID:Number = 2
		//    Order:Number = 1
		//    ID:Number = 1
		
		// setup services...
		myService.getCatalogs();
		
		// service calls successful results function
		function getCatalogs_Result(result){
			// create custom root node 
			var myTreeRoot = new XMLDocument();
			myTreeRoot.addTreeNode("Product Catalog", 0);
			myTreeRoot = myTreeRoot.firstChild;
			myTree.dataProvider = RecordsetToXML.parse(result.items,"ID","ParentID","Label", myTreeRoot, true, true);
			// you could pass in 0 in the "ParentID" field if the recordset does not have a parent id
			//myTree.dataProvider = RecordsetToXML.parse(result.items,"ID",0,"Label", myTreeRoot, true, true);
			// if you want to output a different xml structure then modify the convertToNode function
		}
		</pre>
		@return Object - Returns an xml object ready to assign to the tree dataprovider
		*/
		public static function parse(recordset:Object, idField:String, parentIdField:String, labelField:String, theRootNode:Object, placeOnRoot:Boolean, createLabelAttribute:Boolean):XMLNode {
			//trace("parse")
			var xmlObject:XMLDocument = new XMLDocument();
			var parentNodesTable:Object = new Object();
			var recordsetLength:Number = recordset.length;
			var rootNode:XMLNode;
			var parentNode:XMLNode;
			var nodeToAdd:XMLNode;
			var currentRecord:Object;
			var property:String;
			var parentId:Number;
			
			// allow user to create root node
			if (typeof(theRootNode)=="object") {
				rootNode = theRootNode;
			}
			else {
				// create root node
				rootNode = xmlObject.createElement(rootNodeName);
				// if the user entered a name use it, if not use Root
				rootNode.attributes[labelField] = (theRootNode!=undefined) ? theRootNode : "Root";
				if (createLabelAttribute) {
					rootNode.attributes["label"] = rootNode.attributes[labelField];
				}
			}
			
			// loop through recordset and add rows
			for (var i=0;i<recordsetLength;i++) {
				// get reference to current record
				currentRecord = recordset.getItemAt(i);
				if (parentIdField==0 || parentIdField==undefined) {
					parentId = 0;
				}
				else {
					parentId = currentRecord[parentIdField];
				}
				nodeToAdd = xmlObject.createElement(nodeName);
				
				// convert record to node
				nodeToAdd = convertToNode(currentRecord, nodeToAdd, labelField, createLabelAttribute);
				
				// if parent id is 0 or undefined then put node on the root
				// check if parentId is defined - may need to customize this is parentId is not a Number type
				if (parentId==0 || parentId==undefined || parentId=="" || parentId==null) {
					parentNode = rootNode;
				}
				else {
					// get the parent id from the parentNodesTable
					parentNode = parentNodesTable[parentId];
				}
				
				// add row node to parentNode
				parentNode.appendChild(nodeToAdd);
				// add id value to parentNodesTable
				parentNodesTable[currentRecord[idField]] = nodeToAdd;
			}
			
			// do not create a root for the converted recordset - no root
			if (placeOnRoot) {
				return rootNode;
			}
			
			// add root nodes to parent xml object - this creates a root node as the parent of all the recordset nodes
			xmlObject.appendChild(rootNode);
			
			return xmlObject;
		}
	}
}