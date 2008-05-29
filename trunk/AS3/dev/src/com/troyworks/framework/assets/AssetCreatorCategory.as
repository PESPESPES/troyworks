package  { 
	class com.troyworks.framework.assets.AssetCreatorCategory extends Number{
	
	
		public static var USER:AssetCreatorCategory =  new AssetCreatorCategory(0, "USER");
		public static var SYSTEM:AssetCreatorCategory =  new AssetCreatorCategory(1, "SYSTEM");
		public static var APPLICATION:AssetCreatorCategory =  new AssetCreatorCategory(4, "APPLICATION");
		public static var UNKNOWN:AssetCreatorCategory = new AssetCreatorCategory(8, "UNKNOWN");
	
		
	
		protected var __name : String;
		protected function AssetCreatorCategory (val : Number, name : String)
		{
			super (val);
			this.__name = name;
		}
		public function get name():String{
			return this.__name;
		}
		////////////////////////////////
		//var a = AssetCreatorCategory.MCDOUGAL;
		//trace(a + " " + Number(a) + " " + String(a));
		//returns 1 1 MCDOUGAL1
	//	public function toString():String{
	//		return this.name + super.toString();
	//	}
		public static function parse(o:Object):AssetCreatorCategory{
			var n:Number = -1;
			if( typeof(o) == "string"){
				n = parseInt(String(o));
			}else if(typeof(o)== "number"){
				n = Number(o);
			}else {
				return AssetCreatorCategory.UNKNOWN;
			}
			for(var i in AssetCreatorCategory){
			//	trace("comparing " + i + AssetCreatorCategory[i]);
				var obj:AssetCreatorCategory =  AssetCreatorCategory[i];
				if(n ==  obj ){
					return AssetCreatorCategory[i];
				}
			}
			return AssetCreatorCategory.UNKNOWN;
		}
	}
}