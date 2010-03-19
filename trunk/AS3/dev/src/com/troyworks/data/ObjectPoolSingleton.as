package com.troyworks.data {
	import com.troyworks.util.construct;	

	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;			

	/**
	 * Manages objects by retaining disposed objects and returning them when a new object
	 * is requested, to avoid unecessary object creation and disposal and so avoid
	 * unnecessary object creation and garbage collection.
	 */
	public class ObjectPoolSingleton {
		private var pools : Dictionary = new Dictionary();

		private static var _instance : ObjectPoolSingleton;

		private static function hidden() : void {
		}
		public function ObjectPoolSingleton(h : Function) {
			if (h !== hidden) {
				throw new Error("ObjectPoolSingleton and can only be accessed through ObjectPoolSingleton.getInstance()");
			}
		}
		public static function getInstance() : ObjectPoolSingleton {
			if( _instance == null ) {
				_instance = new ObjectPoolSingleton(hidden);
			}
			return _instance;
		}

		

		private function getPool( type : Class ) : Array {
			return type in pools ? pools[type] : pools[type] = new Array();
		}
		/**
		 * preallocate a pool of objects (typically used at startup times)
		 * aggressive cache allocation.
		 */
		public function prefill(count:int, type:Class, ...parameters ) : void{
			var pool : Array = getPool(type);
			while(count--){
			pool.push(construct(type, parameters));
			}
		}
		/**
		 * Get an object of the specified type. If such an object exists in the pool then 
		 * it will be returned. If such an object doesn't exist, a new one will be created.
		 * 
		 * @param type The type of object required.
		 * @param parameters If there are no instances of the object in the pool, a new one
		 * will be created and these parameters will be passed to the object constrictor.
		 * Because you can't know if a new object will be created, you can't rely on these 
		 * parameters being used. They are here to enable pooling of objects that require
		 * parameters in their constructor.
		 */
		public function getObject( type : Class, ...parameters ) : * {
		//	trace("getPool " + type);
			var pool : Array = getPool(type);
			if( pool.length > 0 ) {
			//	trace("GETTING FROM POOL");
				return pool.shift();
			} else {
				//trace("CONSTRUCTING NEW");
				return construct(type, parameters);
			}
		}

		/**
		 * Return an object to the pool for retention and later reuse. Note that the object
		 * still exists, so you need to clean up any event listeners etc. on the object so 
		 * that the events stop occuring.
		 * 
		 * @param object The object to return to the object pool.
		 * @param type The type of the object. If you don't indicate the object type then the
		 * object is inspected to find its type. This is a little slower than specifying the 
		 * type yourself.
		 */
		public function disposeObject( object : *, type : Class = null ) : void {
			if( !type ) {
				var typeName : String = getQualifiedClassName(object);
				type = getDefinitionByName(typeName) as Class;
			}
			var pool : Array = getPool(type);
			pool.push(object);
		}
	}
}