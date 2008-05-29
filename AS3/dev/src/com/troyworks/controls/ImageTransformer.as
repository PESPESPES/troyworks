/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.controls {
	import com.troyworks.activeframe.QEvent;

	import com.troyworks.cogs.Fsm;
	import com.troyworks.cogs.*;
	import com.troyworks.cogs.proxies.KeyBoardProxy;
	import com.troyworks.signals.Signals;
	import com.troyworks.util.UIUtil;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import com.troyworks.util.NumberUtil;

	public class ImageTransformer extends Fsm{
		public var tools:Array = ["none", "move", "scale", "rotate"]; 
		private var _view:MovieClip;
		private var _clip:Sprite;
		private var _SHIFT_is_down:Boolean= false;
			
		public static const MOUSE_DOWN:CogSignal = Signals.MOUSE_DOWN;
		public static const MOUSE_UP:CogSignal = Signals.MOUSE_UP;
		public static const MOUSE_CLICK:CogSignal = Signals.MOUSE_CLICK;
		public static const MOUSE_MOVE:CogSignal = Signals.MOUSE_MOVE;
		
		///////////////// SNAPSHOT OF STATE //////////////////////
		private	var orig_x:Number;
		private	var orig_y:Number;
		private	var clickx:Number;
		private	var clicky:Number;
		private	var offx:Number;
		private	var offy:Number;
		
		private var clickAngle:Number;
		private var clickRotation:Number;
		private var b:Rectangle;
		
		private var clickXscale:Number;
		private var clickYscale:Number;
		private var sx:Number;
		private	var sy:Number;
		
		private var keyP:KeyBoardProxy;
		private var FTScaleRegulator:Sprite;
		////////////////// UI CONTROLS ////////////////////////
		private var scale_btn:Sprite;
		private var rotate_btn:Sprite;
		private var move_btn:Sprite;
		
		public function ImageTransformer(toOff:Boolean = false) {
			super();
			_initState = s_initial;

		}
		
		public function setView(mc:MovieClip):void{
			_view = mc;
		}
		public function setClipToManipulate(mc:Sprite):void{
			if(mc != _clip){
				if(_clip != null){
					if(keyP != null){
						keyP.disable();
						keyP = null;
					}
					/////// remove listeners ////////////
					_clip.stage.removeEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
					_clip.removeEventListener(MouseEvent.MOUSE_DOWN, onPress);
					_clip.removeEventListener(MouseEvent.MOUSE_UP, onRelease);
				}
				_clip = mc;			
				keyP = new KeyBoardProxy(mc.stage, this);
				keyP.enable();
				_clip.addEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
				_clip.addEventListener(MouseEvent.MOUSE_DOWN, onPress);
				_clip.addEventListener(MouseEvent.MOUSE_UP, onRelease);
			}else{
				//ignore
			}

		}
		public function setUIControls(scale_btn:Sprite, rotate_btn:Sprite, move_btn:Sprite):void{
			this.scale_btn = scale_btn;
			this.rotate_btn = rotate_btn;
			this.move_btn = move_btn;
			enableControls();
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

			var bnds:Rectangle = _clip.getBounds(_clip.parent);
			scale_btn.visible = true;
			rotate_btn.visible = true;
			move_btn.visible = true;
			scale_btn.y = bnds.bottom;
			rotate_btn.y = bnds.bottom;
			move_btn.y = bnds.bottom;
			scale_btn.x = bnds.left;
			rotate_btn.x  = scale_btn.x + scale_btn.width +5 ;
			move_btn.x = rotate_btn.x + rotate_btn.width + 5;
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

		public function onMouseMove(evt:MouseEvent):void{
			dispatchEvent(new CogEvent(Signals.MOUSE_MOVE.name, Signals.MOUSE_MOVE));
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
			clickRotation = _clip.rotation;

		}
		public function onRelease(event:MouseEvent= null):void {
			dispatchEvent(new CogEvent(CogEvent.EVTD_COG_PRIVATE_EVENT, Signals.MOUSE_UP));
			_clip.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

			//_clip.parent.FTScaleRegulator.removeMovieClip();
		};
		public function onPress(event:MouseEvent= null):void{
			dispatchEvent(new CogEvent(CogEvent.EVTD_COG_PRIVATE_EVENT, Signals.MOUSE_DOWN));
			_clip.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			//_clip.parent.FTScaleRegulator.removeMovieClip();
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
				break;
				case SIG_EXIT:
								 scale_btn.alpha = .6;
				 move_btn.alpha = .6;
				 rotate_btn.alpha = .6;

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
				break;
				case SIG_EXIT:
				scale_btn.alpha = .6;
				 move_btn.alpha = .6;
				 rotate_btn.alpha = .6;

				break;

				case MOUSE_DOWN:
				trace("rotate mouse down");
					snapShotClip();
					positionControls();
					enableControls();
				break;
				case MOUSE_MOVE:
				trace("rotate mouse move");
					var r:Number = clickRotation-clickAngle+getMouseAngle();
					_clip.rotation = (_SHIFT_is_down) ? NumberUtil.snap(r, 45, clickRotation) : r;
					positionControls();
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
				break;
				case SIG_EXIT:
					scale_btn.alpha = .6;
					move_btn.alpha = .6;
					rotate_btn.alpha = .6;

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
					clickXscale = _clip.scaleX;
					clickYscale = _clip.scaleY;
					sx = clickXscale/(FTScaleRegulator.mouseX/b.left);
					sy = clickYscale/(FTScaleRegulator.mouseY/b.top);
				break;
				case MOUSE_MOVE:
				trace("scale mouse move");
				
					if (_SHIFT_is_down) {
						var scale:Number = Math.max(((FTScaleRegulator.mouseX*sx/clickXscale)/b.left), ((FTScaleRegulator.mouseY*sy/clickYscale)/b.top))/100;
						_clip.scaleX = clickXscale*scale;
						_clip.scaleY = clickYscale*scale;
					} else {
						trace("scaling");
					//	trace("scaleing" + clickXscale + " " + r._xmouse + " " + sx + " " + b.xMin);
						_clip.scaleX = clickXscale*((FTScaleRegulator.mouseX*sx/clickXscale)/b.left);
						_clip.scaleY = clickYscale*((FTScaleRegulator.mouseY*sy/clickYscale)/b.top);
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
			return Math.atan2(_clip.parent.mouseY-_clip.y, _clip.parent.mouseX-_clip.x)*180/Math.PI;
		}
		
	}
	
}
