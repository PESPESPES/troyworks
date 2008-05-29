package com.troyworks.commandexample.commandcontainers {

	import flash.display.Sprite;
	import com.troyworks.commands.ICommand;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.display.DisplayObject;
	import com.troyworks.commandexample.controls.CommandButton;

	public class CommandContainer extends flash.display.Sprite {
		
		private var _command:ICommand;
		private var _x:Number;
		private var _y:Number;
		
		public function CommandContainer(command:ICommand, labelText:String, xValue:Number, yValue:Number) {
			_command = command;
			graphics.lineStyle();
			graphics.beginFill(0xFFFFFF, 1);
			graphics.drawRect(0, 0, 50, 50);
			graphics.endFill();
			var label:TextField = new TextField();
			label.width = 50;
			label.height = 50;
			label.multiline = true;
			label.wordWrap = true;
			label.text = labelText;
			label.selectable = false;
			addChild(label);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_x = xValue;
			_y = yValue;
			x = _x;
			y = _y;
		}
		
		private function onMouseDown(event:MouseEvent):void {
			startDrag();
			//setCapture();
		}
		
		private function onMouseUp(event:MouseEvent):void {
			stopDrag();
			x = _x;
			y = _y;
			var target:DisplayObject = dropTarget;
			while(target != null && !(target is CommandButton) && target != root) {
				target = target.parent;
			}
			if(target is CommandButton) {
				CommandButton(target).command = _command;
			}
		}
		
	}
}