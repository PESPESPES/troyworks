package com.troyworks.geom.d2 {
	import flash.events.EventDispatcher; 

	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	public class Line extends EventDispatcher {

		
		public var name:String = "";
		public var type:Number = 1;
		public var A:Number = 0;
		public var B:Number = 0;
		public var length:Number = 0;
	
		////////////
		public function Line(assetIDStringOrXML:Object, type:Number, volume:Number, length:Number) {
			trace("new Line ");
			if (assetIDStringOrXML is XMLNode) {
				var x = XMLNode(assetIDStringOrXML);
				//	//trace("XMLNode" + x);
				this.initFromDiskXML(x);
			} else if (assetIDStringOrXML is XMLDocument) {
				var x = XMLDocument(assetIDStringOrXML);
				//	//trace("XMLDocument" + x);
				this.initFromDiskXML(x);
			} else {
				this.init(String(assetIDStringOrXML), type, volume, length);
			}
		}
		public function init(name:String, type:Number, volume:Number, length:Number):void {
			this.name = (name != null) ? name : "";
			this.type = (type != null) ? type : 1;
			this.length = (length != null) ? length : 0;
		}
		///////////////////////////////////////////////////////////////////////
		/// This is used to deserialize from disk
		public function initFromDiskXML(res:XML):Line {
			//trace("SlideMediaAsset.initFromDiskXML");

			this.name = res.@name+"";
			this.type = parseInt(res.@type);
			this.length = parseInt(res.@length);
	/*				for (var i in res.length().childNodes) {
				var node:XMLNode = tree.childNodes[i];
				trace("Track found node "+node.nodeName);
				switch (node.nodeName) {
				case "clip" :
				  var c = new Clip(node);
				  trace("completed track " + c);
					break;
				}
			}*/
			return this;
		}
		public function toString():String{
			return this.name + " " + this.length;
		}
	}
}