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
		public var length : Number = NaN;
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
				initFromXML (x);
			} else if (obj is XMLDocument)
			{
				var x = XMLDocument (obj);
				//	//trace("XMLDocument" + x);
				initFromXML (x);
			} else
			{
				init (String (obj) , type, start, length, end);
			}
		}
		public function init (name : String, type : Number, start : Number, length : Number, end : Number) : void
		{
		//	trace("Line1D.init " + name + " start " + start + " len " + length + " end " + end);
			name = (name != null) ? name : "";
			type = (type != null) ? type : 1;
			if (start != null)
			{
				A = new Point1D ("A", start);
			}
			if (end != null)
			{
				B = new Point1D ("B", end);
			}
			if (length != null)
			{
				length = length;
			}
			calc ();
			trace (this);
		}
		public function calc () : void
		{
			//trace("Line.calc");
			//trace("Line1D.calc1 "+ name + " A:" + A + " B:" + B + " len:" + length);
			var aV = (A != null) && (!isNaN(A.val));
			var bV = (B != null)  && (!isNaN(B.val));
			var lV = (length != null) && (!isNaN(length));
		//	trace("aV "+ aV + " bV " + bV + " lV " + lV);
			if (!aV && bV && lV)
			{
				//calc A from B and length
				A = new Point1D ("A", B.val - length);
			} else if (aV && bV )
			{
				//calc length from A & B;
				length = B.val - A.val;
			} else if (aV && !bV && lV)
			{
				var b:Point1D =  Point1D(new Point1D ("B", (A.position + length)));
				B = b;
			}else
			{
				trace("!!!!!!!!!!!!!!!!!!!!!!!!Line1D..can't calc! "+ name + " A:" + A + " B:" + B + " len:" + length);
			}
			//	trace("Line1D.calc2 "+ name + " A:" + A + " B:" + B + " len:" + length);
	
		}
		///////////////////////////////////////////////////////////////////////
		/// This is used to deserialize from disk
		public function initFromXML (tree : XMLDocument) : Line1D
		{
			//trace("SlideMediaAsset.initFromDiskXML");
			var res : XMLNode = tree;
			name = res.@name + "";
			type = parseInt (res.@type);
			length = parseInt (res.@length);
			return this;
		}
		public function toString () : String
		{
			return " from " + A + " to " + B + " (" + length+ ") " + name ;
		}
	}
	
}