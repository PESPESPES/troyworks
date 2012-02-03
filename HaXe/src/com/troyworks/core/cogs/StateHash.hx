package com.troyworks.core.cogs;

class StateHash{
	private var data : Hash<CacheObject>;

	public function new(){
		data = new Hash();
	}
	public function get(s){
		return data.get(s);
	}
	public function set(s,v){
		data.set(s,v);
	}
	public function exists(s){
		return data.exists(s);
	}
	public function iterator(){
		return data.iterator();
	}
	public function keys(){
		return data.keys();
	}
	public function toString(){
		return "\n" + Lambda.fold( data, function(x,y) return x + "\n" + y ,"");
	}
}