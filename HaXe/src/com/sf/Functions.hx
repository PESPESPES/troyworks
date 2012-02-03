package com.sf;

typedef Thunk<T> 		=  	Void -> T;
typedef Callback 		= 	Void -> Void;
typedef Function1<P,R> 	= 	P -> R;
typedef Function2<P1,P2,R> 	= 	P1 -> P2 -> R;
class Functions{
	
}
class Callbacks{
  public static function promote(c:Callback):Thunk<Dynamic>{
    return function(){
      c();
      return null;
    }
  }
}
class Functions0{
	public static function enclose<R>(f:Thunk<R>):Callback{
		return
			function():Void{
				f();
			}
	}
  public static var nil = function(){ return null; }
}
class Functions1{
	public static function lazy<P1, R>(f: Function1<P1, R>, p1: P1): Thunk<R> {
    	var r = null;
    
    	return function() {
      		return if (r == null) { r = f(p1); r; } else r;
    	}
  	}
  public static var nil = function(a){ return null; }
}
class Functions2{
	
	public static function lazy<P1, P2, R>(f: Function2<P1, P2, R>, p1: P1, p2: P2): Thunk<R> {
    	var r = null;
    
    	return function() {
      		return if (r == null) { r = f(p1, p2); r; } else r;
    	}
  	}	
	public static function flip<P1, P2, R>(f: Function2<P1, P2, R>): Function2<P2, P1, R> {
    	return function(p2, p1) {
      		return f(p1, p2);
   		}
  	}		
  	public static function curry<P1, P2, R>(f: Function2<P1, P2, R>): Function1<P1, Function1<P2, R>> {
    	return function(p1: P1) {
      		return function(p2: P2) {
        		return f(p1, p2);
      		}
    	}
  	}
  public static var nil = function(a,b){ return null; }
 }
class Functions3{
  public static var nil = function(a,b,c){ return null; }
}
class Functions4{
  public static var nil = function(a,b,c,d){ return null; }
}
class Functions5{
  public static var nil = function(a,b,c,d,e){ return null; }
}