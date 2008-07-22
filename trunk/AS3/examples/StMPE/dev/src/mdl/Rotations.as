package mdl {
	import flash.events.EventDispatcher;	

	/**
	 * @author Troy Gardner
	 */
	public class Rotations extends EventDispatcher {
		public var icon : String = "";
		public var name : String;
		public var hv : Array = [[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]];
		public var isUser:Boolean = false;
		public var isDirty:Boolean = false;
		public var isSaved:Boolean = false;
		
		public function Rotations() {
			super();
		}

		public static function XMLFactory(xml : XML) : Rotations {
			trace("Rotations XMLFactory");
			var res : Rotations = new Rotations();
			//	res.icon = xml.@icon;
			res.name = String(xml.@name);
			res.hv = new Array();
			//hv="0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0"
			var hv : String = String(xml.@hv);
			trace("hv " + hv);
			var ary : Array = hv.split(";");
			trace("hv arry " + ary + " " + ary.length);
			var i : int = 0;
			var n : int = ary.length;
					
			for (;i < n; ++i) {
						
				trace(i + " " + ary[i]);
				res.hv.push(ary[i].split(","));
			}
					
			return res;
		}
	}
}
