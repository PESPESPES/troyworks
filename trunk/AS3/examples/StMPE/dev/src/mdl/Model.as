package mdl {
	import flash.events.Event;	
	import flash.events.EventDispatcher;	
	
	/**
	 * @author Troy Gardner
	 */
	public class Model extends CompositeModel {
		public static const POINTS_CHANGED:String = "POINTS_CHANGED";
		public static const COORDS_CHANGED:String = "COORDS_CHANGED";
		public static const ROTATIONS_CHANGED:String = "ROTATIONS_CHANGED";
		
		private var 	_curPointSystem : PointSystem;
		
		public static const MODE_ROTATEHV:String = "MODE_ROTATEHV";
		public static const MODE_ROTATEINTOAXIS:String = "MODE_ROTATEINTOAXIS";
		
		public var userInteractionMode:String = MODE_ROTATEINTOAXIS;
		public var pointSystems : Array = new Array();
		public var curUserRotation : Rotations;
		public var camera : Camera = new Camera();
//		public var scene_points : Array;
	//	public var camera_points : Array;
		//// CurrentUIState ////////////

		public var curXaxis : Dimension = Dimension.D1;
		public var curYaxis : Dimension = Dimension.D2;
		public var curZaxis : Dimension = Dimension.D3;

		///
		var lastRotations : EightDimensionVector;
		var curRotations : EightDimensionVector = new EightDimensionVector();
		var nextRotations : EightDimensionVector;
		public var zoom:Number = 50;

		public var firstClicked : EightDimensionParticle;
		public var secondClicked : EightDimensionParticle;
		public var result1 : EightDimensionParticle;
		public var result2 : EightDimensionParticle;
		
		public function Model() {
			super();
			camera.modl = this;	
		}
		public function get curPointSystem():PointSystem{
			return _curPointSystem;
		}
		public function set curPointSystem(val:PointSystem):void{
			 _curPointSystem = val;
			 //dispatach changed
			 dispatchEvent(new Event(POINTS_CHANGED));
			 dispatchEvent(new Event(COORDS_CHANGED));
			 dispatchEvent(new Event(ROTATIONS_CHANGED));
			
		}
		public function transformE8CoordsToPhyCoords( H : EightDimensionVector ,V : EightDimensionVector  ) : Array {
			trace("H "+ H + " V" + V);
			// transformations of H and H during coordinate cHange
			// from e8coords to pHyscoords
		//	var V : EightDimensionVector = camera.V;
		//	var H : EightDimensionVector = camera.H;
			var V1 : EightDimensionVector = new EightDimensionVector();
			var H1 : EightDimensionVector = new EightDimensionVector();
			
			H1.d1 = 0.7071 * H.d1 + 0.7071 * H.d2;
			H1.d2 = -0.7071 * H.d1 + 0.7071 * H.d2;
			H1.d3 = 0.7071 * H.d3 + 0.7071 * H.d4;
			H1.d4 = -0.7071 * H.d3 + 0.7071 * H.d4;
			H1.d5 = H.d5;
			H1.d6 = -0.5774 * H.d6 - 0.5774 * H.d7 - 0.5774 * H.d8;
			H1.d7 = -0.7071 * H.d6 + 0.7071 * H.d7;
			H1.d8 = -0.4082 * H.d6 - 0.4082 * H.d7 + 0.8165 * H.d8;
		
			V1.d1 = 0.7071 * V.d1 + 0.7071 * V.d2;
			V1.d2 = -0.7071 * V.d1 + 0.7071 * V.d2;
			V1.d3 = 0.7071 * V.d3 + 0.7071 * V.d4;
			V1.d4 = -0.7071 * V.d3 + 0.7071 * V.d4;
			V1.d5 = V.d5;
			V1.d6 = -0.5774 * V.d6 - 0.5774 * V.d7 - 0.5774 * V.d8;
			V1.d7 = -0.7071 * V.d6 + 0.7071 * V.d7;
			V1.d8 = -0.4082 * V.d6 - 0.4082 * V.d7 + 0.8165 * V.d8;
			//camera.H = H1;
			//camera.V = V1;
			trace("H1 "+ H1 + " V1" + V1);
			return [H1, V1];
		}

		public function transformPhyCoordsToE8Coords(H : EightDimensionVector ,V : EightDimensionVector  ) : Array {
			trace("H "+ H + " V" + V);
			// from physcoords to e8coords
//			var V : EightDimensionVector = camera.V;
//			var H : EightDimensionVector = camera.H;
			var V1 : EightDimensionVector = new EightDimensionVector();
			var H1 : EightDimensionVector = new EightDimensionVector();
			H1.d1 = 0.7071 * H.d1 - 0.7071 * H.d2;
			H1.d2 = 0.7071 * H.d1 + 0.7071 * H.d2;
			H1.d3 = 0.7071 * H.d3 - 0.7071 * H.d4;
			H1.d4 = 0.7071 * H.d3 + 0.7071 * H.d4;
			H1.d5 = H.d5;
			H1.d6 = -0.5774 * H.d6 - 0.7072 * H.d7 - 0.4082 * H.d8;
			H1.d7 = -0.5774 * H.d6 + 0.7071 * H.d7 - 0.4082 * H.d8;
			H1.d8 = -0.5774 * H.d6 + 0.8165 * H.d8;
		
			V1.d1 = 0.7071 * V.d1 - 0.7071 * V.d2;
			V1.d2 = 0.7071 * V.d1 + 0.7071 * V.d2;
			V1.d3 = 0.7071 * V.d3 - 0.7071 * V.d4;
			V1.d4 = 0.7071 * V.d3 + 0.7071 * V.d4;
			V1.d5 = V.d5;
			V1.d6 = -0.5774 * V.d6 - 0.7072 * V.d7 - 0.4082 * V.d8;
			V1.d7 = -0.5774 * V.d6 + 0.7071 * V.d7 - 0.4082 * V.d8;
			V1.d8 = -0.5774 * V.d6 + 0.8165 * V.d8;
//			camera.H = H1;
//			camera.V = V1;
			trace("H1 "+ H1 + " V1" + V1);
			return [H1, V1];
		}
		public function initFromXML(xml : XML) : void {
			pointSystems = new Array();
				
			//	trace("XML " + example);
			var psys : XMLList = xml..pointSystem;
			//trace("psys " + psys);
				
			var i : int = 0;
			var n : int = psys.length();
				
				
			for (;i < n; ++i) {
				trace(i);
				curPointSystem = PointSystem.XMLFactory(psys[i]);
				curPointSystem.addEventListener(Model.COORDS_CHANGED, redispatchEvent);
				curPointSystem.addEventListener(Model.ROTATIONS_CHANGED, redispatchEvent);
				pointSystems.push(curPointSystem); 
			}
			var smPointSystem:PointSystem = new PointSystem();
			smPointSystem.name  = "Standard Points";
			smPointSystem.axises = curPointSystem.axises;
			smPointSystem.curPreset = curPointSystem.curPreset;
			smPointSystem.coordinates = curPointSystem.coordinates;
			smPointSystem.axises = curPointSystem.axises;
			smPointSystem.particles = curPointSystem.particles;
			smPointSystem.camera_points = curPointSystem.camera_points;
			smPointSystem.trialities = curPointSystem.trialities;
			smPointSystem.interactions = curPointSystem.interactions;
			smPointSystem.axises = curPointSystem.axises;
			smPointSystem.axises = curPointSystem.axises;
			smPointSystem.curCoordinate = curPointSystem.curCoordinate;
			pointSystems.push(smPointSystem);

			curPointSystem = pointSystems[0];
			trace("CURRENT POINTSYS "+ curPointSystem);
		}
	
		/*public function initializePoints() : void {
			scene_points = [v(50, 50, 50, 0, 0, 0, 0, 0, "mcirc", "lgray", "a"),
							v(-50, 50, 50, 0, 0, 0, 0, 0, "mcirc", "lgray", "b"), 
							v(50, -50, 50, 0, 0, 0, 0, 0, "mcirc", "lgray", "c"), 
							v(-50, -50, 50, 0, 0, 0, 0, 0, "mcirc", "lgray", "d"),
							v(50, 50, -50, 0, 0, 0, 0, 0, "mcirc", "lgray", "e"), 
							v(-50, 50, -50, 0, 0, 0, 0, 0, "mcirc", "lgray", "f"),
							v(50, -50, -50, 0, 0, 0, 0, 0, "mcirc", "lgray", "g"),
							v(-50, -50, -50, 0, 0, 0, 0, 0, "mcirc", "lgray", "h"),
							v(50, 50, 0, 0, 0, 0, 0, 0, "mcirc", "lgray", "i"),
							v(-50, 50, 0, 0, 0, 0, 0, 0, "mcirc", "lgray", "j"),
							v(-50, -50, 0, 0, 0, 0, 0, 0, "mcirc", "lgray", "k"),
							v(50, -50, 0, 0, 0, 0, 0, 0, "mcirc", "lgray", "l"),
							v(0, 50, 50, 0, 0, 0, 0, 0, "mcirc", "lgray", "m"),
							v(-50, 0, -50, 0, 0, 0, 0, 0, "mcirc", "lgray", "n"),
							v(0, -50, 50, 0, 0, 0, 0, 0, "mcirc", "lgray", "o"),
							v(50, 0, -50, 0, 0, 0, 0, 0, "mcirc", "lgray", "p")];
			var i : int = 0;
			var n : int = scene_points.length;
			camera_points = new Array();
			for (;i < n; ++i) {
				camera_points.push(v(0, 0, 0));				
			}
		}*/

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
