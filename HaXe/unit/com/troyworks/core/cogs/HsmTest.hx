/* This is a comprehensive test of possible state transitios and topologies as inspried by EightStateMachine*/
package com.troyworks.core.cogs;

import flash.display.Sprite;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.utils.Timer;
import flash.events.TimerEvent;
import flash.events.Event;
import com.sf.Option;using com.sf.Option;

import com.troyworks.core.cogs.NameSpaceTest;

import flash.utils.Timer;
import flash.events.TimerEvent;

import com.troyworks.core.cogs.EightStateMachine;
import com.troyworks.core.cogs.EightStateMachineSignal;
using com.troyworks.core.cogs.CogSignal;
using com.troyworks.core.cogs.CogEvent;

import massive.munit.async.AsyncFactory;
import massive.munit.Assert;using  massive.munit.Assert;

import com.sf.Tuples;using com.sf.Tuples;
import com.sf.log.Logger;using com.sf.log.Logger;
import com.sf.Arrows; using com.sf.Arrows;
import com.sf.Methods; using com.sf.Methods;

import stax.Functions;using stax.Functions;

class HsmTest {
	public function  new() {
		
	}
	//////////// SYNCHRONOUS TESTS /////////////////
	@Test 
	public function  test_equal()  {
		(test_equal == test_equal).isTrue();
	}

	@Test 
	public function  test_equal2() {
		(test_equal == test_equal).isTrue();
	}

	@Test 
	public function  test_equal3() {
		var fn  = test_equal;
		(fn == test_equal).isTrue();
	}
	private function tester(active: String, transitions:String ){
		return 
			function(m:EightStateMachine){
				Debug("\n" + active + "\n" +  m.currentState + "\n" + transitions + "\n" + m.transitionLog + "\n").log();
				var fn = Reflect.field(m,active);
				m.hsmIsActive.isTrue();
				m.isCurrentState(fn).isTrue();
				transitions.areEqual(m.transitionLog);			
			}
	}
	private function mu(s:EightStateMachine,af:AsyncFactory,m:EightStateMachine->Void){
		var f : Void -> Void =  function(){
			m(s);
		}
		var mf = af.createHandler( this, f , 1000 );
		return function(x:Event){ mf(); return x; }.toMethod('test').lift();
	}
	private function evt():Arrow<IEventDispatcher,Event>{
		return CogExternalEvent.CHANGED.event();
	}
	private function create(str){
		return new EightStateMachine(str);
	}
	
	//-------------- s_0 history test --------------------------------------------
	@AsyncTest
	public function testHistory_s_0(af:AsyncFactory)  {
		var m 	= new EightStateMachine("s_0,noINIT");
		evt().then ( mu(m,af,tester('s_0',"ENTERING s_0 HANDLED")) ).run(m);
	}

	
	//-------------- s_1 history test --------------------------------------------
	@AsyncTest
	public function  testHistory_s_1(af: AsyncFactory) {
		var m 	= new EightStateMachine("s_1,noINIT");
		var t 	= tester('s_1',"ENTERING s_0 HANDLED,ENTERING s_1 HANDLED");

		evt().then( mu(m,af,t) ).run(m);
	}

	//-------------- s_11 history test --------------------------------------------
	@AsyncTest
	public function  atest_0_history_s_11(af:AsyncFactory) {
		var m 	= new EightStateMachine("s_11,noINIT");
		var t 	= tester('s_11',"ENTERING s_0 HANDLED,ENTERING s_1 HANDLED,ENTERING s_11 HANDLED");

		evt().then( mu(m,af,t) ).run(m);
	}

	//-------------- s_2 history test --------------------------------------------
	@AsyncTest
	public function  atest_0_history_s_2(af:AsyncFactory) {
		var m 	= new EightStateMachine("s_2,noINIT");
		var t 	= tester('s_2',"ENTERING s_0 HANDLED,ENTERING s_2 HANDLED");

		evt().then( mu(m,af,t) ).run(m);
	}



	//-------------- s_21 history test --------------------------------------------
	@AsyncTest
	public function  atest_0_history_s_21(af:AsyncFactory)  {
		var m 	= new EightStateMachine("s_21,noINIT");
		var t 	= tester('s_21',"ENTERING s_0 HANDLED,ENTERING s_2 HANDLED,ENTERING s_21 HANDLED");

		evt().then( mu(m,af,t) ).run(m);
	}

	//-------------- s_211 history test --------------------------------------------

	//

	@AsyncTest	
	public function  atest_0_history_s_211(af:AsyncFactory) {
		var m 	= new EightStateMachine("s_211,noINIT");
		var t 	= tester("s_211","ENTERING s_0 HANDLED,ENTERING s_2 HANDLED,ENTERING s_21 HANDLED,ENTERING s_211 HANDLED");

		evt().then( mu(m,af,t) ).run(m);
	}
	/////////////////////////////////// INIT TESTS//////////////////////////////////////////////////////

