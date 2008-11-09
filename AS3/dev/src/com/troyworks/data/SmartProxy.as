package com.troyworks.data {
	import flash.utils.Dictionary;	
	import flash.utils.Proxy;
	import flash.utils.describeType;

	/**
	 * SmartProxy
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Nov 6, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class SmartProxy extends Proxy {
		private var _obj : Object;
		private var _functionNames : Dictionary;

		public function SmartProxy(obj : Object = null) {
			if(obj){
				setProxiedObject(obj);
			}
		}
		protected function setProxiedObject(obj:Object):void{
						_obj = obj;

			// set up Dictionary that goes from functions in this wrapper to function names
			_functionNames = new Dictionary();
			var typeInfo : XML = describeType(this);   
			// returns metadata for subclass interface
			for each (var functionInfo:XML in typeInfo.method) {
				var name : String = functionInfo.@name;
				_functionNames[this[name]] = name;
			}
		}

		protected function handleInvocation(args : Object) : * {
			// 'callee' is a special AS3-defined property of an 'arguments' object
			// that provides the Function which was called
			var functionName : String = _functionNames[args.callee];
			return applyFunction(functionName, args);
		}

		protected function applyFunction(functionName : String, args : Object) : * {
			// This looks up the name of the function that was called, uses it to
			// obtain the Function in the underlying object as a property, and calls it.
			return (_obj[functionName] as Function).apply(_obj, args);
		}
	}
}
