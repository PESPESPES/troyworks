package com.troyworks.core.tweeny.fx {
	import com.troyworks.core.tweeny.Linear;	
	
	import flash.utils.getTimer;	

	import com.troyworks.core.Signals;	
	import com.troyworks.core.cogs.CogSignal;	

	import flash.events.Event;	

	import com.troyworks.core.cogs.CogEvent;	

	import flash.display.DisplayObject;	

	import com.troyworks.core.cogs.Fsm;

	import flash.filters.GlowFilter;

	/*
	 * AnimatedGlow
	 *
	 *  Author: Troy Gardner  
	 * Copyright (c) TroyWorks 2007-2008   http://www.troyworks.com/
	 * Version: 1.0.0  Created:  Dec 26, 2008
	 * 
	 * License Agreement
	 * 
	 * Permission is hereby granted, free of charge, to any person obtaining a copy
	 * of this software and associated documentation files (the "Software"), to deal
	 * in the Software without restriction, including without limitation the rights
	 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	 * copies of the Software, and to permit persons to whom the Software is
	 * furnished to do so, subject to the following conditions:
	 * 
	 * The above copyright notice and this permission notice shall be included in
	 * all copies or substantial portions of the Software.
	 * 
	 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	 * THE SOFTWARE.
	 *
	 * DESCRIPTION
	 * 
	 * This class will ramp up and ramp down a glow (typically used for mouse over
	 * fx and pulse the glow
	 */

	public class AnimatedGlow extends Fsm {
		public static const PLAY : Signals = Signals.PLAY;
		public static const REVERSE_PLAY : Signals = Signals.REVERSE_PLAY;

		private var gf : GlowFilter = new GlowFilter(0xFF0000, 100, 3, 3, 5, 3, false, false);
		private var _target : DisplayObject; 	
		public var minGlow : Number = 0;
		public var maxGlow : Number = 10;
		public var _curGlow : Number = 0;
		public var rampUpTimeMS : Number = 300;
		public var rampDownTimeMS : Number = 150;
		public var rampUpEase:Function = Linear.easeInOut;
		public var rampDownEase:Function= Linear.easeInOut;
		public var enablePulseAtRampedUp : Boolean = true;
		private var _pulseGlow : Number = 5;
		private var _pulseFrequencyInSeconds : Number = 2;
		private	var hpg : Number;
		private var cTime : int;
		private var _timeInt : Number;
		private var lTime : int;
		private var dGlow : Number;
		private var iGlow : Number;
		private var tweenTime : Number;
		

		public function AnimatedGlow(initStateNameAct : String = "s_rampedDown", smName : String = "FSM", aInit : Boolean = true) {
			super(initStateNameAct, smName, aInit);
			//// initialize calculated fields ////
			pulseGlow = pulseGlow;
			pulseFrequencyInSeconds = pulseFrequencyInSeconds;
		}

		public function requestOn(evt : Event = null) : void {
			//requestTran(s_rampingUp);
			dispatchEvent(PLAY.createPrivateEvent());
		}

		public function requestOff(evt : Event = null) : void {
			//requestTran(s_rampedDown);
			dispatchEvent(REVERSE_PLAY.createPrivateEvent());
		}
		public function turnOn(evt : Event = null) : void {
			requestTran(s_rampedDown);
			//dispatchEvent(REVERSE_PLAY.createPrivateEvent());
		}
		public function turnOff(evt : Event = null) : void {
			requestTran(s_rampedDown);
			//dispatchEvent(REVERSE_PLAY.createPrivateEvent());
		}
		public function set glowFilter(val : GlowFilter) : void {
			if(val != null){
			gf = val;
			maxGlow = gf.blurX;
			}else{
				throw new Error("invalid Argument, AnimatedGlow.glowFilter cannot be null");
			}			
		}

		public function get glowFilter() : GlowFilter {
			return gf;
		}

		private function set curGlow(val : Number) : void {
			_curGlow = Math.max(Math.min(maxGlow, val), minGlow);						
			gf.blurX = curGlow;
			gf.blurY = curGlow;
			if(_target != null){
			if(curGlow > 0) {
				_target.filters = [gf];
			}else {
				_target.filters = [];
			}
			}
		}

		
		public function set target( value : DisplayObject ) : void {
			if(_target != null) {
				_target.removeEventListener(Event.ENTER_FRAME, onEF);
			}
			_target = value;
		}

		public function get target( ) : DisplayObject {
			return _target;
		}

		
		private function get curGlow() : Number {
			return _curGlow;
		}

		public function set pulseGlow(val : Number) : void {
			_pulseGlow = val;
			hpg = _pulseGlow / 2;						
		}

		public function set rampUpPeriodInSeconds(val : Number) : void {
			_pulseFrequencyInSeconds = val;
			_timeInt = 1000 / pulseFrequencyInSeconds;						
		}

		public function get rampUpPeriodInSeconds() : Number {
			return _pulseFrequencyInSeconds;
		}

		public function get pulseGlow() : Number {
			return _pulseGlow;
		}

		public function set pulseFrequencyInSeconds(val : Number) : void {
			_pulseFrequencyInSeconds = val;
			_timeInt = 1000 / pulseFrequencyInSeconds;						
		}

		public function get pulseFrequencyInSeconds() : Number {
			return _pulseFrequencyInSeconds;
		}

		private function onEF(evt : Event) : void {
			dispatchEvent(SIG_PULSE.createPrivateEvent());
		}

		public function isOn() : Boolean {
			return isInState(s_rampingUp) || isInState(s_rampedUp);
		}

		public function isOff() : Boolean {
			return isInState(s_rampingDown) || isInState(s_rampedDown);
		}

		public function s_rampedDown(evt : CogEvent) : void {
			switch(evt.sig) {
				case SIG_ENTRY:
					//trace("Starting. ramped Down");
					curGlow = minGlow;
					break;
				case PLAY:
					requestTran(s_rampingUp);	
					break;	
				case SIG_PULSE:
					//trace("Pulsing. ramped Down");
					break;
				case SIG_EXIT:
					//trace("Exiting. ramped Down");
					break;
			}
		}

		public function s_rampingUp(evt : CogEvent) : void {
			switch(evt.sig) {
				case SIG_ENTRY:
					//trace("Starting. ramping Up" + curGlow);
					startPulse();
					iGlow = curGlow;
					dGlow = maxGlow - curGlow;
					//trace("iGlow " + iGlow + " d " + dGlow);
					tweenTime = dGlow / maxGlow * rampUpTimeMS; 
					//trace("tweenTime " + tweenTime + " " + rampUpTimeMS);
					lTime = getTimer();
					s_rampingUp(SIG_PULSE.createPrivateEvent());
					break;
				case SIG_PULSE:
					
					cTime = Math.min((getTimer() - lTime), rampUpTimeMS);
					//trace("ramping Up " + curGlow + "/" + maxGlow + " " + (getTimer() - lTime) + "/" + tweenTime + "  =%" + cTime);
					
					curGlow = rampUpEase( cTime , iGlow,dGlow, tweenTime);
					if(curGlow >= maxGlow) {
						requestTran(s_rampedUp);
					}
					
					break;
				case REVERSE_PLAY:
					requestTran(s_rampingDown);
					break;
				case SIG_EXIT:
					//	trace("Exiting. ramping Up " + curGlow);
					stopPulse();
					break;
			}
		}

		public function s_rampedUp(evt : CogEvent) : void {
			switch(evt.sig) {
				case SIG_ENTRY:
					//trace("Starting. ramped Up " + curGlow);
					//startPulse(1000/24);
					curGlow = maxGlow;
					if(enablePulseAtRampedUp) {
						_target.addEventListener(Event.ENTER_FRAME, onEF);
					}
					lTime = getTimer();
					s_rampedUp(SIG_PULSE.createPrivateEvent());
					break;
				case SIG_PULSE:
					
					cTime = (getTimer() - lTime) % (_timeInt);
					//lTime =getTimer();
					//trace("cTime " + cTime);

					var offset : Number = ((Math.sin(cTime / _timeInt * Math.PI * 2) * hpg) + hpg);
					curGlow = maxGlow - offset ;
					break;
				case REVERSE_PLAY:
					requestTran(s_rampingDown);
				case SIG_EXIT:
					_target.removeEventListener(Event.ENTER_FRAME, onEF);
					//trace("Exiting. ramped Up " + curGlow);
			
					//stopPulse();
					break;
			}
		}

		public function s_rampingDown(evt : CogEvent) : void {
			switch(evt.sig) {
				case SIG_ENTRY:
					//trace("Starting. ramping Down " + curGlow);
					startPulse();
					iGlow = curGlow;
					dGlow = minGlow - curGlow;
					//trace("iGlow " + iGlow + " d " + dGlow);
					tweenTime = ( dGlow * -1) / maxGlow * rampDownTimeMS; 
					//trace("tweenTime " + tweenTime + " " + rampDownTimeMS);
					lTime = getTimer();
					s_rampingDown(SIG_PULSE.createPrivateEvent());
					break;
				case SIG_PULSE:
					//trace("Pulsing. ramping Down " + curGlow);

					cTime = Math.min((getTimer() - lTime), rampDownTimeMS);
					//trace("cTime " + cTime + "/ " + tweenTime);
					curGlow = rampDownEase( cTime, iGlow,dGlow, tweenTime);
				
					//curGlow = iGlow + ( dGlow * cTime / tweenTime);
					if(curGlow <= minGlow) {
						requestTran(s_rampedDown);
					}
					break;
				case PLAY:
					requestTran(s_rampingUp);	
				case SIG_EXIT:
					//trace("Exiting. ramping Down " + curGlow);
					stopPulse();
					break;
			}
		};
	}
}
