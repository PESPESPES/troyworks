package com.troyworks.core.persistance.syncher { 

	class EditedState extends Object
	{
		public static var NO_CHANGE : Number = 0;
		public static var UPDATED : Number = 1;
		public static var CREATED : Number = 2;
		public static var DELETED : Number = 4;
		public static function toString(val:Object):String{
			switch(val){
				case NO_CHANGE:
				return "No Change";
				break;
				case UPDATED:
				return "Updated";
				break;
				case CREATED:
				return "Created";
				break;
				case DELETED:
				return "Deleted";
				break;
			}
		}
	}
	
}