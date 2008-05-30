package com.troyworks.core.chain
{
	import com.troyworks.core.commands.IAsynchronousCommand;

	public interface IUnit extends IAsynchronousCommand
	{
		 function getWorkPerformed():Number;
		 function getTotalWorkToPerform():Number;
		 function startWork():void;
	
	}
}