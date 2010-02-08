package com.troyworks.geom.d1 {
	import flash.net.registerClassAlias;	

	import com.troyworks.data.DataChangedEvent;	
	import com.troyworks.framework.BaseObject; 

	//import flash.events.EventDispatcher;
	/*
	 * A single dimension point 
	 */
	public class Point1D extends BaseObject {
		public var id : Number = 0;
		public var name : String = "Point";
		protected var val : Number = 0;
		private static const REG : * = registerClassAlias("com.troyworks.geom.d1.Point1D", Point1D);

		public function Point1D(name : String = "Point", x : Number = 0) {
			//id = (id != null) ?id : id;
			this.name = name;
			val = x;
		}

		public function add(p : Point1D) : Point1D {
			return new Point1D(name + "+" + p.name, position + p.position);
		}

		public function subtract(p : Point1D) : Point1D {
			return new Point1D(name + "-" + p.name, position - p.position);
		}

		public function multiply(p : Point1D) : Point1D {
			return new Point1D(name + "*" + p.name, position * p.position);
		}

		public function divide(p : Point1D) : Point1D {
			return new Point1D(name + "/" + p.name, position / p.position);
		}

		public function get position() : Number {
			return val;
		}

		public function set position(newVal : Number) : void {
			//	trace ("Point1D setting position from " +super.toString() + " to " + newVal);
			var dce : DataChangedEvent = new DataChangedEvent(DataChangedEvent.DATA_CHANGE);
			dce.oldVal = val;
			dce.currentVal = newVal;
			val = newVal;
			dispatchEvent(dce);
		}

		public function clone() : Point1D {
			var p : Point1D = new Point1D(String(name), Number(val));
			p.id = Number(id);
			return p;
		}

		override public function toString() : String {
			return "" + name + "@" + val;
		}
	}
}