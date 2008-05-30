package com.troyworks.core.commands {

	/**
	 * SampleCommand
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Apr 27, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class SampleCommand implements IUndoableCommand, IRedoableCommand {
		private var _target:Object;
		
		public function SampleCommand(_target:Object) {
			_target = _target;
		}
		public function undo() : void {
			//target.something -=20;
		}
		
		public function execute() : void {
				//target.something +=20;
		}
		
		public function redo() : void {
				execute();
		}
	}
}
