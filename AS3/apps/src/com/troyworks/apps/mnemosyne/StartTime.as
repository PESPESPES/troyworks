package com.troyworks.apps.mnemosyne
{
	public class StartTime
	{
		public var date:Date;
		
		/**
		 * UNIX timestamp
		 */
		public var time:uint;
		
		//-------------------------------------------------------------------------------
		public function StartTime()
		{
			this.date = new Date();
			this.time = this.date.time / 1000;
		}
		
		//-------------------------------------------------------------------------------
		public function updateDaysSince():void
		{
			Mnemosyne.daysSinceStart = (this.date.time / 1000 - this.time) / 60 / 60 / 24;
 		}

	}
}