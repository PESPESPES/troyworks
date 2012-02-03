package com.sf;

/**
 * ...
 * @author 0b1kn00b
 */

typedef Tuple2Dynamic = Tuple2<Dynamic,Dynamic>;
typedef Tuple3Dynamic = Tuple3<Dynamic,Dynamic,Dynamic>;
typedef Tuple4Dynamic = Tuple4<Dynamic,Dynamic,Dynamic,Dynamic>;
typedef Tuple5Dynamic = Tuple5<Dynamic,Dynamic,Dynamic,Dynamic,Dynamic>;

class Tuples {
	public static inline function t2<A,B>(a:A,b:B):Tuple2<A,B>{
		return { a : a, b : b };
	}
	public static inline function t3<A,B,C>(a:A,b:B,c:C):Tuple3<A,B,C>{
		return { a : a, b : b, c : c};
	}
	public static inline function t4<A,B,C,D>(a:A,b:B,c:C,d:D):Tuple4<A,B,C,D>{
		return { a : a, b : b, c : c, d : d };
	}
	public static inline function t5<A,B,C,D,E>(a:A,b:B,c:C,d:D,e:E):Tuple5<A,B,C,D,E>{
		return { a : a, b : b, c : c, d : d,e : e };
	}
	public static function toTuple(a:Array<Dynamic>):Dynamic{
		
	}
}
typedef Tuple2<A,B> = {
	a : Null<A>,
	b : Null<B>,
}
typedef Tuple3<A,B,C> = { > Tuple2<A,B>,
	c : Null<C>,
}
typedef Tuple4<A,B,C,D> = { > Tuple3<A,B,C>,
	d : Null<D>,
}
typedef Tuple5<A,B,C,D,E> = { > Tuple4<A,B,C,D>,
	e : Null<E>,
}
class T2 {
	public static function first<A,B>(t:Tuple2<A,B>):A{
		return t.a;
	}
	public static function second<A,B>(t:Tuple2<A,B>):B{
		return t.b;
	}
	public static function entuple<A,B>(a:A,b:B):Tuple2<A,B>{
		return Tuples.t2(a, b);
	}
	public static function apply<A,B,C>(args:Tuple2<A,B>,f:A->B->C):C{
		return f(args.a, args.b);
	}
	public static function call<A,B,C>(f:A->B->C,args:Tuple2<A,B>):C{
		return f(args.a, args.b);
	}
	public static function patch<A,B>(t0:Tuple2<A,B>,t1:Tuple2<A,B>):Tuple2<A,B>{
		var a = t1.a == null ? t0.a : t1.a;
		var b = t1.b == null ? t0.b : t1.b;
		return Tuples.t2(a, b);
	}
	public static function toArray<A,B>(v:Tuple2<A,B>):Array<Dynamic>{
		return [v.a, v.b];
	}
	public static function fromArray(a:Array<Dynamic>):Tuple2<Dynamic,Dynamic>{
		return Tuples.t2(a[0], a[1]);
	}
}
class T3 {
	public static function entuple<A,B,C>(a:Tuple2<A,B>,b:C):Tuple3<A,B,C>{
		return Tuples.t3(a.a, a.b , b);
	}
	public static function apply<A,B,C,D>(args:Tuple3<A,B,C>,f:A->B->C->D):D{
		return f(args.a, args.b, args.c);
	}
	public static function call<A,B,C,D>(f:A->B->C->D,args:Tuple3<A,B,C>):D{
		return f(args.a, args.b, args.c);
	}
	public static function patch<A,B,C>(t0:Tuple3<A,B,C>,t1:Tuple3<A,B,C>):Tuple3<A,B,C>{
		var a = t1.a == null ? t0.a : t1.a;
		var b = t1.b == null ? t0.b : t1.b;
		var c = t1.c == null ? t0.c : t1.c;
		return Tuples.t3(a, b, c);
	}
}
class T4 {
	public static function entuple<A,B,C,D>(a:Tuple3<A,B,C>,b:D):Tuple4<A,B,C,D>{
		return Tuples.t4(a.a, a.b, a.c, b);
	}
	public static function call<A,B,C,D,E>(f:A->B->C->D->E,args:Tuple4<A,B,C,D>):E{
		return f(args.a, args.b, args.c, args.d);
	}
	public static function apply<A,B,C,D,E>(args:Tuple4<A,B,C,D>,f:A->B->C->D->E):E{
		return f(args.a, args.b, args.c,args.d);
	}
	public static function patch<A,B,C,D>(t0:Tuple4<A,B,C,D>,t1:Tuple4<A,B,C,D>):Tuple4<A,B,C,D>{
		var a = t1.a == null ? t0.a : t1.a;
		var b = t1.b == null ? t0.b : t1.b;
		var c = t1.c == null ? t0.c : t1.c;
		var d = t1.d == null ? t0.d : t1.d;
		return Tuples.t4(a, b, c, d);
	}
}
class T5 {
	public static function entuple<A,B,C,D,E>(a:Tuple4<A,B,C,D>,b:E):Tuple5<A,B,C,D,E>{
		return Tuples.t5(a.a, a.b , a.c, a.d ,b);
	}
	public static function call<A,B,C,D,E,F>(f:A->B->C->D->E->F,args:Tuple5<A,B,C,D,E>):F{
		return f(args.a, args.b, args.c, args.d, args.e);
	}	
	public static function apply<A,B,C,D,E,F>(args:Tuple5<A,B,C,D,E>,f:A->B->C->D->E->F):F{
		return f(args.a, args.b, args.c, args.d, args.e);
	}
	public static function patch<A,B,C,D,E>(t0:Tuple5<A,B,C,D,E>,t1:Tuple5<A,B,C,D,E>):Tuple5<A,B,C,D,E>{
		var a = t1.a == null ? t0.a : t1.a;
		var b = t1.b == null ? t0.b : t1.b;
		var c = t1.c == null ? t0.c : t1.c;
		var d = t1.d == null ? t0.d : t1.d;
		var e = t1.e == null ? t0.e : t1.e;
		return Tuples.t5(a, b, c, d, e);
	}
}