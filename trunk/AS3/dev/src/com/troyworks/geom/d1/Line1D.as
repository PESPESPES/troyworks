package com.troyworks.geom.d1 {
/**
	 *  A 1 dimensional line.
	 *  
	 *  A point bound between two points on a line (inclusive or non-inclusive)
	 *  where length is the Z- A.
	 * 
	 * eg.:     A[......C.......]Z
	 * 
	 * Useful for volume slider like application models.
	 * 
	 * @author Troy Gardner
	 * @version 0.1
	 */
	import flash.net.registerClassAlias;	
	import flash.utils.ByteArray;	

	import com.troyworks.data.DataChangedEvent;	
	import com.troyworks.framework.BaseObject; 

	public class Line1D extends  BaseObject {
		public var id : Number = -1;
		public var name : String = "";
		public var type : Number = 1;
		protected var _A : Point1D = null;
		protected var _C : Point1D = null;
		protected var _B : Point1D = null;
		public var length : Number = NaN;
		public var depthInHeirarchy:int = 0;
		public var data : Object;
		public var parentLine:Line1D;
		protected var spacer:String = "";
		private static const REG:* = registerClassAlias("com.troyworks.geom.d1.Line1D",Line1D);
		////////////
		public function Line1D(obj : Object = null, type : Number = NaN, start : Number = NaN, length : Number = NaN, end : Number = NaN) {	
			super();
			//trace("new Line1D ");
			//	trace("new Line1D " + name + " start " + start + " len " + length + " end " + end);
			//if(arguments.length > 0){
			if (obj is XML) {
				initFromXML(obj as XML);
			} else {
				init(String(obj), type, start, length, end);
			}
			//}
		}

		public function get Aposition() : Number {
			return _A.position ;
		}

		public function get Bposition() : Number {
			return _B.position ;
		}

		public function get A() : Point1D {
			return _A ;
		}
		public function updateSpacer():void{
				var d:int = getDepthInHeirchy();
			var a:int= d;
			var spacein:Array = new Array();
			while(a--){
				spacein.push("   ");
			}
			spacer = spacein.join('');
		}
		public function getDepthInHeirchy():Number{
			if(parentLine){
				return parentLine.getDepthInHeirchy()+ 1;
			}else{
				return depthInHeirarchy;
			}
		}

		public function set A(val : Point1D) : void {
			if(_A != null) {
				_A.removeEventListener(DataChangedEvent.DATA_CHANGED, onAChanged);
			}
			var dce : DataChangedEvent = new DataChangedEvent(DataChangedEvent.DATA_CHANGED);
			dce.oldVal = _A;
			dce.currentVal = val;
			_A = val;
			if(_A != null) {
				_A.addEventListener(DataChangedEvent.DATA_CHANGED, onAChanged);
			}
			dispatchEvent(dce);
		}

		public function onAChanged(evt : DataChangedEvent) : void {
			calc();
		}

		public function get Z() : Point1D {
			return _B ;
		}

		public function set Z(val : Point1D) : void {
			if(_B != null) {
				_B.removeEventListener(DataChangedEvent.DATA_CHANGED, onBChanged);
			}
			var dce : DataChangedEvent = new DataChangedEvent(DataChangedEvent.DATA_CHANGED);
			dce.oldVal = _B;
			dce.currentVal = val;
			_B = val;
			if(_B != null) {
				_B.addEventListener(DataChangedEvent.DATA_CHANGED, onBChanged);
			}
			dispatchEvent(dce);
		}

		public function onBChanged(evt : DataChangedEvent) : void {
			calc();
		}

		public function init(name : String = null, type : Number = NaN, start : Number = NaN, length : Number = NaN, end : Number = NaN) : void {
			trace("Line1D.init " + name + " start " + start + " len " + length + " end " + end);
			this.name = (name != null) ? name : "";
			this.type = (!isNaN(type)) ? type : 1;
			if (!isNaN(start)) {
				A = new Point1D("A", start);
			}
			if (!isNaN(end)) {
				Z = new Point1D("Z", end);
			}
			if (!isNaN(length)) {
				this.length = length;
			}
			calc();
			trace(this);
		}

		public function calc() : void {
			//trace("Line.calc");
			//trace("Line1D.calc1 "+ name + " A:" + A + " Z:" + Z + " len:" + length);
			var aV : Boolean = (A != null) && (!isNaN(A.position));
			var bV : Boolean = (Z != null) && (!isNaN(Z.position));
			var lV : Boolean = (!isNaN(length));
			//	trace("aV "+ aV + " bV " + bV + " lV " + lV);
			if (!aV && bV && lV) {
				//calc A from Z and length
				A = new Point1D("A", Z.position - length);
			} else if (aV && bV ) {
				//calc length from A & Z;
				length = Z.position - A.position;
			} else if (aV && !bV && lV) {
				var b : Point1D = new Point1D("Z", (A.position + length));
				Z = b;
			} else {
				trace("!!!!!!!!!!!!!!!!!!!!!!!!Line1D..can't calc! " + name + " A:" + A + " Z:" + Z + " len:" + length);
			}
			//	trace("Line1D.calc2 "+ name + " A:" + A + " Z:" + Z + " len:" + length);
		}
		// way to shift left and right //
		public function shiftBy(shift:Number):void{
			var aV : Boolean = (A != null) && (!isNaN(A.position));
			var bV : Boolean = (Z != null) && (!isNaN(Z.position));
			if(aV){
				A.position += shift;
			}
			if(bV){
				Z.position += shift;
			}
		}
		public function toXML():XML{
			var res:XML = new XML("<l name='"+name+"' type='"+ type + "' length='" +length  + "'/>");
			return res;				
		}

		///////////////////////////////////////////////////////////////////////
		/// This is used to deserialize from disk
		public function initFromXML(tree : XML) : Line1D {
			//trace("SlideMediaAsset.initFromDiskXML");

			name = tree.@name + "";
			type = parseInt(tree.@type);
			length = parseInt(tree.@length);
			return this;
		}

		override public function toString() : String {
			return spacer +  name + " from " + A + " to " + Z + " (" + length + ") " ;
		}

		public function toUTCString() : String {
			var startDate : Date = new Date(Aposition);
			var endDate : Date = new Date(Bposition);
				
			return name + " from " + startDate.toUTCString() + " to " + endDate.toUTCString() + " (" + length + ") " ;
		}
		public function clone():Object{
			var copier : ByteArray = new ByteArray();
			copier.writeObject(this);
			copier.position = 0;
			return(copier.readObject());
		
		// var res:Line1D = new Line1D(new String(name),type+0,A.position+0,length +0,Z.position+0);
		
		// return res;
		}
	}
}