package  com.troyworks.util{ 
	class util.IntrospectGraph
	{
		public static var blnUnhide;
		public static var blnStrict;
			// object-properties must
			// matched in hasOwnProperty
			//
		public static var arrIndent;
		public static var intObjectCount;
			//
		public static var STR_INDENT_FILLED ;
		public static var STR_INDENT_EMPTY;
			//
	
	
		public static function me (pObj:Object, pStrName:String, pBlnUnhide:Boolean) : String
		{
			return IntrospectGraph.init (pObj, pStrName, pBlnUnhide);
	
		}
		public static function init (pObj:Object, pStrName:String, pBlnUnhide:Boolean):String
		{
			IntrospectGraph.blnUnhide = pBlnUnhide;
			IntrospectGraph.blnStrict = IntrospectGraph.blnUnhide;
			// object-properties must
			// matched in hasOwnProperty
			//
			IntrospectGraph.arrIndent = new Array ();
			IntrospectGraph.intObjectCount = 0;
			//
			IntrospectGraph.STR_INDENT_FILLED = '   |';
			IntrospectGraph.STR_INDENT_EMPTY = '    ';
			//
			IntrospectGraph.setObjectId (pObj);
			IntrospectGraph.traceProperty (pObj, pStrName);
			IntrospectGraph.setObjectTraced (pObj);
			IntrospectGraph.arrIndent.push (IntrospectGraph.STR_INDENT_FILLED);
			//
			return IntrospectGraph.doTreeTrace (pObj);
		};
		public static function doTreeTrace (pObj:Object) : void {
			var strName = '';
			var mixedValue = null;
			var arrProperties = new Array ();
			//
			if (IntrospectGraph.blnUnhide)
			{
				IntrospectGraph.unhideProperties (pObj);
			}
			//
			for (var p in pObj)
			{
				if (IntrospectGraph.blnStrict && ! pObj.hasOwnProperty (p) && pObj != _global)
				{
					continue;
				}
				//
				arrProperties.unshift (
				{
					strName : p, mixedValue : pObj [p]
				});
			}
			//
			for (var i = 0; i < arrProperties.length; i ++)
			{
				strName = arrProperties [i].strName;
				mixedValue = arrProperties [i].mixedValue;
				//
				IntrospectGraph.setObjectId (mixedValue);
				//
				IntrospectGraph.traceProperty (mixedValue, strName);
				//
				if (IntrospectGraph.isCollection (mixedValue) && ! IntrospectGraph.isObjectTraced (mixedValue))
				{
					//
					IntrospectGraph.setObjectTraced (mixedValue);
					//
					if ((i + 1) < arrProperties.length)
					{
						// if last sibling
						IntrospectGraph.arrIndent.push (IntrospectGraph.STR_INDENT_FILLED);
					} else
					{
						IntrospectGraph.arrIndent [IntrospectGraph.arrIndent.length - 1] = IntrospectGraph.STR_INDENT_EMPTY;
						IntrospectGraph.arrIndent.push (IntrospectGraph.STR_INDENT_FILLED);
					}
					//
					arguments.callee.call (IntrospectGraph, mixedValue);
					//
					IntrospectGraph.arrIndent.pop ();
				}
				//
			}
		};
		//
		public static function traceProperty (pObj:Object, pStrName:String) : void {
			var strType = IntrospectGraph.getExtendedType (pObj);
			var strId = IntrospectGraph.getObjectId (pObj);
			var strIndent = IntrospectGraph.arrIndent.join ('');
			var strRefers = (IntrospectGraph.isObjectTraced (pObj)) ? ' refers' : '';
			//
			var stRes = strIndent + '__[' + pStrName + ':[' + strType +
			strRefers + strId + ']' + ' = ' + pObj + ']';
			trace (stRes);
		};
		//
		public static function setObjectTraced (pObj:Object) : void {
			if (IntrospectGraph.isCollection (pObj))
			{
				pObj.__hiddenIsTraced__ = true;
				_global.ASSetPropFlags (pObj, ['__hiddenIsTraced__'] , 1, 0);
			}
		};
		//
		public static function isObjectTraced (pObj:Object) : Boolean {
			return (pObj.hasOwnProperty ('__hiddenIsTraced__'));
		};
		//
		public static function setObjectId (pObj:Object) : void {
			if (IntrospectGraph.isCollection (pObj) && ! IntrospectGraph.isObjectTraced (pObj))
			{
				pObj.__hiddenId__ = IntrospectGraph.intObjectCount ++;
				_global.ASSetPropFlags (pObj, ['__hiddenId__'] , 1, 0);
			}
		};
		//
		public static function getObjectId (pObj:Object) : String {
			if ( ! pObj.hasOwnProperty ('__hiddenId__'))
			{
				return '';
			}
			return ' #' + pObj.__hiddenId__;
		};
		//
		public static function unhideProperties (pObj:Object) : void {
			_global.ASSetPropFlags (pObj, null, 0, 1);
			_global.ASSetPropFlags (pObj, ['__hiddenIsTraced__'] , 1, 0);
			_global.ASSetPropFlags (pObj, ['__hiddenId__'] , 1, 0);
			//
			// uncomment if you dont want to see the properties
			//ASSetPropFlags(pObj, ['__proto__'], 1, 0);
			//ASSetPropFlags(pObj, ['prototype'], 1, 0);
			//ASSetPropFlags(pObj, ['constructor'], 1, 0);
			//ASSetPropFlags(pObj, ['__constructor__'], 1, 0);
			//
			//ASSetPropFlags(Array.prototype, null, 1, 0);
			//ASSetPropFlags(Object.prototype, null, 1, 0);
		};
		//
	
		//
		public static function isCollection (pObj:Object) : Object {
			var strType = typeof (pObj);
			return (strType == 'object') || (strType == 'function') || (strType == 'movieclip');
		};
		protected static function getExtendedType(arg0 : Object) : void {
			
		}
	
	}
	
}