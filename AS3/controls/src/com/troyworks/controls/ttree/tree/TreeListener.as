package com.troyworks.controls.ttree.tree { 
	import mx.controls.TextArea;
	import mx.controls.Tree;
	import com.troyworks.framework.BaseObject;
	//import com.troyworks.ui.controls.DragAndDropTree;
	/**
	 * @author Troy Gardner
	 */
	import flash.utils.getTimer;
	import flash.display.MovieClip;
	import flash.xml.XMLNode;
	public class TreeListener extends BaseObject {
		//////////////////////////////////////////////////
		// set up tree listener
		
		// nodeOpen event handler
		public var canvas : MovieClip = null;
		public var clips : Array = new Array();
		public var openNodes:Object = new Object();
	
		protected var myTree1 : DragAndDropTree;

		protected var activeNode : Object;
	
		protected var myStatusArea : TextArea;
	
		protected var selectedNodeLabel : Object;
	
		protected var lastClick : Number;
	
		protected var activeObject : Object;
	
		public var treeDP : ITreeDataProvider;
		public static var Eventttt_SINGLE_CLICK : String Eventntntnt_SINGLE_CLICK";
		public statiEventententent_DOUBLE_CLICK : SEventventventvent_DOUBLE_CLICK";
	
		protected var open_next : XMLNode;
		
		/*****************************************************
		 *  Constructor
		 */
		public function TreeListener(aMyTree : DragAndDropTree, aStatusLog : TextArea) {
			super();
			REQUIRE(aMyTree != null, " TreeListener must have a valid Tree component");
			trace("TreeListener( " + aMyTree +")");
			myTree1 = aMyTree;
			myStatusArea = aStatusLog;
			canvas = MovieClip(myTree1);
			trace("TreeListener( " + aMyTree +") 2");
	
			// add the UI event listeners
			myTree1.addEventListener("nodeOpen", nodeOpen);
			myTree1.addEventListener("nodeClose", nodeClose);
			myTree1.addEventListener("change", change);
			myTree1.addEventListener("move", move);
			init();
		}
		public function setDataProvider(aTreeDP : ITreeDataProvider) : void{
			trace("cccccccccccccccccccccccccccccccccccccccccccccc");
			trace("cccccccccccccccccccccccccccccccccccccccccccccc");
			trace("cccccccccccc TreeListener.setDataProvider cccccccccccccccccccccccccccccccccc");
			trace("cccccccccccc " +aTreeDP + " cccccccccccccccccccccccccccccccccc");
			trace("cccccccccccccccccccccccccccccccccccccccccccccc");
			trace("cccccccccccccccccccccccccccccccccccccccccccccc");
			if(aTreeDP == null){
				var e : String = "*** ERROR *** TreeListener.setDataProvider cannot have a null dataprovider";
				trace(e);
				throw new Error(e);
			}
			treeDP = aTreeDP;
			trace("AAAAAAAAAAA adding event listeners ");
					// add the Model event listeners
			treeDP.addEveEventEventEventEvent_MODEL_CHANGED", this.onModelChanged);
			/*treeDP.addEventListener("updateTree", this);
			treeDP.addEventListener("addNode", this);
			treeDP.addEventListener("removeNode", this);
			treeDP.addEventListener("changed", this);
			treeDP.addEventListener("onModelChanged", this);*/
			trace("BBBBBBBB triggering model Changed ");
	
			this.onModelChanged();
		}
		public function init(fromNode : XMLNode) : void {
			var _ary : Array = myTree1.dataProvider.childNodes;
			var len : Number = _ary.length;
				while(len--){
				this.openNodes[_ary[len].attributes.label] = true;
					if(len ==0){
					this.activeNode = _ary[len];
					}
				}
			this.onModelChanged();
		}
		public function nodeOpen(evt : Object) : void {
			myStatusArea.text += "<li>"+evt.node.attributes.label+" opened.</li>";
			this.activeNode = evt.node;
			this.openNodes[evt.node.attributes.treeID] = true;
		};
		// nodeClose event handler
		public function nodeClose(evt : Object) : void {
			myStatusArea.text += "<li>"+evt.node.attributes.label+" <i>closed</i>.</li>";
			this.openNodes[evt.node.attributes.treeID] = false;
			this.activeNode = evt.node;
		};
		public function closeNode(node : XMLNode) : void{
			for (var a:String in node.childNodes) {
				if (myTree1.getIsOpen (node.childNodes[a])) {
					this.closeNode (node.childNodes[a]);
				}
			}
			myTree1.setIsOpen (node, false, false);
		};
		public function move(evt : Object) : void {
			myStatusArea.text += "<li>"+evt.node.attributes.label+" <i>move</i>.</li>";
			this.activeNode = evt.node;
			delete this.openNodes[evt.node.attributes.label];
		};
		public function onModelChanged() : void {
			trace("TreeListener.onModelChanged***********************");
			myTree1.dataProvider = treeDP.toXML();
			if(this.activeNode == null){
				trace("active Node null!");
				this.activeNode = myTree1.dataProvider.firstChild ;
				trace("active Node now: " + this.activeNode);
			}
			trace(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
		//	this.openSavedNodes();
		};
		/*public function getBookPresentation () {
			trace("getBookPresentation--- " );//+  this.activeNode);
			var node = this.activeNode;
			while (node != undefined) {
				trace("\ttop? "+node.attributes.ptype);
				if (node.attributes.ptype == "BookPresentation" || node.isTreeRoot || node.parentNode == undefined) {
					//node.dispatchEvent(eventObj);
					this.bookPres = node.attributes.objRef;
					return node.attributes.objRef;
				}
				node = node.parentNode;
			}
			return null;
		};*/
	
		public function openSavedNodes(fromNode : Object) : void {
	
			var cN = (fromNode == null) ? (myTree1.dataProvider.childNodes) : (fromNode.childNodes);
			//trace("openSavedNodes----"+cN.length);
			for (var i = 0; i<cN.length; i++) {
				var id = cN[i].attributes.treeID;
				var t1 = (this.openNodes[id] != undefined);
				var t2 = (this.activeNode.attributes.treeID == id);
				trace(" comparing cn: '"+id+"' to acrtive: '"+this.activeNode.attributes.label+"'"+" 1: "+t1+" 2: "+t2);
				if (t1 || t2) {
					myTree1.setIsOpen(cN[i], true, false);
				}
				if (cN[i].childNodes != null) {
					//trace("going deeper");
					this.openSavedNodes(cN[i]);
				} else {
					//trace("has no children");
				}
			}
		};
		public function getOpenSiblings(xmlN : XMLNode) : Array {
			var parent : XMLNode = xmlN.parentNode;
			trace("Clicked on "+ xmlN.attributes.label);
			var res : Array = new Array();
			for (var a : Number = 0; a < parent.childNodes.length; a++) {
				var n : XMLNode = parent.childNodes[a];
				trace("sibling ? " + n.attributes.label);
			if (n != xmlN && myTree1.getIsOpen (n)) {
					res.push(n);
			}
		}
			if(res.length > 0){
				return res;
			}else {
				return undefined;
			}
		};
			public function getOpenChildren(xmlN : XMLNode) : Array {
			trace("Clicked on "+ xmlN.attributes.label);
			var res : Array = new Array();
			for (var a : Number = 0; a < xmlN.childNodes.length; a++) {
				var n : XMLNode = xmlN.childNodes[a];
				trace("sibling ? " + n.attributes.label);
			if (n != xmlN && myTree1.getIsOpen (n)) {
					res.push(n);
			}
		}
			if(res.length > 0){
				return res;
			}else {
				return undefined;
			}
		};
		// change event handler
		public function change(evt : Object) : void {
	
			trace("000000000000000000000000000000000000000000000000000000");
			trace("000000000000000000000000000000000000000000000000000000");
			trace("000000000000000000000000000000000000000000000000000000");
			trace("00000000000000000000TreeListener.change0000000000000000000000000000000000");
			trace("000000000000000000000000000000000000000000000000000000");
			trace("000000000000000000000000000000000000000000000000000000");
			// the selected node
			var selectedNode : XMLNode = evt.target.selectedNode;
			// the label of the selected node
			var selectedNodeLabel : String = selectedNode.attributes.label;
			var selectedNodeType : String = selectedNode.attributes.ptype;
			this.selectedNodeLabel = selectedNodeLabel;
			if (evt.target.selectedNode == this.activeNode) {
				////////////// DOUBLE CLICK ////////////////////////
				var dur = getTimer()-this.lastClick;
				trace("double click? "+dur);
				if (dur<200) {
					trace("double clicked!!!!!!!? "+dur);
					myStatusArea.text += "<li>"+selectedNodeLabel+":"+selectedNodeType+" <b>double clicked</b>.</li>";
					this.activeObject.onDoubleClick();
					this.dispatchEvent (
					Event	EventyEvent Event_DOUBLE_CLICK, target : this, activeNode:activeNode, activeObject:activeObject
					});
				}else{
					this.activeObject.getSupportedOperations();
				}
				this.lastClick = getTimer();
			} else {
				////////////// SINGLE CLICK //////////////////////////
				this.lastClick = getTimer();
				this.activeNode = selectedNode;
				this.activeObject = selectedNode.attributes.objRef;
				this.activeObject.getSupportedOperations();
				// add a status message to the status message text area component
				myStatusArea.text += "<li>"+selectedNodeLabel+":"+selectedNodeType+" <b>selected</b>.</li>";
				this.dispatchEvent (
		Event
	Event	tEvent: Event_SINGLE_CLICK, target : this, activeNode:activeNode, activeObject:activeObject
					});
	
			}
			var is_open : Boolean = myTree1.getIsOpen (selectedNode);
			var is_branch : Boolean = myTree1.getIsBranch (selectedNode);
			var node_to_close : XMLNode =selectedNode;
			//var nodes_to_close : Array = getOpenChildren(selectedNode);
			// close the opened node first
			//for(var i:String in nodes_to_close){
				//var node_to_close : XMLNode = XMLNode(nodes_to_close[i]);
				trace("closing " + node_to_close.attributes.label);
				if (myTree1.getIsOpen (node_to_close) && myTree1.getIsBranch (node_to_close)) {
					myTree1.setIsOpen (node_to_close, false, true, true);
					this.open_next = selectedNode;
				} else {
					if (is_branch) {
						myTree1.setIsOpen (selectedNode, true, true, true);
					} else {
						myTree1.selectedNode = selectedNode;
						myTree1.dispatchEvent ({type:"click", target:evt.target});
					}
					this.open_next = undefined;
				}
			//}
		};
	
		
	}
}