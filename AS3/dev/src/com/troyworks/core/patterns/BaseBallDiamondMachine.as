package com.troyworks.core.patterns {
	import com.troyworks.core.cogs.Fsm;
	/*****************************************
	 * this is another common state pattern
	 *  comes up in
	 *  atHome
	 *  not-initialized, initializing, initialized, uinitializing
	 *  at A--> transitioning to B---> at B --> transitioning to A
	 */
	public class BaseBallDiamondMachine extends Fsm
	{
	}
}