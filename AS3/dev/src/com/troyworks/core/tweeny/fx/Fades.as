package com.troyworks.core.tweeny.fx { 
	import com.troyworks.hsmf.Hsmf;
	
	import com.troyworks.hsmf.AEvent;
	import com.troyworks.hsmf.Signal;
	
	/**
	 * @author Troy Gardner
	 */
	public class Fades extends com.troyworks.framework.ui.BaseComponent {
		public static var FADEOUT_EVT : Signal = Signal.getNext("FADEOUT_EVT");
		public static var FADEIN_EVT : Signal = Signal.getNext("FADEIN_EVT");
		public static var FADEOUT_IN_EVT : Signal = Signal.getNext("FADEOUT_IN_EVT");
		
	
		public function Fades() {
			super(s1_active);
		}
		function onLoad():void{
	
			// this.oracle = this;	
		}
		function onReachedFrame(aFrameLbl:String):void{
			log("Fades.onReachedFrame " + aFrameLbl);
			
			switch(aFrameLbl){
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
		function s1_active(e : AEvent) : Function
		{
			this.onFunctionEnter ("s1_active-", e, [FADEOUT_EVT, FADEIN_EVT, FADEOUT_IN_EVT]);
			switch (e)
			{
				case ENTRY_EVT :{
				
					return null;
				}
				case EXIT_EVT :
				{
					return null;
				}
				case INIT_EVT :
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
			return s_top;
		}
		function s1_opaque(e : AEvent) : Function
		{
			this.onFunctionEnter ("s1_opaque-", e, [FADEOUT_EVT, FADEOUT_IN_EVT]);
			switch (e)
			{
				case ENTRY_EVT :{
				
					return null;
				}
				case EXIT_EVT :
				{
					return null;
				}
				case INIT_EVT :
				{
					return null;
				}
				
			}
			return s_top;
		}
		function s1_fadingin(e : AEvent) : Function
		{
			this.onFunctionEnter ("s1_fadingin-", e, [FADEOUT_EVT, FADEOUT_IN_EVT]);
			switch (e)
			{
				case ENTRY_EVT :{
				
					return null;
				}
				case EXIT_EVT :
				{
					return null;
				}
				case INIT_EVT :
				{
					return null;
				}
			}
			return s_top;
		}
		function s1_fadingout(e : AEvent) : Function
		{
			this.onFunctionEnter ("s1_fadingout-", e, [FADEIN_EVT, FADEOUT_IN_EVT]);
			switch (e)
			{
				case ENTRY_EVT :{
				
					return null;
				}
				case EXIT_EVT :
				{
					return null;
				}
				case INIT_EVT :
				{
					return null;
				}
			}
			return s_top;
		}
		function s1_transparent(e : AEvent) : Function
		{
			this.onFunctionEnter ("s1_transparent-", e, [FADEOUT_EVT, FADEOUT_IN_EVT]);
			switch (e)
			{
				case ENTRY_EVT :{
				
					return null;
				}
				case EXIT_EVT :
				{
					return null;
				}
				case INIT_EVT :
				{
					return null;
				}
			}
			return s_top;
		}
	}
}