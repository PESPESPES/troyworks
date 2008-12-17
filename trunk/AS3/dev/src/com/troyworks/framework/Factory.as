package com.troyworks.framework {
	import flash.utils.getDefinitionByName;	
	
	public class Factory extends Object {
		private static var registry : Object = new Object();
		private static var objCache : Object = new Object();
		
		public function Factory(name : String) {
			trace("new Factory " + name);
		}

		public static function registerImplementers(obj : Object) : void {
			for(var i:String in obj) {
				Factory.registerImplementer(i, obj[i]);
			}
		}

		/*
		 * Serves to act as a factory for the given classes as strings.
		 */
		public static function registerImplementer(classNameKey : String, implementer : Object) : void {	
			trace("SpringFactory.registerImplementer('" + classNameKey + "'" + " = " + implementer + ")");
			Factory.registry[classNameKey] = implementer;
	//log("SKIN.SWF..........LOADED!");	Factory.listRegistrants();
		}

		public static function getImplementor(classNameKey : String) : Object {
			var cl:Object = Factory.registry[classNameKey];
			trace("class name mapping for " + classNameKey + "  is '" + cl + "'");
			if (cl == null) {
				trace("Factory.error! invalid concrete implementor");
				throw new Error("com.TroyWorks.SpringFactory. invalid concrete implementor");
			}
			//trace(typeof (cl));
			var t_cl:String = typeof(cl);
			if(typeof (cl) == "function" || typeof (cl) == "movieclip" ) {
				//passed in a concrete instance
				//		trace("returning concrete instance of function/movieclip");
				return cl;
			}else {
				////// if not cached ////////////
				var cf:Object = Factory.objCache[classNameKey];
				if(cf != null) {
					//		trace("Factory, cached object Factory found! ");	    	
					return getSingletonOrNewInstance(classNameKey, Class(cf));
				}
				///// else create it ////////////
				//XXX eval NOT Supported in Flash 9!! but can be done via other ways
				//http://dynamicflash.com/2005/03/class-finder/
				var f : Class = Class(getDefinitionByName(cl as String)) ;
				//eval (cl);
				trace("'" + cl + "' function? " + f);
				if (f is Class) {
					return getSingletonOrNewInstance(classNameKey, Class(f));
				} else {
					trace("****WARNING*****: Factory.returning null, could not find implmentor for " + classNameKey); 
					return null;
				}
			}
		}

		private static function getSingletonOrNewInstance(classNameKey : String, f : Class) : Object {
			var i:Object = null;
			///Lets see if the class is a singleton or not
		//TODO XXX singleton
		//	if(f.hasOwnProperty("getInstance") != null) {
		//		i = Object(f).getInstance();
		//	}
			if(i != null) {
				//is actually a singleton 	
				//trace("Factory.returning Singleton " + i.toString());
				Factory.objCache[classNameKey] = f;
				return i;
			}else {
				// is a normal class, instantiate a new instance.
				var o:Object = new f();
				//trace("Factory.returning new instance " + o.toString());		
				return o;
			}
		}

		public static function listRegistrants() : void {
			trace("Factory listing Registrants\\");
			for (var i : String in Factory.registry) {
				trace(" -  " + i + " = " + Factory.registry[i]);
			}
			trace("Factory listing Registrants///");
		}
	}
}