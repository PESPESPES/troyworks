package com.troyworks.controls.tbutton {
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.filters.BevelFilter;
	import flash.text.TextFieldAutoSize;

	public class BasicButton extends SimpleButton {

		private var _label : String;

		private var _upLabel : TextField;
		private var _overLabel : TextField;
		private var _downLabel : TextField;

		private var _up : Sprite;
		private var _over : Sprite;
		private var _down : Sprite;
		private var _hit : Sprite;
		public var bevelAlpha : Number = .3;
		public var bevelSize : Number = 4;
		public var bevelPad : Number = 10;
		public var data : Object;
		public var disabledStyle : String = "ALPHA";

		public function set label(value : String) : void {
			_label = value;
			draw();
		}

		public function BasicButton(label : String) {
			
			_label = label;
			
			_up = new Sprite();
			_upLabel = new TextField();
			_upLabel.autoSize = TextFieldAutoSize.LEFT;

			_over = new Sprite();
			_overLabel = new TextField();			
			_overLabel.autoSize = TextFieldAutoSize.LEFT;
			_overLabel.textColor = 0xFFFFFF;
			
			_down = new Sprite();
			_downLabel = new TextField();
			_downLabel.autoSize = TextFieldAutoSize.LEFT;
			_overLabel.textColor = 0x000000;
			
			_hit = new Sprite();
			
			
			/////////////////////
			upState = _up;
			downState = _down;
			overState = _over;
			hitTestState = _hit;
			
			useHandCursor = true;
			
			draw();
		}

		/**
		 * Overides the setter method of its enabled property
		 * @param  value	Boolean true or false 
		 */
		override public function set enabled(value : Boolean) : void {
			super.enabled = value;
			// hide or enable mouse events			
			this.mouseEnabled = enabled;
			// With mouseEnabled = false you'll have only one state named "upState".
			// Use this state for setting the new states called "enabledState" or "disabledState" ;-)
			//upState = (enabled) ? enabledState : disabledState;
			if(disabledStyle == "ALPHA") {
				alpha = (enabled) ? 1 : .3;
			} else {
				draw();
			}
		}

		private function draw() : void {
			trace("BasicButton.draw");
			_upLabel.text = _label;
			_up.graphics.clear();
			_up.graphics.lineStyle();
			if(enabled) {
				_up.graphics.beginFill(0xCCCCCC, 100);
			} else {
				_up.graphics.beginFill(0xDDDDDD, 100);
			}
			trace(" _upLabel.width " + _upLabel.width, _upLabel.height);
			_up.graphics.drawRect(-bevelPad, -bevelPad, _upLabel.width + (2 * bevelPad), _upLabel.height + (2 * bevelPad));
			_up.graphics.endFill();
			if(disabledStyle == "FLAT" && !enabled) {
				_up.filters = [new BevelFilter(bevelSize, 225, 0xFFFFFF, bevelAlpha, 0x000000, bevelAlpha)];				
			} else {
				_up.filters = [new BevelFilter(bevelSize, 225, 0x000000, bevelAlpha, 0xFFFFFF, bevelAlpha)];
			}
			
			_up.addChild(_upLabel);
			
			_overLabel.text = _label;
			_over.graphics.clear();
			_over.graphics.lineStyle();
			if(enabled) {
				_over.graphics.beginFill(0xDDDDDD, 100);
			} else {
				_over.graphics.beginFill(0xDDDDDD, 100);
			}
			_over.graphics.drawRect(-bevelPad, -bevelPad, _overLabel.width + (2 * bevelPad), _overLabel.height + (2 * bevelPad));
			_over.graphics.endFill();
			if(disabledStyle == "FLAT" && !enabled) {
				_over.filters = [new BevelFilter(bevelSize, 225, 0xFFFFFF, bevelAlpha, 0x000000, bevelAlpha)];
			} else {
				_over.filters = [new BevelFilter(bevelSize, 225, 0x000000, bevelAlpha, 0xFFFFFF, bevelAlpha)];
			}
			_over.addChild(_overLabel);
			
			_downLabel.text = _label;
			_down.graphics.clear();
			_down.graphics.lineStyle();
			if(enabled) {
				_down.graphics.beginFill(0xBBBBBB, 100);
			} else {
				_down.graphics.beginFill(0xDDDDDD, 100);
			}
			_down.graphics.drawRect(-bevelPad, -bevelPad, _downLabel.width + (2 * bevelPad), _downLabel.height + (2 * bevelPad));
			_down.graphics.endFill();
			if(disabledStyle == "FLAT" && !enabled) {
				_down.filters = [new BevelFilter(bevelSize, 225, 0xFFFFFF, bevelAlpha, 0x000000, bevelAlpha)];
			} else {
				_down.filters = [new BevelFilter(bevelSize, 225, 0x000000, bevelAlpha, 0xFFFFFF, bevelAlpha)];	
			}
			_down.addChild(_downLabel);
			_downLabel.x = 2;
			_downLabel.y = 2;
			
			_hit.graphics.clear();
			_hit.graphics.lineStyle();
			_hit.graphics.beginFill(0xAAAAAA, 100);
			_hit.graphics.drawRect(0, 0, _up.width, _up.height);
			_hit.graphics.endFill();
		}
	}
}