	private function second_evt(){
		return evt().split( evt() );
	}
	private function init_tester(active: String, transitions:String ){
		return 
			function(m:EightStateMachine){
				var fn = Reflect.field(m,active);

				Debug("\n" +m.sLookup(m.asState(fn)) + "\n" + m.currentState + "\n" + transitions + "\n" + m.transitionLog +"\n").log();

				m.hsmIsActive.isTrue();
				m.isCurrentState(fn).isTrue();
				m.isInState(m.s_2);
				transitions.areEqual(m.transitionLog);
			}
	}
	//----------------- init chain 1 (from root to final)------------------------------------
	@AsyncTest 
	public function  atest_1_init(af:AsyncFactory) {
		var m 	= new EightStateMachine();
		var t 	= init_tester("s_11","ENTERING s_initial NOT HANDLED,ENTERING s_0 HANDLED,ENTERING s_1 HANDLED,ENTERING s_11 HANDLED");
		//m.addEventListener( CogExternalEvent.CHANGED, function(x) Debug(x).log() );
		
		evt().then( mu(m,af,t) ).run(m);
		m.initStateMachine();
	}
	private function wrap(f:Dynamic){
		return function(){
				f();	
		}.promote().withEffect().toMethod("test").lift();
	}
	private function handle(af:AsyncFactory,f:Void -> Void){
		return wrap( af.createHandler( this , function() f() , 1000 ) );
	}
	//----------------- init chain 2 (from root via s_2 as )------------------------------------
	@AsyncTest 
	public function  atest_1b_init_s2(af:AsyncFactory) {
		var stack = "ENTERING s_0 HANDLED,ENTERING s_2 HANDLED,ENTERING s_21 HANDLED,ENTERING s_211 HANDLED";
		var m = new EightStateMachine("s_2");

		var  f = af.createHandler( this, function(){ stack.areEqual(m.transitionLog); } );
		var g = function(x) { f(); }	
		evt().then( g.lift() ).run(m);

	}
	@AsyncTest 
	public function  atest_2_SELF(af:AsyncFactory) {
		twoStep(af, "EXITING s_11 HANDLED,ENTERING s_11 HANDLED", ESSignal.Self.getNextSignal().fromUserSig() );
	}
	@AsyncTest 
	public function  atest_2_SELF2(af:AsyncFactory) {
		twoStep( af, "EXITING s_11 HANDLED,EXITING s_1 HANDLED,ENTERING s_1 HANDLED", ESSignal.Self2.getNextSignal().fromUserSig() );
	}
	
	private function twoStep(af:AsyncFactory, stack : String, event : CogEvent, init : String = null){
		
		var m 	= new EightStateMachine(init);
		var t 	= stack;

		var h2 	=
			function (m:EightStateMachine){
				//m.isCurrent(m.s_11).isTrue();
				Debug("\n" + "required:\n" + t + "\n" + "received:\n" + m.transitionLog +"\n").log();
				t.areEqual( m.transitionLog );	
				return m;			
			};
		var lft = T2.first;

		//this has to be declared here so munit knows there is an asyn delegate.
		var hd =  handle( af, h2.lazy(m).toEffect() );

		var h1 	= 
			function (e:Event){
				Debug("Fire").log();
				Debug("\n" + "required:\n" + t + "\n" + "received:\n" + m.transitionLog +"\n").log();

				//add the second handler before the fire action in case there are no asynchronous gaps.
				evt().bind(lft.lift()).then( cast hd ).run( cast m );
				
				if (event != null){
					Warning("Not Sending Event").log();
					m.dispatchEvent( event );
				}
				
				 return e;
			}.toMethod('fire').lift();

		evt().then(h1).bind(lft.lift()).run( cast m );
	
	//	m.initStateMachine();
	}
	@AsyncTest 
	public function  atest_3_PARENT(af:AsyncFactory)  {
		twoStep( af , "EXITING s_11 HANDLED", ESSignal.Parent.getNextSignal().fromUserSig() );
	}
	@AsyncTest
	public function atest_3_PARENT2(af:AsyncFactory) {
		twoStep( af, "EXITING s_1 HANDLED", ESSignal.Parent.getNextSignal().fromUserSig() , "s_1,noINIT");
	}
	@AsyncTest
	public function  atest_3_GRANDPARENT(af:AsyncFactory){
		twoStep( af, "EXITING s_11 HANDLED,EXITING s_1 HANDLED",ESSignal.GrandParent.getNextSignal().fromUserSig());
	}

	/////////////////////////////////////////////////////////////////////////////////
	//                                  CHILD STATE TETS
	////////////////////////////////////////////////////////////////////////////////////////

