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

	public class Expander extends Hsm {
		/* cache the signals for clarity in code and performance reasons */
		public static const REQUEST_TRANSIN:Signals = Signals.REQUEST_TRANSIN;
		public static const REQUEST_TRANSOUT:Signals = Signals.REQUEST_TRANSOUT;
		public static  const TRANSITION_PROGRESS:Signals = Signals.TRANSITION_PROGRESS;
		private var _targPoint:Point;
		private var _mover:Sprite;
		private var easing:Number = 0.3;
		
		private var _enterFrameAdapt:SignalEventAdaptor;
		private var _enterRelay:Function;

		public static var topology:XML = null;
		public static var stateNameIdx:Array;


		public function Expander(initState:String = "s_initial") {
			super(initState, "Expander");
			_enterFrameAdapt = new SignalEventAdaptor(dispatchEvent, TRANSITION_PROGRESS);
			_enterRelay = _enterFrameAdapt.relayEvent;
		}
		public function setMover(view:Sprite):void{
			_mover = view;
		}
		public function requestExpansion():void{
			dispatchEvent(REQUEST_TRANSOUT.createPrivateEvent());
		}
		public function requestContraction():void{
			dispatchEvent(REQUEST_TRANSIN.createPrivateEvent());
		}
		/*.................................................................*/
		 public function s_initial(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_INIT :
				    return s_notExpanded;
			}
			return  s_root;
		}
		///////////////////// STATES ///////////////////////////////
		/*.................................................................*/
		public function s_notExpanded(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_ENTRY :
					return null;
				case SIG_EXIT :
					return null;
				case REQUEST_TRANSOUT:
					tran(s_expanding);
					return null;
			}
			return  s_root;
		}
		/*.................................................................*/
		public function s_expanding(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_ENTRY :
					//starting move/tween
					_mover.addEventListener(Event.ENTER_FRAME, _enterRelay);
					return null;
				case SIG_EXIT :
					//stopping tween 
					_mover.removeEventListener(Event.ENTER_FRAME, _enterRelay);
					return null;
				case TRANSITION_PROGRESS:
					//finished moving
					var tScale:Number = 2;
					var vx:Number = (tScale - _mover.scaleX) * easing;
					var vy:Number = (tScale - _mover.scaleY) * easing;
					_mover.scaleX +=vx;
					_mover.scaleY += vy;
					trace("Expanding....... " + vx + " " + tScale);
					if(Math.abs(vx)  < .25){
						tran(s_expanded);
					}
			}
			return  s_root;
		}
		/*.................................................................*/
		public function s_expanded(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_ENTRY :
					return null;
				case SIG_EXIT :
					return null;
				case REQUEST_TRANSIN:
					tran(s_deexpanding);
					return null;		
			}
			return  s_root;
		}
			/*.................................................................*/
		public function s_deexpanding(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_ENTRY :
					//starting move/tween
					_mover.addEventListener(Event.ENTER_FRAME, _enterRelay);
					return null;
				case SIG_EXIT :
					//stopping tween 
					_mover.removeEventListener(Event.ENTER_FRAME, _enterRelay);
					return null;
				case TRANSITION_PROGRESS:

					var tScale:Number = .24;
					var vx:Number = (tScale - _mover.scaleX  ) * easing * 2;
					var vy:Number = (tScale - _mover.scaleY) * easing * 2;
					_mover.scaleX +=vx;
					_mover.scaleY += vy;
					if(Math.abs(vx) < .25){
						//finished moving
						tran(s_notExpanded);
					}
			}
			return  s_root;
		}	
	}
}
