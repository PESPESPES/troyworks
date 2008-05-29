package  { 
	/**
	import flash.display.MovieClip;
	 * @author Troy Gardner
	 */
	interface com.troyworks.framework.ui.IHaveChildrenComponents {
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
		public function onChildClipLoad(_mc : MovieClip) : void;
		//public function onChildClipReady(_mc : MovieClip) : void;
		public function onChildClipEvent(evtd:Object) : void;
	}
}