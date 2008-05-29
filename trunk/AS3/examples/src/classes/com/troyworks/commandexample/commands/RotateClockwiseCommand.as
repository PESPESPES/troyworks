package com.troyworks.commandexample.commands {

	import com.troyworks.commands.IUndoableCommand;
	import com.troyworks.commands.IRedoableCommand;
	import flash.display.DisplayObject;
	
	public class RotateClockwiseCommand implements IUndoableCommand, IRedoableCommand {
		
		private var _receiver:DisplayObject;
		
		public function RotateClockwiseCommand(receiver:DisplayObject) {
			_receiver = receiver;
		}
		
		public function execute():void {
			trace("HIGHLIGHTo execute CW " );
			_receiver.rotation += 20;
		}
		
		public function undo():void {
						trace("HIGHLIGHTo undo CW " );
			_receiver.rotation -= 20;
		}

		public function redo():void {
						trace("HIGHLIGHTo redo CW " );
			execute();
		}


	}
}