	/*******************************************
 * This is an reference statemachine that is used for testing
 * Hsm, this state topology has all the major states 
 * and possible state transitions (A-
 * 
 * The graphical version can be found on page 95 of Miro Samek's "Practical Statecharts in C
 * but this has a few more cases.
 * 
 * C++" ISBN 1-57820-110-1
 * ****************************************/
package com.troyworks.core.cogs;

import com.sf.Option;using com.sf.Option;
import com.troyworks.core.cogs.CogSignal;
import com.troyworks.core.cogs.CogEvent;
using com.troyworks.core.cogs.CogEvent;
using com.troyworks.core.cogs.CogSignal;


import com.troyworks.core.cogs.Hsm;
import com.troyworks.core.cogs.EightStateMachineSignal;

import com.sf.log.Logger;
using com.sf.log.Logger;

import flash.display.MovieClip;

import com.sf.Assert;using com.sf.Assert;




class EightStateMachine extends Hsm {

	/* the view for this particular model/controller */
	var timeline : MovieClip;
	/* extended state variable */
	var __foo : Bool;
	
	public function new(initState : String = "s_initial", ?init : Bool = true, tl : MovieClip = null) {
		super(initState, "EightStateMachine",init);
		timeline = tl;
	}

	/////////////////// INIT FROM SHALLOW HISTORY //////////////////////////////
	static public function  initFrom_s0() : EightStateMachine {
		var sm : EightStateMachine = new EightStateMachine("s_0");
		//sm... set state vars
		return sm;
	}

	static public function  initFrom_s1() : EightStateMachine {
		var sm : EightStateMachine = new EightStateMachine("s_1");
		//sm... set state vars
		return sm;
	}

	static public function  initFrom_s11() : EightStateMachine {
		var sm : EightStateMachine = new EightStateMachine("s_11");
		//sm... set state vars
		return sm;
	}

	static public function  initFrom_s2() : EightStateMachine {
		var sm : EightStateMachine = new EightStateMachine("s_2");
		//sm... set state vars
		return sm;
	}

	static public function  initFrom_s21() : EightStateMachine {
		var sm : EightStateMachine = new EightStateMachine("s_21");
		//sm... set state vars
		return sm;
	}

	static public function  initFrom_s22() : EightStateMachine {
		var sm : EightStateMachine = new EightStateMachine("s_22");
		//sm... set state vars
		return sm;
	}

	/////////////////// EVENT GENERATORS ////////////////////////////////
	
	public function  fire_SELF() : Void {
		var e = ESSignal.Self.getNextSignal().fromUserSig();
		Debug(("HIGHLIGHTO firing SELF : " + e) ).log();
		dispatchEvent(e);
	}

	 
	public function  fire_SELF2() : Void {
		Debug(("HIGHLIGHTO firing SELF2")).log();
		dispatchEvent(ESSignal.Self2.getNextSignal().fromUserSig());
	}

	 
	public function  fire_GRANDCHILD_ACTIVE() : Void {
		Debug(("HIGHLIGHTO firing GRANDCHILD_ACTIVE")).log();
		dispatchEvent(ESSignal.GrandChildActive.getNextSignal().fromUserSig());
	}

	 
	public function  fire_GRANDCHILD_INACTIVE2() : Void {
		Debug(("HIGHLIGHTO firing GRANDCHILD_INACTIVE2 ")).log();
		dispatchEvent(ESSignal.GrandChildInactive2.getNextSignal().fromUserSig());
	}

	 
	public function  fire_SIBLING() : Void {
		Debug(("HIGHLIGHTO firing SIBLING")).log();
		dispatchEvent(ESSignal.Sibling.getNextSignal().fromUserSig());
	}

	 
	public function  fire_UNCLE() : Void {		currentState.isNull();
		Debug(("HIGHLIGHTO firing UNCLE")).log();
		dispatchEvent(ESSignal.Uncle.getNextSignal().fromUserSig());
	}

	 
	public function  fire_NEPHEW() : Void {
		Debug(("HIGHLIGHTO firing UNCLE")).log();
		dispatchEvent(ESSignal.Nephew.getNextSignal().fromUserSig());
	}

	 
	public function  fire_GREAT_UNCLE() : Void {
		Debug(("HIGHLIGHTO firing GREAT_UNCLE")).log();
		dispatchEvent(ESSignal.GreatUncle.getNextSignal().fromUserSig());
	}

	 
	public function  fire_GREAT_NEPHEW() : Void {
		Debug(("HIGHLIGHTO firing GREAT_NEPHEW")).log();
		dispatchEvent(ESSignal.GreatNephew.getNextSignal().fromUserSig());
	}

	 
	public function  fire_FIRST_COUSIN_REMOVED() : Void {
		Debug(("HIGHLIGHTO firing FIRST_COUSIN_REMOVED")).log();
		dispatchEvent(ESSignal.FirstCousinRemoved.getNextSignal().fromUserSig());
	}

	 
	public function  fire_MIRRORDEPTH_ON_OTHER_STACK() : Void {
		Debug(("HIGHLIGHTO firing MIRRORDEPTH_ON_OTHER_STACK")).log();
		dispatchEvent(ESSignal.MirrorDepthOnOtherStack.getNextSignal().fromUserSig());
	}
	///////////////////// STATES ///////////////////////////////
	/*.................................................................*/
	 