	@AsyncTest 
	public function  atest_4_CHILD_INACTIVE(af:AsyncFactory)  {
		twoStep( af, "ENTERING s_111 NOT HANDLED", ESSignal.ChildInactive.getNextSignal().fromUserSig());
	}
	@AsyncTest 
	public function  atest_4_CHILD_ACTIVE(af:AsyncFactory)  {
		twoStep( af , "ENTERING s_11 HANDLED", ESSignal.ChildActive.getNextSignal().fromUserSig(),"s_1,noInit");
	}
	/////////////////////////////////////////////////////////////////////////////////
	//                                  GRANDCHILD STATE TESTS
	////////////////////////////////////////////////////////////////////////////////////////
	@AsyncTest 
	public function atest_5_GRANDCHILD_INACTIVE(af:AsyncFactory)  {
		twoStep( af , "ENTERING s_2 HANDLED,ENTERING s_21 HANDLED,ENTERING s_211 HANDLED" , ESSignal.GrandChildInactive.getNextSignal().fromUserSig(),"s_0,noInit");
	}
	@AsyncTest 
	public function atest_5_GRANDCHILD_INACTIVE2(af:AsyncFactory)  {
		twoStep( af , "EXITING s_11 HANDLED,EXITING s_1 HANDLED,ENTERING s_2 HANDLED,ENTERING s_21 HANDLED,ENTERING s_211 HANDLED" , ESSignal.GrandChildInactive2.getNextSignal().fromUserSig());
	}
	@AsyncTest 
	public function atest_5_GRANDCHILD_ACTIVE(af:AsyncFactory)  {
		twoStep( af , "EXITING s_11 HANDLED,EXITING s_1 HANDLED,ENTERING s_1 HANDLED,ENTERING s_11 HANDLED,ENTERING s_111 NOT HANDLED", ESSignal.GrandChildActive.getNextSignal().fromUserSig());
	}

	@AsyncTest 
	public function atest_6_SIBLING(af:AsyncFactory)  {
		twoStep( af , "EXITING s_1 HANDLED,ENTERING s_2 HANDLED", ESSignal.Sibling.getNextSignal().fromUserSig(),"s_1,noInit");
	}

	@AsyncTest 
	public function atest_6_SIBLING2(af:AsyncFactory)  {
		twoStep( af , "EXITING s_11 HANDLED,EXITING s_1 HANDLED,ENTERING s_2 HANDLED", ESSignal.Sibling.getNextSignal().fromUserSig());
	}
	//TODO Why are these two tests the same?
	@AsyncTest 
	public function atest_6_UNCLE(af:AsyncFactory)  {
		twoStep( af , "EXITING s_11 HANDLED,EXITING s_1 HANDLED,ENTERING s_2 HANDLED", ESSignal.Sibling.getNextSignal().fromUserSig());
	}
	@AsyncTest 
	public function atest_6_UNCLE2(af:AsyncFactory)  {
		twoStep( af , "EXITING s_111 NOT HANDLED,EXITING s_11 HANDLED,EXITING s_1 HANDLED,ENTERING s_2 HANDLED", ESSignal.Sibling.getNextSignal().fromUserSig(),"s_111");
	}
	@AsyncTest 
	public function atest_7_NEPHEW(af:AsyncFactory)  {
		twoStep( af , "EXITING s_1 HANDLED,ENTERING s_2 HANDLED,ENTERING s_21 HANDLED", ESSignal.Nephew.getNextSignal().fromUserSig(),"s_1,noInit");
	}
	@AsyncTest 
	public function atest_8_FIRSTCOUSIN(af:AsyncFactory)  {
		twoStep( af , "EXITING s_11 HANDLED,EXITING s_1 HANDLED,ENTERING s_2 HANDLED,ENTERING s_21 HANDLED,ENTERING s_211 HANDLED" , ESSignal.FirstCousinRemoved.getNextSignal().fromUserSig());
	}
	@AsyncTest 
	public function atest_8_FIRSTCOUSIN2(af:AsyncFactory)  {
		twoStep( af , "EXITING s_111 NOT HANDLED,EXITING s_11 HANDLED,EXITING s_1 HANDLED,ENTERING s_2 HANDLED,ENTERING s_21 HANDLED,ENTERING s_211 HANDLED" , ESSignal.FirstCousinRemoved.getNextSignal().fromUserSig(),"s_111,noInit");
	}
	@AsyncTest 
	public function atest_9_MIRRORDEPTH_OTHER_STACK(af:AsyncFactory)  {
		twoStep( af , "EXITING s_211 HANDLED,EXITING s_21 HANDLED,EXITING s_2 HANDLED,ENTERING s_1 HANDLED,ENTERING s_11 HANDLED,ENTERING s_111 NOT HANDLED" , ESSignal.MirrorDepthOnOtherStack.getNextSignal().fromUserSig(),"s_211,noInit");
	}
}

