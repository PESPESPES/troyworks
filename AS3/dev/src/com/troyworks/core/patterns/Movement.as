/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.core.patterns {
	import com.troyworks.core.SignalEventAdaptor;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.events.Event;
	import com.troyworks.core.Signals;
	import com.troyworks.core.cogs.Hsm;
	import com.troyworks.core.cogs.CogEvent;

	public class Movement extends Hsm {
		/* cache the signals for clarity in code and performance reasons */

		public static const REQUEST_NEW_TARGET:Signals = Signals.REQUEST_TRANSITION;
		public static  const TRANSITION_PROGRESS:Signals = Signals.TRANSITION_PROGRESS;
		private var _targPoint:Point;
		private var _mover:Sprite;
		private var easing:Number = 0.3;
		
		private var _enterFrameAdapt:SignalEventAdaptor;
		private var _enterRelay:Function;

		public static var topology:XML = null;
		public static var stateNameIdx:Array;


		public function Movement(initState:String = "s_initial") {
			super(initState, "Movement");
			_enterFrameAdapt = new SignalEventAdaptor(dispatchEvent, Signals.TRANSITION_PROGRESS);
			_enterRelay = _enterFrameAdapt.relayEvent;
		}
		public function setMover(view:Sprite):void{
			_mover = view;
		}
		public function setTargetXYPoint(targ:Point):void{
			trace("setTargetXYPoint " + targ);
			if(targ == null){
				return;
			}
			if((_targPoint == null) || (_targPoint != targ && _targPoint.x != targ.x && _targPoint.y != targ.y)) {
				_targPoint = targ;
				tran(s__movementNeeded);
				//changed;
				return;
			}
		}
		public function noMovementIsNeeded():Boolean{
			return isInState(s__noMovementNeeded);
		}
		public function movementIsNeeded():Boolean{
			return isInState(s__movementNeeded);
		}

		///////////////////// STATES ///////////////////////////////

		/*.................................................................*/
		 public function s_initial(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_INIT :
				    return s__noMovementNeeded;
			}
			return  s_root;
		}
		/*.................................................................*/
		public function s_readyToMove(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_INIT :
				    return s__noMovementNeeded;
				case SIG_ENTRY :
					return null;
				case SIG_EXIT :
					return null;
					
			}
			return  s_root;
		}
		/*.................................................................*/
		public function s__noMovementNeeded(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_ENTRY :
					return null;
				case SIG_EXIT :
					return null;
			}
			return  s_readyToMove;
		}
		/*.................................................................*/
		public function s__movementNeeded(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_ENTRY :
					//starting move/tween
					_mover.alpha = .6;
					_mover.addEventListener(Event.ENTER_FRAME, _enterRelay);
					return null;
				case SIG_EXIT :
					//stopping tween 
					_mover.alpha = 1;
					_mover.removeEventListener(Event.ENTER_FRAME, _enterRelay);
					return null;
				case TRANSITION_PROGRESS:
					
					var vx:Number = (_targPoint.x - _mover.x) * easing;
					var vy:Number = (_targPoint.y - _mover.y) * easing;
					_mover.x += vx;
					_mover.y += vy;
					if(Math.abs(vx) < .25 && Math.abs(vy) < .25){
						//finished moving
						tran(s__noMovementNeeded);
					}
					return null;
			}
			return  s_readyToMove;
		}
	}
}
