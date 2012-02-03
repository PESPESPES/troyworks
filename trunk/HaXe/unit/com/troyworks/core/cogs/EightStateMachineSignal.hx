/*****************************************
 * Signals are immutable and reused over and over again
 *  across various CogEvents,
 * 
 * This collection of Signals covers the entire 'Family Tree'
 * of Transitions that Cog Supports.
 * 
 * See 	//http://en.wikipedia.org/wiki/Cousin for a better understanding 
 * of terms as used traditionally, 
 * 
 *************************************** */
package com.troyworks.core.cogs;

import com.troyworks.core.cogs.CogSignal;
import com.troyworks.core.cogs.CogEvent;
using com.troyworks.core.cogs.CogSignal;

enum ESSignal {
	Self;
	Self2;
	Parent;
	GrandParent;
	ChildInactive;
	GrandChildInactive;
	GrandChildInactive2;
	ChildActive;
	GrandChildActive;
	Sibling;
	Uncle;
	Nephew;
	GreatUncle;
	GreatNephew;
	FirstCousinRemoved;
	MirrorDepthOnOtherStack;
}
class EightStateMachineSignal{
}
