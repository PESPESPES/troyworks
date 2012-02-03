package com.sf;
import haxe.PosInfos;
using Std;

class Assert{
	public static function isTrue(v:Bool,onfail:String = "[false] should have been [true]",?pos:PosInfos){
		if(!v){
			throw onfail;
		}
	}
	public static function isNotNull(v:Dynamic,onfail:String = " should not be [null]",?pos:PosInfos){
		if( v == null ){
			throw Std.string(v) + onfail;
		}
	}
	public static function isNull(v:Dynamic,onfail:String = " should be [null]",?pos:PosInfos){
		if( v != null ){
			throw Std.string(v) + onfail;
		}
	}
	public static function isType(v:Dynamic,t:Class<Dynamic>,onfail = " should be of type ",?pos:PosInfos){
		if(!Std.is(v,t)){
			throw v.string() + onfail + t.string();
		}
	}

}