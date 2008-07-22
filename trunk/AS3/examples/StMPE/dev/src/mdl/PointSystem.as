package mdl {
	import flash.utils.Dictionary;	
	import flash.events.EventDispatcher;
	import flash.events.Event;	

	/**
	 * @author Troy Gardner
	 */
	public class PointSystem extends CompositeModel {
		public var icon : String = "";
		public var name : String;
		/////// PRESETS ///////////////
		public var curPreset : Preset;
		public var presets : Array;

		/////// COORDINATE SYSTEM //////////
		private var _curCoordinate : Coordinates;
		public var coordinates : Array;

		//////// PARTICLES ////////////////
		public var axises : Array;
		public var particles : Array;
		public var camera_points : Array;
		public var edges : Array;
		public var interactions : Dictionary;

		private var i : int;
		private var n: int;
		
		public function PointSystem() {
			super();
		}

		public function get curCoordinate() : Coordinates {
			return _curCoordinate ;
		}

		public function set curCoordinate(val : Coordinates) : void {
			_curCoordinate = val;
			trace("setting curCoordinate to " + val.id + " from " + _curCoordinate.id);
			///////// UPDATE the POINTS COORDS /////////////
			i = 0;
			n = particles.length;
			var cp : EightDimensionParticle;
			trace(" particles " + n);
			for (;i < n; ++i) {
				
				cp = particles[i] as EightDimensionParticle;
				cp.setCurrentCoordinates(val.id);
				cp = camera_points[i] as EightDimensionParticle;
				cp.setCurrentCoordinates(val.id);
			}
			/////////    dispatach changed //////////////////
			dispatchEvent(new Event(Model.COORDS_CHANGED));
			//dispatchEvent(new Event(Model.ROTATIONS_CHANGED));
			
		}

		public static function XMLFactory(xml : XML) : PointSystem {
			var ps : PointSystem = new PointSystem();
			ps.name = String(xml.@name);
			var i : int;
			var n: int;	
			
			//////////////////////////////////////////////////////////////////
			///                  VISUALIZE THE AXISES                      ///
			//////////////////////////////////////////////////////////////////
			var p1 : EightDimensionParticle;
			var p2 : EightDimensionParticle;
			i = 0;
			n = Dimension.EIGHTD.length;
			ps.axises = new Array();
			for(;i < n;++i) {
				var dm : EightDimensionVector = Dimension.EIGHTD[i];
				p1 = new EightDimensionParticle();
				p2 = new EightDimensionParticle();
					
				var p1v:EightDimensionVector = dm.clone();
				p1v.multiply(.5);
				p1.setPosition(p1v);
				var p2v:EightDimensionVector = dm.clone();
				
				p2v.multiply(-.5);
				trace("p1v " + p1v +" p2v " + p2v);
				p2.setPosition(p2v);
				ps.axises.push([p1, p2]);	
			}
			
			///////////////////////////////////////////////////////////////
			///           CREATE PARTICLES ON MODEL                     ///
			///////////////////////////////////////////////////////////////
			var p : EightDimensionParticle;
			var xparticles : XMLList = xml..p;
			i = 0;
			n = xparticles.length();
			//	trace("xml2 " + xparticles + " a " + xparticles.length() + " b " + xparticles.length);
			//	trace("xml " + xml..p);
			trace("found PARTICLES " + n + " =========================================");
			ps.particles = new Array();
			for (;i < n; ++i) {
				//	trace("Particle " + i + " " + xparticles[i].toXMLString());
				p = EightDimensionParticle.XMLFactory(xparticles[i]);
				p.id = i + 1; //1 based
				//	trace("Particle obj " + co);
				//	p.addEventListener(Model.ROTATIONS_CHANGED, ps.redispatchEvent);
				ps.particles.push(p);				
			}
			/////////////////////////////////////////////////////////////////////////////////
			///           CREATE VIEWED/TRANSLATED PARTICLES CAMERA                       ///
			/////////////////////////////////////////////////////////////////////////////////
			
			ps.camera_points = new Array();
			var cp : EightDimensionParticle;
			i = 0;
			for (;i < n; ++i) {
				
				p = ps.particles[i];
				cp = p.clone() as EightDimensionParticle;
				ps.camera_points.push(cp);				
			}
			///////////////////////////////////////////////////////////////////////
			///           COORDS        (must go after Particles!              ///
			//////////////////////////////////////////////////////////////////////
			var coords : XMLList = xml..system;
			i = 0;
			n  = coords.length();
			trace("found " + n + " Coordinate Systems ");
			ps.coordinates = new Array();
			var co : Coordinates;
			for (;i < n; ++i) {
				//	trace("Coord " + i + " " + coords[i].toXMLString());
				co = Coordinates.XMLFactory(coords[i], ps, i);
				//trace("Coord obj " + co);
				co.addEventListener(Model.ROTATIONS_CHANGED, ps.redispatchEvent);
				ps.coordinates.push(co);
			}
			ps.curCoordinate = ps.coordinates[0];
			//trace("CUR COORDI " + ps.curCoordinate);
			
			////////////// CREATE INTERACTIONS BETWEEN PARTICLES ////////////
			ps.interactions = new Dictionary(true);
			var xparticlInteractions : XMLList = xml..i;
			var pi : ParticleInteractions;
			i = 0;
			n = xparticlInteractions.length();
			var ky_val : Array;
			var lnks : Array;
			var keys:Array;
			var pk:Number;
			var sk:Number;
			trace("Found " + n + "interactions====================================");
			//XXX 
			if(true){
			for (;i < n; ++i) {
				//trace("PInteraction " + i + " " + xparticlInteractions[i].toXMLString());
				ky_val = String(xparticlInteractions[i].@lnk).split("=");
				lnks = ky_val[1].split(",");
				keys  = ky_val[0].split(",");
				if(keys.length ==2){
					// given a particle has many outgoing links we need to put them into a single array on the particle
					pk = Number(keys[0]-1);
					sk = Number(keys[1]-1);
					trace();
					//trace(" pk " + pk + "pFrom " +ps.particles[pk] +"  "+ " sk " + sk +" "  + ps.particles[sk]);
//					trace("pFrom " +ps.particles[pk] );
					ps.particles[pk].outboundParticleLinks.push(ps.particles[sk]);
				}
				if(lnks.length == 1) {
					//					trace("putting 1 interaction" + ky_val[0]);
					ps.interactions[ky_val[0]] = [ps.particles[Number(lnks[0])-1]];
				}else if(lnks.length == 2) {
					//				trace("putting 2 interaction" + ky_val[0]);
					ps.interactions[ky_val[0]] = [ps.particles[Number(lnks[0])-1], ps.particles[Number(lnks[1])]-1];
				}
		//		p = ParticleInteractions.XMLFactory(xparticles[i]);
			//	trace("Particle obj " + co);
			//	p.addEventListener(Model.ROTATIONS_CHANGED, ps.redispatchEvent);
			//	ps.particles.push(p);				
			}
			}
			return ps;
		} 
	}
}
