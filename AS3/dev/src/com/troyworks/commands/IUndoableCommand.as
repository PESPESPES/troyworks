package com.troyworks.commands {

	public interface IUndoableCommand extends ICommand {
	
		function undo():void;
		
	}
}