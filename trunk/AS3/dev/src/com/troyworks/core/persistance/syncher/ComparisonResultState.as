package com.troyworks.core.persistance.syncher { 

	class ComparisonResultState
	{
		public static var UNDEFINED : Number = -1;
		public static var UP_TO_DATE : Number = 1;
		public static var MODIFIED : Number = 2;
		public static var NEEDS_PATCH : Number = 4;
		public static var NEEDS_MERGE : Number = 8;
		//Up-to-date - The file is identical with the latest revision in the repository. (versionA == versionB && modifiedState == Nochange).
		//Locally Modified -You have edited the file, and not yet committed your changes. (versionA == versionB && modifiedState == CUD update).
		//Needing Patch -Someone else has committed a newer revision to the repository. (versionA < versionB && modifiedState == nochange).
		//Needs Merge -Someone else has committed a newer revision to the repository, and you have also made modifications to the file. (versionA < versionB && modifiedState == CUD update).
		public static function toString(val:Object):String{
			switch(val){
				case UNDEFINED:
				return "UNDEFINED";
				break;
				case UP_TO_DATE:
				return "UP_TO_DATE";
				break;
				case MODIFIED:
				return "MODIFIED";
				break;
				case NEEDS_PATCH:
				return "NEEDS_PATCH";
				break;
				case NEEDS_MERGE:
				return "NEEDS_MERGE";
				break;
			}
		}
	}
	
}