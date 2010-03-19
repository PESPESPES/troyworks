package com.troyworks.geom.d1 {
	import com.troyworks.data.DataChangedEvent;	
	
	import flash.net.registerClassAlias;	
	
	import com.troyworks.geom.d1.LineQuery;		

	public class CompoundLine1D extends Line1D {
		public var children : Array = new Array();
		private static const REG:* = registerClassAlias("com.troyworks.geom.d1.CompoundLine1D",CompoundLine1D);
		////////////
		public function CompoundLine1D(obj : Object = null, type : Number = NaN, start : Number = NaN, length : Number = NaN, end : Number = NaN) {	
	
			super(obj, type, start, length, end);
		//	trace ("new CompoundLine1D " + this.name + " " + start + " len " + length + " end " + end);
		}

		public function addChild(ch : Line1D) : void {
			//trace
			trace("addChild " + this.children.length);
			this.children.push(ch);
			//sort by starttime.
			if (this.children.length > 1) {
				//trace ("before sort:\r\t" + this.children.join("\t\r  "));
				this.children.sort(this.order);
				//trace ("after sort:\r\t" + this.children.join("\t\r  "));
			}
			this.A = this.children[0].A;
			this.Z = this.children[this.children.length - 1].Z;
			//	trace ("aed Child " + this);
			calc();
		}

		// a utility function for sorting the line values, by end points
		protected function order(A : Line1D, Z : Line1D) : Number {
			//trace ("ordering " + A + " " + Z)
			if (A.A.position < Z.A.position) {
				return -1;
			} else if (A.A.position > Z.A.position) {
				return 1;
			} else if (A.A.position == Z.A.position) {
				if (A.Z.position < Z.Z.position) {
					return -1;
				} else if (A.Z.position > Z.Z.position) {
					return 1;
				} else {
					return 0;
				}
			}
			return 0;
		}

		public function getClips(qry : LineQuery) : Array {
			//trace ("getClips ");
			var res : Array = new Array();
			var i : int = 0;
			var n : int = this.children.length;
			//this.children.filter(qry.passesMinAndMaxCheck);			
			for (;i < n; ++i) {
				var c : Line1D = this.children[i] as Line1D;
			
				var a : Boolean = qry.passesMinAndMaxCheck(c.A.position, c.Z.position);
				//trace(qry);
				if (a) {
					res.push(c);
				}
			}
			if (res.length == 0)
			{
				//trace ("no clips found");
				//return null;
			}
			return res;
		}
		override public function onAChanged(evt : DataChangedEvent) : void {
			var delta:Number = (evt.currentVal as Number) -(evt.oldVal as Number);
			trace("onAChanged " + delta);
			var i : int = 0;
			var n : int = this.children.length;
			//this.children.filter(qry.passesMinAndMaxCheck);			
			for (;i < n; ++i) {
				var c : Line1D = this.children[i] as Line1D;
				c.A.dispatchEventsEnabled = false;
				c.A.position += delta;
				c.A.dispatchEventsEnabled = true;
			}
			calc();
		}
		///////////////////////////////////////////////////////////////////////
		/// This is used to deserialize from disk
		override public function initFromXML(tree : XML) : Line1D {
			//trace("SlideMediaAsset.initFromDiskXML");
			var res : XML = tree;
			this.name = res.@name + "";
			this.type = parseInt(res.@type);
			this.length = parseInt(res.@length);
			/*XXX update for E4x for (var i in tree.childNodes)
			{
			var node : XML = tree.childNodes [i];
			trace ("CompoundLine1D found node " + node.nodeName);
			switch (node.nodeName)
			{
			case "Line1D" :
			var c:Line1D = new Line1D (node);
			break;
			}
			}*/
			return this;
		}

		override public function toString() : String {
			return name + " from " + this.A + " to " + this.Z + " (" + this.length + ") " + this.name + " children:\t\r" + this.children.join("\t\r");
		}

		/*override public function clone() : Object {
		
			var res : CompoundLine1D = new CompoundLine1D(new String(name), type + 0, A.position + 0, length + 0, Z.position + 0);

			var i : int = 0;
			var n : int = this.children.length;
			//this.children.filter(qry.passesMinAndMaxCheck);			
			for (;i < n; ++i) {
				var c : Object = this.children[i].cone();
				res.children.push(c);
			}
			return res;
		}*/
	}
}