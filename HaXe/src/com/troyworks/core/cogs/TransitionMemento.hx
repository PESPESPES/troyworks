/**	 * This is a transient state, that reflects the cached 	 * as state topologies might change past versions of the code,	 * plug given that transitions are function pointer lists	 * it doesn't make sense to have this class as serializable.	 * 	 * @author Troy Gardner	 */
package com.troyworks.core.cogs;

class TransitionMemento implements Dynamic {

	var ID : Float;
	var description : String;
	//////COMMAND OPTIONS ////////
	var opts : TransitionOptions;
	///// COMMAND LIST ///////////
	var exit : Array<Dynamic>;
	var cross : Array<Dynamic>;
	var enter : Array<Dynamic>;
	public function new(id : Float, descriptionOfTran : String, transitionOpts : TransitionOptions, exitStateList : Array<Dynamic>, enterStateList : Array<Dynamic>, crossLCAList : Array<Dynamic>) {
		ID = id;
		description = descriptionOfTran;
		opts = transitionOpts;
		exit = exitStateList;
		cross = crossLCAList;
		enter = enterStateList;
	}

}

