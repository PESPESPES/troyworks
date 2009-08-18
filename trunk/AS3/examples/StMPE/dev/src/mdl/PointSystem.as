﻿package mdl {
	import com.troyworks.data.Default;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;		

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
		public var trialities : Array;
		public var interactions : Dictionary;

		private var i : int;
		private var n : int;
		// use Grand Unified Theory labels and colors
		public var useGut : Boolean;

		public function PointSystem() {
			super();
		}

		/*public function get curCoordinate() : Coordinates {
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
		}*/

		public static function XMLFactory(xml : XML, gutIDx : Dictionary, GUTparticle : EightDimensionParticle, GUTparticle2 : EightDimensionParticle, mdlx:Model) : PointSystem {
			//	trace("!!!!!!!!!!!!!!!XMLFactory!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			//	trace(xml.toXMLString());
			//	trace("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			var ps : PointSystem = new PointSystem();
			ps.name = String(xml.@name);
			ps.useGut = Default.getBooleanFromString(xml.@useGut, false);
			trace("====================================================");
			trace("new PointSystem.XMLFactory " + ps.name);
			trace("====================================================");
			var i : int;
			var n : int;	
			
			//////////////////////////////////////////////////////////////////
			///                  VISUALIZE THE AXISES                      ///
			//////////////////////////////////////////////////////////////////
			var p1 : EightDimensionParticle;
			var p2 : EightDimensionParticle;
			i = 0;
			n = Dimension.EIGHTD.length;
			trace("found AXISeS " + n + " =========================================");	
			ps.axises = new Array();
			for(;i < n;++i) {
	
				var dm : EightDimensionVector = Dimension.EIGHTD[i];
				p1 = new EightDimensionParticle();
				p2 = new EightDimensionParticle();
					
				var p1v : EightDimensionVector = dm.clone();
				p1v.multiply(.5);
				p1.name + "AxisD" + i + "_A";
				p1.setPosition(p1v);
				var p2v : EightDimensionVector = dm.clone();
				
				p2v.multiply(-.5);
				trace("  " + i + "  p1v " + p1v + " p2v " + p2v);
				p2.setPosition(p2v);
				p2.name + "AxisD" + i + "_B";
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
			//	var idx:Object = new Object();

			for (;i < n; ++i) {
	
				p = EightDimensionParticle.XMLFactory(xparticles[i]);
				
				p.id = i + 1; //1 based
				///////////////// UPDATE PARTICLES WITH GUT GRAPHICS /////////////
				if(gutIDx[p.id] == "X") {
					trace("FOUND CONVENTIONAL GUT Particle");
					p.gutcolor = GUTparticle.gutcolor;
					p.gutcolorObj = GUTparticle.gutcolorObj;
					p.gutcoord = GUTparticle.gutcoord;
					p.gutlabel = GUTparticle.gutlabel;
					p.gutshape = GUTparticle.gutshape;
					p.gutname = GUTparticle.gutname;
					p.isGUT = true;
				} else 	if(gutIDx[p.id] == "H") {
				
					trace("FOUND HIGGS GUT Particle");
					p.gutcolor = GUTparticle2.gutcolor;
					p.gutcolorObj = GUTparticle2.gutcolorObj;
					p.gutcoord = GUTparticle2.gutcoord;
					p.gutlabel = GUTparticle2.gutlabel;
					p.gutshape = GUTparticle2.gutshape;
					p.gutname = GUTparticle2.gutname;
					p.isGUT = true;
				} else {
					trace("FOUND NON GUT Particle " + i);
				}
				/*
				 * REPARSING IDs................ 
				var pstr:String =  xparticles[i].toXMLString();
				var an:String = 'name="';
				var bn:String = '" e8coordlbl';
				var ai:int = pstr.indexOf(an);
				var bi:int = pstr.indexOf(bn);
				var pnamA:String = pstr.substring(0, ai + an.length );
				var pnam:String = pstr.substring(ai + an.length , bi);
				var pnamB:String = pstr.substring(bi, pstr.length);
				/////////////////////////////////////////////
				if(idx[pnam] == null){
				idx[pnam] = p.id;
				trace(pnamA +  p.id + pnamB);
				}else{
				//trace("found duplicate" + idx[pnam] + " at " + p.id);
				trace(pnamA +  idx[pnam] + pnamB);
				}*/
				//	trace("Particle " + i + " " + pnam);
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
			n = coords.length();
			trace("found " + n + " Coordinate Systems  =========================================");
			var curCord : Coordinates;
			if(n > 0) {
				ps.coordinates = new Array();
				var co : Coordinates;
				for (;i < n; ++i) {
					//	trace("Coord " + i + " " + coords[i].toXMLString());
					co = Coordinates.XMLFactory(coords[i], ps, i);
					trace("Coord obj " + co.label);
					co.addEventListener(Model.ROTATIONS_CHANGED, ps.redispatchEvent);
					ps.coordinates.push(co);
					if(co.isDefault) {
						trace("isDefault " + co);
						mdlx.curcoords  = co;
					}
				}
			
				//ps.curCoordinate = ps.coordinates[0];
				//mdlx.curcoords =  ps.coordinates[0];
				//ps.curCoordinate = curCord;//
				//trace("CUR COORDI " + ps.curCoordinate);
			}
			
			///////////////////////////////////////////////////////////////////////
			///           INTERACTIONS BETWEEN PARTICLES       (must go after Particles!              ///
			//////////////////////////////////////////////////////////////////////			
			ps.interactions = new Dictionary(true);
			var xparticlInteractions : XMLList = xml..i;
			//trace("xparticlInteractions " + xparticlInteractions.toXMLString());
			//throw new Error("DEBUGGING BREAK");
			var pi : ParticleInteractions;
			i = 0;
			n = xparticlInteractions.length();
			var ky_val : Array;
			var lnks : Array;
			var keys : Array;
			var pk : Number;
			var sk : Number;
			trace("Found " + n + " interactions====================================");
			//XXX 
			if(true && n > 0) {
				try {
					for (;i < n; ++i) {
						//trace("PInteraction " + i + " " + xparticlInteractions[i].toXMLString());
						ky_val = String(xparticlInteractions[i].@lnk).split("=");
						lnks = ky_val[1].split(",");
						keys = ky_val[0].split(",");
						if(keys.length == 2) {
							// given a particle has many outgoing links we need to put them into a single array on the particle
							pk = Number(keys[0] - 1);
							sk = Number(keys[1] - 1);
							//trace();
							//trace(" pk " + pk + "pFrom " +ps.particles[pk] +"  "+ " sk " + sk +" "  + ps.particles[sk]);
							//					trace("pFrom " +ps.particles[pk] );
							/////////// BIDIRECTIONAL LINK
							ps.particles[pk].outboundParticleLinks.push(ps.particles[sk]);
							ps.particles[sk].outboundParticleLinks.push(ps.particles[pk]);
						}
						if(lnks.length == 1) {
							//					trace("putting 1 interaction" + ky_val[0]);
							ps.interactions[ky_val[0]] = [ps.particles[Number(lnks[0]) - 1]];
							ps.interactions[keys[1]+","+keys[0]] = [ps.particles[Number(lnks[0]) - 1]];
						}else if(lnks.length == 2) {
							//								trace("putting 2 interaction" + ky_val[0] + "  "+ ps.particles[Number(lnks[0])-1] + " " +  ps.particles[Number(lnks[1])]-1]);
							ps.interactions[ky_val[0]] = [ps.particles[Number(lnks[0]) - 1], ps.particles[Number(lnks[1]) - 1]];
							ps.interactions[keys[1]+","+keys[0]] = [ps.particles[Number(lnks[0]) - 1], ps.particles[Number(lnks[1]) - 1]];
						}
		//		p = ParticleInteractions.XMLFactory(xparticles[i]);
			//	trace("Particle obj " + co);
			//	p.addEventListener(Model.ROTATIONS_CHANGED, ps.redispatchEvent);
			//	ps.particles.push(p);				
					}
				}catch(er : Error) {
				//	throw new Error("ERROR in PointSystem.XMLFactory parsing interactions " +  xparticlInteractions[i].toXMLString() +  " " + er.getStackTrace());
				}
			}
			///////////////////////////////////////////////////////////////////////
			///           CREATE TRIALITIES      (must go after Particles!              ///
			//////////////////////////////////////////////////////////////////////			
			ps.trialities = new Array();
			var tri : XMLList = xml..trialities.t;
			i = 0;
			n = tri.length();
			trace("Found " + n + " trialities ====================================");
			for (;i < n; ++i) {
				//trace("PInteraction " + i + " " + xparticlInteractions[i].toXMLString());
				lnks = String(tri[i].@lnk).split(",");
				//	trace(" triality " + lnks.join(","));
				ps.trialities.push([ps.particles[Number(lnks[0]) - 1], ps.particles[Number(lnks[1]) - 1],ps.particles[Number(lnks[2]) - 1]]);
			}
			trace("Finished PointSystem ////////////////////////////////////////////////");
			trace("returning " + ps);
			return ps;
		} 
	}
}
