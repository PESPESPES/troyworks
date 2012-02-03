package com.troyworks.core.cogs;
import com.sf.Assert;using com.sf.Assert;
import com.sf.Methods;using com.sf.Methods;
import com.sf.Util;

class CacheObject {
	public var method(default,null) 		: Null<State>;
	public var xml (default,null)		: Xml;
	public function new(method:State,xml:Xml){
		method.isNotNull();
		this.method 	= method;
		xml.isNotNull();
		this.xml 	= xml;
	}
	public function toString(){
		return( "Cache [ " + this.method.name + " ]");
	}
	
}