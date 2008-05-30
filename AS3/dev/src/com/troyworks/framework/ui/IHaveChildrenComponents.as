package com.troyworks.framework.ui {
	import flash.display.MovieClip; 

	/**
	import flash.display.MovieClip;
	 * @author Troy Gardner
	 */
	interface IHaveChildrenComponents {
		/*  
		 * Used for notifying that this component has loaded, when there
		 * is a heirarchy of components, the parent waiting on all the chilren
	     * to proceed
	     * SAMPLE CODE:
		  protected function onLoad():void{
	    	super.onLoad();
	    	parent.onChildClipLoad(this);
	    	}
	     * 
	     */
		function onChildClipLoad(_mc : MovieClip) : void;
		//function onChildClipReady(_mc : MovieClip) : void;
		function onChildClipEvent(evtd:Object) : void;
	}
}