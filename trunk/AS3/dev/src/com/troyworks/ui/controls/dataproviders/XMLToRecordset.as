package com.troyworks.ui.controls.dataproviders { 
	/**
	* XMLDocument to Recordset class
	* @description This class is used to convert a xml tree node into a recordset
	* @author Judah Frangipane
	*/
	
	import flash.xml.XMLDocument;
	public class XMLToRecordset {
		
		/**
		A user customizable function to convert a xml node into a row item
		@description A user customizable function to convert a xml node into a row item
		@param Object - The xml node that will be converted into a row item
		@param String - Field in the database that should be used as the labelField as defined in the grid or list
		@param Boolean - Takes field in the database defined as the labelField and copies that value into the "label" property. Default value is false. Optional
		*/
		public static function convertToItem(theNode:Object, labelField:String, createLabelField:Boolean):Object {
			// create new item from xml node
			var newItem:Object = new Object();
			var label:String;
			
			// NOTE: This may copy references from the node. 
			// add any other properties 
			for (var prop in theNode.attributes) {
				//if (prop != "__ID__") {
					newItem[prop] = theNode.attributes[prop];
				//}
				// if there is no corresponding field in the database with the name "label" allow user to assign it here
				if (createLabelField) {
					newItem["label"] = theNode.attributes[labelField];
				}
			}
			return newItem;
		}
		
		/**
		Parses an xml dom into a recordset
		@description Parses an xml dom into a recordset
		@usage listComponent.dataProvider = XMLToRecordset.parse(xmlDB.firstChild, "label", true);
		@param Object - This is usually the parent node of the child nodes you want to use
		@param String - Field in the database that should be used as the labelField as defined in the tree
		@param Boolean - Takes field in the database defined as the labelField and copies that value into the "label" attribute. Default value is false. Optional
		@example This code parses a xml object and places it into a grid
		<pre>
		import XMLToRecordset;
		
		//::Define XMLDocument object to load the external data
		xmlDB = new XMLDocument();
		xmlDB.ignoreWhite = true;
		
		// load data
		xmlDB.load("testdata.xml");
		
		xmlDB.onLoad = function() {
			// pass in the firstchild node of the xml object to the XMLToRecordset transmogrification class
			theDataGrid.dataProvider = XMLToRecordset.parse(xmlDB.firstChild, "label", true);
		}
		</pre>
		@return Object - Returns an recordset ready to assign to a list or datagrid dataprovider
		*/
		public static function parse(xmlObject:Object, labelField:String, createLabelField:Boolean):Array {
			var xmlObjectLength:Number = xmlObject.childNodes.length;
			var newRecordset:Array = new Array();
			var currentNode:Object = new Object();
			var currentRow:Object = new Object();
			
			// loop through recordset and add rows
			for (var i=0;i<xmlObjectLength;i++) {
				// get reference to current record
				currentNode = xmlObject.childNodes[i];
				// convert to row object and add to recordset array
				currentRow = convertToItem(currentNode, labelField, createLabelField);
				newRecordset.push(currentRow);
			}
			
			return newRecordset;
		}
	}
}