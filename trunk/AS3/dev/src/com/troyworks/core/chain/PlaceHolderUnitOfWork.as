package com.troyworks.core.chain {
	import com.troyworks.logging.TraceAdapter;	
	import com.troyworks.core.cogs.CogEvent;	
	import com.troyworks.core.chain.UnitOfWork;

	/**
	 * PlaceHolderUnitOfWork
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Jun 5, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class PlaceHolderUnitOfWork extends UnitOfWork {
		public var timeSpent : int;
		public static var trace : Function = TraceAdapter.CurrentTracer;

		
		public function PlaceHolderUnitOfWork(initState : String = "s__haventStarted", aMode : Boolean = SEQUENTIAL_MODE) {
			super(initState, aMode);
			totalWork = 10;
		}

		
		override public function s__doing(e : CogEvent) : Function {		
			switch (e.sig) {
	
				case SIG_PULSE:  
					totalPerformed++;
					trace(smID + ".Pulsing " + totalPerformed + "/ " + totalWork);
					if(totalPerformed == totalWork) {
						requestTran(s_done);
					}
					//	dispatchEvent()
					return null;		
			}
			return super.s__doing(e);
		}
	}
}
