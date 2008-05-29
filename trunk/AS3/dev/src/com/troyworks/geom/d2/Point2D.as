package com.troyworks.geom.d2 { 
	/**
	 * @author Troy Gardner
	 */
	public class Point2D {
		public var x : Number = null;
		public var y : Number = null;
		public var id : Number = 0;
		public var name : String = "Point2D";
		
		
		public function Point2D(name : String, x : Number, y : Number)
		{
			//this.id = (id != null) ?id : this.id;
			this.name = (name != null) ?name : this.name;
			if (x != null)
			{
				this.x = x;
			}
					if (y != null)
			{
				this.y = y;
			}
		}
	}
}