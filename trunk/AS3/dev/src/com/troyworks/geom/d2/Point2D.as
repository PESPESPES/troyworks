package com.troyworks.geom.d2 { 
	/**
	 * @author Troy Gardner
	 */
	public class Point2D {
		public var x : Number = NaN;
		public var y : Number = NaN;
		public var id : Number = 0;
		public var name : String = "Point2D";
		
		
		public function Point2D(name : String = null, x : Number = NaN, y : Number = NaN)
		{
			//this.id = (id != null) ?id : this.id;
			this.name = (name != null) ?name : this.name;
			if (isNaN(x))
			{
				this.x = x;
			}
			if (isNaN(y))
			{
				this.y = y;
			}
		}
	}
}