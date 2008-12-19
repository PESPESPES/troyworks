package com.troyworks.data.constraints
{
	import com.troyworks.util.StringUtil;
	
	public class StringListConstraint extends StringConstraint	
	{
		public var whitelist:Array = null;
		public var blacklist:Array = null;
		public var convertToUpperCase:Boolean = false;
		public var trimWhiteSpace:Boolean = true;
		public var pCase:Boolean = false;
		
		public function StringListConstraint()
		{
		}

		public function constrainToList(val:String):String
		{
			var res:Boolean;
			if (convertToUpperCase) val = val.toUpperCase();
			if (trimWhiteSpace) val = StringUtil.trim(val);
			if (pCase) val = StringUtil.toPCase(val);
			var str:String;
			
			if (whitelist != null)
			{
				res = false;
				for each (str in whitelist)
					if (val == str) res = true;
				if (!res) return whitelist[0].toString();				
			}
			
			if (blacklist != null)
			{
				res = true;
				for each (str in blacklist)
					if (val == str) res = false;
				if (!res) return "";
			}
			
			return val;
		}
	}
}