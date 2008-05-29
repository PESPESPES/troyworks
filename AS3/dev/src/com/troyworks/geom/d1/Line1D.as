package com.troyworks.geom.d1 { 
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	public class Line1D extends com.troyworks.framework.BaseObject
	{
		public var id:Number = -1;
		public var name : String = "";
		public var type : Number = 1;
		public var A : Point1D = null;
		public var B : Point1D = null;
		public var length : Number = null;
		public var data:Object;
		////////////
		public function Line1D (obj : Object, type : Number, start : Number, length : Number, end : Number)
		{
				//trace("new Line1D ");
			//	trace("new Line1D " + name + " start " + start + " len " + length + " end " + end);
	
			if (obj is XMLNode)
			{
				var x = XMLNode (obj);
				//	//trace("XMLNode" + x);
				this.initFromXML (x, type, start, length, end);
			} else if (obj is XMLDocument)
			{
				var x = XMLDocument (obj);
				//	//trace("XMLDocument" + x);
				this.initFromXML (x, type, start, length, end);
			} else
			{
				this.init (String (obj) , type, start, length, end);
			}
		}
		public function init (name : String, type : Number, start : Number, length : Number, end : Number) : void
		{
		//	trace("Line1D.init " + name + " start " + start + " len " + length + " end " + end);
			this.name = (name != null) ? name : "";
			this.type = (type != null) ? type : 1;
			if (start != null)
			{
				this.A = new Point1D ("A", start);
			}
			if (end != null)
			{
				this.B = new Point1D ("B", end);
			}
			if (length != null)
			{
				this.length = length;
			}
			this.calc ();
			trace (this);
		}
		public function calc () : void
		{
			//trace("Line.calc");
			//trace("Line1D.calc1 "+ this.name + " A:" + this.A + " B:" + this.B + " len:" + this.length);
			var aV = (this.A != null) && (!isNaN(this.A));
			var bV = (this.B != null)  && (!isNaN(this.B));
			var lV = (this.length != null) && (!isNaN(this.length));
		//	trace("aV "+ aV + " bV " + bV + " lV " + lV);
			if (!aV && bV && lV)
			{
				//calc A from B and length
				this.A = new Point1D ("A", this.B - this.length);
			} else if (aV && bV )
			{
				//calc length from A & B;
				this.length = this.B - this.A;
			} else if (aV && !bV && lV)
			{
				var b:Point1D =  Point1D(new Point1D ("B", (this.A.position + this.length)));
				this.B = b;
			}else
			{
				trace("!!!!!!!!!!!!!!!!!!!!!!!!Line1D..can't calc! "+ this.name + " A:" + this.A + " B:" + this.B + " len:" + this.length);
			}
			//	trace("Line1D.calc2 "+ this.name + " A:" + this.A + " B:" + this.B + " len:" + this.length);
	
		}
		///////////////////////////////////////////////////////////////////////
		/// This is used to deserialize from disk
		public function initFromXML (tree : XMLDocument) : Line1D
		{
			//trace("SlideMediaAsset.initFromDiskXML");
			var res : XMLNode = tree;
			this.name = res.attributes.name + "";
			this.type = parseInt (res.attributes.type);
			this.length = parseInt (res.attributes.length);
			return this;
		}
		public function toString () : String
		{
			return " from " + this.A + " to " + this.B + " (" + this.length+ ") " + this.name ;
		}
	}
	
}