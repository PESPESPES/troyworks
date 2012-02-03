/**
* ...
* @author Default
* @version 0.1
*/
package com.troyworks.snippets.reflection;

import flash.utils.Namespace;
import com.troyworks.snippets.reflection.Introspectable;
import flash.events.Event;
import com.troyworks.core.cogs.COG;

class IntrospectableObj implements Dynamic {

	//private var ns:Namespace;// = me "com.troyworks";
	//// Instance ////////////
	var introVar 						: Event->Dynamic;
	var defVar 							: Event->Dynamic;
	var priVar 							: Event->Dynamic;
	var proVar 							: Event->Dynamic;
	public var pubVar : Event->Dynamic;
	//// Statics /////////////
	static var introVarStat : Event->Dynamic = null;
	static var defVarStat 	: Event->Dynamic = null;
	static var priVarStat 	: Event->Dynamic = null;
	static var proVarStat 	: Event->Dynamic = null;
	static public var pubVarStat : Event->Dynamic = null;
	//// Constants  /////////////
	var introConstStat 							: Event->Dynamic;
	var defConstStat 								: Event->Dynamic;
	static var priConstStat 				: Event->Dynamic = null;
	static var proConstStat 				: Event->Dynamic = null;
	static public var pubConstStat 	: Event->Dynamic = null;
	
	var _item : Array<Dynamic>;
	// array of object's properties
	public function new() {
		introVar = null;
		defVar = null;
		priVar = null;
		proVar = null;
		pubVar = null;
		introConstStat = null;
		defConstStat = null;
		//super();
		//trace("props " + _item.join("\r"));
		trace("new Introspectable");
		//	trace("s_internal "  + s_internal);
		//	trace("s_private "  + s_private);
		//	trace("s_protected "  + s_protected);
		//				trace("s_public "  + s_public);
		//	IntrospectableNS.uri = "com.troyworks";
		for (x in Reflect.fields(this)) {
			trace("pushing " + x);
			//_item.push(x);
		}

		/*	 for (var y:* in this.ns::) {
		 trace("pushing " + y);
		//_item.push(x);
		 }*/;
	}

	/*override flash_proxy function nextNameIndex (index:int):int {
         // initial call
	 trace(" Introspectable.nextNameIndex " + index);
	 if (index == 0) {
	  trace("new  " + x);
	 _item = new Array();
	 for (var x:* in this) {
	 trace("pushing " + x);
	_item.push(x);
	 }
	 }
	 
	 if (index < _item.length) {
	 return index + 1;
	 } else {
	 return 0;
	 }
	}
	 override flash_proxy function nextName(index:int):String {
	 return _item[index - 1];
	 }*/
	 //TODO integrate name spaces
/*	public function getNS() : Namespace {
		return introspectable;
	}*/

	/////////////////// INSTANCE /////////////////////////
	function s_introspectable() : Void {
		trace("Hello World from introspectable::s_introspectable");
	}

	function s_internal() : Void {
	}

	function s_private() : Void {
	}

	function s_protected() : Void {
	}

	public function s_public() : Void {
	}

	///////////////////// STATICS ///////////////////////
	static function stat_internal() : Void {
	}

	static function stat_private() : Void {
	}

	static function stat_protected() : Void {
	}

	static public function stat_public() : Void {
	}

	///////////////////// CONST ///////////////////////
	/*	const function const_internal():void{
	
	}
	const private function const_private():void{
	
	}
	const protected function const_protected():void{
	
	}
	const public function const_protected():void{
	
	}*/
}

