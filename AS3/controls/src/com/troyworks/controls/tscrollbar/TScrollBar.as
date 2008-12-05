package com.troyworks.controls.tscrollbar {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.events.Event;

	public class TScrollBar extends flash.display.Sprite {

		public static const SCROLL:String = "scroll";
	
		private var _track:Sprite;
		private var _up:Sprite;
		private var _down:Sprite;
		private var _thumb:Sprite;
		private var _height:Number = 100;
		private var _width:Number = 16;
		private var _pageSize:Number = 10;
		private var _minimum:Number = 0;
		private var _maximum:Number = 100;
		private var _value:int = 0;
		private var _mouseDown:Boolean = false;

		public function get value():int {
			_value = (_thumb.y - _track.y - 1) / (_track.height - _thumb.height - 2) * (_maximum - _minimum);
			return _value;
		}

		override public function set height(value:Number):void {
			_height = value;
			draw();
		}
		
		public function set enabled(value:Boolean):void {
			//super.enabled = value;
			_thumb.visible = value;
		}
	
		public function ScrollBar() {
			_track = new Sprite();
			_up = new Sprite();
			_down = new Sprite();
			_thumb = new Sprite();
			addChild(_track);
			addChild(_up);
			addChild(_down);
			addChild(_thumb);
			_thumb.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_thumb.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_thumb.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			draw();
		}
		
		public function setScrollProperties(pageSize:Number, minimum:Number, maximum:Number):void {
			_pageSize = pageSize;
			_minimum = minimum;
			_maximum = maximum;
			drawThumb();
		}
		
		private function draw():void {
			_track.graphics.clear();
			_track.graphics.lineStyle();
			_track.graphics.beginFill(0xFFFFFF, 100);
			_track.graphics.drawRect(0, 0, _width, _height - 2 * _width);
			_track.graphics.endFill();
			_track.y = 16;
			_up.graphics.clear();
			_up.graphics.lineStyle();
			_up.graphics.beginFill(0xFFFFFF, 100);
			_up.graphics.drawRect(0, 0, _width, _width);
			_up.graphics.endFill();
			_down.graphics.clear();
			_down.graphics.lineStyle();
			_down.graphics.beginFill(0xFFFFFF, 100);
			_down.graphics.drawRect(0, 0, _width, _width);
			_down.graphics.endFill();
			_down.y = _height - _width;
			
			drawThumb();
			
		}
		
		private function drawThumb():void {
			_thumb.graphics.clear();
			_thumb.graphics.lineStyle();
			_thumb.graphics.beginFill(0xFFFFFF, 1);
			_thumb.graphics.drawRect(0, 0, _width - 2, (_pageSize / (_pageSize + Math.abs(_maximum - _minimum))) * (_track.height - 2));
			_thumb.graphics.endFill();
			_thumb.x = 1;
			_thumb.y = _track.y + 1;
			_thumb.visible = _thumb.height < _track.height;
		}
		
		private function onMouseDown(event:MouseEvent):void {
			_thumb.startDrag(false, new Rectangle(_track.x + 1, _track.y + 1, 0, _track.height - _thumb.height + _width));
			//_thumb.setCapture();
			_mouseDown = true;
		}
		
		private function onMouseUp(event:MouseEvent):void {
			_thumb.stopDrag();
			_mouseDown = false;
		}
		
		private function onMouseMove(event:MouseEvent):void {
			if(_mouseDown) {
				dispatchEvent(new Event(SCROLL));
			}
		}
		
	}
}