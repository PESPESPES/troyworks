package mdl {
	import com.troyworks.data.Default;	

	import flash.net.SharedObject;	
	import flash.events.EventDispatcher;
	import flash.events.Event;	

	/**
	 * @author Troy Gardner
	 */
	public class Coordinates extends CompositeModel {
		public var id : Number;
		public var internalName : String;
		public var icon : String = "";
		public var name : String;
		public var coordLabels : Array;
		public var _curRotation : Rotations;
		public var rotations : Array;
		public var isDefault : Boolean;
		public var order : Number = 0;

		public function Coordinates() {
			super();
		}

		public function get label() : String {
			return name;
		}

		public function get data() : String {
			return internalName;
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
			res.isDefault = Default.getBooleanFromString(xml.@default, false);
			res.id = id;
			res.internalName = String(xml.@id);
			res.name = String(xml.@name);
			res.order = Number(xml.@order);
			trace(" Coordinate " + res.name + " isDefault?" + res.isDefault);
			res.coordLabels = String(xml.@coordlbl).split(",");
			trace(" coordinate lables\r " + res.coordLabels.join("\r\t"));
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
				//trace("trying rotation " + i);
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
			if(res.rotations.length > 0) {
				res.curRotation = res.rotations[0];
				trace("curRotation " + res.curRotation.name);
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
