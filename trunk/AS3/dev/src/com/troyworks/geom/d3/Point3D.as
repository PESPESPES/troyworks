package  com.troyworks.geom.d3{ 
	public class Point3D
	{
		public var id:Number = 0;
		public var x : Number = 0;
		public var y : Number = 0;
		public var z : Number = 0;
		public function Point3D (id : Number= NaN, x : Number= NaN, y : Number= NaN, z : Number = NaN)
		{
			
			//	this.init(id,name,nType);
			this.x = (isNaN(x)) ?this.x : x;
			this.y = (isNaN(y)) ?this.y : y;
			this.z = (isNaN(z)) ?this.z : z;
		}
		public function clone():Point3D{
			return new Point3D(this.id, this.x, this.y, this.z);
		}
	}
	
}