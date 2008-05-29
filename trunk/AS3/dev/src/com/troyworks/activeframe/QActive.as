/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.activeframe {
	import com.troyworks.cogs.Hsm;
	import com.troyworks.activeframe.QF;

	public class QActive extends Hsm{
		private var priority:Number;

		public function QActive(initStateNameAct : String =null, hsmName : String =null, aInit : Boolean = true){
			super(initStateNameAct, hsmName, aInit);
		}
	}
	
}
