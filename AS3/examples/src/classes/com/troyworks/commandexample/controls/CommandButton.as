package com.troyworks.commandexample.controls {
	
	import com.troyworks.controls.BasicButton;
	import com.troyworks.commands.ICommand;
	import com.troyworks.commands.CommandStack;
	import flash.events.MouseEvent;

	public class CommandButton extends BasicButton {
		
		private var _command:ICommand;
		private var cmdStk:CommandStack;
		
		public function set command(value:ICommand):void {
			_command = value;
		}
		
		public function CommandButton(label:String, cmdStk:CommandStack) {
			super(label);
			this.cmdStk = cmdStk;
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(event:MouseEvent):void {
			if(_command != null) {
				//_command.execute();
				cmdStk.putCommand(_command);
			}
		}
		
	}
}