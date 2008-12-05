package com.troyworks.controls.tparticleengine { 
	import com.troyworks.data.graph.MicroNode;
	import com.troyworks.geom.d3.Point3D;
	import flash.geom.Rectangle;
	
	/**
	 * @author Troy Gardner
	 */
	public class Particle extends MicroNode {
		//////////// ORIGINAL //////////////
		public var ox:Number = 0;
		public var oy:Number = 0;
		public var oz:Number = 0;
		
		//////////// CURRENT //////////////
		public var x:Number = 0;
		public var y:Number = 0;
		public var z:Number = 0;
	
		//////////// LAST /////////////////////
		public var lx:Number = 0;
		public var ly:Number = 0;
		public var lz:Number = 0;
	
		///////////// VELOCITY X ///////////////
		public var vx:Number = 0;
		public var vy:Number = 0;
		public var vz:Number = 0;
		
		
		
		public var bounds:Rectangle;
		
		public function Particle(id : Number, name : String, nType : String) {
			super(id, name, nType);
		}
	
	}
}