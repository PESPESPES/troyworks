package com.troyworks.cogs {	/**	 * This is a transient state, that reflects the cached 	 * as state topologies might change past versions of the code,	 * plug given that transitions are function pointer lists	 * it doesn't make sense to have this class as serializable.	 * 	 * @author Troy Gardner	 */	public class TransitionMemento extends Object {		private var ID:Number		private var description:String;		//////COMMAND OPTIONS ////////		private var opts:TransitionOptions;		///// COMMAND LIST ///////////		private var exit:Array;		private var cross:Array;		private var enter:Array;				public function TransitionMemento(id:Number, descriptionOfTran:String, transitionOpts:TransitionOptions, exitStateList:Array, enterStateList:Array, crossLCAList:Array){			ID = id;			description = descriptionOfTran;			opts = transitionOpts;			exit = exitStateList;			cross = crossLCAList;			enter = enterStateList;		}	}}