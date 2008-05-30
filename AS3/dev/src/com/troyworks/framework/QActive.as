/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.framework {
	import com.troyworks.core.cogs.Hsm;
	import com.troyworks.framework.QF;

	public class QActive extends Hsm{
		private var priority:Number;

		public function QActive(initStateNameAct : String =null, hsmName : String =null, aInit : Boolean = true){
			super(initStateNameAct, hsmName, aInit);
		}
	}
	
}
