package com.troyworks.particleengine { 
	import com.troyworks.geom.d3.Point3D;
	/**
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;
	public class PhysicsParticle extends Object{
		
		public var lp:Point3D;
		public var cp:Point3D;
		public var v:Point3D;
		public var a:Point3D;
		public var mass:Number = 1;	
		public var targetP:Point3D;
		
		public var view:MovieClip;
		
		public function PhysicsParticle() {
			lp = new Point3D();
			cp = new Point3D();
			v = new Point3D();
			a = new Point3D();
		}
		public function get x():Number{
			return cp.x;
		}
		public function get y():Number{
			return cp.y;
		}
		public function get z():Number{
			return cp.y;
		}
		public function integrateVelocity():void{
			cp.x += v.x;
			cp.y += v.y;
			
		}
		public function updateView():void{
			view.x = cp.x;
			view.y = cp.y;
		}
		public function integrateUpdate():void{
			v.x += a.x;
			v.y += a.y;
			cp.x += v.x;
			cp.y += v.y;
			view.x = cp.x;
			view.y = cp.y;
			
		}
	}
}