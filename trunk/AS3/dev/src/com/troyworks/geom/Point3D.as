package  { 
	class com.troyworks.geom.Point3D
	{
		public var id:Number = 0;
		public var x : Number = 0;
		public var y : Number = 0;
		public var z : Number = 0;
		public function Point3D (id : Number, x : Number, y : Number, z : Number)
		{
			//	this.init(id,name,nType);
			this.x = (x != null) ?x : this.x;
			this.y = (y != null) ?y : this.y;
			this.z = (z != null) ?z : this.z;
		}
		public function clone():Point3D{
			return new Point3D(this.id, this.x, this.y, this.z);
		}
	}
	
}