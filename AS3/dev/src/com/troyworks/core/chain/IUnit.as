package com.troyworks.core.chain
{
	import com.troyworks.core.commands.IAsynchronousCommand;

	public interface IUnit extends IAsynchronousCommand
	{	
		 function getUnitName():String;
		 function getWorkPerformed():Number;
		 function getTotalWorkToPerform():Number;
		 function startWork():void;
		 function isComplete():Boolean;
		 function setParentTask(parent:IUnit):void;
		 
	}
}