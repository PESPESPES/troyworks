package ;

import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;
//import com.sf.Arrows; using com.sf.Arrows;
//import com.sf.Methods;using com.sf.Methods;
//import com.sf.States;
//import com.troyworks.core.cogs.EightStateMachineTest;
import com.troyworks.core.cogs.HsmTest;
//import com.troyworks.core.cogs.StateMachineTest;
/**
 * ...
 * @author 0b1kn00b
 */

class Main {
	
	static function main() {
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		// entry point

		var a = new HsmTest();
		var b = new com.troyworks.core.cogs.FsmTest();
		
	}
	
}