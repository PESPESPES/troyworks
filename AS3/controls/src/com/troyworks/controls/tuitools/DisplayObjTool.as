﻿/**
 * A wrapper to manipulate an onscreen ui element, with scale/move etc.
 * @author Default
 * @version 0.1
 */

package com.troyworks.controls.tuitools {
	import flash.filters.DropShadowFilter;
	import flash.display.DisplayObjectContainer;
	import com.troyworks.events.EventWithArgs;	

	import flash.events.Event;	

	import com.troyworks.core.Signals;
	import com.troyworks.core.cogs.*;
	import com.troyworks.core.cogs.proxies.KeyBoardProxy;
	import com.troyworks.ui.UIUtil;

	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;	

	public class DisplayObjTool extends Fsm {
		public var tools : Array = ["none", "move", "scale", "rotate"]; 
		//private var _view : Sprite;
		private var _clip : DisplayObject;
		private var _SHIFT_is_down : Boolean = false;

		public static const MOUSE_DOWN : CogSignal = Signals.MOUSE_DOWN;
		public static const MOUSE_UP : CogSignal = Signals.MOUSE_UP;
		public static const MOUSE_CLICK : CogSignal = Signals.MOUSE_CLICK;
		public static const MOUSE_MOVE : CogSignal = Signals.MOUSE_MOVE;
		public static const MOUSE_RELEASED_OUTSIDE : CogSignal = Signals.MOUSE_RELEASED_OUTSIDE;
		public static const EVT_USERPLACED_REGISTRATION : String = "EVT_USERPLACED_REGISTRATION";
		///////////////// SNAPSHOT OF STATE //////////////////////
		private	var orig_x : Number;
		private	var orig_y : Number;
		private	var clickx : Number;
		private	var clicky : Number;
		private	var offx : Number;
		private	var offy : Number;

		private var clickAngle : Number;
		private var clipRotation : Number;
		private var b : Rectangle;

		private var clickXscale : Number;
		private var clickYscale : Number;
		private var sx : Number;
		private	var sy : Number;
		private var lx : Number;
		private	var ly : Number;
		private var keyP : KeyBoardProxy;
		private var FTScaleRegulator : Sprite;
		private var rp : Point;
		private var isPressed : Boolean = false;
		private var registrationPoint : Sprite;
		private var clickTime : int;

		////////////////// UI CONTROLS ////////////////////////
		private var scale_btn : Sprite;
		private var rotate_btn : Sprite;
		private var move_btn : Sprite;

		private var _tl : Sprite;
		private var _t : Sprite;
		private var _tr : Sprite;
		private var _l : Sprite;
		private var _r : Sprite;
		private var _bl : Sprite;
		private var _b : Sprite;
		private var _br : Sprite;
		private var _constraintAspectRatio : Boolean;
		public var userHasPlacedRegistration : Boolean = false;
		private var tmpdistFromStartToRp : Number;
		public var selectedFilters : Array = [];
		private var itmpdistFromStartToRp : Number;
		private var ip : Point;
		private var pip : Point;

		private var scalMx : Number;
		private var offsMx : Number;
		private var sRot : Number;
		private var clickMSTime : Number = 250;
		private var sw : Number;
		private var sh : Number;
		private var visualizationON : Boolean = false;

		public var allowClickToReplaceRegistrationPoint : Boolean = false;
		private var hideRegistrationPointOnMove : Boolean = true;
		private var rpIdx : Object = new Object();

		public function DisplayObjTool(toOff : Boolean = false) {
			super("s_initial","DisplayObjTool");
		}

		/*public function setView(mc : Sprite) : void {
			_view = mc;
		}*/

		public function createBuiltInUI(scope:DisplayObjectContainer) : void {
			_tl = new  Sprite();
			_t = new  Sprite();
			_tr = new  Sprite();
			_l = new  Sprite();
			_r = new  Sprite();
			_bl = new  Sprite();
			_b = new  Sprite();
			_br = new  Sprite();
			drawControl(_tl, scope);
			drawControl(_t, scope);
			drawControl(_tr, scope);
			drawControl(_l, scope);
			drawControl(_r, scope);
			drawControl(_bl, scope);
			drawControl(_b, scope);
			drawControl(_br, scope);
			this.scale_btn = new  Sprite();
			this.rotate_btn = new  Sprite();
			this.move_btn = new  Sprite();
			this.registrationPoint = new  Sprite();
			this.registrationPoint.graphics.lineStyle(1, 0);
			this.registrationPoint.graphics.beginFill(0xFF0000, .6);
			this.registrationPoint.graphics.drawCircle(0, 0, 5);
			scope.addChild(this.registrationPoint);
			
		}

		protected function drawControl(dO : Sprite, scope:DisplayObjectContainer) : void {
			dO.graphics.lineStyle(1, 0);
			dO.graphics.beginFill(0xCCCCCC, .6);
			dO.graphics.drawCircle(0, 0, 5);
			dO.buttonMode = true;
			dO.filters = [new DropShadowFilter(4,45,.6)];
			scope.addChild(dO);
		}

		public function setClipToManipulate(mc : DisplayObject) : void {
			trace("setClipToManipulate " + mc);
			if(mc != _clip) {
				if(_clip != null) {
					//////////// CLEAR out old one ///////////////
					if(keyP != null) {
						keyP.disable();
						keyP = null;
					}
					//	if(rpIdx[_clip.name]!= null){
					trace("caching registration point");
					rpIdx[UIUtil.getAnchorPath(_clip)] = new Point(rp.x, rp.y);
					//	}
					/////// remove listeners ////////////
					_clip.stage.removeEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
					_clip.removeEventListener(MouseEvent.CLICK, onClick);
					_clip.removeEventListener(MouseEvent.MOUSE_DOWN, onPress);
					_clip.removeEventListener(MouseEvent.MOUSE_UP, onRelease);
					registrationPoint.visible = false;
				}
				
				_clip = mc;			
				if(mc != null) {
					b = mc.getBounds(mc);
					//setRegistration(0, 0);
					var ap : String = UIUtil.getAnchorPath(mc);
					if(rpIdx[ap] != null) {
						trace("found Cached Registration Point");
						setRegistration(rpIdx[ap].x, rpIdx[ap].y);
					} else {
						trace("no found Cached Registration Point");
						setRegistration(b.x + b.width / 2, b.y + b.height / 2);
					}
					keyP = new KeyBoardProxy(mc.stage, this);
					keyP.enable();
				
					trace("adding setClipToManipulate ");
					
					_clip.addEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
					_clip.addEventListener(MouseEvent.CLICK, onClick);
					_clip.addEventListener(MouseEvent.MOUSE_DOWN, onPress);
					_clip.addEventListener(MouseEvent.MOUSE_UP, onRelease);
					if(_tl != null) {
						_tl.visible = true;
						_t.visible = true;
						_tr.visible = true;
						_l.visible = true;
						_r.visible = true;
						_bl.visible = true;
						_b.visible = true;
						_br.visible = true;
					}
					tran(_currentState);
					//					_currentState(SIG_EXIT.createPrivateEvent());
					//					_currentState(SIG_EXIT.createPrivateEvent());
					positionControls();
				} else {
					///////// settting to null clip ///////
					if(_tl != null) {
						_tl.visible = false;
						_t.visible = false;
						_tr.visible = false;
						_l.visible = false;
						_r.visible = false;
						_bl.visible = false;
						_b.visible = false;
						_br.visible = false;
					}
				}
			} else {
				//ignore
				trace("ignoring setClipToManipulate ");
			}
		}

		public function setUIControls(scale_btn : Sprite, rotate_btn : Sprite, move_btn : Sprite, registrationPoint : Sprite) : void {
			this.scale_btn = (scale_btn == null) ? new Sprite() : scale_btn;
			this.rotate_btn = (rotate_btn == null) ? new Sprite() : rotate_btn;
			this.move_btn = (move_btn == null) ? new Sprite() : move_btn;
			if(this.registrationPoint != null) {
				this.registrationPoint.removeEventListener(MouseEvent.MOUSE_DOWN, onRPMouseDown);
				this.registrationPoint.removeEventListener(MouseEvent.MOUSE_MOVE, onRPMouseDown);
			}
			if(registrationPoint != null) {
				this.registrationPoint = registrationPoint;
				this.registrationPoint.addEventListener(MouseEvent.MOUSE_DOWN, onRPMouseDown);
				this.registrationPoint.visible = false;
			}
			enableControls();
		}

		public function onRPMouseDown(evt : Event) : void {
			trace("onRPMouseDown " + registrationPoint);
			
			this.registrationPoint.stage.addEventListener(MouseEvent.MOUSE_MOVE, onRPMouseMove);
			this.registrationPoint.stage.addEventListener(MouseEvent.MOUSE_UP, onRPMouseUp);
			//this.registrationPoint.removeEventListener(MouseEvent.MOUSE_DOWN, onRPMouseDown);
			var evtA : EventWithArgs = new EventWithArgs("REQUEST_HAND_CURSOR_MODE");
			evtA.args = ["holdOnTop"];
			_clip.stage.dispatchEvent(evtA);
			onRPMouseMove();
		}

		public function onRPMouseMove(evt : Event = null) : void {
			trace("onRPMouseMove ");
			if(registrationPoint != null) {
			
				registrationPoint.x = registrationPoint.parent.mouseX;
				registrationPoint.y = registrationPoint.parent.mouseY;
			}
			//setRegistration(_clip.mouseX, _clip.mouseY);
		}

		public function onRPMouseUp(evt : Event) : void {
			trace("onRPMouseUp ");
			if(registrationPoint != null) {
			
				this.registrationPoint.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onRPMouseMove);
				this.registrationPoint.stage.removeEventListener(MouseEvent.MOUSE_UP, onRPMouseUp);
			}
			setRegistration(_clip.mouseX, _clip.mouseY);
			var evtA : EventWithArgs = new EventWithArgs("REQUEST_HAND_CURSOR_MODE");
			evtA.args = [null];
			userHasPlacedRegistration = true;
			_clip.stage.dispatchEvent(evtA);
		}

		public function setUIFreeScaleHandles(tl : Sprite, t : Sprite, tr : Sprite,  l : Sprite,r : Sprite,bl : Sprite,b : Sprite,br : Sprite) : void {
			//trace("setUIFreeScaleHandles "+ arguments.join(","));
			if(_tl != null) {
				_tl = tl;
				_t = t;
				_tr = tr;
				_l = l;
				_r = r;
				_bl = bl;
				_b = b;
				_br = br;
			}
			if(_clip != null) {
				positionControls();
			}
		}

		public function requestScaleTool(evt : MouseEvent = null) : void {
			tran(s_ScaleTool);
		}

		public function requestMoveTool(evt : MouseEvent = null) : void {
			tran(s_MoveTool);
		}

		public function requestRotateTool(evt : MouseEvent = null) : void {
			tran(s_RotateTool);
		}

		private function positionControls() : void {
			var rect : Rectangle;
			var bnds : Rectangle = (rect == null) ? (_clip.getBounds(_clip.parent)) : rect;
			scale_btn.visible = true;
			rotate_btn.visible = true;
			move_btn.visible = true;
			if(false) {
				scale_btn.y = bnds.bottom;
				rotate_btn.y = bnds.bottom;
				move_btn.y = bnds.bottom;
				scale_btn.x = bnds.left;
				rotate_btn.x = scale_btn.x + scale_btn.width + 5 ;
				move_btn.x = rotate_btn.x + rotate_btn.width + 5;
			}
			//if(_currentState == s_MoveTool || _currentState == s_ScaleTool){
			if(_tl != null) {
				_tl.y = bnds.topLeft.y;
				_tl.x = bnds.topLeft.x;
					
				_t.y = bnds.top;
				_t.x = bnds.x + bnds.width / 2;
					
				_tr.y = bnds.top;
				_tr.x = bnds.right;

				_l.y = bnds.y + bnds.height / 2;
				_l.x = bnds.left;

				_r.y = bnds.y + bnds.height / 2;
				_r.x = bnds.right;

				_bl.y = bnds.bottom;
				_bl.x = bnds.left;

				_b.y = bnds.bottom;
				_b.x = bnds.x + bnds.width / 2;
					
				_br.y = bnds.bottomRight.y;
				_br.x = bnds.bottomRight.x;
			}
			var evtA : EventWithArgs = new EventWithArgs("positionImageControls", true, true);
			evtA.args = [rp.clone()];
			_clip.stage.dispatchEvent(evtA);
			
				//}
		}

		public function updateRegistrationPointView() : void {
			if(registrationPoint != null) {
				var a : Point = registrationPoint.parent.globalToLocal(_clip.localToGlobal(rp.clone()));
				registrationPoint.x = a.x;
				registrationPoint.y = a.y;
				//registrationPoint.visible = true;
			}
		}

		private function hideControls() : void {
			trace("hiding controls ");
			//	scale_btn.visible = false;
			rotate_btn.visible = false;
			move_btn.visible = false;
		}

		private function enableControls() : void {
			trace("enableControls");
			scale_btn.addEventListener(MouseEvent.CLICK, requestScaleTool);
			rotate_btn.addEventListener(MouseEvent.CLICK, requestRotateTool);
			move_btn.addEventListener(MouseEvent.CLICK, requestMoveTool);
		//	registrationPoint.visible = true;
		}

		private function releaseControls() : void {
			trace("releaseControls");
			scale_btn.removeEventListener(MouseEvent.CLICK, requestScaleTool);
			rotate_btn.removeEventListener(MouseEvent.CLICK, requestRotateTool);
			move_btn.removeEventListener(MouseEvent.CLICK, requestMoveTool);
			if(registrationPoint != null) {
			
				registrationPoint.visible = false;
			}
		}

		private function enableFreeScaleControls() : void {
			if(_tl != null) {
				_tl.addEventListener(MouseEvent.MOUSE_DOWN, onFreeScaleControlClicked);
				_t.addEventListener(MouseEvent.MOUSE_DOWN, onFreeScaleControlClicked);
				_tr.addEventListener(MouseEvent.MOUSE_DOWN, onFreeScaleControlClicked);
				_l.addEventListener(MouseEvent.MOUSE_DOWN, onFreeScaleControlClicked);
				_r.addEventListener(MouseEvent.MOUSE_DOWN, onFreeScaleControlClicked);
				_bl.addEventListener(MouseEvent.MOUSE_DOWN, onFreeScaleControlClicked);
				_b.addEventListener(MouseEvent.MOUSE_DOWN, onFreeScaleControlClicked);
				_br.addEventListener(MouseEvent.MOUSE_DOWN, onFreeScaleControlClicked);
			}
		}

		private function onFreeScaleControlClicked(event : MouseEvent = null) : void {
			var opposite : Sprite;
			var tg : Sprite = Sprite(event.target);
			trace("onFreeScaleControlClicked " + tg.name + " " + _tl.name);
			if(_tl != null) {
				if(tg == _tl) {
					trace("opposite bottom right");
					opposite = _br;
				}else if (tg == _t) {
					opposite = _b;
				}else if (tg == _tr) {
					opposite = _bl;
				}else if (tg == _r) {
					opposite = _l;
				}else if (tg == _br) {
					opposite = _tl;
				}else if (tg == _b) {
					opposite = _t;
				}else if (tg == _bl) {
					opposite = _tr;
				}else if (tg == _l) {
					opposite = _r;
				} else {
					trace("no valid control click");
				}
			}
			trace("opposite is " + opposite.name + " " + _clip);
			var p1 : Point = new Point(opposite.x, opposite.y);
			trace(" _clip.globalToLocal " +  _clip.globalToLocal);
			trace(" opposite.parent " +  opposite.parent);
			var p : Point = _clip.globalToLocal(opposite.parent.localToGlobal(p1));
			setRegistration(p.x, p.y);
			//if(_clip.getBounds(_clip.parent).contains(_clip.parent.mouseX, _clip.parent.mouseY)){
			//	onPress();
			//}
			//setRegistration(opposite.x, opposite.y);
		}

		private function releaseFreeScaleControls() : void {
			if(_tl != null) {
				_tl.removeEventListener(MouseEvent.MOUSE_DOWN, onFreeScaleControlClicked);
				_t.removeEventListener(MouseEvent.MOUSE_DOWN, onFreeScaleControlClicked);
				_tr.removeEventListener(MouseEvent.MOUSE_DOWN, onFreeScaleControlClicked);
				_l.removeEventListener(MouseEvent.MOUSE_DOWN, onFreeScaleControlClicked);
				_r.removeEventListener(MouseEvent.MOUSE_DOWN, onFreeScaleControlClicked);
				_bl.removeEventListener(MouseEvent.MOUSE_DOWN, onFreeScaleControlClicked);
				_b.removeEventListener(MouseEvent.MOUSE_DOWN, onFreeScaleControlClicked);
				_br.removeEventListener(MouseEvent.MOUSE_DOWN, onFreeScaleControlClicked);
			}
		}

		public function onMouseMove(evt : MouseEvent) : void {
			dispatchEvent(new CogEvent(Signals.MOUSE_MOVE.name, MOUSE_MOVE));
			evt.updateAfterEvent();
		}

		public function snapShotClip() : void {
			orig_x = _clip.x;
			orig_y = _clip.y;
			clickx = _clip.parent.mouseX;
			clicky = _clip.parent.mouseY;
			offx = clickx - orig_x;
			offy = clicky - orig_y;
			clickAngle = getMouseAngle();
			clipRotation = rotation2;//_clip.rotation;
		}

		public function onRelease(event : MouseEvent = null) : void {
			trace("onRelease");
			isPressed = false;
			dispatchEvent(new CogEvent(CogEvent.EVTD_COG_PRIVATE_EVENT, MOUSE_UP));
			_clip.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_clip.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			_clip.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
			_clip.stage.removeEventListener(MouseEvent.MOUSE_UP, onReleaseOutside);
			//_clip.parent.FTScaleRegulator.removeMovieClip();
		};

		public function onReleaseOutside(event : MouseEvent = null) : void {
			trace("onReleaseOutside**************************************");
			onRelease();
			dispatchEvent(new CogEvent(CogEvent.EVTD_COG_PRIVATE_EVENT, MOUSE_RELEASED_OUTSIDE));
		}

		public function onPress(event : MouseEvent = null) : void {
			trace("onPress");
			isPressed = true;
			clickTime = getTimer();
			dispatchEvent(new CogEvent(CogEvent.EVTD_COG_PRIVATE_EVENT, MOUSE_DOWN));
			_clip.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_clip.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			_clip.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			
			
			//_clip.stage.addEventListener(MouseEvent.MOUSE_UP, onReleaseOutside, true);
			//_clip.parent.FTScaleRegulator.removeMovieClip();
		}

		public function onRollOut(event : MouseEvent = null) : void {
			trace("DisplayObjTool.onRollOut**************************************" + _clip);
			//onReleaseOutside();
			_clip.stage.addEventListener(MouseEvent.MOUSE_UP, onReleaseOutside);//, true);
		}

		public function onRollOver(event : MouseEvent = null) : void {
			trace("DisplayObjTool.onRollOver******************************************");
			_clip.stage.removeEventListener(MouseEvent.MOUSE_UP, onReleaseOutside);
		}

		public function onClick(event : MouseEvent = null) : void {
			dispatchEvent(new CogEvent(CogEvent.EVTD_COG_PRIVATE_EVENT, MOUSE_CLICK));
		}

		public function reportKeyDown(event : KeyboardEvent) : void {
			//	trace("Key Pressed: " + String.fromCharCode(event.charCode) +         " (key code: " + event.keyCode + " character code: "         + event.charCode + ")");
			if (event.keyCode == Keyboard.SHIFT) {
				_SHIFT_is_down = true;
			}
		}

		public function reportKeyUp(event : KeyboardEvent) : void {
			//	trace("Key Released: " + String.fromCharCode(event.charCode) +         " (key code: " + event.keyCode + " character code: " +         event.charCode + ")");
			if (event.keyCode == Keyboard.SHIFT) {
				_SHIFT_is_down = false;
			}
		}

		public function set constraintAspectRatio(val : Boolean) : void {
			_constraintAspectRatio = val;
		}

		public function get constraintAspectRatio() : Boolean {
			return _constraintAspectRatio;
		}

		public function setRegistration(x : Number = 0, y : Number = 0) : void {
			trace("setRegistration x:" + x);
			rp = new Point(x, y);
			updateRegistrationPointView();
			dispatchEvent(new Event("EVT_USERPLACED_REGISTRATION"));
		}

		public function get x2() : Number {
			var p : Point = _clip.parent.globalToLocal(_clip.localToGlobal(rp.clone()));
			return p.x;
		}

		public function set x2(value : Number) : void {
			var p : Point = _clip.parent.globalToLocal(_clip.localToGlobal(rp.clone()));
			_clip.x += value - p.x;
		}

		public function get y2() : Number {
			var p : Point = _clip.parent.globalToLocal(_clip.localToGlobal(rp.clone()));
			return p.y;
		}

		public function set y2(value : Number) : void {
			var p : Point = _clip.parent.globalToLocal(_clip.localToGlobal(rp.clone()));
			_clip.y += value - p.y;
		}

		public function get scaleX2() : Number {
			return _clip.scaleX;
		}

		public function set scaleX2(value : Number) : void {
			setProperty2("scaleX", value);
		}

		public function get scaleY2() : Number {
			return _clip.scaleY;
		}

		public function set scaleY2(value : Number) : void {
			setProperty2("scaleY", value);
		}

		public function get width2() : Number {
			return _clip.scaleX;
		}

		public function set width2(value : Number) : void {
			setProperty2("width", value);
		}

		public function get height2() : Number {
			return _clip.height;
		}

		public function set height2(value : Number) : void {
			setProperty2("height", value);
		}

		public function get rotation2() : Number {
			return _clip.rotation;
		}

		public function set rotation2(value : Number) : void {
			setProperty2("rotation", value);
		}

		public function get mouseX2() : Number {
			if(_clip is InteractiveObject) {
				return Math.round(InteractiveObject(_clip).mouseX - rp.x);
			} else {
				return 0;
			}
		}

		public function get mouseY2() : Number {
			if(_clip is InteractiveObject) {
				return Math.round(InteractiveObject(_clip).mouseY - rp.y);
			} else {
				return 0;
			}
		}

		public function setProperty2(prop : String, n : Number) : void {
			var a : Point = _clip.parent.globalToLocal(_clip.localToGlobal(rp.clone()));

			_clip[prop] = n;

			var b : Point = _clip.parent.globalToLocal(_clip.localToGlobal(rp.clone()));

			_clip.x -= (b.x - a.x);
			_clip.y -= (b.y - a.y);
		}

		public function isInNoToolMode() : Boolean {
			return isInState(s_NoTool);
		}

		public function isInMoveToolMode() : Boolean {
			return isInState(s_MoveTool);
		}

		public function isInRotateToolMode() : Boolean {
			return isInState(s_RotateTool);
		}

		public function isInScaleToolMode() : Boolean {
			return isInState(s_ScaleTool);
		}

		////////////// STATES /////////////////////////////////
		public function s_initial(evt : CogEvent) : void {
			switch(evt.sig) {
				case SIG_INIT:
				trace('s_initial '+s_ScaleTool );
					//			_initState=s_NoTool;
					//tran(s_MoveTool);
					//tran(s_RotateTool);
					tran(s_ScaleTool);
					break;
			}
		}

		public function s_NoTool(evt : CogEvent) : void {
			trace("s_NoTool");
			switch(evt.sig) {
				case SIG_ENTRY:
					//	hideControls();
					break;
				case SIG_EXIT:
			
					break;
			}
		}

		public function s_MoveTool(evt : CogEvent) : void {
			//trace("TwoStateFsm.ON_state " + event);
			trace("s_MoveTool" + evt.sig);
			switch(evt.sig) {
				case SIG_ENTRY:
					trace("movingtool enter");
					//show the move cursor
					scale_btn.filters = [];
					move_btn.filters = selectedFilters;
					rotate_btn.filters = [];
					enableFreeScaleControls();
					if(registrationPoint) {
						registrationPoint.visible = false;
					}
					break;
				case SIG_EXIT:
					scale_btn.filters = [];
					move_btn.filters = [];
					rotate_btn.filters = [];
					releaseFreeScaleControls();
					if(registrationPoint) {
						registrationPoint.visible = false;
					}
					break;
				case MOUSE_DOWN:
					trace("mouse down");
					snapShotClip();
					positionControls();
					enableControls();
					break;
				case MOUSE_MOVE:
					trace("mouse move");
					
					if (_SHIFT_is_down) {
						var thisx : Number = _clip.parent.mouseX - clickx;
						var thisy : Number = _clip.parent.mouseY - clicky;
						if (Math.abs(thisx) > Math.abs(thisy)) {
							_clip.x = _clip.parent.mouseX - offx;
							_clip.y = orig_y;
						} else {
							_clip.x = orig_x;
							_clip.y = _clip.parent.mouseY - offy;
						}
					} else {
						_clip.x = _clip.parent.mouseX - offx;
						_clip.y = _clip.parent.mouseY - offy;
					}
					//_clip.updateAfterEvent();
					positionControls();
					break;
				case MOUSE_UP:
					trace("mouse up");
					//	hideControls();
					//releaseControls();
					break;
			}
		}

		public function s_SetRegistrationTool(evt : CogEvent) : void {
			switch(evt.sig) {
				case SIG_ENTRY:
					trace("registration enter");
					scale_btn.filters = [];
					move_btn.filters = [];
					rotate_btn.filters = selectedFilters;
					updateRegistrationPointView();
					registrationPoint.visible = true;
					//					enableFreeScaleControls();
					break;
				case SIG_EXIT:
					scale_btn.filters = [];
					move_btn.filters = [];
					rotate_btn.filters = [];
					registrationPoint.visible = false;
					//releaseFreeScaleControls();
					break;
				case MOUSE_CLICK:
					if(allowClickToReplaceRegistrationPoint) {
						var exitTime : Number = (clickTime + clickMSTime);
						var curTime : Number = getTimer();
						trace("mouse Click " + clickTime + " " + exitTime);
						if( curTime < exitTime) {
							registrationPoint.x = registrationPoint.parent.mouseX;
							registrationPoint.y = registrationPoint.parent.mouseY;
							setRegistration(_clip.mouseX, _clip.mouseY);
						}
					}
					break;
				case MOUSE_DOWN:
					trace("rotate mouse down");
					snapShotClip();
					positionControls();
					enableControls();
					break;
				case MOUSE_MOVE:
					trace("rotate mouse move");
					registrationPoint.x = registrationPoint.parent.mouseX;
					registrationPoint.y = registrationPoint.parent.mouseY;
					setRegistration(_clip.mouseX, _clip.mouseY);
					break;
				case MOUSE_RELEASED_OUTSIDE:
					tran(s_NoTool);
					break;
				case MOUSE_UP:
					trace("rotate mouse up");
					//hideControls();
					//releaseControls();
					break;
			}
		}

		public function s_RotateTool(evt : CogEvent) : void {
			switch(evt.sig) {
				case SIG_ENTRY:
					trace("rotate enter");
					scale_btn.filters = [];
					move_btn.filters = [];
					rotate_btn.filters = selectedFilters;
					updateRegistrationPointView();
					registrationPoint.visible = true;
					//					enableFreeScaleControls();
					break;
				case SIG_EXIT:
					scale_btn.filters = [];
					move_btn.filters = [];
					rotate_btn.filters = [];
					registrationPoint.visible = false;
					//releaseFreeScaleControls();
					break;
				case MOUSE_CLICK:
					if(allowClickToReplaceRegistrationPoint) {
						var exitTime : Number = (clickTime + clickMSTime);
						var curTime : Number = getTimer();
						trace("mouse Click " + clickTime + " " + exitTime);
						if( curTime < exitTime) {
							registrationPoint.x = registrationPoint.parent.mouseX;
							registrationPoint.y = registrationPoint.parent.mouseY;
							setRegistration(_clip.mouseX, _clip.mouseY);
							userHasPlacedRegistration = true;
						}
					}
					break;
				case MOUSE_DOWN:
					trace("rotate mouse down");
					snapShotClip();
					positionControls();
					enableControls();
					sx = (_clip.parent.mouseX - registrationPoint.x) ;
					sy = (_clip.parent.mouseY - registrationPoint.y);
					sRot = Math.atan2(sx, sy);
					if(hideRegistrationPointOnMove) {
						registrationPoint.visible = false;
					}
					break;
				case MOUSE_MOVE:
					trace("rotate mouse move");
					trace("clipRotation " + clipRotation + " clickAngle " + clickAngle + " getMouseAngle() " + getMouseAngle());
					
					var	cx : Number = (_clip.parent.mouseX - registrationPoint.x) ;
					var cy : Number = (_clip.parent.mouseY - registrationPoint.y);
					var cRot : Number = Math.atan2(cx, cy);
					var dRot : Number = cRot - sRot;
					var dRotA : Number = dRot * 180 / Math.PI;
					rotation2 = clipRotation - dRotA;
					
					positionControls();
					break;
				case MOUSE_RELEASED_OUTSIDE:
					tran(s_NoTool);
					break;
				case MOUSE_UP:
					trace("rotate mouse up");
					if(hideRegistrationPointOnMove) {
						registrationPoint.visible = true;
					}
					//hideControls();
					//releaseControls();
					break;
			}
		}

		public function s_ScaleTool(evt : CogEvent) : void {
			switch(evt.sig) {
				case SIG_ENTRY:
					trace("scale enter");
					//show the move cursor
					scale_btn.filters = selectedFilters;
					move_btn.filters = [];
					rotate_btn.filters = [];
					enableFreeScaleControls();
					updateRegistrationPointView();
					if(registrationPoint) {
						registrationPoint.visible = true;
					}
					break;
				case SIG_EXIT:
					scale_btn.filters = [];
					move_btn.filters = [];
					rotate_btn.filters = [];
					releaseFreeScaleControls();
					if(registrationPoint) {
						registrationPoint.visible = false;
					}
					break;
				case MOUSE_CLICK:
					if(allowClickToReplaceRegistrationPoint) {
						var exitTime : Number = (clickTime + clickMSTime );
						var curTime : Number = getTimer();
						trace("mouse Click " + clickTime + " " + exitTime);
						if( curTime < exitTime) {
							if(registrationPoint) {
								registrationPoint.x = registrationPoint.parent.mouseX;
								registrationPoint.y = registrationPoint.parent.mouseY;
							}
							setRegistration(_clip.mouseX, _clip.mouseY);
							userHasPlacedRegistration = true;
						}
					}
					break;
				case MOUSE_DOWN:
					trace("scale mouse down");
					snapShotClip();
					positionControls();
					enableControls();
					if(FTScaleRegulator == null) {
						FTScaleRegulator = new Sprite();
						FTScaleRegulator.mouseEnabled = false;
						FTScaleRegulator.mouseChildren = false;
					}
					_clip.parent.addChild(FTScaleRegulator);
					FTScaleRegulator.graphics.clear();
					//, "scaleX", "scaleY"]);

					
					b = _clip.getBounds(_clip);
					//sb = _clip.getBounds(_clip.parent);
					//	trace(" b " + b + " clip " + clip + " clipp " + clip._parent + " " + b.xMin);
					clickXscale = scaleX2;
					clickYscale = scaleY2;
			
					sw = _clip.width ;
					/// _clip.scaleX;
					sh = _clip.height;
					sx = (_clip.parent.mouseX) ;
					sy = (_clip.parent.mouseY );
					//_clip.parent.graphics.clear();

					var pp : Point = _clip.parent.globalToLocal(_clip.localToGlobal(rp.clone()));
					trace("rp " + rp.x + " " + pp.x);
					var dxS : Number = ((sx - pp.x )) ;
					var dyS : Number = 0;
					//((sy - rp.y) );
					tmpdistFromStartToRp = Math.sqrt(dxS * dxS + dyS * dyS);
					
					ip = new Point(_clip.mouseX, _clip.mouseY);
					pip = _clip.parent.globalToLocal(_clip.localToGlobal(ip));
					dxS = (ip.x - rp.x);
					dyS = (ip.y - rp.y);
					//	var rightSideOfRpInParent : Number = ( b.right * _clip.scaleX);
					//	var mouseXInParent : Number = (_clip.mouseX * _clip.scaleX);
					//right side should be 400 (800 wide clip)
					//	trace("b.right " + b.right + " in parent 400? " + rightSideOfRpInParent + " pp.x " + (_clip.mouseX * _clip.scaleX));
					//400-400==1   400-200= 2
					//	var tp : Number = rightSideOfRpInParent - mouseXInParent;
					//	trace(" tp 200? " + tp);
					//	scalMx = (rightSideOfRpInParent) / mouseXInParent;
					trace("scalMx " + scalMx);
					//left side infinite?  right side 0;
					//	offsMx = 0;
					//(rightSideOfRpInParent - (_clip.mouseX*_clip.scaleX))/2;// tp; 
					itmpdistFromStartToRp = Math.sqrt(dxS * dxS + dyS * dyS);
					//FTScaleRegulator.transform.matrix = _clip.transform.matrix;
					visualize();
					if(hideRegistrationPointOnMove) {
						registrationPoint.visible = false;
					}
					break;
				case MOUSE_MOVE:
					//	trace("scale mouse move");
					var dxC : Number = _clip.parent.mouseX - pip.x ;
					var dyC : Number = _clip.parent.mouseY - pip.y;

					visualize(dxC, dyC);
					
					if (_SHIFT_is_down || constraintAspectRatio) {
						/////// SCALE maintaining aspect ratio /////////

						var ox : Number = sx - registrationPoint.x;
						var oy : Number = sy - registrationPoint.y;
						var oRad : Number = Math.sqrt(ox * ox + oy * oy);
							
						var cx : Number = _clip.parent.mouseX - registrationPoint.x;
						var cy : Number = _clip.parent.mouseY - registrationPoint.y;
						var cRad : Number = Math.sqrt(cx * cx + cy * cy);
						var scale : Number = cRad / oRad;
						width2 = scale * sw;
						height2 = scale * sh;
					} else {
						/////// SCALE without maintaining aspect ratio /////////
						width2 = (_clip.parent.mouseX - registrationPoint.x) / (sx - registrationPoint.x) * sw;
						// * scalMx;
						height2 = (_clip.parent.mouseY - registrationPoint.y) / (sy - registrationPoint.y) * sh;
					}
					//	FTScaleRegulator.transform.matrix = _clip.transform.matrix;				
					positionControls();
					break;
				case MOUSE_UP:
					if(hideRegistrationPointOnMove) {
						registrationPoint.visible = true;
					}
					trace("scale mouse up FTScaleRegulator" + FTScaleRegulator) ;
					if(FTScaleRegulator && FTScaleRegulator.parent != null) {
						_clip.parent.removeChild(FTScaleRegulator);
					}
					//hideControls();
					//releaseControls();
					break;
			}
		}

		public function visualize(dx : Number = 0, dy : Number = 0) : void {
			if(visualizationON) {
				//////////////////DEBUGGING VISUALIZATION ///////////////////
				var vis : Sprite = FTScaleRegulator;
				// : registrationPoint;
				Sprite(vis).graphics.clear();
				Sprite(vis).graphics.lineStyle(2, 0x00FF00, .8);
				var pp : Point = _clip.parent.globalToLocal(_clip.localToGlobal(rp));
				//Sprite(vis).graphics.moveTo(rp.x, rp.y);
				//Sprite(vis).graphics.lineTo(_clip.mouseX, _clip.mouseY);

				Sprite(vis).graphics.moveTo(pp.x, pp.y);
				Sprite(vis).graphics.lineTo(_clip.parent.mouseX, _clip.parent.mouseY);
				
				Sprite(vis).graphics.lineStyle(2, 0x0000FF, .8);
				Sprite(vis).graphics.drawCircle(pp.x, pp.y, tmpdistFromStartToRp);
				
				var aip : Point = _clip.parent.globalToLocal(_clip.localToGlobal(ip));
				Sprite(vis).graphics.lineStyle(4, 0xFF00FF, .8);
				//Sprite(vis).graphics.clear();
				Sprite(vis).graphics.drawCircle(aip.x, aip.y, 3);
				Sprite(vis).graphics.lineStyle(2, 0xFF0000, .8);
				Sprite(vis).graphics.moveTo(_clip.parent.mouseX, _clip.parent.mouseY);
				Sprite(vis).graphics.lineTo(_clip.parent.mouseX - dx, _clip.parent.mouseY - dy);
			}
		}

		public function getMouseAngle() : Number {
			return Math.atan2((_clip.parent.mouseY - _clip.y), (_clip.parent.mouseX - _clip.x)) * 180 / Math.PI;
		}
	}
}
