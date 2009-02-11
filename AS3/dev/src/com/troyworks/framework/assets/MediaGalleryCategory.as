package  com.troyworks.framework.assets{ 
	class MediaGalleryCategory extends Object {
		protected var _name : String;
		protected var _value:int;
		//natively supported
		//images
		public static var UNDEFINED:MediaGalleryCategory = new MediaGalleryCategory(0, "UNDEFINED");
		public static var IMAGE:MediaGalleryCategory = new MediaGalleryCategory(1, "IMAGE");
		public static var MAP:MediaGalleryCategory = new MediaGalleryCategory(2, "MAP");
		public static var INTERACTIVE:MediaGalleryCategory = new MediaGalleryCategory(4, "INTERACTIVE");
		public static var CHART:MediaGalleryCategory = new MediaGalleryCategory(8, "CHART");
	
		//timeline based
		public static var AUDIO:MediaGalleryCategory = new MediaGalleryCategory(16, "AUDIO");
		public static var GRAPH:MediaGalleryCategory = new MediaGalleryCategory(32, "GRAPH");
		public static var VIDEO:MediaGalleryCategory = new MediaGalleryCategory(64, "VIDEO");
	
		public static var USERIMAGE:MediaGalleryCategory = new MediaGalleryCategory(128, "USERIMAGE");
	
		//special
		public static var HELP:MediaGalleryCategory = new MediaGalleryCategory(256, "HELP");
		public static var OVERVIEW:MediaGalleryCategory = new MediaGalleryCategory(512, "OVERVIEW");
		public static var ATLAS:MediaGalleryCategory = new MediaGalleryCategory(1024, "ATLAS");
	
	
		public static var CHART_GRAPH:MediaGalleryCategory = new MediaGalleryCategory(CHART | GRAPH, "CHART_GRAPH");
	//	public static var __:MediaGalleryCategory = 128;
	//	public static var __:MediaGalleryCategory = 1024;
		public static var ALL:MediaGalleryCategory = new MediaGalleryCategory(IMAGE | MAP |INTERACTIVE | CHART | AUDIO | GRAPH | VIDEO | USERIMAGE, "ALL");
		public static var __labels:Object;
		
	
		
		protected function MediaGalleryCategory (val : int, name : String = "")
		{
			_value = val;
			_name = name;
		}
		
	    public static function constructLabels():void{
			MediaGalleryCategory.__labels = new Object();
			for(var i in MediaGalleryCategory){
				var s:String = String(i);
				MediaGalleryCategory.__labels[MediaGalleryCategory[i]] = s;
				//trace(s + " " +	MediaGalleryCategory[i]);
			}
		}
		public static function getLabel(typeVal:Number):String{
			return MediaGalleryCategory.__labels[typeVal];
		}
		public static function parse(o:Object):MediaGalleryCategory{
		//trace("MediaGalleryCategory parsing " + o);
			var n:Number = -1;
			if( typeof(o) == "string"){
				n = parseInt(String(o));
			}else if(typeof(o)== "number"){
				n = Number(o);
			}else {
				return null;
			}
			if(n == CHART || n == GRAPH){
				return CHART_GRAPH;
			}else{
				for(var i in MediaGalleryCategory){
	
				//trace(i +" " + MediaGalleryCategory[i] + " ==?"+ (MediaGalleryCategory[i] == n));
					var f = MediaGalleryCategory[i];
					if(f == n){
						return MediaGalleryCategory[i];
					}
				}
			}
	
		}
	
	
	}
	
}