package com.troyworks.particleengine { 
	import flash.geom.Rectangle;
	import com.troyworks.framework.ui.DraggableClip;
	import com.troyworks.framework.ui.layout.Bounds2;
	import com.troyworks.geom.d2.Rect2D;
	import com.troyworks.ui.LayoutHelper;
	import com.troyworks.geom.d2.Point2D;
	/**
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;
	public class ParticleSim extends MovieClip {
	
		public var bounds : Rect2D;
		public var layoutMan : LayoutHelper;
	
		public var particles : Array = new Array();
		public var clips : Array = new Array();
	
		public var numOfParticles : Number = 0;
		
		//////////Forces ///////////
		public var easing : Number = .1;
		public var bounce : Number = 0.7;
		public var gravity : Number = 1;
		public var spring : Number = 0.1;
		public var springLength : Number = 75;
		public var friction : Number = 0.97;
		public var linkageID : String = "ball";
		public function ParticleSim() {
			
		}
		public function onLoad() : void{
			trace("onLoad");
			bounds = new Rect2D();
			bounds.top = 0;
			bounds.left = 0;
			bounds.bottom =height;
			bounds.right = width;
			layoutMan = new LayoutHelper(null, bounds);
			trace(" bounds " + util.Trace.me(bounds, "bounds", true));
			createParticles();
	
		}
		public function createParticles() : void{
			layoutMan.setupLayout(numOfParticles);
			for (public var i : Number = 0; i <numOfParticles; i++) {
				public var p2d : Point2D = new Point2D();
				layoutMan.layoutClip(i, p2d);
	
				public var p : PhysicsParticle = new PhysicsParticle();
				p.cp.x = p2d.x;
				p.cp.y = p2d.y;
	
				p.v.x = Math.random() * 10 -5;
				p.v.y = Math.random() * 10 -5;
	
				particles.push(p);
				public var initO : Object = new Object();
				initO.x = p.x;
				initO.y = p.y;
				initO.p = p;
				initO.id = i;
				public var _mc : MovieClip = attachMovie(linkageID,linkageID+i, i+10, initO);
				p.view = _mc;
				clips.push(_mc);
			}
		}
		function onEnterFrame():void
		{
			for(var i:Number = 0;i<numOfParticles;i++)
			{
				public var particle:MovieClip = this["p" + i];
				particle.x += particle.vx;
				particle.y += particle.vy;
			}
			for(i=0;i<numOfParticles-1;i++)
			{
				public var partA:PhysicsParticle = this["p" + i];
				for(public var j:Number = i+1;j<numOfParticles;j++)
				{
					var partB:PhysicsParticle = this["p" + j];
					checkCollision(partA, partB);
					gravitate(partA, partB);
				}
			}
		}
	
		function springTo(pA : PhysicsParticle, pB : PhysicsParticle) : void{
			trace("springTo");
			var dx : Number = pA.x - pB.x;
			var dy : Number = pA.y - pB.y;
			var angle : Number = Math.atan2(dy, dx);
			var targetX : Number = pB.x + Math.cos(angle) * springLength;
			var targetY : Number = pB.y + Math.sin(angle) * springLength;
			pA.v.x  += (targetX - pA.x) * spring;
			pA.v.y  += (targetY - pA.y) * spring;
			pA.v.x *= friction;
			pA.v.y *= friction;
		}
		function gravitate(pA : PhysicsParticle, pB : PhysicsParticle) : void{
			trace("gravitate");
			var dx : Number = pA.x - pB.x;
			var dy : Number = pA.y - pB.y;
			var distSQ : Number = dx*dx + dy*dy;
			var dist : Number = Math.sqrt(distSQ);
			var force : Number = pA.mass * pB.mass /distSQ;
			var ax : Number = force * dx /dist;
			var ay : Number = force * dy /dist;
			pA.v.x += ax /pA.mass;
			pA.v.y += ay/ pA.mass;
			pB.v.x += ax /pB.mass;
			pB.v.y += ay/ pB.mass;
		}
		function drag(p : PhysicsParticle) : void{
			var ball : DraggableClip = DraggableClip(p.view);
			p.a.x = 0;
			p.a.y = 0;
			p.v.x = 0;
			p.v.y = 0;
	//		p.v.x = ball.x - ball.lastX;
	//		p.v.y = ball.y - ball.lastY;
			p.cp.x = ball.x;
			p.cp.y = ball.y;
		}
		function rotate(x : Number, y : Number, sine : Number, cosine : Number, reverse : Boolean) : Object
	{
			var result : Object = new Object();
			if(reverse)
			{
				result.x = x * cosine + y * sine;
				result.y = y * cosine - x * sine;
			}
			else
			{
				result.x = x * cosine - y * sine;
				result.y = y * cosine + x * sine;
			}
			return result;
		}
		function checkCollision(ball0 : MovieClip, ball1 : MovieClip) : void
	{
			var dx : Number = ball1.x - ball0.x;
			var dy : Number = ball1.y - ball0.y;
			var dist : Number = Math.sqrt(dx*dx + dy*dy);
			if(dist < ball0.width / 2 + ball1.width / 2)
			{
				// calculate angle, sine and cosine
					public var angle : Number = Math.atan2(dy, dx);
					public var sine : Number = Math.sin(angle);
					public var cosine : Number = Math.cos(angle);
				
				// rotate ball0's position
					public var pos0 : Object = {x:0, y:0};
				
				// rotate ball1's position
					public var pos1 : Object = rotate(dx, dy, sine, cosine, true);
		
				// rotate ball0's velocity
					public var vel0 : Object = rotate(ball0.vx, ball0.vy, sine, cosine, true);
				
				// rotate ball1's velocity
					public var vel1 : Object = rotate(ball1.vx, ball1.vy, sine, cosine, true);
		
				// collision reaction
					public var vxTotal : Number = vel0.x - vel1.x;
					vel0.x = ((ball0.mass - ball1.mass) * vel0.x + 2 * ball1.mass * vel1.x) / (ball0.mass + ball1.mass);
					vel1.x = vxTotal + vel0.x;
				
				// update position
					public var absV : Number = Math.abs(vel0.x) + Math.abs(vel1.x);
					public var overlap : Number = (ball0.width / 2 + ball1.width / 2) - Math.abs(pos0.x - pos1.x);
					pos0.x += vel0.x / absV * overlap;
					pos1.x += vel1.x / absV * overlap;
				
				// rotate positions back
					public var pos0F : Object = rotate(pos0.x, pos0.y, sine, cosine, false);
		
					public var pos1F : Object = rotate(pos1.x, pos1.y, sine, cosine, false);
				
				// adjust positions to actual screen positions
					ball1.x = ball0.x + pos1F.x;
					ball1.y = ball0.y + pos1F.y;
					ball0.x = ball0.x + pos0F.x;
					ball0.y = ball0.y + pos0F.y;
				
				// rotate velocities back
					public var vel0F : Object = rotate(vel0.x, vel0.y, sine, cosine, false);
					public var vel1F : Object = rotate(vel1.x, vel1.y, sine, cosine, false);
					ball0.vx = vel0F.x;
					ball0.vy = vel0F.y;
					ball1.vx = vel1F.x;
					ball1.vy = vel1F.y;
			}
		}
		function checkBounds(p : PhysicsParticle) : void{
			var ball : DraggableClip = DraggableClip(p.view);
			var b : Bounds2 = new Bounds2(ball.getBounds(this));
				///////// check x ///////////////
				if(b.xMax > bounds.right){
				trace("hit R wall");
				p.cp.x = bounds.right - b.width;
				p.v.x = Math.abs(p.v.x)*-1* bounce;
				}else if(b.xMin < bounds.left){
				trace("hit L wall");
				p.cp.x = bounds.left + 1;// + b.width + 1;
				p.v.x = Math.abs(p.v.x) * bounce;
				}
				////////// check y ////////////////
				if( bounds.bottom -.9 < b.yMax && b.yMax < bounds.bottom +.9 && Math.abs(p.v.y) <3){
			//		trace("on Bottom");
				//	v.x = 0;
				   if(gravity >0){
					p.v.y = -gravity;
				   }
				} else if(b.yMax >bounds.bottom){
				trace("hit Bottom yMax: " + b.yMax  + " bottom: " + bounds.bottom + " v: " + p.v.y);
	
				p.v.y= Math.abs(p.v.y* bounce)*-1;
				p.cp.y -= (b.yMax- bounds.bottom) - p.v.y;
				}else if(b.yMin < bounds.top){
				trace("hit Top");
				p.cp.y = bounds.top +1 ;//+ b.height;
				p.v.y= Math.abs(p.v.y* bounce);
				}
				///// update the clip /////////
			ball.x = p.x;
			ball.y = p.y;
		}
		function applyGravity(p : PhysicsParticle) : void{
			p.v.y += gravity;
		}
	}
}