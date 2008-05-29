package com.troyworks.commands {

	public interface IRedoableCommand extends ICommand {
	
		function redo():void;
		
	}
}