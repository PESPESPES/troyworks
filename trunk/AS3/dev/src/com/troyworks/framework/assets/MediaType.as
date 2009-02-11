package  com.troyworks.framework.assets{ 
	class MediaType extends Object {
		protected var _name : String;
		protected var _value:int;
		
		protected function MediaType(val : int, name : String)
		{
			_value = val;
			_name = name;
		}
		//natively supported
		//images
		public static var JPG:MediaType = new MediaType(0, "JPG");
		public static var GIF:MediaType = new MediaType(1, "GIF");
		public static var PNG:MediaType = new MediaType(2, "PNG");
		public static var ZOOMABLE:MediaType = new MediaType(4, "ZOOMABLE");
	
		//timeline based
		public static var SWF:MediaType = new MediaType(8, "SWF");
		public static var MP3:MediaType = new MediaType(16, "MP3");
		public static var FLV:MediaType = new MediaType(32, "FLV");
		public static var HTM:MediaType = new MediaType(64, "HTM");
		public static var PRODUCT:MediaType = new MediaType(128, "PRODUCT");
		public static var PRODUCT_CLIP:MediaType = new MediaType(256, "PRODUCT_CLIP");
		//	public static var __:Number = new MediaType(512, "JPG");
		public static var PDF:MediaType = new MediaType(1024, "PDF");
	
	//	public static var ALL:MediaType = new MediaType(JPG | GIF | PNG | SNOW | MX | MORE);
		public static var __labels : Object;
		//needed for compiler to work correctly
		protected static var self : MediaType;
		public static function constructLabels () : void
		{
			MediaType.__labels = new Object ();
			for (var i:String in MediaType)
			{
				var s : String = String (i);
				MediaType.__labels [MediaType [i]] = s;
				//trace(s + " " +	MediaType[i]);
	
			}
		}
		/////////////////////////////////////////////////
		public static function parse(o:Object):MediaType{
			var n:Number = -1;
			if( typeof(o) == "string"){
				n = parseInt(String(o));
			}else if(typeof(o)== "number"){
				n = Number(o);
			}else {
				return null;
			}
	        for(var i:String in MediaType){
	
				//trace(i +" " + MediaType[i] + " ==?"+ (MediaType[i] == n));
				var f:MediaType = MediaType(MediaType[i]);
				if(f == n){
					return f;
				}
			}
	
		}
	
	}
	
}