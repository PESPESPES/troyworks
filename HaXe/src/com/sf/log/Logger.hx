/**
 * ...
 * @author 0b1kn00b
 */

package com.sf.log;
import haxe.PosInfos;

enum LogLevel {
	Info(v:Dynamic, ?pos:PosInfos);
	Debug(v:Dynamic, ?pos:PosInfos); 
	Error(v:Dynamic, ?pos:PosInfos);
	Test(v:Dynamic, ?pos:PosInfos);
	Warning(v:Dynamic, ?pos:PosInfos);
}
class Logger {
	public static var blacklist : Array<LogLevel->Bool> = [];
	public static var whitelist : Array<LogLevel->Bool> = [];

	public static function log(v:LogLevel){
		var params 				= Type.enumParameters(v);
		var pos 	: PosInfos 	= params[1];
		var o = ( Type.enumConstructor(v) + " [" + toString(pos) + "] " + Std.string(params[0]));

		if( whitelist.length > 0 ){
			for (f in whitelist){
				if( f(v) ){
					trace(o);
				}
			}
		}else if(blacklist.length > 0 ){
			var ok = true;
			for (f in blacklist){
				if( f(v) ){
					ok =  false;
				}
			}
			if( ok ){
				trace(o);
			}
		}else{
			trace (o);
		}

		switch(v){
			 default :
			 case Error(v,p) :
			 trace("\n:::UNHANDLED ERROR:::\n\t"+v+"\n:::::::::::::::::::::");
			 	throw v;
		}
		return o;
	}
	public static function toString(pos:PosInfos){
		if (pos == null) return 'nil';
		var type                = pos.className.split(".");
		return type[type.length-1] + "::" + pos.methodName + "#" + pos.lineNumber;
	}
}
class ErrorLog{
	public static function log(e:com.sf.error.Error){
		return Logger.log( Error(e) );
	}
}