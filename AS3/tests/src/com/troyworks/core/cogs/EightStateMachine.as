
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
package com.troyworks.core.cogs {
	import com.troyworks.core.cogs.Hsm;	
	import com.troyworks.core.cogs.EightStateMachineSignal;
	import com.troyworks.core.cogs.EightStateMachineEvent;
	import flash.display.MovieClip;


	public class EightStateMachine extends Hsm {
		/* cache the signals for clarity in code and performance reasons */
		public static  const SELF:EightStateMachineSignal = EightStateMachineSignal.SELF;
		public static  const SELF2:EightStateMachineSignal = EightStateMachineSignal.SELF2;
		public static  const PARENT:EightStateMachineSignal = EightStateMachineSignal.PARENT;
		public static  const GRANDPARENT:EightStateMachineSignal = EightStateMachineSignal.GRANDPARENT;
		public static  const CHILD_INACTIVE:EightStateMachineSignal = EightStateMachineSignal.CHILD_INACTIVE;
		public static  const CHILD_ACTIVE:EightStateMachineSignal = EightStateMachineSignal.CHILD_ACTIVE;
		public static  const GRANDCHILD_INACTIVE:EightStateMachineSignal = EightStateMachineSignal.GRANDCHILD_INACTIVE;
		public static  const GRANDCHILD_ACTIVE:EightStateMachineSignal = EightStateMachineSignal.GRANDCHILD_ACTIVE;
		public static  const GRANDCHILD_INACTIVE2:EightStateMachineSignal = EightStateMachineSignal.GRANDCHILD_INACTIVE2;

		public static  const SIBLING:EightStateMachineSignal = EightStateMachineSignal.SIBLING;
		public static  const UNCLE:EightStateMachineSignal = EightStateMachineSignal.UNCLE;
		public static  const NEPHEW:EightStateMachineSignal = EightStateMachineSignal.NEPHEW;
		
		public static  const GREAT_UNCLE:EightStateMachineSignal = EightStateMachineSignal.GREAT_UNCLE;
		public static  const GREAT_NEPHEW:EightStateMachineSignal = EightStateMachineSignal.GREAT_NEPHEW;
		public static  const FIRST_COUSIN_REMOVED:EightStateMachineSignal = EightStateMachineSignal.FIRST_COUSIN_REMOVED;
		public static  const MIRRORDEPTH_ON_OTHER_STACK:EightStateMachineSignal = EightStateMachineSignal.MIRRORDEPTH_ON_OTHER_STACK;

		
		
		/* the view for this particular model/controller */
		private var timeline:MovieClip;
		/* extended state variable */
		private var __foo : Boolean;

		public function EightStateMachine(initState:String = "s_initial", tl : MovieClip = null) {
			super(initState, "EightStateMachine");
			timeline = tl;
		}

		/////////////////// INIT FROM SHALLOW HISTORY //////////////////////////////
		public static function initFrom_s0():EightStateMachine{
			var sm:EightStateMachine = new EightStateMachine("s_0");
			//sm... set state vars
			return sm;
		}
		public static function initFrom_s1():EightStateMachine{
			var sm:EightStateMachine = new EightStateMachine("s_1");
						//sm... set state vars
			return sm;

		}
		public static function initFrom_s11():EightStateMachine{
			var sm:EightStateMachine = new EightStateMachine("s_11");
			//sm... set state vars
			return sm;

			}
		public static function initFrom_s2():EightStateMachine{
			var sm:EightStateMachine = new EightStateMachine("s_2");
			//sm... set state vars
			return sm;

			}
		public static function initFrom_s21():EightStateMachine{
			var sm:EightStateMachine = new EightStateMachine("s_21");
			//sm... set state vars
			return sm;

			}
		public static function initFrom_s22():EightStateMachine{
			var sm:EightStateMachine = new EightStateMachine("s_22");
			//sm... set state vars
			return sm;

			}

		/////////////////// EVENT GENERATORS ////////////////////////////////
		public function fire_SELF():void{
			trace("HIGHLIGHTO firing SELF");
			dispatchEvent(new EightStateMachineEvent(SELF));
		}
		public function fire_SELF2():void{
			trace("HIGHLIGHTO firing SELF2");
			dispatchEvent(new EightStateMachineEvent(SELF2));
		}
		public function fire_PARENT():void{
			trace("HIGHLIGHTO firing PARENT");
			dispatchEvent(new EightStateMachineEvent(PARENT));
		}
		public function fire_GRANDPARENT():void{
			trace("HIGHLIGHTO firing GRANDPARENT");
			dispatchEvent(new EightStateMachineEvent(GRANDPARENT));
		}
		public function fire_CHILD_INACTIVE():void{
			trace("HIGHLIGHTO firing CHILD_INACTIVE");
			dispatchEvent(new EightStateMachineEvent(CHILD_INACTIVE));
		}
		public function fire_CHILD_ACTIVE():void{
			trace("HIGHLIGHTO firing CHILD_ACTIVE");
			dispatchEvent(new EightStateMachineEvent(CHILD_ACTIVE));
		}
		public function fire_GRANDCHILD_INACTIVE():void{
			trace("HIGHLIGHTO firing GRANDCHILD_INACTIVE");
			dispatchEvent(new EightStateMachineEvent(GRANDCHILD_INACTIVE));
		}
		public function fire_GRANDCHILD_ACTIVE():void{
			trace("HIGHLIGHTO firing GRANDCHILD_ACTIVE");
			dispatchEvent(new EightStateMachineEvent(GRANDCHILD_ACTIVE));
		}
		public function fire_GRANDCHILD_INACTIVE2 ():void{
			trace("HIGHLIGHTO firing GRANDCHILD_INACTIVE2 ");
			dispatchEvent(new EightStateMachineEvent(GRANDCHILD_INACTIVE2 ));
		}
		public function fire_SIBLING():void{
			trace("HIGHLIGHTO firing SIBLING");
			dispatchEvent(new EightStateMachineEvent(SIBLING));
		}
		public function fire_UNCLE():void{
			trace("HIGHLIGHTO firing UNCLE");
			dispatchEvent(new EightStateMachineEvent(UNCLE));
		}
		public function fire_NEPHEW():void{
			trace("HIGHLIGHTO firing UNCLE");
			dispatchEvent(new EightStateMachineEvent(NEPHEW));
		}
		public function fire_GREAT_UNCLE():void{
			trace("HIGHLIGHTO firing GREAT_UNCLE");
			dispatchEvent(new EightStateMachineEvent(GREAT_UNCLE));
		}
		public function fire_GREAT_NEPHEW():void{
			trace("HIGHLIGHTO firing GREAT_NEPHEW");
			dispatchEvent(new EightStateMachineEvent(GREAT_NEPHEW));
		}
		public function fire_FIRST_COUSIN_REMOVED():void{
			trace("HIGHLIGHTO firing FIRST_COUSIN_REMOVED");
			dispatchEvent(new EightStateMachineEvent(FIRST_COUSIN_REMOVED));
		}
		public function fire_MIRRORDEPTH_ON_OTHER_STACK():void{
			trace("HIGHLIGHTO firing MIRRORDEPTH_ON_OTHER_STACK");
			dispatchEvent(new EightStateMachineEvent(MIRRORDEPTH_ON_OTHER_STACK));
		}
		//////////////////// CURRENT STATE ACCESSORS ////////////////////////////////////////
		public function get s_initial_isCurrent():Boolean{
			return s_initial == myCurState;
		}
		public function get s_0_isCurrent():Boolean{
			trace("s_0_isCurrent " + (s_0 == myCurState));
			return s_0 == myCurState;
		}
		public function get s_1_isCurrent():Boolean{
				trace("s_1_isCurrent " + (s_1 == myCurState));
			return s_1 == myCurState;
		}
		public function get s_11_isCurrent():Boolean{
				trace("s_11_isCurrent " + (s_11 == myCurState));
			return s_11 == myCurState;
		}
		public function get s_111_isCurrent():Boolean{
				trace("s_111_isCurrent " + (s_111 == myCurState));
			return s_111 == myCurState;
		}
		public function get s_2_isCurrent():Boolean{
			return s_2 == myCurState;
		}
		public function get s_21_isCurrent():Boolean{
			return s_21 == myCurState;
		}
		public function get s_211_isCurrent():Boolean{
			return s_211 == myCurState;
		}
		//////////////
		public function get s_initial_isInState():Boolean{
			return isInState(s_initial);
		}
		public function get s_0_isInState():Boolean{
			return isInState(s_0 );
		}
		public function get s_1_isInState():Boolean{
			return isInState(s_1);
		}
		public function get s_11_isInState():Boolean{
			return isInState(s_11);
		}
		public function get s_111_isInState():Boolean{
			return isInState(s_111);
		}
		public function get s_2_isInState():Boolean{
			return isInState(s_2);
		}
		public function get s_21_isInState():Boolean{
			return isInState(s_21);
		}
		public function get s_211_isInState():Boolean{
			return isInState(s_211 );
		}
				
		
		///////////////////// STATES ///////////////////////////////

		/*.................................................................*/
		 public function s_initial(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_INIT :
					/* initialize extended state variable */
					this.__foo = false;
					return s_0;
			}
			return  s_root;
		}
		/*.................................................................*/
		public function s_0(e : CogEvent):Function {
			//this.__cStateOpts = [E];
			//if (e.sig != SIG_EMPTY  && e.sig != SIG_EMPTY) {
			//trace(sn + e);
			//}
			switch (e.sig) {
				case SIG_ENTRY :
					//timeline.s0Vis.gotoAndStop(2);
					return null;
				case SIG_EXIT :
					//timeline.s0Vis.gotoAndStop(1);
					return null;
				case SIG_INIT :
					return s_1;
				case GRANDCHILD_INACTIVE2 :	
				case GRANDCHILD_INACTIVE :
					tran(s_211);
					return null;
				case GRANDCHILD_ACTIVE:
					tran(s_111);
				     return null;
			}
			return  s_root;
		}
		/*.................................................................*/
		public function s_1(e : CogEvent):Function {
			//__cStateOpts = [A, B, SIG, D, F];
			//if (e.sig != SIG_EMPTY) {
			//trace(sn + e);
			//}
			switch (e.sig) {
				case SIG_ENTRY :

					//timeline.s1Vis.gotoAndStop(2);
					return null;

				case SIG_EXIT :

					//timeline.s1Vis.gotoAndStop(1);
					return null;

				case SIG_INIT :

					return s_11;

				case SELF2:
				
					requestTranNoInit(s_1);
					return null;
					
				case PARENT :
				
					requestTranNoInit(s_0);
					return null;

				case CHILD_ACTIVE :

					requestTranNoInit(s_11);
					return null;
					
				case SIBLING :

					requestTranNoInit(s_2);
					return null;

				case NEPHEW :

					requestTranNoInit(s_21);
					return null;
					
			}
			return s_0;
		}
		/*.......................DEFAULT..........................................*/
		public function s_11(e : CogEvent):Function {
			//__cStateOpts = [G, H, D];
			//if (e.sig != SIG_EMPTY) {
			//trace(sn + e);
			//}
			switch (e.sig) {
				case SIG_ENTRY :

					//timeline.s11Vis.gotoAndStop(2);
					return null;

				case SIG_EXIT :

					//timeline.s11Vis.gotoAndStop(1);
					return null;

				case SELF:
				
					requestTranNoInit(s_11);
					return null;
					
				case PARENT :

					requestTranNoInit(s_1);
					return null;

				case GRANDPARENT :

					requestTranNoInit(s_0);
					return null;
					
				case CHILD_INACTIVE:

					requestTranNoInit(s_111);
					return null;
					
				case UNCLE :

					requestTranNoInit(s_2);
					return null;
					
				case FIRST_COUSIN_REMOVED :
				
					requestTranNoInit(s_211);
					return null;
	
			}
			return s_1;
		}
		/*.................................................................*/
		public function s_111(e : CogEvent):Function {
			//no actions
			return s_11;
		}
		/*.................................................................*/
		public function s_2(e : CogEvent):Function {
			//__cStateOpts = [SIG, F];
			//if (e.sig != SIG_EMPTY) {
			//trace(sn + e);
			//}
			switch (e.sig) {
				case SIG_ENTRY :

					//timeline.s2Vis.gotoAndStop(2);
					return null;

				case SIG_EXIT :

					//timeline.s2Vis.gotoAndStop(1);
					return null;

				case SIG_INIT :

					return s_21;

			}
			return s_0;
		}
		/*.................................................................*/
		public function s_21(e : CogEvent):Function {
			//__cStateOpts = [B, H];
			//if (e.sig != SIG_EMPTY) {
			//trace(sn + e);
			//}
			switch (e.sig) {
				case SIG_ENTRY :

					//timeline.s21Vis.gotoAndStop(2);
					return null;

				case SIG_EXIT :
				
					//timeline.s21Vis.gotoAndStop(1);
					return null;

				case SIG_INIT :
					return s_211;
			}
			return s_2;
		}
		/*.................................................................*/
		public function s_211(e : CogEvent):Function {

			//__cStateOpts = [D, G];
			//if (e.sig != SIG_EMPTY) {
			//trace(sn + e);
			//}
			switch (e.sig) {
				case SIG_ENTRY :

					//timeline.s211Vis.gotoAndStop(2);
					return null;


				case SIG_EXIT :

					//timeline.s211Vis.gotoAndStop(1);
					return null;
					
				case MIRRORDEPTH_ON_OTHER_STACK:
				
					requestTranNoInit(s_111);
				   return null;
					
			}
			return s_21;
		}
	}

}