	override public function  s_initial(e : CogEvent) : Dynamic {
		var o : Dynamic = null;
		Debug(e).log();
		var _sw0_ = (e.sig);
		switch(_sw0_) {
			case SigInit(_) :
			/* initialize extended state variable */
				this.__foo = false;
				o = s_0;
			default			:
				o = s_root;
		}
		return o;
	}

	/*.................................................................*/
	 
	public function  s_0(e : CogEvent) : Dynamic {
		Debug(e).log();
		var o : Dynamic = null;
		switch (e.sig) {
			case SigEntry(_),SigExit(_)			: null;
			case SigInit(_)						: o = s_1;
			case SigUser(en,id,e)				:
				switch (en) {
					case GrandChildInactive2,GrandChildInactive 	
												: tran(s_211);
					case GrandChildActive 		: tran(s_111);
					default						: o = s_root;
				}
			default								: o = s_root;
		}
		return o;
	}

	/*.................................................................*/
	 
	public function  s_1(e : CogEvent) : Dynamic {
		Debug(e).log();
		return switch (e.sig) {
			case SigEntry(_),SigExit(_)			: null;
			case SigInit(_)						: s_11;
			case SigUser(en,id,e)				:
				switch (en) {
					case Self2 					: requestTranNoInit(s_1);null;
					case Parent 				: requestTranNoInit(s_0);null;
					case ChildActive 			: requestTranNoInit(s_11);null;
					case Sibling 				: requestTranNoInit(s_2);null;
					case Nephew 				: requestTranNoInit(s_21);null;
					default						: s_0;
				}
			default								: s_0;
		}
	}

	/*.......................DEFAULT..........................................*/
	 
	public function  s_11(e : CogEvent) :  Dynamic {
		var o : Dynamic = null;
		Debug(e).log();
		switch (e.sig) {
			case SigEntry(_),SigExit(_)			: 
			case SigUser(en,id,e)				:
				var en : ESSignal = en;
				switch(en){
					case Self                	: o = requestTranNoInit(s_11);
					case Parent 				: o = requestTranNoInit(s_1);
					case GrandParent			: o = requestTranNoInit(s_0);
					case ChildInactive			: o = requestTranNoInit(s_111);
					case Uncle					: o = requestTranNoInit(s_2);
					case FirstCousinRemoved		: o = requestTranNoInit(s_211);
					default						: o = s_1;
				}
			default								: o = s_1;
		}
		return o;
	}

	/*.................................................................*/
	 
	public function  s_111(e : CogEvent) :  Dynamic {
		Debug(e).log();
		//no actions
		return s_11;
	}

	/*.................................................................*/
	 
	public function  s_2(e : CogEvent) :  Dynamic {
		Debug(e).log();
		return switch (e.sig) {
			case SigEntry(_),SigExit(_)			: null;
			case SigInit(_) 					: s_21;
			default								: s_0;
		}
	}

	/*.................................................................*/
	 
	public function  s_21(e : CogEvent) :  Dynamic {
		Debug(e).log();
		return switch (e.sig) {
			case SigEntry(_),SigExit(_)			: null;
			case SigInit(_) 					: s_211;
			default								: s_2;
		}
	}

	/*.................................................................*/
	 
	public function  s_211(e : CogEvent) :  Dynamic {
		Debug(e).log();
		return switch (e.sig) {
			case SigEntry(_),SigExit(_)			: null;
			case SigUser(en,id,e) 				:
				switch(en){
					case MirrorDepthOnOtherStack: requestTranNoInit(s_111);null;
					default						: s_21;
				}
			default								: s_21;
		}
	}

}