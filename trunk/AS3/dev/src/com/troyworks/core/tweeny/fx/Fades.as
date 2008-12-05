package com.troyworks.core.tweeny.fx {
	import com.troyworks.core.Signals;	
	import com.troyworks.core.cogs.CogEvent; 

	/**
	 * @author Troy Gardner
	 */
	public class Fades extends com.troyworks.framework.ui.BaseComponent {
		public static var FADEOUT_EVT : Signals = Signals.getNextSignal("FADEOUT_EVT");
		public static var FADEIN_EVT : Signals = Signals.getNextSignal("FADEIN_EVT");
		public static var FADEOUT_IN_EVT : Signals = Signals.getNextSignal("FADEOUT_IN_EVT");

		
		public function Fades() {
			super("s1_active");
		}

		function onReachedFrame(aFrameLbl : String) : void {
			//log("Fades.onReachedFrame " + aFrameLbl);

			switch(aFrameLbl) {
				case "opaque":
					break;
				case "fadein":
					break;
				case "fadedin":
					break;
				case "fadeout":
					break;
				case "fadedout":
					break;
				case "fadeoutin":
					break;
				case "fadeoutin_halfway":
					break;
				case "fadeoutin":
					break;
				case "transparent":
					break;
				default:
					break;
			}
		}

		function s1_active(e : CogEvent) : Function {
			//this.onFunctionEnter ("s1_active-", e, [FADEOUT_EVT, FADEIN_EVT, FADEOUT_IN_EVT]);
			switch (e.sig) {
				case SIG_ENTRY :
					
					{
				
					return null;
					}
				case SIG_EXIT :
					{
					return null;
				}
				case SIG_INIT :
				{
					return null;
				}
				case FADEOUT_EVT:
				{
					return null;
				}
				case FADEIN_EVT:
				{
					return null;
				}
				case FADEOUT_IN_EVT:
				{
					return null;
				}
			}
			return s_root;
		}
		function s1_opaque(e:CogEvent) : Function
		{
			//this.onFunctionEnter ("s1_opaque-", e, [FADEOUT_EVT, FADEOUT_IN_EVT]);
			switch (e.sig)
			{
				case SIG_ENTRY :{
				
					return null;
				}
				case SIG_EXIT :
				{
					return null;
				}
				case SIG_INIT :
				{
					return null;
				}
				
			}
			return s_root;
		}
		function s1_fadingin(e:CogEvent) : Function
		{
			//this.onFunctionEnter ("s1_fadingin-", e, [FADEOUT_EVT, FADEOUT_IN_EVT]);
			switch (e.sig)
			{
				case SIG_ENTRY :{
				
					return null;
				}
				case SIG_EXIT :
				{
					return null;
				}
				case SIG_INIT :
				{
					return null;
				}
			}
			return s_root;
		}
		function s1_fadingout(e:CogEvent) : Function
		{
		//	this.onFunctionEnter ("s1_fadingout-", e, [FADEIN_EVT, FADEOUT_IN_EVT]);
			switch (e.sig)
			{
				case SIG_ENTRY :{
				
					return null;
				}
				case SIG_EXIT :
				{
					return null;
				}
				case SIG_INIT :
				{
					return null;
				}
			}
			return s_root;
		}
		function s1_transparent(e:CogEvent) : Function
		{
			//this.onFunctionEnter ("s1_transparent-", e, [FADEOUT_EVT, FADEOUT_IN_EVT]);
			switch (e.sig)
			{
				case SIG_ENTRY :{
				
					return null;
				}
				case SIG_EXIT :
				{
					return null;
				}
				case SIG_INIT :
				{
					return null;
				}
			}
			return s_root;
		}
	}
}