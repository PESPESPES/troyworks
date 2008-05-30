/**
* A wrapper to manipulate an onscreen ui element, with scale/move etc.
* @author Default
* @version 0.1
*/

package com.troyworks.controls.tuitools {
	import com.troyworks.framework.QEvent;
	import com.troyworks.geom.d1.Point1D;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;

	import com.troyworks.core.cogs.Fsm;
	import com.troyworks.core.cogs.*;
	import com.troyworks.core.cogs.proxies.KeyBoardProxy;
	import com.troyworks.core.Signals;
	import com.troyworks.ui.UIUtil;
	import flash.display.MovieClip;
	import flash.display.Sprite;	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import com.troyworks.util.NumberUtil;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	public class DisplayObjTool extends Fsm{
		public var tools:Array = ["none", "move", "scale", "rotate"]; 
		private var _view:MovieClip;
		private var _clip:DisplayObject;
		private var _SHIFT_is_down:Boolean= false;
			
		public static const MOUSE_DOWN:CogSignal = Signals.MOUSE_DOWN;
		public static const MOUSE_UP:CogSignal = Signals.MOUSE_UP;
		public static const MOUSE_CLICK:CogSignal = Signals.MOUSE_CLICK;
		public static const MOUSE_MOVE:CogSignal = Signals.MOUSE_MOVE;
		public static const MOUSE_RELEASED_OUTSIDE:CogSignal = Signals.MOUSE_RELEASED_OUTSIDE;
		
		///////////////// SNAPSHOT OF STATE //////////////////////
		private	var orig_x:Number;
		private	var orig_y:Number;
		private	var clickx:Number;
		private	var clicky:Number;
		private	var offx:Number;
		private	var offy:Number;
		
		private var clickAngle:Number;
		private var clipRotation:Number;
		private var b:Rectangle;
		
		private var clickXscale:Number;
		private var clickYscale:Number;
		private var sx:Number;
		private	var sy:Number;
		
		private var keyP:KeyBoardProxy;
		private var FTScaleRegulator:Sprite;
		private var rp:Point;
		private var isPressed:Boolean = false;
		private var registrationPoint:Sprite;
		private var clickTime:int;

		////////////////// UI CONTROLS ////////////////////////
		private var scale_btn:Sprite;
		private var rotate_btn:Sprite;
		private var move_btn:Sprite;
		
		private var _tl:Sprite;
		private var _t:Sprite;
		private var _tr:Sprite;
		private var _l:Sprite;
		private var _r:Sprite;
		private var _bl:Sprite;
		private var _b:Sprite;
		private var _br:Sprite;

		
		public function DisplayObjTool(toOff:Boolean = false) {
			super();
			_initState = s_initial;

		}
		
		public function setView(mc:MovieClip):void{
			_view = mc;
		}
		public function setClipToManipulate(mc:DisplayObject):void{
			if(mc != _clip){
				if(_clip != null){
					if(keyP != null){
						keyP.disable();
						keyP = null;
					}
					/////// remove listeners ////////////
					_clip.stage.removeEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
					_clip.removeEventListener(MouseEvent.CLICK, onClick);
					_clip.removeEventListener(MouseEvent.MOUSE_DOWN, onPress);
					_clip.removeEventListener(MouseEvent.MOUSE_UP, onRelease);
				}
				setRegistration();
				_clip = mc;			
				keyP = new KeyBoardProxy(mc.stage, this);
				keyP.enable();
				
				_clip.addEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
				_clip.addEventListener(MouseEvent.CLICK, onClick);
				_clip.addEventListener(MouseEvent.MOUSE_DOWN, onPress);
				_clip.addEventListener(MouseEvent.MOUSE_UP, onRelease);
			}else{
				//ignore
			}

		}
		public function setUIControls(scale_btn:Sprite, rotate_btn:Sprite, move_btn:Sprite, registrationPoint:Sprite):void{
			this.scale_btn = scale_btn;
			this.rotate_btn = rotate_btn;
			this.move_btn = move_btn;
			this.registrationPoint = registrationPoint;
			enableControls();
		}
		public function setUIFreeScaleHandles(tl:Sprite, t:Sprite, tr:Sprite,  l:Sprite,r:Sprite,bl:Sprite,b:Sprite,br:Sprite):void{
			_tl = tl;
			_t = t;
			_tr = tr;
			_l = l;
			_r = r;
			_bl = bl;
			_b = b;
			_br = br;
		}
		public function requestScaleTool(evt:MouseEvent= null):void{
			tran(s_ScaleTool);
		}
		public function requestMoveTool(evt:MouseEvent= null):void{
			tran(s_MoveTool);
		}
		public function requestRotateTool(evt:MouseEvent= null):void{
			tran(s_RotateTool);
		}
		private function positionControls():void{
			var rect:Rectangle;
				var bnds:Rectangle = (rect == null)?(_clip.getBounds(_clip.parent)): rect;
				scale_btn.visible = true;
				rotate_btn.visible = true;
				move_btn.visible = true;
				scale_btn.y = bnds.bottom;
				rotate_btn.y = bnds.bottom;
				move_btn.y = bnds.bottom;
				scale_btn.x = bnds.left;
				rotate_btn.x  = scale_btn.x + scale_btn.width +5 ;
				move_btn.x = rotate_btn.x + rotate_btn.width + 5;
				//if(_currentState == s_MoveTool || _currentState == s_ScaleTool){
					_tl.y = bnds.topLeft.y;
					_tl.x = bnds.topLeft.x;
					
					_t.y = bnds.top;
					_t.x = bnds.x + bnds.width/2;
					
					_tr.y = bnds.top;
					_tr.x = bnds.right;

					_l.y = bnds.y + bnds.height/2;
					_l.x = bnds.left;

					_r.y = bnds.y + bnds.height/2;
					_r.x = bnds.right;

					_bl.y = bnds.bottom;
					_bl.x = bnds.left;

					_b.y = bnds.bottom;
					_b.x = bnds.x + bnds.width/2;
					
					_br.y = bnds.bottomRight.y;
					_br.x = bnds.bottomRight.x;
				//}
			
			
	
		}
		public function updateRegistrationPointView():void{
			if(registrationPoint != null){
				var a:Point = registrationPoint.parent.globalToLocal(_clip.localToGlobal(rp));
				registrationPoint.x = a.x;
				registrationPoint.y = a.y;
				registrationPoint.visible = true;
			}
		}

		private function hideControls():void{
			scale_btn.visible = false;
			rotate_btn.visible = false;
			move_btn.visible = false;
		}
		private function enableControls():void{
			scale_btn.addEventListener(MouseEvent.CLICK, requestScaleTool);
			rotate_btn.addEventListener(MouseEvent.CLICK, requestRotateTool);
			move_btn.addEventListener(MouseEvent.CLICK, requestMoveTool);
		}
		private function releaseControls():void{
			scale_btn.removeEventListener(MouseEvent.CLICK, requestScaleTool);
			rotate_btn.removeEventListener(MouseEvent.CLICK, requestRotateTool);
			move_btn.removeEventListener(MouseEvent.CLICK, requestMoveTool);
		}
		private function enableFreeScaleControls():void{
			_tl.addEventListener(MouseEvent.MOUSE_DOWN, onFreeScaleControlClicked);
			_t.addEventListener(MouseEvent.MOUSE_DOWN, onFreeScaleControlClicked);
			_tr.addEventListener(MouseEvent.MOUSE_DOWN, onFreeScaleControlClicked);
			_l.addEventListener(MouseEvent.MOUSE_DOWN, onFreeScaleControlClicked);
			_r.addEventListener(MouseEvent.MOUSE_DOWN, onFreeScaleControlClicked);
			_bl.addEventListener(MouseEvent.MOUSE_DOWN, onFreeScaleControlClicked);
			_b.addEventListener(MouseEvent.MOUSE_DOWN, onFreeScaleControlClicked);
			_br.addEventListener(MouseEvent.MOUSE_DOWN, onFreeScaleControlClicked);

		}
		private function onFreeScaleControlClicked(event:MouseEvent= null):void{
			var opposite:Sprite;
			var tg:Sprite = Sprite(event.target);
			trace("onFreeScaleControlClicked " + tg.name  + " " + _tl.name);
			if(tg == _tl){
				trace("opposite bottom right");
				opposite = _br;
			}else if (tg == _t){
				opposite = _b;
			}else if (tg == _tr){
				opposite = _bl;
			}else if (tg == _r){
				opposite = _l;
			}else if (tg == _br){
				opposite = _tl;
			}else if (tg == _b){
				opposite = _t;
			}else if (tg == _bl){
				opposite = _tr;
			}else if (tg == _l){
				opposite = _r;
			}else{
				trace("no valid control click");
			}
			trace("opposite is " + opposite.name);
			var p1:Point = new Point(opposite.x, opposite.y);
			var p:Point =  _clip.globalToLocal(opposite.parent.localToGlobal(p1));
			setRegistration(p.x, p.y);
			//if(_clip.getBounds(_clip.parent).contains(_clip.parent.mouseX, _clip.parent.mouseY)){
			//	onPress();
			//}
			//setRegistration(opposite.x, opposite.y);
		}
		private function releaseFreeScaleControls():void{
			_tl.removeEventListener(MouseEvent.MOUSE_DOWN, onFreeScaleControlClicked);
			_t.removeEventListener(MouseEvent.MOUSE_DOWN, onFreeScaleControlClicked);
			_tr.removeEventListener(MouseEvent.MOUSE_DOWN, onFreeScaleControlClicked);
			_l.removeEventListener(MouseEvent.MOUSE_DOWN, onFreeScaleControlClicked);
			_r.removeEventListener(MouseEvent.MOUSE_DOWN, onFreeScaleControlClicked);
			_bl.removeEventListener(MouseEvent.MOUSE_DOWN, onFreeScaleControlClicked);
			_b.removeEventListener(MouseEvent.MOUSE_DOWN, onFreeScaleControlClicked);
			_br.removeEventListener(MouseEvent.MOUSE_DOWN, onFreeScaleControlClicked);
		}
		
		public function onMouseMove(evt:MouseEvent):void{
			dispatchEvent(new CogEvent(Signals.MOUSE_MOVE.name, MOUSE_MOVE));
			evt.updateAfterEvent();
		}
		public function snapShotClip():void{
			orig_x = _clip.x;
			orig_y = _clip.y;
			clickx = _clip.parent.mouseX;
			clicky =_clip.parent.mouseY;
			offx = clickx-orig_x;
			offy = clicky-orig_y;
			clickAngle = getMouseAngle();
			clipRotation = rotation2;//_clip.rotation;

		}
		public function onRelease(event:MouseEvent= null):void {
			isPressed = false;
			dispatchEvent(new CogEvent(CogEvent.EVTD_COG_PRIVATE_EVENT, MOUSE_UP));
			_clip.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_clip.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			_clip.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
			//_clip.parent.FTScaleRegulator.removeMovieClip();
		};
		public function onReleaseOutside(event:MouseEvent= null):void {
			trace("onReleaseOutside**************************************");
			onRelease();
			dispatchEvent(new CogEvent(CogEvent.EVTD_COG_PRIVATE_EVENT, MOUSE_RELEASED_OUTSIDE));
		}
		public function onPress(event:MouseEvent= null):void{
			isPressed = true;
			clickTime = getTimer();
			dispatchEvent(new CogEvent(CogEvent.EVTD_COG_PRIVATE_EVENT, MOUSE_DOWN));
			_clip.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_clip.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			_clip.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			
			//_clip.stage.addEventListener(MouseEvent.MOUSE_UP, onReleaseOutside, true);
			//_clip.parent.FTScaleRegulator.removeMovieClip();
		}
		public function onRollOut(event:MouseEvent= null):void{
			trace("onRollOut**************************************" + _clip);
			//onReleaseOutside();
			_clip.stage.addEventListener(MouseEvent.MOUSE_UP, onReleaseOutside);//, true);
		}
		public function onRollOver(event:MouseEvent= null):void{
		trace("onRollOver******************************************");
			_clip.stage.removeEventListener(MouseEvent.MOUSE_UP, onReleaseOutside);
	
		}
		public function onClick(event:MouseEvent= null):void{
			dispatchEvent(new CogEvent(CogEvent.EVTD_COG_PRIVATE_EVENT, MOUSE_CLICK));
		}
		function reportKeyDown(event:KeyboardEvent):void
		{
		//	trace("Key Pressed: " + String.fromCharCode(event.charCode) +         " (key code: " + event.keyCode + " character code: "         + event.charCode + ")");
			if (event.keyCode == Keyboard.SHIFT){
				_SHIFT_is_down = true;
			}
		}

		function reportKeyUp(event:KeyboardEvent):void
		{
		//	trace("Key Released: " + String.fromCharCode(event.charCode) +         " (key code: " + event.keyCode + " character code: " +         event.charCode + ")");
			if (event.keyCode == Keyboard.SHIFT)
			{
				_SHIFT_is_down = false;
			}
		}
		public function setRegistration(x:Number=0, y:Number=0):void
		{
			trace("setRegistration x:" + x);
			rp = new Point(x, y);
			updateRegistrationPointView();
		}

		public function get x2():Number
		{
			var p:Point = _clip.parent.globalToLocal(_clip.localToGlobal(rp));
			return p.x;
		}

		public function set x2(value:Number):void
		{
			var p:Point = _clip.parent.globalToLocal(_clip.localToGlobal(rp));
			_clip.x += value - p.x;
		}

		public function get y2():Number
		{
			var p:Point = _clip.parent.globalToLocal(_clip.localToGlobal(rp));
			return p.y;
		}

		public function set y2(value:Number):void
		{
			var p:Point = _clip.parent.globalToLocal(_clip.localToGlobal(rp));
			_clip.y += value - p.y;
		}

		public function get scaleX2():Number
		{
			return _clip.scaleX;
		}

		public function set scaleX2(value:Number):void
		{
			setProperty2("scaleX", value);
		}

		public function get scaleY2():Number
		{
			return _clip.scaleY;
		}

		public function set scaleY2(value:Number):void
		{
			setProperty2("scaleY", value);
		}

		public function get rotation2():Number
		{
			return _clip.rotation;
		}

		public function set rotation2(value:Number):void
		{
			setProperty2("rotation", value);
		}

		public function get mouseX2():Number
		{
			if(_clip is InteractiveObject){
				return Math.round(InteractiveObject(_clip).mouseX - rp.x);
			}else{
				return 0;
			}
		}

		public function get mouseY2():Number
		{
			if(_clip is InteractiveObject){
				return Math.round(InteractiveObject(_clip).mouseY - rp.y);
			}else{
				return 0;
			}
		}

		public function setProperty2(prop:String, n:Number):void
		{
			var a:Point = _clip.parent.globalToLocal(_clip.localToGlobal(rp));

			_clip[prop] = n;

			var b:Point = _clip.parent.globalToLocal(_clip.localToGlobal(rp));

			_clip.x -= (b.x - a.x);
			_clip.y -= (b.y - a.y);
		}

		////////////// STATES /////////////////////////////////
		public function s_initial(evt:CogEvent):void{
			switch(evt.sig){
				case SIG_INIT:
				//			_initState=s_NoTool;
			    //tran(s_MoveTool);
				//tran(s_RotateTool);
				tran(s_ScaleTool);
				break;
			}
		}
		public function s_NoTool(evt:CogEvent):void {
			trace("s_NoTool");
			switch(evt.sig){
				case SIG_ENTRY:
					hideControls();
				break;
				case SIG_EXIT:
			
				break;
			}
		}
		public function s_MoveTool(evt:CogEvent):void {
			//trace("TwoStateFsm.ON_state " + event);
			trace("s_MoveTool" + evt.sig);
			switch(evt.sig){
				case SIG_ENTRY:
				trace("movingtool enter");
					//show the move cursor
					scale_btn.alpha = .6;
					move_btn.alpha = 1;
					rotate_btn.alpha = .6;
					enableFreeScaleControls();

				break;
				case SIG_EXIT:
					scale_btn.alpha = .6;
					move_btn.alpha = .6;
					rotate_btn.alpha = .6;
					releaseFreeScaleControls();
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
						var thisx:Number = _clip.parent.mouseX-clickx;
						var thisy:Number = _clip.parent.mouseY-clicky;
						if (Math.abs(thisx)>Math.abs(thisy)) {
							_clip.x = _clip.parent.mouseX-offx;
							_clip.y = orig_y;
						} else {
							_clip.x = orig_x;
							_clip.y = _clip.parent.mouseY-offy;
						}
					} else {
						_clip.x = _clip.parent.mouseX-offx;
						_clip.y = _clip.parent.mouseY-offy;
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
		public function s_RotateTool(evt:CogEvent):void{
			switch(evt.sig){
				case SIG_ENTRY:
					trace("rotate enter");
					scale_btn.alpha = .6;
					move_btn.alpha = .6;
					rotate_btn.alpha = 1;
					updateRegistrationPointView();
					registrationPoint.visible = true;
					//					enableFreeScaleControls();
				break;
				case SIG_EXIT:
					scale_btn.alpha = .6;
					move_btn.alpha = .6;
					rotate_btn.alpha = .6;
					registrationPoint.visible = false;
					//releaseFreeScaleControls();
				break;
				case MOUSE_CLICK:
					var exitTime = (clickTime + 200);
					var curTime = getTimer();
					trace("mouse Click " + clickTime + " " + exitTime);
					if( curTime < exitTime){
						registrationPoint.x = registrationPoint.parent.mouseX;
						registrationPoint.y = registrationPoint.parent.mouseY;
						setRegistration(_clip.mouseX, _clip.mouseY);
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
				trace("clipRotation " + clipRotation + " clickAngle " + clickAngle  + " getMouseAngle() " + getMouseAngle() );
					var r:Number = clipRotation-clickAngle+getMouseAngle();
					rotation2 = (_SHIFT_is_down) ? NumberUtil.snap(r, 45, clipRotation) : r;
					positionControls();
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
		public function s_ScaleTool(evt:CogEvent):void{
			switch(evt.sig){
				case SIG_ENTRY:
					trace("scale enter");
					//show the move cursor
					scale_btn.alpha = 1;
					move_btn.alpha = .6;
					rotate_btn.alpha = .6;
					enableFreeScaleControls();
					registrationPoint.visible = true;
				break;
				case SIG_EXIT:
					scale_btn.alpha = .6;
					move_btn.alpha = .6;
					rotate_btn.alpha = .6;
					releaseFreeScaleControls();
					registrationPoint.visible = false;
				break;

				case MOUSE_DOWN:
					trace("scale mouse down");
					snapShotClip();
					positionControls();
					enableControls();
					FTScaleRegulator = new Sprite();
					_clip.parent.addChild(FTScaleRegulator);
					
//					trace("clipB." + clip.getBounds + " " + clip.getBounds(_root));
				//	var b = _root.my_mc.getBounds(_root.my_mc);
				//	trace(b.xMin);
					UIUtil.match(FTScaleRegulator, _clip, ["rotation", "x", "y"]);

					
					 b = _clip.getBounds(_clip.parent);
		
				//	trace(" b " + b + " clip " + clip + " clipp " + clip._parent + " " + b.xMin);
					clickXscale = scaleX2;
					clickYscale = scaleY2;
					sx = clickXscale/(FTScaleRegulator.mouseX/b.left);
					sy = clickYscale/(FTScaleRegulator.mouseY/b.top);
				break;
				case MOUSE_MOVE:
				trace("scale mouse move");
				
					if (_SHIFT_is_down) {
						var scale:Number = Math.max(((FTScaleRegulator.mouseX*sx/clickXscale)/b.left), ((FTScaleRegulator.mouseY*sy/clickYscale)/b.top))/100;
						scaleX2 = clickXscale*scale;
						scaleY2 = clickYscale*scale;
					} else {
						trace("scaling");
					//	trace("scaleing" + clickXscale + " " + r._xmouse + " " + sx + " " + b.xMin);
						scaleX2 = clickXscale*((FTScaleRegulator.mouseX*sx/clickXscale)/b.left);
						scaleY2 = clickYscale*((FTScaleRegulator.mouseY*sy/clickYscale)/b.top);
					}
					positionControls();
				break;
				case MOUSE_UP:
				trace("scale mouse up");
				_clip.parent.removeChild(FTScaleRegulator);
				//hideControls();
				//releaseControls();
				break;
			}

		}
				
		public function getMouseAngle() :Number{
			return Math.atan2((_clip.parent.mouseY-_clip.y), (_clip.parent.mouseX-_clip.x))*180/Math.PI;
		}
		
	}
	
}
