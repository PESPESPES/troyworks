package com.troyworks.reflection {
	import flash.utils.Proxy;	
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;	
	import flash.utils.describeType;	

	/**
	 * Cache
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Oct 30, 2008
	 * DESCRIPTION ::
	 * a cache utility to reduce getDefinitionByName
	 * totally cloned by 
	 * http://jacwright.com/blog/94/finally-getting-my-preso-up/#comments
	 *
	 */
	public class Cache {
		protected static var cache : Dictionary = new Dictionary();

		public static function describe(obj : Object) : XML {
			if(obj is String || obj is XML || obj is XMLList) {
				obj = getDefinitionByName(obj.toString());
			}else if (obj is Proxy) {
				// Proxy subclasses don't have references to their constructors
				obj = getDefinitionByName(getQualifiedClassName(obj));
			}else if (!(obj is Class)) {
				obj = obj.constructor;
			}
			if(obj in cache) {
				return cache[obj];
			}
			var info : XML = describeType(obj).factory[0];
			cache[obj] = info;
			return info;
		}
	}
}
