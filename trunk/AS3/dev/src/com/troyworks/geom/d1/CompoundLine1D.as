package com.troyworks.geom.d1 { 
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	public class CompoundLine1D extends com.troyworks.geom.d1.Line1D
	{
		public var children : Array = new Array ();
		////////////
		public function CompoundLine1D (obj : Object, type : Number, start : Number, length : Number, end : Number)
		{
			super (obj, type, start, length, end);
		//	trace ("new CompoundLine1D " + this.name + " " + start + " len " + length + " end " + end);
		}
		public function addChild (ch:Line1D):void
		{
			this.children.push (ch);
			//sort by starttime.
			if (this.children.length > 1)
			{
				//trace ("before sort:\r\t" + this.children.join("\t\r  "));
				this.children.sort (this.order);
				//trace ("after sort:\r\t" + this.children.join("\t\r  "));
	
			}
			this.A = this.children [0].A;
			this.B = this.children [this.children.length - 1].B;
			//	trace ("aed Child " + this);
	
		}
		// a utility function for sorting the line values, by end points
		protected function order (A:Line1D, B:Line1D) : Number
		{
			//trace ("ordering " + A + " " + B)
			if (A.A < B.A)
			{
				return - 1;
			} else if (A.A > B.A)
			{
				return 1;
			} else if (A.A == B.A)
			{
				if (A.B < B.B)
				{
					return - 1;
				} else if (A.B > B.B)
				{
					return 1;
				} else
				{
					return 0;
				}
			}
		}
		public function getClipsIntersectAt (t : Number, tAInclusive : Boolean, tBInclusive : Boolean, invert : Boolean) : Array
		{
			if (this.A <= t && t <= this.B)
			{
				var res : Array = new Array ();
				for (var i in this.children)
				{
					var c = this.children [i];
					var a : Boolean = false;
					//intersects with A
					trace ("checking " + c);
					//      |TA
					// c.A==============c.B
					//	trace("intersectA c.A " + c.A +" tA " + tA +" c.B " + c.B );
					if (tAInclusive && tBInclusive)
					{
						//	trace("AIBI");
						if (c.A <= t && t <= c.B )
						{
							a = true;
						}
					} else if ( ! tAInclusive && tBInclusive)
					{
						//	trace("ABI");
						if (c.A < t && t <= c.B )
						{
							a = true;
						}
					} else if (tAInclusive && ! tBInclusive)
					{
						//	trace("AIB");
						if (c.A <= t && t < c.B )
						{
							a = true;
						}
					} else if ( ! tAInclusive && ! tBInclusive)
					{
						//	trace("AB");
						if (c.A < t && t <= c.B )
						{
							a = true;
						}
					}
					if (a || ( ! a && invert))
					{
						res.push (c);
					}
				}
				if (res.length == 0)
				{
				//	trace ("no clips found");
					return null;
				}
				return res;
			} else
			{
				//trace ("time out of bounds");
				return null;
			}
		};
		public function getClipsStartingBetween (tA : Number, tB : Number, tAInclusive : Boolean, tBInclusive : Boolean, endsInside : Boolean, endsInclusive : Boolean, invert : Boolean) : Array
		{
			//trace ("getClipsStartingBetween " + tA + " " + tB + " endsInside:" + endsInside + " invert: " + invert);
			var res : Array = new Array ();
			for (var i in this.children)
			{
				var c = this.children [i];
				var a : Boolean = false;
				//intersects with A
				//      |TA
				// c.A==============c.B
				//trace("intersectA c.A " + c.A +" tA " + tA +" c.B " + c.B );
				if (tAInclusive && tBInclusive)
				{
				//	trace ("AIBI");
					if (tA <= c.A && c.A <= tB )
					{
						a = true;
					}
				} else if ( ! tAInclusive && tBInclusive)
				{
			//		trace ("ABI");
					if (tA < c.A && c.A <= tB )
					{
						a = true;
					}
				} else if (tAInclusive && ! tBInclusive)
				{
			//		trace ("AIB" + tA + " " + c.A + " " + tB + " " + c.B);
					if (tA <= c.A && c.A < tB )
					{
						a = true;
					}
				} else if ( ! tAInclusive && ! tBInclusive)
				{
			//		trace ("AB");
					if (tA < c.A && c.A < tB)
					{
						a = true;
					}
				}
				if (a && (endsInside != null))
				{
					if (endsInside)
					{
						// c.B < tB
						// c.B <= tB
						if (endsInclusive)
						{
							if (c.B <= tB)
							{
							}else
							{
								a = false;
							}
						} else
						{
							if (c.B < tB )
							{
							}else
							{
								a = false;
							}
						}
					} else
					{
						//ends outside
						// tB <= c.B
						// tB < c.B
	
						if (endsInclusive)
						{
							if (tB <= c.B)
							{
							}else
							{
								a = false;
							}
						} else
						{
							if (tB < c.B )
							{
							}else
							{
								a = false;
							}
						}
					}
				}
				//&& tB < c.B
				if (a || ( ! a && invert))
				{
				//	trace ("aing " + c);
					res.push (c);
				}
			}
			if (res.length == 0)
			{
				//trace ("no clips found");
				return null;
			}
			return res;
		}
		public function getClipsEndingBetween (tA : Number, tB : Number, tAInclusive : Boolean, tBInclusive : Boolean, startsInside : Boolean, startsInclusive : Boolean, invert : Boolean) : Array
		{
		//	trace ("getClipsEndingBetween " + tA + " " + tB + " " + invert);
			var res : Array = new Array ();
			for (var i in this.children)
			{
				var c = this.children [i];
				var a : Boolean = false;
				//intersects with A
				//      |TA
				// c.A==============c.B
				//	trace("intersectA c.A " + c.A +" tA " + tA +" c.B " + c.B );
				if (tAInclusive && tBInclusive)
				{
					//trace ("AIBI");
					if (tA <= c.B && c.B <= tB )
					{
						a = true;
					}
				} else if ( ! tAInclusive && tBInclusive)
				{
				//	trace ("ABI");
					if (tA < c.B && c.B <= tB )
					{
						a = true;
					}
				} else if (tAInclusive && ! tBInclusive)
				{
				//	trace ("AIB" + tA + " " + c.A + " " + tB + " " + c.B);
					if (tA <= c.B && c.B < tB )
					{
						a = true;
					}
				} else if ( ! tAInclusive && ! tBInclusive)
				{
				//	trace ("AB");
					if (tA < c.B && c.B< tB)
					{
						a = true;
					}
				}
				if (a && (startsInside != null))
				{
					if (startsInside)
					{
	
						// tA <= c.A
						// tA < c.A
						if (startsInclusive)
						{
							if (tA <= c.A)
							{
							}else
							{
								a = false;
							}
						} else
						{
							if (tA < c.A )
							{
							}else
							{
								a = false;
							}
						}
					} else
					{
						//starts outside
						// c.A < tA
						// c.A <= tA
						if (startsInclusive)
						{
							if (c.A <= tA)
							{
							}else
							{
								a = false;
							}
						} else
						{
							if (c.A < tA )
							{
							}else
							{
								a = false;
							}
						}
	
					}
				}
				if (a || ( ! a && invert))
				{
				//	trace ("aing " + c);
					res.push (c);
				}
			}
			if (res.length == 0)
			{
			//	trace ("no clips found");
				return null;
			}
			return res;
		}
	
		public function getClipsBetween (tA : Number, tB : Number, tAInclusive : Boolean, tBInclusive : Boolean, invert : Boolean) : Array
		{
			var res : Array = new Array ();
			for (var i in this.children)
			{
				var c = this.children [i];
				var a : Boolean = false;
				//intersects with A
				//trace ("checking " + c);
				//      |TA
				// c.A==============c.B
				//	trace("intersectA c.A " + c.A +" tA " + tA +" c.B " + c.B );
				if (tAInclusive && tBInclusive)
				{
					//	trace("AIBI");
					if (tA <= c.A && c.B <= tB )
					{
						a = true;
					}
				} else if ( ! tAInclusive && tBInclusive)
				{
					//	trace("ABI");
					if (tA < c.A && c.B <= tB )
					{
						a = true;
					}
				} else if (tAInclusive && ! tBInclusive)
				{
					//	trace("AIB");
					if (tA <= c.A && c.B < tB)
					{
						a = true;
					}
				} else if ( ! tAInclusive && ! tBInclusive)
				{
					//	trace("AB");
					if (tA < c.A && c.B < tB )
					{
						a = true;
					}
				}
				//is outside A and B
				if (a || ( ! a && invert))
				{
					res.push (c);
				}
			}
			if (res.length == 0)
			{
			//	trace ("no clips found");
				return null;
			}
			return res;
		}
		///////////////////////////////////////////////////////////////////////
		/// This is used to deserialize from disk
		public function initFromXML (tree : XMLDocument) : CompoundLine1D
		{
			//trace("SlideMediaAsset.initFromDiskXML");
			var res : XMLNode = tree;
			this.name = res.attributes.name + "";
			this.type = parseInt (res.attributes.type);
			this.length = parseInt (res.attributes.length);
			for (var i in tree.childNodes)
			{
				var node : XMLNode = tree.childNodes [i];
				trace ("CompoundLine1D found node " + node.nodeName);
				switch (node.nodeName)
				{
					case "Line1D" :
					var c = new Line1D (node);
					break;
				}
			}
			return this;
		}
		public function toString () : String
		{
			return " from " + this.A + " to " + this.B + " (" + this.length + ") " + this.name + " children:\t\r" + this.children.join ("\t\r");
		}
	}
	
}