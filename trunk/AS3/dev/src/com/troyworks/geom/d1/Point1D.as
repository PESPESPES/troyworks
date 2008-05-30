package com.troyworks.geom.d1 { 
	import flash.events.EventDispatcher;
	 /*
	* A single dimension point
	* Test Code:
	
	
	pn = new Point1D(34,1);
	trace(pn);
	
	pv = pn.clone();
	trace(pv);
	p3 = pv + pn;
	trace(p3)//
	p4 = pv-pn;
	trace(p4);
	
	trace(3 < p4);
	pv.position = 2;
	trace(pv);
	
	
	//Outputs
	/*
	* P1D 34 1
	  P1D 34 1
	   2
	   0
	   false
	setting position 2
	   P1D 34 2
	*/
	   public class Point1D extends EventDispatcher
	{
		public var id : Number = 0;
		public var name : String = "Point";
		public var val:Number = 0;
		public function Point1D (name : String, x : Number)
		{
			//id = (id != null) ?id : id;
			name = (name != null) ?name : name;
			if (x != null)
			{
				val = x;
			}
		}
		public function get position () : Number
		{
			return val;
		}
		public function set position (newVal:Number) : void
		{
			trace ("Point1D setting position from " +super.toString() + " to " + newVal);
			val = newVal;
			
		}
		public function clone () : Point1D
		{
			var p:Point1D = new Point1D (String(name), Number(val));
			p.id = Number(id);
			return p;
		}
		public function toString () : String
		{
			return "P1D " + name + " " + super.toString ();
		}
	}
	
}