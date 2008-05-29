package  { 
	class com.troyworks.framework.assets.MediaType extends Number {
		protected function MediaType(value:Number){
			super(value);
		}
		//natively supported
		//images
		public static var JPG:MediaType = new MediaType(0);
		public static var GIF:MediaType = new MediaType(1);
		public static var PNG:MediaType = new MediaType(2);
		public static var ZOOMABLE:MediaType = new MediaType(4);
	
		//timeline based
		public static var SWF:MediaType = new MediaType(8);
		public static var MP3:MediaType = new MediaType(16);
		public static var FLV:MediaType = new MediaType(32);
		public static var HTM:MediaType = new MediaType(64);
		public static var PRODUCT:MediaType = new MediaType(128);
		public static var PRODUCT_CLIP:MediaType = new MediaType(256);
		//	public static var __:Number = new MediaType(512);
		public static var PDF:MediaType = new MediaType(1024);
	
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