package com.troyworks.chain
{
	import com.troyworks.commands.IAsychronousCommand;
	public interface IUnit extends IAsychronousCommand
	{
		public function getWorkPerformed():Number;
		public function getTotalWorkToPerform():Number;
		public function startWork():void;
	
	}
}