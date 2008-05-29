package  { 
	class com.troyworks.framework.assets.MediaGalleryCategory extends Number {
		//natively supported
		//images
		public static var UNDEFINED:MediaGalleryCategory = new MediaGalleryCategory(0);
		public static var IMAGE:MediaGalleryCategory = new MediaGalleryCategory(1);
		public static var MAP:MediaGalleryCategory = new MediaGalleryCategory(2);
		public static var INTERACTIVE:MediaGalleryCategory = new MediaGalleryCategory(4);
		public static var CHART:MediaGalleryCategory = new MediaGalleryCategory(8);
	
		//timeline based
		public static var AUDIO:MediaGalleryCategory = new MediaGalleryCategory(16);
		public static var GRAPH:MediaGalleryCategory = new MediaGalleryCategory(32);
		public static var VIDEO:MediaGalleryCategory = new MediaGalleryCategory(64);
	
		public static var USERIMAGE:MediaGalleryCategory = new MediaGalleryCategory(128);
	
		//special
		public static var HELP:MediaGalleryCategory = new MediaGalleryCategory(256);
		public static var OVERVIEW:MediaGalleryCategory = new MediaGalleryCategory(512);
		public static var ATLAS:MediaGalleryCategory = new MediaGalleryCategory(1024);
	
	
		public static var CHART_GRAPH:MediaGalleryCategory = new MediaGalleryCategory(CHART | GRAPH);
	//	public static var __:MediaGalleryCategory = 128;
	//	public static var __:MediaGalleryCategory = 1024;
		public static var ALL:MediaGalleryCategory = new MediaGalleryCategory(IMAGE | MAP |INTERACTIVE | CHART | AUDIO | GRAPH | VIDEO | USERIMAGE);
		public static var __labels:Object;
		protected function MediaGalleryCategory (val : Number, name : String)
		{
			super (val);
			//this.__name = name;
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