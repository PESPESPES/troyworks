package mdl {
	import flash.net.SharedObject;	
	import flash.events.EventDispatcher;
	import flash.events.Event;	

	/**
	 * @author Troy Gardner
	 */
	public class Coordinates extends CompositeModel {
		public var id : Number;
		public var icon : String = "";
		public var name : String;
		public var coordLabels : Array;
		public var _curRotation : Rotations;
		public var rotations : Array;

		public function Coordinates() {
			super();
		}

		public function get curRotation() : Rotations {
			return _curRotation ;
		}

		public function set curRotation(val : Rotations) : void {
			_curRotation = val;
			//dispatach changed
			dispatchEvent(new Event(Model.ROTATIONS_CHANGED));
		}

		public static function XMLFactory(xml : XML, ps : PointSystem, id : Number) : Coordinates {
			trace("Coordinates XMLFactory");
			/*       <system name="Physics coords" coordlbl="1/2:w^3:L,1/2:w^3:R,W^3,:B^3:1,w,:B:2,g^3,g^8">
			<rotations>
			<r name="Home" hv="0,1;1,0;0,0;0,0;0,0;0,0;0,0;0,0"h="0" v="1" />			           
			</rotations>
			<coords>*/
			var res : Coordinates = new Coordinates();
			res.id = id;
			res.name = String(xml.@name);
			res.coordLabels = String(xml.@coordlbl).split(",");
			trace(" coordinate lables " + res.coordLabels.join("\r"));
			///////////////////////////////////////////////////////////
			//    PARSE ROTATIONS
			//////////////////////////////////////////////////////////
			var rotations : XMLList = xml..r;
			var i : int = 0;
			var n : int = rotations.length();
			
			res.rotations = new Array();
			trace("found rotations=========" + rotations.length());
			var ro : Rotations;
			for (;i < n; ++i) {
				trace("rotation " + rotations[i]);
				ro = Rotations.XMLFactory(rotations[i]);
				//	ro.addEventListener(type, listener)
				res.rotations.push(ro);
			}
			var so : SharedObject = SharedObject.getLocal("StMPE_Rotations", "/");
			if(so.data[res.name + "Rotations"] != null) {
				var rot : Array = so.data[res.name + "Rotations"] as Array;
				////////////// RESTORE FROM SHARED OBJECT //////////
				for (;i < n; ++i) {
			 		//res.rotations.push()	
			 	}
			}

			res.curRotation = res.rotations[0];
			trace("curRotation " + res.curRotation.name);
			///////////////////////////////////////////////////////////
			//    PARSE COORDINATES
			//////////////////////////////////////////////////////////
			var coordsForParticles : XMLList = xml..pc;
			i = 0;
			n = coordsForParticles.length();
			var lblidx : Object = new Object();
			var lblRes : Array = new Array();
			var pcord : EightDimensionParticleLabelledCoordinates;
			trace("pasing coordinates " + n);
			for (;i < n; ++i) {
				//trace("coordsForParticles " + coordsForParticles[i]);
				pcord = new EightDimensionParticleLabelledCoordinates();
				////////////// ID //////////////////////////////////
				var idx : Number = Number(coordsForParticles[i].@id) - 1;
				//trace("setting coords["+id+"] for particle idx " + i);
				////////////// COORDINATE ////////////////////////
				var coord : Array = String(coordsForParticles[i].@coord).split(",");
			//	trace("coords " + coord.join(","));
				pcord.d1 = Number(coord[0]);
				pcord.d2 = Number(coord[1]);
				pcord.d3 = Number(coord[2]);
				pcord.d4 = Number(coord[3]);
				pcord.d5 = Number(coord[4]);
				pcord.d6 = Number(coord[5]);
				pcord.d7 = Number(coord[6]);
				pcord.d8 = Number(coord[7]);
	

				////////////// COORDINATE LABEL  ////////////////////////
				var coordLbl : Array = String(coordsForParticles[i].@lbl).split(",");
			
				pcord.d1Lbl = coordLbl[0];
				pcord.d2Lbl = coordLbl[1];
				pcord.d3Lbl = coordLbl[2];
				pcord.d4Lbl = coordLbl[3];
				pcord.d5Lbl = coordLbl[4];
				pcord.d6Lbl = coordLbl[5];
				pcord.d7Lbl = coordLbl[6];
				pcord.d8Lbl = coordLbl[7];
				
			/*	trace("pcord.d1Lbl " + pcord.d1Lbl);
				trace("pcord.d2Lbl " + pcord.d2Lbl);
				trace("pcord.d3Lbl " + pcord.d3Lbl);
				trace("pcord.d4Lbl " + pcord.d4Lbl);
				trace("pcord.d5Lbl " + pcord.d5Lbl);
				trace("pcord.d6Lbl " + pcord.d6Lbl);
				trace("pcord.d7Lbl " + pcord.d7Lbl);
				trace("pcord.d8Lbl " + pcord.d8Lbl);
				if(lblidx[pcord.d1Lbl] == null) {
					lblidx[pcord.d1Lbl] = true;
					trace("adding " + pcord.d1Lbl);
					lblRes.push(pcord.d1Lbl);
				}
				if(lblidx[pcord.d2Lbl] == null) {
					lblidx[pcord.d2Lbl] = true;
					trace("adding " + pcord.d2Lbl);
					lblRes.push(pcord.d2Lbl);
				}
				if(lblidx[pcord.d3Lbl] == null) {
					lblidx[pcord.d3Lbl] = true;
					trace("adding " + pcord.d3Lbl);
					lblRes.push(pcord.d3Lbl);
				}
				if(lblidx[pcord.d4Lbl] == null) {
					lblidx[pcord.d4Lbl] = true;
					trace("adding " + pcord.d4Lbl);
					lblRes.push(pcord.d4Lbl);
				}
				if(lblidx[pcord.d5Lbl] == null) {
					lblidx[pcord.d5Lbl] = true;
					trace("adding " + pcord.d5Lbl);
					lblRes.push(pcord.d5Lbl);
				}
				if(lblidx[pcord.d6Lbl] == null) {
					lblidx[pcord.d6Lbl] = true;
					trace("adding " + pcord.d6Lbl);
					lblRes.push(pcord.d6Lbl);
				}
				if(lblidx[pcord.d7Lbl] == null) {
					lblidx[pcord.d7Lbl] = true;
					trace("adding " + pcord.d7Lbl);
					lblRes.push(pcord.d7Lbl);
				}
				if(lblidx[pcord.d8Lbl] == null) {
					lblidx[pcord.d8Lbl] = true;
					trace("adding " + pcord.d8Lbl);
					lblRes.push(pcord.d8Lbl);
				}*/

				
				(ps.particles[i] as EightDimensionParticle).coords[id] = (pcord);
				//trace((ps.particles[i] as EightDimensionParticle).coords.length);
			}
			/*(trace("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace("XXXXXXXXXXXXXXXXX COORD LABEL XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace(lblRes.join("\r"));
			trace("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
			trace("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");*/
						
			return res;
		}
	}
}
