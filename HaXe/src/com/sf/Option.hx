package com.sf;

import com.sf.Functions;using com.sf.Functions;
using com.sf.Option;

import com.sf.log.Logger; using com.sf.log.Logger;

enum Option<T>{
	Some(v:T);
	None;
}
class Options{
	public static function toOption<A>(v:A){
		return (v == null) ?  None : Some(v);
	}
	public static function getWith<A>(v:Option<A>,f:Void->A):A{
		return switch (v) {
			case Some(d)	: d;
			case None 		: f();
		}
	}
	public static function get<A>(v:Option<A>){
		return switch (v) {
			case Some(d)	: d;
			case None 		: null;
		}	
	}
	public static function orElse<T>(o1: Option<T>, thunk: Thunk<Option<T>>): Option<T> {
    	return switch (o1) {
      		case None: thunk();
      		case Some(v): o1;
    	}
  	}
	public static function with(){
		
	}
	public static function apply<I,O>(f:Option<I->O>,v:I):O{
		return switch (f) {
			case Some(f) : f(v);
			case None : null;
		}
	}
	public static function applyOr<I,O>(o:Option<I->O>,x:I,f0:Callback):Option<O>{
		return switch(o){
			case Some(f) 	: toOption(f(x));
			case None 		: f0(); None;
		}
	}
	public static function getWithError<A>(v : Option<A> , e : Dynamic ): Option<A>{
		return v.orElse( function(){ throw e;}.promote() );
	}
	public static function isEmpty<A>(o:Option<A>):Bool{
		if(o==null){
			return true;
		}
		return switch (o) {
			case Some(_) 	: false;
			case None 		: true;
		}
	}
	public static function contentis<A>(o:Option<A>,v1:A):Bool{
		return switch (o) {
			case Some(v2) 	: v1 == v2;
			case None 		: v1 == null;
		}
	}
/*	public static function compare<A>(a:Option<A>,b:Option<B>):Int{
		return switch (a {
			case None 		:
				switch ( b ){
					case None 		: 0;
					case Some(v) 	: 1;
				}
			case Some(v) 	:
				switch( b ) {
					case None 		: -1;
					case Some(
				}
		}
	}*/
	public static function equals<A>(a:Option<A>,b:Option<A>):Bool{
		if(a == null || b == null ) {
			Error("Option should not be null with " + a + " == " + b).log();
		}
		return switch (a) {
			case None 		:
				switch ( b ){
					case None 		: true;
					case Some(_) 	: false;
				}
			case Some(v1) 	:
				switch( b ) {
					case None 		: false;
					case Some(v2)	: 
						if(v2 == null || v1 == null ) {
							throw "Option should not contain a null at " + a + " == " + b;
						}
						v1 == v2;
				}
		}
	}
}