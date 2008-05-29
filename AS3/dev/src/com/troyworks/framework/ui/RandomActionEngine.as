package com.troyworks.framework.ui { 
	/**
	 * @author Troy Gardner
	 * 
	//////////////CONFIGURE THE RANDOMIZATION ENGINE ///////////
	// config.actions -is a list of frame labels inside the timeline to navigate to
	// note that each action should have a gotoAndPlay(actions.shift()) on the last
	// frame of the action.
	//
	// config.maxActionPerCycle - of the list of possible actions, select this many to do
	// in a row before waiting again.
	//
	// config.waitBeforeStartingInSeconds - a number in seconds that is the upper bounds to wait
	// e.g. if I set it to 10 seconds, the player may randomly select anytime between 0 and 10 
	// seconds before starting
	//
	// config.rollOverActions - is the name of the frameLabel to go to when the action
	// completes, there is an property that can be detected to perform a mouse over
	//  e.g. 
	/*
	trace("----detecting mouse " + mouseIsOver);
	if(mouseIsOver ){
	stop();
	}
	*/
	/* //SAMPLE
	var config = new Object();
	config.actions = ["action1", "action2", "action3"];
	config.maxActionsPerCycle = 2;
	config.waitBeforeStartingInSeconds = 7;
	config.rollOverActions = ["action3","action4"];
	config.pressActions = ["action4"];
	config.releaseActions = [];
	config.rollOutActions =[];
	
	stop();
	 */
	import flash.display.MovieClip;
	public class RandomActionEngine extends MovieClip {
		public var init:Boolean = false;
		public var config:Object = null;
		public var actions:Array = null;
		public var waitToStart:Number = null;
		public var mouseIsOver:Boolean = false;
		protected var isEnabled:Boolean = true;
		
		public function onLoad():void{
			initClip();
	 	}
	 	public function initClip():void{
	 		waitToStart = (Math.random()* config.waitBeforeStartingInSeconds *1000);
			actions = new Array();
			var c = config.maxActionsPerCycle;
			while(c--){
				var a = Math.round( Math.random()*(config.actions.length-1));
				var act  = config.actions[a];
				//trace("adding " + a + " " + act);
				actions.push(act);
			}
			//add a finished action
			actions.push("actionsFinished");
		//	trace("INIT actions: " + actions+ " waitToStart " + waitToStart);
			_global.setTimeout(this, "gotoAndPlay", waitToStart, actions.shift());	
	 	}
		public function onRollOver() : void {
			if(config.rollOverActions.length > 0){
	 		 var act =getRandomAction(config.rollOverActions);
	 		 trace("onRollOver" + act);
	  		 actions.unshift(act);
			}
	   		mouseIsOver = true; 
		}
		public function	onRollOut():void{
		   //trace("onRollOut");
		   mouseIsOver = false; 
		   if(config.rollOutActions.length > 0){
		   		var act  = getRandomAction(config.rollOutActions);
			   trace("rollOutActions " + act);
			   actions.unshift(act);
		   }else{
		 	  play();
		   }
		}
		public function onPress():void{
			if(config.pressActions.length > 0){
				var act  = getRandomAction(config.pressActions);
			   trace("onPress " + act);
			   actions.unshift(act);
			}
		}
		public function onRelease():void{
			if(config.releaseActions.length > 0){
				var act:String  = getRandomAction(config.releaseActions);
		 	//  trace("onRollOver" + config.releaseActions);
		   		actions.unshift(act);
			}
		}
		public function getRandomAction(_ary:Array):String{
			var a:Number = Math.round( Math.random()*(_ary.length-1));
			var act:String  = String(_ary[a]);
			return act;
		}
		//Called by the end of the animations on the timeline
		public function nextAction() : void {
	    	gotoAndPlay(actions.shift());
		}
	}
}