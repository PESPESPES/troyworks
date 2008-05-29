package com.troyworks.geom.d1 { 
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
	public class Point1D extends Number
	{
		public var id : Number = 0;
		public var name : String = "Point";
		public function Point1D (name : String, x : Number)
		{
			//this.id = (id != null) ?id : this.id;
			this.name = (name != null) ?name : this.name;
			if (x != null)
			{
				super (x);
			}
		}
		public function get position () : Number
		{
			return super;
		}
		public function set position (val:Number) : void
		{
			trace ("Point1D setting position from " +super.toString() + " to " + val);
			super = val;
			
		}
		public function clone () : Point1D
		{
			var p:Point1D = new Point1D (this.name, super);
			p.id = this.id;
			return p;
		}
		public function toString () : String
		{
			return "P1D " + this.name + " " + super.toString ();
		}
	}
	
}