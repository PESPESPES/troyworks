package com.troyworks.commandexample.commands {

	import com.troyworks.commands.IUndoableCommand;
	import com.troyworks.commands.IRedoableCommand;
	import flash.display.DisplayObject;
	
	public class ScaleUpCommand implements IUndoableCommand, IRedoableCommand {
		
		private var _receiver:DisplayObject;
		
		public function ScaleUpCommand(receiver:DisplayObject) {
			_receiver = receiver;
		}
		
		public function execute():void {
			_receiver.scaleX += .1;
			_receiver.scaleY += .1;
		}
		
		public function undo():void {
			_receiver.scaleX -= .1;
			_receiver.scaleY -= .1;			
		}
		
		public function redo():void {
			execute();
		}
				
	}
}