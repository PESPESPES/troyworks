package com.troyworks.core.persistance.syncher { 
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	public class Syncher extends Object
	{
		//used for compiler time references
		//protected static var __crs:ComparisonResultState;
		protected static var __es:EditedState;
		protected static var __ss:SynchState;
	
		public function Syncher ()
		{
			trace ("new Syncher");
		}
		public function initFromDiskXML () : void
		{
		}
		public function getServerVersion (user : SynchState) : SynchState
		{
			return null;
		}
		public function getUpdateState (users : SynchState, ref : SynchState) : Number
		{
			var res:Number = ComparisonResultState.UNDEFINED;
			if (users.version != null && ref.version != null)
			{
				//trace ("valid version test");
				if (users.version == ref.version)
				{
					if (users.hasChanged)
					{
						//Locally Modified -You have edited the file, and not yet committed your changes.
						res= ComparisonResultState.MODIFIED;
					}else
					{
						//Up-to-date - The file is identical with the latest revision in the repository.
						res = ComparisonResultState.UP_TO_DATE;
					}
				} else if (users.version < ref.version)
				{
					if (users.hasChanged)
					{
						//Needs Merge -Someone else has committed a newer revision to the repository, and you have also made modifications to the file.
						res = ComparisonResultState.NEEDS_MERGE;
					}else
					{
						//Needing Patch -Someone else has committed a newer revision to the repository.
						res = ComparisonResultState.NEEDS_PATCH;
					}
				}
	
			}else
			{
				//trace ("no version test");
	
					if (users.hasChanged)
					{
						//Locally Modified -You have edited the file, and not yet committed your changes.
						res= ComparisonResultState.MODIFIED;
					}else
					{
						//Up-to-date - The file is identical with the latest revision in the repository.
						res = ComparisonResultState.UP_TO_DATE;
					}
	
			}
			return res;
		}
	}
	
}