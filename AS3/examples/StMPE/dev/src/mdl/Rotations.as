package mdl {
	import flash.events.EventDispatcher;	

	/**
	 * @author Troy Gardner
	 */
	public class Rotations extends EventDispatcher {
		public var icon : String = "";
		public var name : String;
		//public var hv : Array = [[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]];
		
		public var V : EightDimensionVector = new EightDimensionVector();
		public var H : EightDimensionVector = new EightDimensionVector();
		public var isUser:Boolean = false;
		public var isDirty:Boolean = false;
		public var isSaved:Boolean = false;
		public var isE8:Boolean = false;
		public var selectedHAxisIdx:int = 0;
		public var selectedVAxisIdx:int = 0;
		
		public function Rotations() {
			super();
		}
		public function get label():String{
			return name;
		}

		public static function XMLFactory(xml : XML) : Rotations {
			trace("Rotations XMLFactory");
			var res : Rotations = new Rotations();
			//	res.icon = xml.@icon;
			res.name = String(xml.@name);
	//		res.hv = new Array();
			//hv="0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0"
			var hv : String = String(xml.@hv);
		//	trace("hv " + hv);
			var ary : Array = hv.split(";");
			//trace("hv arry " + ary + " " + ary.length);
			var i : int = 0;
			var n : int = ary.length;
			var hvr:Array;		
			for (;i < n; ++i) {
				hvr = ary[i].split(",");
			//	trace("hvr " + hvr.join(","));
			//	trace(i + " " + ary[i]);
//				res.hv.push(ary[i].split(","));
				hvr = ary[i].split(",");
				res.H["d"+(i+1)] = hvr[0];
				res.V["d"+(i+1)] = hvr[1];
				//trace(res.H.d1 + " "+ res.V.d1); 
			}
			res.selectedHAxisIdx = int(xml.@h);
			res.selectedVAxisIdx = int(xml.@v);
			res.isE8 = (xml.@isE8== "true");
					
			return res;
		}
	}
}
