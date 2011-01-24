package mdl {
	import flash.utils.Dictionary;	
	import flash.events.Event;	
	import flash.events.EventDispatcher;	

	/**
	 * @author Troy Gardner
	 */
	public class Model extends CompositeModel {
		public static const POINTS_CHANGED : String = "POINTS_CHANGED";
		public static const COORDS_CHANGED : String = "COORDS_CHANGED";
		public static const ROTATIONS_CHANGED : String = "ROTATIONS_CHANGED";

		public static const MODE_ROTATEHV : String = "MODE_ROTATEHV";
		public static const MODE_ROTATEINTOAXIS : String = "MODE_ROTATEINTOAXIS";

		private var 	_curPointSystem : PointSystem;
		public var pointSystems : Array = new Array();
		public var curUserRotation : Rotations;

		
		
		//// CurrentUIState ////////////
		public var curXaxis : Dimension = Dimension.D1;
		public var curYaxis : Dimension = Dimension.D2;
		public var curZaxis : Dimension = Dimension.D3;
		public var userInteractionMode : String = MODE_ROTATEINTOAXIS;
		public var camera : Camera = new Camera();

		///
		var lastRotations : EightDimensionVector;
		var curRotations : EightDimensionVector = new EightDimensionVector();
		var nextRotations : EightDimensionVector;
		public var zoom : Number = 50;
		//////////// FOR CLICKING and BROWSING INTERACTIONS
		public var firstClicked : EightDimensionParticle;
		public var secondClicked : EightDimensionParticle;
		public var result1 : EightDimensionParticle;
		public var result2 : EightDimensionParticle;
		public var curInteractionKey:String;
		//////////////// COORDINATES /////////////////////
		public static const e8coords : String = "e8coords";
		public static const smcoords : String = "smcoords";
		public static const gutcoords : String = "gutcoords";
		private var _curcoords : Coordinates;
		private var _lastcoords : Coordinates;
		private var _isGUTmode : Boolean;
		private var _lastPointSystem : PointSystem;

		public function set isGUTmode( value : Boolean ) : void {
			_isGUTmode = value;
		}

		public function get isGUTmode( ) : Boolean {
			return _isGUTmode;
		}

		
		public function set curcoords( desCoord : Coordinates ) : void {
			if(desCoord == null) {
				trace("WARNING curcords cannot be set to null");
				return;
			}
			if(_curcoords != desCoord ) {

				if(_curcoords != null) {
					_lastcoords = _curcoords;
				}
				try {
					if(_lastcoords == null){
						///////// FIRST SETUP is E8 no translation needed ////////
					} else {
						trace("=== COORD CHANGE ========================================================");
						trace("Model.curcoords CHANGE to '" + desCoord.internalName + "' from '" + _lastcoords.internalName + "'");
						trace("=========================================================================");
						///////////// TRANSLATING betwen Coordinates /////////////
						var hv : Array;
						var crhv : Array;
						var cr : Rotations;
						var i : int = 0;
						var n : int = 0;
						var fn : Function;
						if(_lastcoords.internalName == e8coords) {
							trace("Going from e8coords");
							if(desCoord.internalName == smcoords) {
								trace("FN using transform_e8coords_To_smcoords");
								fn = transform_e8coords_To_smcoords;
							}else if(desCoord.internalName == gutcoords) {
								trace("FN using transform_e8coords_To_gutcoords");
								fn = transform_e8coords_To_gutcoords;
							} else {
								fn = no_transform;
							}
						} else if(_lastcoords.internalName == smcoords) {
							trace("Going from smcoords");
							if(desCoord.internalName == e8coords) {
								trace("FN using transform_smcoords_To_e8coords");
								fn = transform_smcoords_To_e8coords;
							}else if(desCoord.internalName == gutcoords) {
								trace("FN using transform_smcoords_To_gutcoords");
								fn = transform_smcoords_To_gutcoords;
							} else {
								fn = no_transform;
							}
						} else if(_lastcoords.internalName == gutcoords) {
							trace("Going from gutcoords");
							if(desCoord.internalName == smcoords) {
								trace("FN using transform_gutcoords_To_smcoords");
								fn = transform_gutcoords_To_smcoords;
							}else if(desCoord.internalName == e8coords) {
								trace("FN using transform_gutcoords_To_e8coords");
								fn = transform_gutcoords_To_e8coords;
							} else {
								fn = no_transform;
							}
						}
						if(fn == null) {
							throw new Error("Error invalid coordinate change");
						}
						trace("A CAMERA H " + camera.H.toString());
						trace("A CAMERA V " + camera.V.toString());
						hv = fn(camera.H, camera.V);
						trace("B CAMERA H " + camera.H.toString());
						trace("B CAMERA V " + camera.V.toString());
						//if( coords) {
						i = 0;
						n = coords.rotations.length;
						trace("transform " + n + " rotations " + " in  " + coords.name);
						if(n == 0) {
							throw new Error("Error invalid coordinate change...missing rotations! last " + _lastcoords.name + " cur " + coords.name);
						}
						//for(i = 0; i < n;i++) {
						while( coords.rotations.length > 0) {
							trace("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
							
							cr = coords.rotations.shift() as Rotations;
							trace(" adjusting rotation " + i + " " + cr.name + " " + cr.label);
							crhv = fn(cr.H, cr.V);
							//cr.isE8 = true;
							cr.H = crhv[0];
							cr.V = crhv[1];
							desCoord.rotations.push(cr);
							if(coords.curRotation == cr) {
								trace("XXXXXXXXXXXXXXXXXXXXXXX Found DESIred rotations XXXXXXXXXXXXXXXXXXXXX");
								desCoord.curRotation = cr; 
							}
						}
					
						/*	var coord:Coordinates;
						for(i = 0; i <  curPointSystem.coordinates.length; i++){
						trace("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
							
						coord = curPointSystem.coordinates[i] as Coordinates;
						trace(" adjusting ccord " + i + " " + coord.name + " " + coord.label);
						//crhv = fn(cr.H, cr.V);
						//cr.isE8 = true;
						//coord..H = crhv[0];
						//cr.V = crhv[1];
						
						}*/
						cr = curUserRotation;
						if(cr != null) {
							crhv = fn(cr.H, cr.V);//transform_smcoords_To_e8coords(cr.H, cr.V);
							cr.H = crhv[0];
							cr.V = crhv[1];
							//cr.isE8 = true;
						}
				
				 
						trace("hv " + hv);
						camera.H = hv[0] as EightDimensionVector;
						camera.V = hv[1] as EightDimensionVector;
						desCoord.curRotation = coords.curRotation;		
					}	
					//}
					i = 0;
					if(curPointSystem && curPointSystem.particles) {
						n = curPointSystem.particles.length;
						var cp : EightDimensionParticle;
						trace(" particles " + n);
						for (;i < n; ++i) {
							
							cp = curPointSystem.particles[i] as EightDimensionParticle;
							cp.setCurrentCoordinates(desCoord.id);
							cp = curPointSystem.camera_points[i] as EightDimensionParticle;
							cp.setCurrentCoordinates(desCoord.id);
						}
					}
					/////////    dispatach changed //////////////////
					dispatchEvent(new Event(Model.COORDS_CHANGED));
					//dispatchEvent(new Event(Model.ROTATIONS_CHANGED));
					trace("XXXXXXXXXXXXXXXXXXX DESIRED CURRENT COORDINATES XXXXXXXXXXXXXXXXXXXXXXXXXXX");
					//trace(coords.id + " " + desCoord.id);
					//trace(coords.name + " " + desCoord.name);
					//coords = desCoord ;
					_curcoords = desCoord;
		
					dispatchEvent(new Event(COORDS_CHANGED));
					dispatchEvent(new Event(ROTATIONS_CHANGED));
				}catch(er : Error) {
					throw new Error("Error changing rotations " + er.getStackTrace());
				}
			} else {
				trace("!!!!!!!!!!!!!!!!!!!!!!!!! NO CHANGE IN COORDINATE SYSTEM!!!!!!!!!!!!!!!!!!!!!" + desCoord.name);
				dispatchEvent(new Event(ROTATIONS_CHANGED));
			}
		}

		public function get coords( ) : Coordinates {
			return _curcoords;
		}

		
		
		public function Model() {
			super();
			camera.modl = this;	
		}

		public function get curPointSystem() : PointSystem {
			return _curPointSystem;
		}

		public function set curPointSystem(val : PointSystem) : void {
			_lastPointSystem = _curPointSystem;
			_curPointSystem = val;
			if(_lastPointSystem) {
				trace("set curPointSystem to " + val.name + " from " + _lastPointSystem.name);
			//	_curcoords = null;
			//	curcoords = _lastPointSystem.curCoordinate;
			} else {
			//	curcoords = val.curCoordinate;
			}
			//trace(" curcoords == " + _curcoords.name);
			//dispatach changed
			dispatchEvent(new Event(POINTS_CHANGED));
			dispatchEvent(new Event(COORDS_CHANGED));
			dispatchEvent(new Event(ROTATIONS_CHANGED));
		}

		// transformations of H and V during coordinate changes
		public function no_transform(H : EightDimensionVector ,V : EightDimensionVector  ) : Array {
			return [H, V];
		}

		public function transform_e8coords_To_smcoords( H : EightDimensionVector ,V : EightDimensionVector  ) : Array {
			trace("transform_e8coords_To_smcoords H " + H + " V" + V);
			// transformations of H and H during coordinate cHange
			var V1 : EightDimensionVector = new EightDimensionVector();
			var H1 : EightDimensionVector = new EightDimensionVector();
			// from e8coords to smcoords

			H1.d1 = H.d1;
			H1.d2 = H.d2;
			H1.d3 = -0.7071 * H.d3 + 0.7071 * H.d4;
			H1.d4 = 0.5477 * H.d3 + 0.5477 * H.d4 + 0.3651 * H.d6 + 0.3651 * H.d7 + 0.3651 * H.d8;
			H1.d5 = H.d5;
			H1.d6 = -0.4472 * H.d3 - 0.4472 * H.d4 + 0.4472 * H.d6 + 0.4472 * H.d7 + 0.4472 * H.d8;
			H1.d7 = -0.7071 * H.d6 + 0.7071 * H.d7;
			H1.d8 = -0.4082 * H.d6 - 0.4082 * H.d7 + 0.8165 * H.d8;

			V1.d1 = V.d1;
			V1.d2 = V.d2;
			V1.d3 = -0.7071 * V.d3 + 0.7071 * V.d4;
			V1.d4 = 0.5477 * V.d3 + 0.5477 * V.d4 + 0.3651 * V.d6 + 0.3651 * V.d7 + 0.3651 * V.d8;
			V1.d5 = V.d5;
			V1.d6 = -0.4472 * V.d3 - 0.4472 * V.d4 + 0.4472 * V.d6 + 0.4472 * V.d7 + 0.4472 * V.d8;
			V1.d7 = -0.7071 * V.d6 + 0.7071 * V.d7;
			V1.d8 = -0.4082 * V.d6 - 0.4082 * V.d7 + 0.8165 * V.d8;
			trace("H1 " + H1 + " V1" + V1);
			return [H1, V1];
		}

		public function transform_smcoords_To_e8coords( H : EightDimensionVector ,V : EightDimensionVector  ) : Array {
			trace("transform_smcoords_To_e8coords H " + H + " V" + V);
			// transformations of H and H during coordinate cHange
			var V1 : EightDimensionVector = new EightDimensionVector();
			var H1 : EightDimensionVector = new EightDimensionVector();
			// from smcoords to e8coords

			H1.d1 = H.d1;
			H1.d2 = H.d2;
			H1.d3 = -0.7071 * H.d3 + 0.5477 * H.d4 - 0.4472 * H.d6;
			H1.d4 = 0.7071 * H.d3 + 0.5477 * H.d4 - 0.4472 * H.d6;
			H1.d5 = H.d5;
			H1.d6 = 0.3651 * H.d4 + 0.4472 * H.d6 - 0.7071 * H.d7 - 0.4082 * H.d8;
			H1.d7 = 0.3651 * H.d4 + 0.4472 * H.d6 + 0.7071 * H.d7 - 0.4082 * H.d8;
			H1.d8 = 0.3651 * H.d4 + 0.4472 * H.d6 + 0.8165 * H.d8;

			V1.d1 = V.d1;
			V1.d2 = V.d2;
			V1.d3 = -0.7071 * V.d3 + 0.5477 * V.d4 - 0.4472 * V.d6;
			V1.d4 = 0.7071 * V.d3 + 0.5477 * V.d4 - 0.4472 * V.d6;
			V1.d5 = V.d5;
			V1.d6 = 0.3651 * V.d4 + 0.4472 * V.d6 - 0.7071 * V.d7 - 0.4082 * V.d8;
			V1.d7 = 0.3651 * V.d4 + 0.4472 * V.d6 + 0.7071 * V.d7 - 0.4082 * V.d8;
			V1.d8 = 0.3651 * V.d4 + 0.4472 * V.d6 + 0.8165 * V.d8;
			trace("H1 " + H1 + " V1" + V1);
			return [H1, V1];
		}

		public function transform_e8coords_To_gutcoords( H : EightDimensionVector ,V : EightDimensionVector  ) : Array {
			trace("transform_e8coords_To_gutcoords H " + H + " V" + V);
			// transformations of H and H during coordinate cHange
			var V1 : EightDimensionVector = new EightDimensionVector();
			var H1 : EightDimensionVector = new EightDimensionVector();
			// from e8coords to gutcoords

			H1.d1 = H.d1;
			H1.d2 = H.d2;
			H1.d3 = -0.7071 * H.d3 + 0.7071 * H.d4;
			H1.d4 = 0.7071 * H.d3 + 0.7071 * H.d4;
			H1.d5 = H.d5;
			H1.d6 = 0.5774 * H.d6 + 0.5774 * H.d7 + 0.5774 * H.d8;
			H1.d7 = -0.7071 * H.d6 + 0.7071 * H.d7;
			H1.d8 = -0.4082 * H.d6 - 0.4082 * H.d7 + 0.8165 * H.d8;

			V1.d1 = V.d1;
			V1.d2 = V.d2;
			V1.d3 = -0.7071 * V.d3 + 0.7071 * V.d4;
			V1.d4 = 0.7071 * V.d3 + 0.7071 * V.d4;
			V1.d5 = V.d5;
			V1.d6 = 0.5774 * V.d6 + 0.5774 * V.d7 + 0.5774 * V.d8;
			V1.d7 = -0.7071 * V.d6 + 0.7071 * V.d7;
			V1.d8 = -0.4082 * V.d6 - 0.4082 * V.d7 + 0.8165 * V.d8;
			trace("H1 " + H1 + " V1" + V1);
			return [H1, V1];
		}

		public function transform_gutcoords_To_e8coords( H : EightDimensionVector ,V : EightDimensionVector  ) : Array {
			trace("transform_gutcoords_To_e8coords H " + H + " V" + V);
			// transformations of H and H during coordinate cHange
			var V1 : EightDimensionVector = new EightDimensionVector();
			var H1 : EightDimensionVector = new EightDimensionVector();
			// from gutcoords to e8coords

			H1.d1 = H.d1;
			H1.d2 = H.d2;
			H1.d3 = -0.7071 * H.d3 + 0.7071 * H.d4;
			H1.d4 = 0.7071 * H.d3 + 0.7071 * H.d4;
			H1.d5 = H.d5;
			H1.d6 = 0.5774 * H.d6 - 0.7071 * H.d7 - 0.4082 * H.d8;
			H1.d7 = 0.5774 * H.d6 + 0.7071 * H.d7 - 0.4082 * H.d8;
			H1.d8 = 0.5774 * H.d6 + 0.8165 * H.d8;

			V1.d1 = V.d1;
			V1.d2 = V.d2;
			V1.d3 = -0.7071 * V.d3 + 0.7071 * V.d4;
			V1.d4 = 0.7071 * V.d3 + 0.7071 * V.d4;
			V1.d5 = V.d5;
			V1.d6 = 0.5774 * V.d6 - 0.7071 * V.d7 - 0.4082 * V.d8;
			V1.d7 = 0.5774 * V.d6 + 0.7071 * V.d7 - 0.4082 * V.d8;
			V1.d8 = 0.5774 * V.d6 + 0.8165 * V.d8;
			trace("H1 " + H1 + " V1" + V1);
			return [H1, V1];
		}

		public function transform_gutcoords_To_smcoords( H : EightDimensionVector ,V : EightDimensionVector  ) : Array {
			trace("transform_gutcoords_To_smcoords H " + H + " V" + V);
			// transformations of H and H during coordinate cHange
			var V1 : EightDimensionVector = new EightDimensionVector();
			var H1 : EightDimensionVector = new EightDimensionVector();
			// from gutcoords to smcoords

			H1.d1 = H.d1;
			H1.d2 = H.d2;
			H1.d3 = H.d3;
			H1.d4 = 0.7746 * H.d4 + 0.6325 * H.d6;
			H1.d5 = H.d5;
			H1.d6 = -0.6325 * H.d4 + 0.7746 * H.d6;
			H1.d7 = H.d7;
			H1.d8 = H.d8;

			V1.d1 = V.d1;
			V1.d2 = V.d2;
			V1.d3 = V.d3;
			V1.d4 = 0.7746 * V.d4 + 0.6325 * V.d6;
			V1.d5 = V.d5;
			V1.d6 = -0.6325 * V.d4 + 0.7746 * V.d6;
			V1.d7 = V.d7;
			V1.d8 = V.d8;
			trace("H1 " + H1 + " V1" + V1);
			return [H1, V1];
		}

		public function transform_smcoords_To_gutcoords( H : EightDimensionVector ,V : EightDimensionVector  ) : Array {
			trace("transform_smcoords_To_gutcoords H " + H + " V" + V);
			// transformations of H and H during coordinate cHange
			var V1 : EightDimensionVector = new EightDimensionVector();
			var H1 : EightDimensionVector = new EightDimensionVector();
			// from smcoords to gutcoords

			H1.d1 = H.d1;
			H1.d2 = H.d2;
			H1.d3 = H.d3;
			H1.d4 = 0.7746 * H.d4 - 0.6325 * H.d6;
			H1.d5 = H.d5;
			H1.d6 = 0.6325 * H.d4 + 0.7746 * H.d6;
			H1.d7 = H.d7;
			H1.d8 = H.d8;

			V1.d1 = V.d1;
			V1.d2 = V.d2;
			V1.d3 = V.d3;
			V1.d4 = 0.7746 * V.d4 - 0.6325 * V.d6;
			V1.d5 = V.d5;
			V1.d6 = 0.6325 * V.d4 + 0.7746 * V.d6;
			V1.d7 = V.d7;
			V1.d8 = V.d8;
			trace("H1 " + H1 + " V1" + V1);
			return [H1, V1];
		}

		public function initFromXML(xml : XML) : void {
			pointSystems = new Array();
			//////////////////////////////////////////////////////
			//   GUT Config 
			//////////////////////////////////////////////////////
			var GUTconfigs : XMLList = xml..GUTconfig;
			var GUTconfig : XML = GUTconfigs[0];
			trace("GUTconfig IDs " + GUTconfig.@pids);
			var guTdA : Array = String(GUTconfig.@pids).split(",");
			var gutIDx : Dictionary = new Dictionary();
			while(guTdA.length > 0) {
				var gtid : int = new int(guTdA.pop());
				trace('gtid ' + gtid);
				gutIDx[gtid] = "X";
			}
			guTdA = String(GUTconfig.@hids).split(",");
			while(guTdA.length > 0) {
				gtid = new int(guTdA.pop());
				trace('gtid ' + gtid);
				gutIDx[gtid] = "H";
			}
			 
			var GUTparticle : EightDimensionParticle = EightDimensionParticle.XMLFactory(GUTconfig.p[0]);
			GUTparticle.modl = this;
			var GUTparticle2 : EightDimensionParticle = EightDimensionParticle.XMLFactory(GUTconfig.p[1]);
			GUTparticle2.modl = this;		
			trace("GUTconfig IDs " + GUTparticle.name + " " + GUTparticle.gutcolor + " ");
			//////////////////////////////////////////////////////
			//   Colors
			//////////////////////////////////////////////////////
			var colorsCfg : XMLList = xml.colorConfig.children();
			trace("Colors " + colorsCfg.toString());
			var i : int;
			var n : int;
			i= 0;
			n = colorsCfg.length();
			trace(i + " " + n);
			for (;i < n; ++i) {
				trace(i + "  " + colorsCfg[i].@id + " == " + colorsCfg[i].@rgb);
				var clr:Colors = Colors.parse(colorsCfg[i].@id);
				clr.rgb = new Number(colorsCfg[i].@rgb);
			}
			//////////////////////////////////////////////////////
			//   POINT SYSTEMS 
			//////////////////////////////////////////////////////
			
			//	trace("XML " + example);
			var psys : XMLList = xml..pointSystem;
			//trace("psys " + psys);

			i= 0;
			n = psys.length();
			trace("Found " + n + " PointSystems ");
			var e8PointSystem : PointSystem;
			var stPointSystem : PointSystem;
			for (;i < n; ++i) {
				///////// SETUP E8 first as it's the superset
				// we reuse most the parts in other places //
				trace("  looking for e8 " + psys[i].@name);
				if(psys[i].@name == "E8") {
					trace("E8 PointSystem Found ");
					curPointSystem = PointSystem.XMLFactory(psys[i], gutIDx, GUTparticle, GUTparticle2, this);
					e8PointSystem = curPointSystem;
					curPointSystem.addEventListener(Model.COORDS_CHANGED, redispatchEvent);
					curPointSystem.addEventListener(Model.ROTATIONS_CHANGED, redispatchEvent);
				//	pointSystems.push(curPointSystem); 
				} 
			}
	
			///////// SETUP Everyhting But E8 second /////////////////////////
			trace("=============== CREATING 2ndary Point Systems ============");
			i = 0;
			n = psys.length();
			for (;i < n; ++i) {
				
				trace("---------------------AA-------------------");
				if(psys[i].@name != "E8") {
					trace("---------------------BB-------------------");
					curPointSystem = PointSystem.XMLFactory(psys[i], gutIDx, GUTparticle, GUTparticle2, this);
					trace("---------------------CC-------------------");
					trace("PointSystem Found " + curPointSystem.name);
					trace("PointSystem Found Subset of e8");
					////////////// STANDARD MODEL ///////////////////// 
					// (reuses as much as possible
					// to avoid reparsing 240particles+10K links)
					///////////////////////////////////////////////////

					curPointSystem.axises = e8PointSystem.axises;
					curPointSystem.curPreset = e8PointSystem.curPreset;
					curPointSystem.coordinates = e8PointSystem.coordinates;
					curPointSystem.axises = e8PointSystem.axises;
					curPointSystem.particles = e8PointSystem.particles;
					curPointSystem.camera_points = e8PointSystem.camera_points;
					curPointSystem.trialities = e8PointSystem.trialities;
					curPointSystem.interactions = e8PointSystem.interactions;
					curPointSystem.reverseinteractions = e8PointSystem.reverseinteractions;
					curPointSystem.reverseinteractions2 = e8PointSystem.reverseinteractions2;
					curPointSystem.axises = e8PointSystem.axises;
					//		coords = e8PointSystem.curCoordinate;
					if(curPointSystem.name == "Standard Model") {
						stPointSystem = curPointSystem;
					} 
					curPointSystem.addEventListener(Model.COORDS_CHANGED, redispatchEvent);
					curPointSystem.addEventListener(Model.ROTATIONS_CHANGED, redispatchEvent);
				
					pointSystems.push(curPointSystem);
				} else {
					pointSystems.push(e8PointSystem);
				}
			}
			i = 0;
			n = curPointSystem.coordinates.length;
			for (;i < n; ++i) {
				trace("curPointSystem.coordinates." + curPointSystem.coordinates[i].label);
			}
			curPointSystem.coordinates.sortOn("order", Array.NUMERIC);
			i = 0;
			n = curPointSystem.coordinates.length;
			for (;i < n; ++i) {
				trace("curPointSystem.coordinates." + curPointSystem.coordinates[i].label);
			}
			curcoords = curPointSystem.coordinates[0];
			//		curPointSystem
			///////// SET CURRENT POINTSYSTEM ///////////
			curPointSystem = e8PointSystem;//stPointSystem;//pointSystems[0];

					
			trace("CURRENT POINTSYS " + curPointSystem.name);
			trace("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace("coords " + coords.name);
			trace("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
				
			// dispatchEvent(new Event(POINTS_CHANGED));
		}

		
		function v(w3t : Number = 0,w25 : Number = 0,u3 : Number = 0,v3 : Number = 0,w : Number = 0,x : Number = 0,y : Number = 0,z : Number = 0,sym : String = null, color : String = null, name : String = null) : EightDimensionParticle {
			var res : EightDimensionParticle = new EightDimensionParticle(w3t, w25, u3, v3, w, x, y, z, sym, color, name); 
			return res;
		}

		/***************************************
		 * rotates the system in 8 dimensions
		 * note this function may be tweened by 
		 * some other function.
		 * 
		 */
		public function jumpTo(d1 : Number = 0,d2 : Number = 0,d3 : Number = 0,d4 : Number = 0,d5 : Number = 0,d6 : Number = 0,d7 : Number = 0,d8 : Number = 0) : void {
			//calculate end positions based on garrets algorithm
			// tween to the end position.
		}

		public function rotateH(byVal : Number) : void {
		}

		public function rotateV(byVal : Number) : void {
		}

		public function onChanged() : void {
			//snapshot current point
			//calculate end point
			//calculate diffs between end and start, tween to them
		}
	}
}
