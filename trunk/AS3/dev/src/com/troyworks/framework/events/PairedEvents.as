package com.troyworks.framework.events { 
	/**
	 * @author Troy Gardner
	 * part of a timeline event, e.g. 
	 */
	public class PairedEvents {
		
		//indicate static states
		public var STARTING:String;
		public var START:String;
		public var STARTED:String;
		
		public var STOPPING:String;
		public var STOP:String;
		public var STOPPED:String;
	
		//dynmaic states
	 	public var PLAY:String;
		public var PLAYING:String;
		public var PLAYED:String;	
	}
}