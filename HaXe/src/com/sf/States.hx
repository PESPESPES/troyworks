package com.sf;

import haxe.rtti.Infos;

import com.sf.Arrows; using com.sf.Arrows;
import com.sf.Methods; using com.sf.Methods;
import com.sf.Option; using com.sf.Option;
import com.sf.Either;

using com.sf.States;

typedef Transition<T>	= Arrow<Control,Signal<T>->Option<Transition<Dynamic>>>;
typedef Selector<T>		= Signal<T> -> Transition<T>;
//typedef Select<A,B> 	= { x : A , xs : B };
//typedef Group<T> 		= Method1<T,Option<Select<State<T>,Dynamic>>>;
//typedef State<T>		= Method1<T,Group<T>>;


typedef Node<T> = {
	parent 		: T
}
typedef Group 	= { >Node<State> , 
	selected 	: State,
	states  	: Array<State>
}
typedef State 	= { >Node<Group> ,
	groups 		: Array<Group>
}
typedef Part 	= Either<Group,State>;

typedef TransitionObject = {
	from 		: Control,
	to 			: Control,
	trans 		: Null<Transition<Dynamic>>,
	structure	: Null<Part>
}
enum Control{
	Handle( m : Method1<Signal<Dynamic>,Void>);
	Closed( m : Method0<Void> );
	Select( m : Method1<Signal<Dynamic>,Transition<Dynamic>> );
}
class SelectControllers{
	public static function part<A>(v:Signal<A>->Transition<Dynamic>):Control{
		return Select( v.toMethod() );
	}
}
class HandleControllers{
	public static function part<A>(v:Signal<A>->Void):Control{
		return  Handle( v.toMethod() );
	}
}
class ClosureControllers{
	public static function part<A>(v:Void->Void):Control{
		return  Closed( v.toMethod() );
	}
}
enum Signal<T>{
	Init;
	Entry;
	Exit;
	Update(v:T);
}
enum Async{
	Call;
	Respond;
}

class States{
	public static function handle<A>(f:Signal<A>->Void){
		
	}
	public static function beat<A>(f:A->Void):Arrow<Dynamic,Dynamic>{
		return null;
	}
	public static function add(c:Control->Dynamic){
		
	}
	public static function parent(me:Control,parent:Control){
		return Transitions.create(me,parent);
	}
	public static function child(me:Control,child:Control){
		return Transitions.create(me,child);
	}
	public static function sibling(me:Control,sibling:Control){
		return Transitions.create(me,sibling);
	}
}
class Groups{
	/*
	public static function parent<A>(g:Group<A>,v:State<A>):Arrow<Group<A>,State<A>>{
		return v.lift().then(g.lift());
	}*/
}
class StateMachine<T> implements haxe.rtti.Infos{

	public var transitions (default,null) 	: Transitions<T>;
	public var stem 						: Control;
	public var shoots 						: Control;
	
	public function transition(m:Control){
		
	}
	/*
	public static function create(v:Infos,stem:Signal<Dynamic> -> Void>,shoots<Signal<Dynamic>->Transition<Dynamic>,init:Void->Void{
		
	}*/
	public function new(){
		
	}
}
class Transitions<T>{
	public var select (default,null) : T;

	public function new(t){
		this.select = t;
	}
	public static var none : Transition<Dynamic>;
	public static var self : Transition<Dynamic>;

	public static function create(from:Control,to:Control):TransitionObject{
		return { from : from , to : to , trans : null };
	}
	public static function commit(transition:TransitionObject,to:StateMachine<Dynamic>){
		
	}
	public static function parent(me:TransitionObject,parent:Control){
		
	}
}
class Asyncs{
	public static function defer(s:Signal<Async>, call : Selector<Dynamic> ,respond : Selector<Dynamic> ):Control {
		return switch (s) {
			default 		: 
			case Update(u) 	: {
				switch(u){
					case Call		: call(s);
					case Respond 	: respond(s);
				}
			}
		}
	}
}