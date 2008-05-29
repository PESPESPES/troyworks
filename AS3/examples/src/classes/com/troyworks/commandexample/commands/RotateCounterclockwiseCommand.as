package com.troyworks.commandexample.commands {

	import com.troyworks.commands.IUndoableCommand;
	import com.troyworks.commands.IRedoableCommand;
	import flash.display.DisplayObject;
	
	public class RotateCounterclockwiseCommand implements IUndoableCommand, IRedoableCommand {
		
		private var _receiver:DisplayObject;
		
		public function RotateCounterclockwiseCommand(receiver:DisplayObject) {
			_receiver = receiver;
		}
		
		public function execute():void {
			_receiver.rotation -= 20;
		}
		
		public function undo():void {
			_receiver.rotation += 20;
		}

		public function redo():void {
			execute();
		}

						
	}
}