package com.troyworks.framework.assets { 
	 //This is a bitflag for various categories of the assets
	public class MediaCategory extends Number
	{
		public var departmentID:Number;
		protected function MediaCategory (value : Number, deptID : Number)
		{
			super (value);
			this.departmentID = deptID;
		}
		/*
		*  intdepartmentid |  vchdepartment
	-----------------+------------------
	               2 | Surf
	               3 | Skate
	               4 | Snow
	               5 | MX
	               6 | Current Releases
	               9 | More
				   */
		//default value.
		public static var UNDEFINED : MediaCategory = new MediaCategory (0);
		//bit mask
		public static var CURRENT : MediaCategory = new MediaCategory (1, 6);
		public static var SURF : MediaCategory = new MediaCategory (2,2);
		//skateboarding
		public static var SKATE : MediaCategory = new MediaCategory (4,3);
		//snow board
		public static var SNOW : MediaCategory = new MediaCategory (8,4);
		//motocross
		public static var MX : MediaCategory = new MediaCategory (16,5);
		//
		public static var MORE : MediaCategory = new MediaCategory (32,9);
		//below this line are unused. ----------------------------------
		//	public static var MOTO:Number = 64;
		//	public static var BMX:Number = 128;
		//	public static var WAKE:Number = 256;
		//	public static var OVERVIEW:Number = 512;
		//	public static var ATLAS:Number = 1024;
		//above this line are unused.
		public static var ALL = CURRENT | SURF | SKATE | SNOW | MX | MORE;
		public static var __labels : Object;
		protected static var self : MediaCategory;
		public static function constructLabels () : void
		{
			MediaCategory.__labels = new Object ();
			for (var i in MediaCategory)
			{
				var s : String = String (i);
				MediaCategory.__labels [MediaCategory [i]] = s;
				//trace(s + " " +	MediaCategory[i]);
	
			}
		}
		public static function getLabel (typeVal : Number) : String
		{
			return MediaCategory.__labels [typeVal];
		}
		//if exact = false/null, this parses it as a bit flag isntead of a single enumerated type
		//if exact = true, it parses it as one of the enumerated type values.
		public static function parse (o : Object, exact : Boolean) : MediaCategory
		{
			//trace ("MediaCategory parsing " + o);
			var n : Number = - 1;
			if (typeof (o) == "string")
			{
				n = parseInt (String (o));
			} else if (typeof (o) == "number")
			{
				n = Number (o);
			} else
			{
				return null;
			}
			if (exact == null || exact == false)
			{
				var mcn : MediaCategory = new MediaCategory (n);
				return mcn;
			} else
			{
				for (var i in MediaCategory)
				{
					//trace(i +" " + MediaCategory[i] + " ==?"+ (MediaCategory[i] == n) + " " + (Number(MediaCategory[i]) == n));
					var f = Number (MediaCategory [i]);
					if (f == n)
					{
						return MediaCategory [i];
					}
				}
			}
		}
	}
	
}