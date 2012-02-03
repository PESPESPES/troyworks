package com.sf;

import haxe.PosInfos;

import com.troyworks.core.cogs.State;
import com.sf.Methods;
class Util{
	public static function here(d:Dynamic,?pos:PosInfos){
		return pos;
	}
	public static function equals(a:Dynamic,b:Dynamic){
		return a == b;
	}
}