package com.troyworks.syncher { 
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
			if (arguments.length > 0)
			{
				var arg1 = arguments [0];
				if (arg1 is XMLNode)
				{
					var x = XMLNode (arg1);
					//	trace("XMLNode" + x);
					this.initFromDiskXML (x);
				} else if (arg1 is XMLDocument)
				{
					var x = XMLDocument (arg1);
					//	trace("XMLDocument" + x);
					this.initFromDiskXML (x);
				} else
				{
					//	trace("String");
					this.init.apply (this, arguments);
				}
			}
		}
		public function init () : void
		{
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