package com.troyworks.controls.tbutton {
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.filters.BevelFilter;
	import flash.text.TextFieldAutoSize;
	
	public class BasicButton extends SimpleButton {
		
		private var _label:String;
		
		private var _upLabel:TextField;
		private var _overLabel:TextField;
		private var _downLabel:TextField;
		
		private var _up:Sprite;
		private var _over:Sprite;
		private var _down:Sprite;
		private var _hit:Sprite;
		
		public function set label(value:String):void {
			_label = value;
			draw();
		}
		
		public function BasicButton(label:String) {
			
			_label = label;
			
			_upLabel = new TextField();
			_up = new Sprite();
			_overLabel = new TextField();
			_downLabel = new TextField();
			_down = new Sprite();
			_hit = new Sprite();
			_over = new Sprite();
			
			_upLabel.autoSize = TextFieldAutoSize.LEFT;
			_overLabel.autoSize = TextFieldAutoSize.LEFT;
			_overLabel.textColor = 0xCCCCCC;
			_downLabel.autoSize = TextFieldAutoSize.LEFT;
			
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
		override public function set enabled(value: Boolean):void 
		{
			super.enabled = value;
			// hide or enable mouse events			
			this.mouseEnabled = enabled;
			// With mouseEnabled = false you'll have only one state named "upState".
			// Use this state for setting the new states called "enabledState" or "disabledState" ;-)
			//upState = (enabled) ? enabledState : disabledState;
			alpha = (enabled)? 1:.3;
		}
		
		private function draw():void {
			
			_upLabel.text = _label;
			_up.graphics.clear();
			_up.graphics.lineStyle();
			_up.graphics.beginFill(0xFFFFFF, 100);
			_up.graphics.drawRect(0, 0, _upLabel.width + 2, _upLabel.height + 2);
			_up.graphics.endFill();
			_up.filters = [new BevelFilter()];
			_up.addChild(_upLabel);
			
			_overLabel.text = _label;
			_over.graphics.clear();
			_over.graphics.lineStyle();
			_over.graphics.beginFill(0xFFFFFF, 100);
			_over.graphics.drawRect(0, 0, _overLabel.width + 2, _overLabel.height + 2);
			_over.graphics.endFill();
			_over.filters = [new BevelFilter()];
			_over.addChild(_overLabel);
			
			_downLabel.text = _label;
			_down.graphics.clear();
			_down.graphics.lineStyle();
			_down.graphics.beginFill(0xFFFFFF, 100);
			_down.graphics.drawRect(0, 0, _overLabel.width + 2, _overLabel.height + 2);
			_down.graphics.endFill();
			_down.filters = [new BevelFilter(4, 225)];
			_down.addChild(_downLabel);
			_downLabel.x = 2;
			_downLabel.y = 2;
			
			_hit.graphics.clear();
			_hit.graphics.lineStyle();
			_hit.graphics.beginFill(0xFFFFFF, 100);
			_hit.graphics.drawRect(0, 0, _up.width, _up.height);
			_hit.graphics.endFill();
		}
		
		
		
	}
}